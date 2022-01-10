// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/model/msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot>(
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('error');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('empty');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return LinearProgressIndicator();
                  }
                  List<DocumentSnapshot> _docs = snapshot.data!.docs;

                  List<MSG> _msg = _docs
                      .map((e) => MSG.fromMap(e.data() as Map<String, dynamic>))
                      .toList();

                  return Expanded(
                      child: ListView.builder(
                          itemCount: _msg.length,
                          itemBuilder: (context, index) {
                            return Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 50,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(_msg[index].messnger ?? 'no name'));
                          }));
                },
                stream:
                    FirebaseFirestore.instance.collection("msg").snapshots(),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messnger,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_globalKey.currentState!.validate()) {
                          MSG _msg = MSG(messnger: _messnger.value.text);
                          _messnger.text = "";

                          FirebaseFirestore.instance
                              .collection("msg")
                              .doc()
                              .set(_msg.toMap(), SetOptions(merge: true));
                        }
                      },
                      child: Text("send"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
