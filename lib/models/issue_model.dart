import 'package:cloud_firestore/cloud_firestore.dart';

class IssueModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status; // 'reported', 'assigned', 'resolved'
  final DateTime createdAt;
  final String? assignedWorkerId;
  final String? reportedBy; // citizen user ID or name

  IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    this.assignedWorkerId,
    this.reportedBy,
  });

  // Convert Firestore document to IssueModel
  factory IssueModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return IssueModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      status: data['status'] ?? 'reported',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      assignedWorkerId: data['assignedWorkerId'],
      reportedBy: data['reportedBy'],
    );
  }

  // Convert IssueModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'assignedWorkerId': assignedWorkerId,
      'reportedBy': reportedBy,
    };
  }
}
