import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CustomTextField.dart';
import 'package:flutter_application_1/components/mainButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


class updateCategory extends StatefulWidget {
  
  String oldName;
  String? id;
  updateCategory({super.key, required this.id, required this.oldName});

  @override
  State<updateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<updateCategory> {
  CollectionReference categories = FirebaseFirestore.instance.collection(
    "categories",
  );

  Future<void> updateCategory() async {
    await categories.doc(widget.id).update({'name': controller.text});
  }

  // Form Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.oldName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Category")),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  // filed contain old value
                  validator: (value) {
                    if (value!.isEmpty) {
                      print("Empty");
                      return "Please Enter The New Category Name";
                    }
                    return null;
                  },
                  controller: controller,
                ),
                SizedBox(height: 20),
                mainButton(
                  text: "Update",
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        await updateCategory();
                        print("Category Updated");
                        // snackbar to show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Category Updated Successfully!"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                            // success
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (_) => false,
                        );
                      } catch (e) {
                        print(e);
                      }
                      
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
