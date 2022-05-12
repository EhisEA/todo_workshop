import 'package:flutter/material.dart';

class CreatTodoView extends StatelessWidget {
  const CreatTodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              TextFormField(),
              const SizedBox(
                height: 24,
              ),
              TextFormField(),
              const SizedBox(
                height: 54,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
