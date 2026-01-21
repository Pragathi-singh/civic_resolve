import 'package:flutter/material.dart';
import 'issue_detail_worker.dart';

class AvailableIssues extends StatelessWidget {
  final List<String> issues = [
    "Pothole near main gate",
    "Street light not working",
    "Garbage overflow",
    "Water leakage",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Issues")),
      body: ListView.builder(
        itemCount: issues.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(issues[index]),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        IssueDetailWorker(issueTitle: issues[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
