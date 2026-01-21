import 'package:flutter/material.dart';

class AssignedIssues extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Assigned Issues")),
      body: Center(child: Text("Your assigned issues")),
    );
  }
}
