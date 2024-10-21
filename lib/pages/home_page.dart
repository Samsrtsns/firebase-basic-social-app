import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/components/my_drawer.dart';
import 'package:socialapp/components/my_saysomething_button.dart';
import 'package:socialapp/components/my_textfield.dart';
import 'package:socialapp/database/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController newCommentController = TextEditingController();

  void sendCommentMessage() {
    if (newCommentController.text.isNotEmpty) {
      String message = newCommentController.text;
      database.addPosts(message);
    }
    newCommentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('W A L L'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                      hintText: 'Say something',
                      obscureText: false,
                      controller: newCommentController,
                      hasPasswordLine: false),
                ),
                MySaysomethingButton(
                  onTap: sendCommentMessage,
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Bir hata oluştu: ${snapshot.error}'),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('No post'),
                  ),
                );
              }

              final posts = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];

                    return Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(message),
                              subtitle: Text(userEmail),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
