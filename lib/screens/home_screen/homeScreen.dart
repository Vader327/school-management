import 'package:flutter/material.dart';

import 'package:school_management/screens/home_screen/components/section_header.dart';
import 'package:school_management/screens/home_screen/components/task_container.dart';
import 'package:school_management/screens/home_screen/components/class_container.dart';
import 'package:school_management/screens/home_screen/components/empty_container.dart';

import 'package:school_management/data/tasks.dart';
import 'package:school_management/data/colors.dart';
import 'package:school_management/functions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map> allClasses;
  List<Map> allTasks;
  List allAchievements;

  /*List<Map> allClasses = [
    {
      "title": "Geography - Class X",
      "time": "08:00",
      "room": "Room 10D, 5th Floor",
    },
    {
      "title": "Maths - Class IV",
      "time": "09:30",
      "room": "Room 3d, 2nd Floor",
    },
  ];

  List<Map> allTasks = tasks(colors);

  List allAchievements = [
    'images/badges/best_teacher.png',
    'images/badges/star_teacher.png',
  ];*/

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String name = "";
  String email;

  @override
  void initState() {
    super.initState();
    email = FirebaseAuth.instance.currentUser.email;

    users
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var data = doc.data();

        setState(() {
          name = doc['name'];

          allTasks = [];
          if (data['tasks'] != null) {
            for (var i in data['tasks']) {
              allTasks.add(
                {
                  "deadline": i['deadline'],
                  "month": i['month'],
                  "task": i['task'],
                  "description": i['description'],
                  "deadlineMessage": getDeadlineMessage(
                      DateTime.parse(getCorrectDateFormat(i))),
                  "status": i['status'],
                  "color": Color(int.parse(i['color'])),
                },
              );
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(DateTime.now().toString());
    var formattedDate = "${date.day} ${getMonthName(date.month)}";

    return Container(
      padding: EdgeInsets.only(top: 24),
      color: Color(0XFFD4E7FE),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                                icon: Icon(
                                  Icons.menu,
                                  color: Color(0XFF263064),
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${getDayName(date.weekday)} ",
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color(0XFF263064),
                                ),
                              ),
                              Text(
                                formattedDate,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0XFF263064),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey.withOpacity(0.2),
                                      blurRadius: 12,
                                      spreadRadius: 8,
                                    )
                                  ],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      'https://i.pravatar.cc/150?img=65',
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Hi ${name.split(" ")[0]}",
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 25,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      color: Color(0XFF263064),
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    child: Text(
                                      "Here is today's schedule",
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            sectionHeader(
                              "TODAY'S CLASSES",
                              context,
                              '/main/classes',
                            ),
                            allClasses == null
                                ? emptyContainer("classes")
                                : Column(
                                    children: allClasses
                                        .map(
                                          (e) => classContainer(e),
                                        )
                                        .toList(),
                                  ),
                            SizedBox(height: 20),
                            sectionHeader(
                              "YOUR TASKS",
                              context,
                              '/main/tasks',
                            ),
                            allTasks == null
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : allTasks.isEmpty
                                    ? emptyContainer("tasks")
                                    : Container(
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: allTasks
                                                .map(
                                                  (e) => taskContainer(e),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                            SizedBox(height: 20),
                            sectionHeader(
                              "YOUR ACHIEVEMENTS",
                              context,
                            ),
                            allAchievements == null
                                ? emptyContainer("achievements")
                                : Row(
                                    children: allAchievements
                                        .map(
                                          (e) => Card(
                                            elevation: 18.0,
                                            color: Colors.transparent,
                                            shape: CircleBorder(),
                                            child: Image.asset(
                                              e,
                                              height: 80,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
