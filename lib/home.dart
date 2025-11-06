import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/categoryCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<DocumentSnapshot> categories = [];

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  // Fetch categories from Firestore
  getCategory() async {
    try {
      QuerySnapshot value = await FirebaseFirestore.instance
          .collection("categories")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      categories.clear(); // ✅ prevent duplicates
      categories.addAll(value.docs);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // navigate to AddCategory
          await Navigator.pushNamed(context, '/addCategory');
          // didPopNext will automatically refresh
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Home Page"),
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
          : GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => categoryCard(
                title: categories[index]["name"],
                folderId: categories[index].id,
              ),
            ),
    );
  }
}
