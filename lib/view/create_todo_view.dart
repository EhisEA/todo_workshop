import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/constants/todo_keys.dart';

class CreatTodoView extends StatefulWidget {
  const CreatTodoView(
      {Key? key, required this.onSave, required this.categories})
      : super(key: key);

  final Function(Map<String, dynamic>) onSave;
  final List<String> categories;

  @override
  State<CreatTodoView> createState() => _CreatTodoViewState();
}

class _CreatTodoViewState extends State<CreatTodoView> {
  String selectedCategory = "All";
  DateTime? date;
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  pickdate() async {
    date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                  controller: _controller,
                  validator: (e) {
                    if (e == null || e.isEmpty) return "Enter a valid title";
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Title"),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Categories"),
                          DropdownButton<String>(
                            value: selectedCategory,
                            items: List.generate(
                              widget.categories.length,
                              (index) => DropdownMenuItem(
                                child: Text(
                                  widget.categories[index],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                value: widget.categories[index],
                              ),
                            ),
                            onChanged: (pickedCategory) {
                              setState(() {
                                selectedCategory = pickedCategory ?? "All";
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Time"),
                          Card(
                            child: InkWell(
                              onTap: pickdate,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  date == null
                                      ? "select a date"
                                      : DateFormat("dd-MMM-yyyy ")
                                          .format(date!),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        if (date == null) {
                          scaffoldKey.currentState!.showSnackBar(
                              SnackBar(content: Text("Please Select a time")));
                          //to kill the function
                          // return;
                        } else {
                          Navigator.pop(context);
                          widget.onSave({
                            TodoKeys.title: _controller.text,
                            TodoKeys.category: selectedCategory,
                            TodoKeys.date: date,
                          });
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        // color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
