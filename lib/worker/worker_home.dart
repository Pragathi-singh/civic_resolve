import 'package:flutter/material.dart';
import 'available_issues.dart';
import 'assigned_issues.dart';

class WorkerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Worker Home")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("Available Issues"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AvailableIssues()),
              );
            },
          ),
          ElevatedButton(
            child: Text("My Assigned Issues"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AssignedIssues()),
              );
            },
          ),
        ],
      ),
    );
  }
}
