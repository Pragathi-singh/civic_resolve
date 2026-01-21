import 'package:flutter/material.dart';

class IssueDetailWorker extends StatefulWidget {
  final String issueTitle;

  const IssueDetailWorker({super.key, required this.issueTitle});

  @override
  State<IssueDetailWorker> createState() => _IssueDetailWorkerState();
}

class _IssueDetailWorkerState extends State<IssueDetailWorker> {
  String status = "Open";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Issue Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.issueTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Status: $status"),
            const SizedBox(height: 20),

            if (status == "Open")
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    status = "Assigned";
                  });
                },
                child: const Text("Accept Issue"),
              ),

            if (status == "Assigned")
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    status = "Resolved";
                  });
                },
                child: const Text("Mark as Resolved"),
              ),
          ],
        ),
      ),
    );
  }
}
