import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CustomTextField.dart';
import 'package:flutter_application_1/components/mainButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateNote extends StatefulWidget {
  final String folderId; // The note's parent document ID
  final String? noteId; // The note  ID
  final String oldName;

  const UpdateNote({
    super.key,
    required this.noteId,
    required this.oldName,
    required this.folderId,
  });

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  late DocumentReference noteRef;

  @override
  void initState() {
    super.initState();

    // Point directly to the note document
    noteRef = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.folderId)
        .collection("notes")
        .doc(widget.noteId);

    controller.text = widget.oldName;
  }

  Future<void> updateNote() async {
    await noteRef.update({'name': controller.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Note")),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the new note name";
                    }
                    return null;
                  },
                  controller: controller,
                ),
                const SizedBox(height: 20),
                mainButton(
                  text: "Update",
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        await updateNote();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Note updated successfully!"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/view',
                          (_) => false,
                          arguments: widget.folderId,
                        );
                      } catch (e) {
                        print("Error updating note: $e");
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
