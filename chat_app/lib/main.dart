// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/model/msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Messnger());
}

class Messnger extends StatefulWidget {
  const Messnger({Key? key}) : super(key: key);

  @override
  _MesngerState createState() => _MesngerState();
}

class _MesngerState extends State<Messnger> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController _messnger = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messnger.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MSG> messages = [];
    // FirebaseFirestore.instance
    //     .collection("messages")
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     MSG message = MSG.fromJson({
    //       'message': doc['message'],
    //       'username': doc['username'],
    //       'id': doc.reference.id
    //     });
    //     messages.add(message);
    //   });
    // });
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("messages")
                    .orderBy('createdAt')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('error');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('empty');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return LinearProgressIndicator();
                  }
                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  List<MSG> messages = [];
                  docs.forEach((doc) {
                    MSG message = MSG.fromJson({
                      'message': doc['message'],
                      'username': doc['username'],
                      'createdAt': doc['createdAt'],
                      'id': doc.reference.id
                    });
                    messages.add(message);
                    // ignore: unused_local_variable
                    String? generate = message.username!.split(' ').length > 1
                        ? 'hbehfjbe'
                        : 'jktj3';
                  });
                  return Expanded(
                      child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              child: Container(
                                margin: EdgeInsets.only(top: 10, left: 5),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      child: Text(messages[index]
                                                      .username!
                                                      .split(' ')[0][0]
                                                      .toUpperCase() +
                                                  messages[index]
                                                      .username
                                                      .split(' ')
                                                      .length >
                                              1
                                          ? 'tst'
                                          : 'test'),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.teal[400],
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16))),
                                        child: Text(messages[index].message!),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              secondaryActions: [
                                Container(
                                    height: 36,
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                    ),
                                    child: Row(children: [
                                      IconButton(
                                        onPressed: () {
                                          _showDialog(BuildContext, context,
                                              messages[index].id);
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ])),
                              ],
                            );
                          }));
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messnger,
                      decoration: InputDecoration(
                          hintText: 'Enter new message',
                          prefixIcon: Icon(Icons.create_sharp)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "message must contain text";
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          //MSG _msg = MSG(messnger: _messnger.value.text);
                          MSG message = MSG.fromJson({
                            'message': _messnger.value.text,
                            'username': 'anonymous'
                          });

                          await FirebaseFirestore.instance
                              .collection("messages")
                              .add({
                            'message': _messnger.value.text,
                            'username': 'anonymous',
                            'createdAt': FieldValue.serverTimestamp()
                          });
                          _messnger.text = "";
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.blue,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext, context, id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    CollectionReference message =
                        FirebaseFirestore.instance.collection('messages');
                    message.doc(id).delete();
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
            ],
            title: Text('Confirmation'),
            content: Text('are you sure to delete this message?')),
      );
}
