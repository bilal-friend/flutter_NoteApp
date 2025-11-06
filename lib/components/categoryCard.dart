//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// awesome dialog
import 'package:awesome_dialog/awesome_dialog.dart';
// import update category
import 'package:flutter_application_1/categories/update.dart';
import 'package:flutter_application_1/note/edit.dart';
// import editor

class categoryCard extends StatelessWidget {
  final String title;
  final String folderId;
  final bool isNote;
  final String? noteId;

  const categoryCard({
    super.key,
    required this.title,
    required this.folderId,
    this.isNote = false,
    this.noteId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // print doc id

        if (!isNote) {
          // navigate to view page && pass id
          Navigator.pushNamed(context, '/view', arguments: folderId);
        } else {
          // go to editor
          Navigator.pushNamed(
            context,
            '/editor',
            arguments: {"folderId": folderId, "noteId": noteId},
          );
        }
      },
      onLongPress: () {
        print("Long Pressed");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: 'Choice',
          btnOkText: 'Delete',
          btnOkColor: Colors.red,
          btnCancelText: 'Update',
          btnCancelColor: Colors.green,
          desc: 'Are you sure you want to delete this category?',
          btnCancelOnPress: () {
            print('Update');
            // go to update category
            if (isNote) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdateNote(
                    oldName: title,
                    folderId: folderId,
                    noteId: noteId,
                  ),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      updateCategory(oldName: title, id: folderId),
                ),
              );
            }
          },
          btnOkOnPress: () async {
            print('Delete');
            if (isNote) {
              await FirebaseFirestore.instance
                  .collection('categories')
                  .doc(folderId)
                  .collection('notes')
                  .doc(noteId)
                  .delete();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/view',
                (_) => false,
                arguments: folderId,
              );
            } else {
              await FirebaseFirestore.instance
                  .collection('categories')
                  .doc(folderId)
                  .delete();
              Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
            }
          },
        ).show();
      },

      child: Container(
        // simple border
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              // folder like them color and sheet or note in olmost white color
              isNote ? Icons.note : Icons.folder,
              color: !isNote ? Colors.orange[400] : Colors.grey[400],
              size: 100,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
