import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'todo_model.dart';
import 'db_helper.dart';

class toDoapp extends StatefulWidget {
  const toDoapp({super.key});

  @override
  State createState() => _toDoapp();
}

class _toDoapp extends State {
  final DBHelper _dbHelper = DBHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<TodoModel> todoCards = [];

  List<Color> listOfColors = [
    const Color.fromARGB(255, 162, 237, 147),
    const Color.fromARGB(255, 164, 189, 248),
    const Color.fromARGB(255, 245, 239, 128),
    const Color.fromARGB(255, 135, 220, 243),
  ];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    todoCards = await _dbHelper.fetchTodos();
    setState(() {});
  }

  void submit(bool doedit, [TodoModel? todoobj]) async {
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty) {
      if (doedit) {
        todoobj!.title = titleController.text;
        todoobj.description = descriptionController.text;
        todoobj.date = dateController.text;
        await _dbHelper.updateTodo(todoobj);
      } else {
        final newTodo = TodoModel(
          title: titleController.text,
          description: descriptionController.text,
          date: dateController.text,
        );
        await _dbHelper.insertTodo(newTodo);
      }
    }
    Navigator.of(context).pop();
    clearControllers();
    _loadTodos();
  }

  void deleteTodoById(int id) async {
    await _dbHelper.deleteTodoById(id);
    _loadTodos();
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
  }

  void openBottomSheet(bool doedit, [TodoModel? todoobj]) {
    if (doedit) {
      titleController.text = todoobj!.title;
      descriptionController.text = todoobj.description;
      dateController.text = todoobj.date;
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const Text("To -Do List",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue)),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Title",
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: const Color.fromARGB(255, 16, 84, 201)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      hintText: "Add title",
                      label: const Text("Title"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      )),
                ),
              ),
              Text(
                "Description",
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: const Color.fromARGB(255, 16, 84, 201)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      hintText: "Description",
                      label: const Text("Description"),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(11),
                      )),
                ),
              ),
              Text(
                "Date",
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: const Color.fromARGB(255, 16, 84, 201)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      hintText: "Date",
                      label: const Text("Date"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      suffixIcon: const Icon(Icons.calendar_month_outlined)),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2025));
                    String formatedDate =
                        DateFormat.yMMMd().format(pickedDate!);
                    setState(() {
                      dateController.text = formatedDate;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (doedit) {
                      submit(true, todoobj);
                    } else {
                      submit(false);
                    }
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Color.fromRGBO(159, 218, 223, 1))),
                  child: Text(
                    "Submit",
                    style: GoogleFonts.quicksand(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFDBFE),
      appBar: AppBar(
        title: const Text(
          "To-Do App",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Color.fromARGB(255, 127, 199, 241)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: ListView.builder(
        itemCount: todoCards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Container(
              decoration: BoxDecoration(
                  color: listOfColors[index % listOfColors.length],
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 10),
                        color: Color.fromRGBO(0, 0, 0, 0.1))
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todoCards[index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                todoCards[index].description,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 14.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        children: [
                          Text(
                            todoCards[index].date,
                            style: GoogleFonts.quicksand(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  titleController.text = todoCards[index].title;
                                  descriptionController.text =
                                      todoCards[index].description;
                                  dateController.text = todoCards[index].date;
                                  openBottomSheet(true, todoCards[index]);
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.edit_outlined,
                                  color: Color.fromRGBO(0, 139, 148, 1),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  deleteTodoById(todoCards[index].id!);
                                },
                                child: const Icon(
                                  Icons.delete_outlined,
                                  color: Color.fromRGBO(0, 139, 148, 1),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBottomSheet(false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
