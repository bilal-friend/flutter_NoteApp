import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/categoryCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// addnoe
import 'addNote.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  ViewPageState createState() => ViewPageState();
}

class ViewPageState extends State<ViewPage> {
  bool isLoading = true;
  List<DocumentSnapshot> notes = [];
  String folderId = ""; // will store the folder (category) ID

  @override
  void initState() {
    super.initState();

    // delay to get arguments after build context is ready
    Future.delayed(Duration.zero, () {
      folderId =
          ModalRoute.of(context)!.settings.arguments
              as String; // ✅ assign to the class variable
      print("📁 Folder ID received: $folderId");
      getNote(folderId); // ✅ pass it to the function
    });
  }

  // Fetch notes from Firestore (inside selected folder)
  getNote(String folderId) async {
    try {
      print("Fetching notes for folder: $folderId");

      QuerySnapshot value = await FirebaseFirestore.instance
          .collection("categories")
          .doc(folderId)
          .collection(
            "notes",
          ) // 👈 make sure your subcollection name matches this
          .get();

      notes.clear();
      notes.addAll(value.docs);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error loading notes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // navigate to AddNote page and pass folderId , not named
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddNote(id: folderId)),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("View Page "),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? const Center(child: Text("No notes found"))
          : GridView.builder(
              itemCount: notes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => categoryCard(
                title: notes[index]["name"],
                folderId: folderId,
                noteId: notes[index].id,
                isNote: true,
              ),
            ),
    );
  }
}
