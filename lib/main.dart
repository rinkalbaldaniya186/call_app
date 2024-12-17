import 'package:call_app/add_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Call App'),
        // ),
        body: AddPage(),
      ),
    );
  }
}

