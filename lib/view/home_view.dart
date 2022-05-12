import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/constants/storage_keys.dart';
import 'package:todo/constants/todo_keys.dart';
import 'package:todo/view/create_todo_view.dart';
import 'package:todo/view/todo_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Set<String> categories = {"All"};
  List<Map<String, dynamic>> todos = [];
  late final SharedPreferences _sharedPreferences;
  bool loading = false;

  @override
  initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    setState(() {
      loading = true;
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    _getLocalCategories();
    setState(() {
      loading = false;
    });
  }

  Future<void> _saveCategoryLocally() async {
    await _sharedPreferences.setString(
      StorageKey.category,
      jsonEncode(categories.toList()),
    );
  }

  Future<void> _getLocalCategories() async {
    setState(() {
      categories = (jsonDecode(
        _sharedPreferences.getString(StorageKey.category) ??
            <String>["All"].toString(),
      ) as List)
          .map<String>((e) => e)
          .toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Card(
        clipBehavior: Clip.hardEdge,
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // onPressed: () {},
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreatTodoView(
                    categories: categories.toList(),
                    onSave: (e) {
                      print("ldkdk");
                      todos.add(e);
                      print(todos.length);
                    }),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                ),
                Text(
                  "Create Task",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: const [
                Text("My List"),
                Spacer(),
                Icon(Icons.more_horiz_outlined),
              ],
            ),
          ),
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(15),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: categories.length + 1,
                    itemBuilder: (context, index) {
                      // check if the card is all
                      bool isAll = categories.length == index
                          ? false
                          : categories.elementAt(index) == "All";
                      print(isAll);
                      String currentCategory = categories.length == index
                          ? ""
                          : categories.elementAt(index);

                      // build widget
                      return categories.length == index
                          ? InkWell(
                              onTap: addCategory,
                              child: const Card(
                                child: Icon(Icons.add),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TodoListView(
                                      todos: isAll
                                          ? todos.toList()
                                          : todos
                                              .where((element) =>
                                                  element[TodoKeys.category] ==
                                                  currentCategory)
                                              .toList(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 150,
                                width: 175,
                                margin: const EdgeInsets.all(5),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.task_rounded,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      Text(
                                        categories.elementAt(index),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Text("9 Items"),
                                    ],
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
          )
        ],
      ),
    );
  }

  addCategory() {
    TextEditingController _categoryController = TextEditingController();
    GlobalKey<FormState> _form = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Form(
          key: _form,
          child: TextFormField(
            controller: _categoryController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Enter a category";
              }
              if (categories.contains(value)) {
                return "Category name already exist";
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_form.currentState!.validate()) {
                Navigator.pop(context);
                saveCategory(_categoryController.text);
              }
            },
            child: const Text("+ Create"),
          ),
        ],
      ),
    );
  }

  void saveCategory(value) {
    setState(() {
      categories.add(value);
      _saveCategoryLocally();
    });
  }
}
