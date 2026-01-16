import 'package:flutter/material.dart';
import '../profil/profile_screen.dart';
import '../form/form_screen.dart';
import '../logbook/logbook_screen.dart';
import '../konten/content_screen.dart';
import '../notifikasi/notification_screen.dart';

class MainAppScreen extends StatefulWidget {
  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    
     ProfileScreen(),
     ProfileScreen(),
    FormScreen(),
    LogbookScreen(),
    HomeScreen(),
    NotificationScreen(),
   
    
   
    
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Identity Service App"),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Formulir"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Logbook"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Konten"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifikasi"),
        ],
      ),
    );
  }
}
