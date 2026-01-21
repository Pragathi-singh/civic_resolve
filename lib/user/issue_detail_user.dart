import 'package:flutter/material.dart';
import '../models/issue_model.dart';

class IssueDetailUser extends StatelessWidget {
  final IssueModel issue;

  const IssueDetailUser({required this.issue});

  @override
  Widget build(BuildContext context) {
    // Status color
    Color statusColor;
    IconData statusIcon;
    
    switch (issue.status) {
      case 'reported':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'assigned':
        statusColor = Colors.blue;
        statusIcon = Icons.person;
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
        title: Text('Issue Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(color: statusColor, width: 3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(statusIcon, color: statusColor, size: 32),
                  SizedBox(width: 12),
                  Text(
                    issue.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Issue Title',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    issue.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Category
                  _buildInfoRow(
                    icon: Icons.category,
                    label: 'Category',
                    value: issue.category,
                  ),
                  SizedBox(height: 16),

                  // Reported Date
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Reported On',
                    value: _formatDate(issue.createdAt),
                  ),
                  SizedBox(height: 24),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        issue.description,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Status Information
                  if (issue.status == 'reported')
                    _buildStatusCard(
                      title: 'Pending Assignment',
                      message:
                          'Your issue has been reported. A worker will be assigned soon.',
                      icon: Icons.hourglass_empty,
                      color: Colors.orange,
                    ),
                  if (issue.status == 'assigned')
                    _buildStatusCard(
                      title: 'Worker Assigned',
                      message:
                          'A worker has been assigned to resolve your issue.',
                      icon: Icons.engineering,
                      color: Colors.blue,
                    ),
                  if (issue.status == 'resolved')
                    _buildStatusCard(
                      title: 'Issue Resolved',
                      message:
                          'Thank you for reporting! This issue has been resolved.',
                      icon: Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 20),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
