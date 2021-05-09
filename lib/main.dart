import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:school_management/drawer.dart';

import 'package:school_management/screens/home_screen/homeScreen.dart';
import 'package:school_management/screens/login_screen/loginScreen.dart';
import 'package:school_management/screens/profile_screen/profileScreen.dart';
import 'package:school_management/screens/about_screen/aboutScreen.dart';

import 'package:school_management/screens/signup_screen/signupScreen.dart';
import 'package:school_management/screens/login_signup_select_screen/loginSignupSelectScreen.dart';

import 'package:school_management/screens/calendar_screen/classesCalendarScreen.dart';
import 'package:school_management/screens/calendar_screen/tasksCalendarScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'EduLy',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/': (_) => LoginSignupSelectScreen(),
        '/login': (_) => LoginScreen(),
        '/signup': (_) => SignupScreen(),
        '/about': (_) => AboutScreen(),
        '/main': (_) => BottomNavigator(),
        '/main/classes': (_) => ClassesCalendarScreen(),
        '/main/tasks': (_) => TasksCalendarScreen(),
      },
    ),
  );
}

class BottomNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavigatorState();
  }
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _index = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          children: <Widget>[
            HomeScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex) => setState(() {
          _index = newIndex;
          _pageController.animateToPage(
            newIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }),
        currentIndex: _index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFFF0F0F0),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        selectedIconTheme: IconThemeData(color: Colors.blueGrey[600]),
        items: [
          BottomNavigationBarItem(
            icon: _index == 0
                ? Icon(Icons.home_filled)
                : Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _index == 1
                ? Icon(Icons.account_box)
                : Icon(Icons.account_box_outlined),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
