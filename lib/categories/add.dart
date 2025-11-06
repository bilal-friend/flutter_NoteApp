import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// textFiled import
import 'package:flutter_application_1/components/CustomTextField.dart';
// main button
import 'package:flutter_application_1/components/mainButton.dart';
// Cloud FireStore
import 'package:cloud_firestore/cloud_firestore.dart';
// async await
import 'dart:async';

class addCategory extends StatefulWidget {
  const addCategory({super.key});

  @override
  State<addCategory> createState() => _addCategoryState();
}

class _addCategoryState extends State<addCategory> {
  // create a collectionRefrence
  CollectionReference categories = FirebaseFirestore.instance.collection(
    "categories",
  );
  Future<void> addCategory(String data) {
    return categories
        .add({'name': data, 'uid': FirebaseAuth.instance.currentUser!.uid})
        .then((value) => print("Category Added"))
        .catchError((error) => print(error));
  }

  // Form Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Category")),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 300,

          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  hinttext: "Enter Category Name",
                  validator: (value) {
                    if (value!.isEmpty) {
                      print("Empty");
                      return "Please Enter Category Name";
                    }
                    return null;
                  },
                  controller: controller,
                ),
                SizedBox(height: 20),
                mainButton(
                  text: "Add",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      addCategory(controller.text);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (_) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// bilalelemrani18@gmail.com
// elemranibilal2006@gmail.com