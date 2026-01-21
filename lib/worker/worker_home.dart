import 'package:flutter/material.dart';
import 'available_issues.dart';
import 'assigned_issues.dart';

class WorkerHome extends StatelessWidget {
  const WorkerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Worker Home")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text("Available Issues"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AvailableIssues()),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text("My Assigned Issues"),
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
