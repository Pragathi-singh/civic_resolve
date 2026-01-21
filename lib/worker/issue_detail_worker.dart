import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/issue_model.dart';

class IssueDetailWorker extends StatefulWidget {
  final IssueModel issue;
  final String workerId;

  const IssueDetailWorker({super.key, required this.issue, required this.workerId});

  @override
  State<IssueDetailWorker> createState() => _IssueDetailWorkerState();
}

class _IssueDetailWorkerState extends State<IssueDetailWorker> {
  bool _isLoading = false;
  late IssueModel _issue;

  @override
  void initState() {
    super.initState();
    _issue = widget.issue;
  }

  Future<void> _acceptIssue() async {
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance.collection('issues').doc(_issue.id).update({
      'status': 'assigned',
      'assignedWorkerId': widget.workerId,
    });
    setState(() {
      _issue = IssueModel(
        id: _issue.id,
        title: _issue.title,
        description: _issue.description,
        category: _issue.category,
        status: 'assigned',
        createdAt: _issue.createdAt,
        assignedWorkerId: widget.workerId,
        reportedBy: _issue.reportedBy,
      );
      _isLoading = false;
    });
  }

  Future<void> _resolveIssue() async {
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance.collection('issues').doc(_issue.id).update({
      'status': 'resolved',
    });
    setState(() {
      _issue = IssueModel(
        id: _issue.id,
        title: _issue.title,
        description: _issue.description,
        category: _issue.category,
        status: 'resolved',
        createdAt: _issue.createdAt,
        assignedWorkerId: _issue.assignedWorkerId,
        reportedBy: _issue.reportedBy,
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (_issue.status) {
      case 'reported':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'assigned':
        statusColor = Colors.blue;
        statusIcon = Icons.assignment_ind;
        break;
      case 'resolved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    _issue.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _issue.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(_issue.category, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  '${_issue.createdAt.day}/${_issue.createdAt.month}/${_issue.createdAt.year}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_issue.description),
              ),
            ),
            const SizedBox(height: 24),
            if (_issue.status == 'reported')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.assignment_ind),
                  label: const Text('Accept Issue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isLoading ? null : _acceptIssue,
                ),
              ),
            if (_issue.status == 'assigned' && _issue.assignedWorkerId == widget.workerId)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Mark as Resolved'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isLoading ? null : _resolveIssue,
                ),
              ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
