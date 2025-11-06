import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CustomTextField.dart';
import 'package:flutter_application_1/components/mainButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNote extends StatefulWidget {
  final String id; // folder (category) id

  const AddNote({super.key, required this.id});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  // Form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  late CollectionReference notesRef; // ✅ declare at class level

  @override
  void initState() {
    super.initState();
    // ✅ initialize reference here
    notesRef = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.id)
        .collection("notes");
  }

  Future<void> addNote(String data) async {
    try {
      await notesRef.add({
        'name': data,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("✅ Note Added");
    } catch (error) {
      print("❌ Error adding note: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  hinttext: "Enter Note Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter note name";
                    }
                    return null;
                  },
                  controller: controller,
                ),
                const SizedBox(height: 20),
                mainButton(
                  text: "Add",
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await addNote(controller.text);

                      // go to view page view but reload
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/view', arguments: widget.id);
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
