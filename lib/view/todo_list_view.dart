import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/constants/todo_keys.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({Key? key, required this.todos}) : super(key: key);
  final List<Map<String, dynamic>> todos;
  // final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              const SizedBox(
                height: 7,
              ),
              Row(
                children: const [
                  Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.add,
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) => Container(
                          color: Colors.white,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 9,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      todos[index][TodoKeys.title],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      todos[index][TodoKeys.category],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          DateFormat("dd-MMM-yyyy ").format(
                                              todos[index][TodoKeys.date]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    )
                                  ],
                                )
                              ]),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
