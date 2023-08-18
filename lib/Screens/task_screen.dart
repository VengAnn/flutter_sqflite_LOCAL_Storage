<<<<<<< HEAD
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite/database/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import '../Models/task_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: camel_case_types
class task_screen extends StatefulWidget {
  const task_screen({super.key});

  @override
  State<task_screen> createState() => _task_screenState();
}

// ignore: camel_case_types
class _task_screenState extends State<task_screen> {
  bool isDone = false;
  final _formkey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();
  final taskNameController = TextEditingController();
  final taskDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task'),
      ),
      //
      body: FutureBuilder<List<Task>>(
        future: _getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Empty Data"),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var task = snapshot.data![index];
                  return Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: const ValueKey(0),

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 1,
                          onPressed: (context) {
                            setState(() {
                              DatabaseHelper.deleteTask(id: task.id!);
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          flex: 1,
                          onPressed: (context) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setStateForAlert) {
                                    return AlertDialog(
                                      title: const Text("Update Task"),
                                      content: SingleChildScrollView(
                                        child: Form(
                                          key: _formkey,
                                          child: ListBody(
                                            children: [
                                              TextFormField(
                                                controller: taskNameController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "update title",
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                //

                                                //if use in index code below
                                                // initialValue: "${task.title}",
                                                // onFieldSubmitted: (value) {
                                                //   setState(() {
                                                //     task.title = value;
                                                //     print(value);
                                                //     var row = {"title": value};
                                                //     DatabaseHelper.updateTask(
                                                //         id: task.id!, row: row);
                                                //     Navigator.pop(context);
                                                //     Toast.show("Update Success");
                                                //   });
                                                // },
                                                //
                                                validator: (value) {
                                                  if (value!.isEmpty ||
                                                      value == null) {
                                                    return "Enter data";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                              //
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: taskDateController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "update Date",
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                //  initialValue: "${task.date}",
                                                onTap: () async {
                                                  DateTime? date =
                                                      DateTime.now();
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode());
                                                  date = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2022),
                                                    lastDate: DateTime(2025),
                                                  );
                                                  if (date == null) {
                                                    //Protect null
                                                    return;
                                                  }
                                                  String formattedDate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(date!);
                                                  taskDateController.text =
                                                      formattedDate;
                                                },
                                                //
                                                validator: (value) {
                                                  if (value!.isEmpty ||
                                                      value == null) {
                                                    return "Enter data";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                              //
                                              CheckboxListTile(
                                                title: const Text("checkBox"),
                                                value: isDone,
                                                onChanged: (value) {
                                                  isDone = value!;
                                                  print(value);
                                                  setStateForAlert(() {});
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      //
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              // final db = await dbHelper.database;
                                              // Map<String, dynamic> row = {
                                              //   DatabaseHelper().columnDate:
                                              //       taskDateController.text,
                                              // };
                                              // two way to make or declare row
                                              var row = {
                                                "date": taskDateController.text,
                                                "title":
                                                    taskNameController.text,
                                                "isDone": isDone ? 1 : 0,
                                              };
                                              DatabaseHelper.updateTask(
                                                  id: task.id!, row: row);
                                              setState(() {});
                                            }
                                            final snackBar = SnackBar(
                                              content:
                                                  const Text("Update success"),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {
                                                  // Some code to undo the change.
                                                },
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                            //can use Snack Bar or Toast show
                                            Toast.show("Update Success");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
                                          child: const Text("Update now"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Update Task tile',
                        ),
                      ],
                    ),

                    child: Card(
                      color: task.isDone == 1
                          ? Colors.deepPurple
                          : Colors.red[400],
                      child: ListTile(
                        onTap: () async {
                          task.isDone = task.isDone == 1 ? 0 : 1;
                          //meaning is task.isDone =1 give it to 0 and 0 give to 1;
                          var row = {"isDone": task.isDone};
                          //
                          await DatabaseHelper.updateTask(
                              id: task.id!, row: row);
                          print(task.isDone);
                          setState(() {});
                        },
                        leading: Text("${task.id}"),
                        title: Text("${task.title}"),
                        subtitle: Text(
                          "${task.date}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Checkbox(
                          activeColor:
                              index % 2 == 0 ? Colors.amber : Colors.blue,
                          // Set the color when checkbox is checked
                          shape: const CircleBorder(side: BorderSide.none),
                          value: task.isDone == 1 ? true : false,
                          onChanged: (value) async {
                            print(value);
                            setState(() {
                              if (value!) {
                                var row = {"isDone": 1};
                                task.isDone = 1;
                                DatabaseHelper.updateTask(
                                    id: task.id!, row: row);
                              } else {
                                task.isDone = 0;
                                var row = {"isDone": 0};
                                DatabaseHelper.updateTask(
                                    id: task.id!, row: row);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //
  Future<List<Task>> _getTasks() async {
    final task = await DatabaseHelper.getTask();
    return task.map((e) => Task.fromJson(e)).toList();
  }

  //
  Future<void> _showMyDialog(BuildContext context) async {
    final taskNameController = TextEditingController();
    final taskDateController = TextEditingController();

    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return AlertDialog(
                title: const Text("Add Task"),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: ListBody(
                      children: <Widget>[
                        TextFormField(
                          controller: taskNameController,
                          decoration: const InputDecoration(
                            hintText: "Enter Task",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter task';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: taskDateController,
                          onTap: () async {
                            DateTime? date = DateTime.now();
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2025),
                            );
                            if (date == null) {
                              //Protect null
                              return;
                            }
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(date!);
                            taskDateController.text = formattedDate;
                          },
                          //
                          decoration: const InputDecoration(
                            hintText: "Date",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        //
                        const SizedBox(
                          height: 10,
                        ),
                        //
                        CheckboxListTile(
                          title: const Text("Is Done"),
                          value: isDone,
                          onChanged: (value) {
                            setState2(() {
                              isDone = value!;
                              print(isDone);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final snackBar = SnackBar(
                        content: const Text("insert success"),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );

                      if (_formkey.currentState!.validate()) {
                        final db = await dbHelper.database;
                        Map<String, dynamic> row = {
                          DatabaseHelper().columnTitle: taskNameController.text,
                          DatabaseHelper().columnDate: taskDateController.text,
                          DatabaseHelper().columnIsDone: isDone ? 1 : 0,
                        };
                        final id = await DatabaseHelper.insertTask(row);
                        if (id > 0) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          setState(() {});
                        }
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        });
  }
=======
import 'package:flutter/material.dart';

// ignore: camel_case_types
class task_screen extends StatelessWidget {
  const task_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){}, child: const Icon(Icons.add),),
    );
  }
>>>>>>> 2952aadb7bdf3b50ba52cec25b55bbc3720b036d
}
