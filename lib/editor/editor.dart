import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final TextEditingController controller = TextEditingController();
  late String folderId;
  late String noteId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments safely
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    folderId = args['folderId'];
    noteId = args['noteId'];

    _loadNote();
  }

  Future<void> _loadNote() async {
    final doc = await FirebaseFirestore.instance
        .collection('categories')
        .doc(folderId)
        .collection('notes')
        .doc(noteId)
        .get();

    if (doc.exists) {
      controller.text = doc['content'] ?? '';
    }
  }

  Future<void> _saveNote() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(folderId)
        .collection('notes')
        .doc(noteId)
        .set({'content': controller.text}, SetOptions(merge: true));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Note saved!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor"),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: controller,
          expands: true,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: "Type Your Note Here ...",
          ),
        ),
      ),
    );
  }
}
