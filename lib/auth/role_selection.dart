import 'package:flutter/material.dart';
import '../user/user_home.dart';
import '../worker/worker_home.dart';

class RoleSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Role")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("Citizen"),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => UserHome()),
              );
            },
          ),
          ElevatedButton(
            child: Text("Worker"),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => WorkerHome()),
              );
            },
          ),
        ],
      ),
    );
  }
}
