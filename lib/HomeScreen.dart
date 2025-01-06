import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:tugaskelompok2/db_services/database.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool Personal = true, College = false, Office = false;
  bool suggest = false;
  TextEditingController todoController = TextEditingController();
  Stream? todoStream;

  getonTheLoad() async {
    todoStream = await DatabaseService().getTask(Personal
        ? "Personal"
        : College
            ? "College:"
            : "Office");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget getWork() {
    return StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot docsnap = snapshot.data.docs[index];
                        return CheckboxListTile(
                          activeColor: Colors.greenAccent.shade400,
                          title: Text(docsnap["work"]),
                          value: docsnap["Yes"],
                          onChanged: (newValue) async {
                            await DatabaseService().tickMethod(
                                docsnap["id"],
                                Personal
                                    ? "Personal"
                                    : College
                                        ? "College:"
                                        : "Office");
                            setState(() {
                              Future.delayed(Duration(seconds: 1),(){
                              DatabaseService().removeMethod(
                                  docsnap["id"],
                                  Personal
                                      ? "Personal"
                                      : College
                                          ? "College:"
                                          : "Office");
                              });
                              
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }),
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent.shade400,
        onPressed: () {
          openBox();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amberAccent,
              Colors.redAccent,
              Colors.greenAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: const Text(
                "Hii",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: const Text(
                "Danar",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: const Text(
                "Kerja Kerja Kerja !",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Personal
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Personal",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = true;
                          College = false;
                          Office = false;
                          await getonTheLoad();
                          setState(() {});
                        },
                        child: const Text(
                          "Personal",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                College
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = false;
                          College = true;
                          Office = false;
                          await getonTheLoad();
                          setState(() {});
                        },
                        child: const Text(
                          "",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                Office
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Office",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = false;
                          College = false;
                          Office = true;
                          await getonTheLoad();
                          setState(() {});
                        },
                        child: const Text(
                          "Office",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            getWork(),
          ],
        ),
      ),
    );
  }

  Future openBox() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel),
                        ),
                        SizedBox(
                          width: 60.0,
                        ),
                        Text(
                          "Ngopi reneO",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Add Text"),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      )),
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter The Task",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            String id = randomAlphaNumeric(10);
                            Map<String, dynamic> userTodo = {
                              "work": todoController.text,
                              "id": id,
                              "Yes": false,
                            };
                            Personal
                                ? DatabaseService()
                                    .addPersonalTask(userTodo, id)
                                : College
                                    ? DatabaseService()
                                        .addCollegeTask(userTodo, id)
                                    : DatabaseService()
                                        .addOfficeTask(userTodo, id);
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
