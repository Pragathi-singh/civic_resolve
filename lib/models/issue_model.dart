import 'package:cloud_firestore/cloud_firestore.dart';

class IssueModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status; // 'reported', 'assigned', 'in-progress', 'resolved', 'verified', 'reopened'
  final String? reportedBy; // Citizen user ID
  final String? reportedByName;
  final String? assignedWorkerId;
  final String? assignedWorkerName;
  final String? verifiedBy; // Authority user ID
  final String? resolvedBy; // Worker user ID
  final GeoPoint location;
  final String address;
  final DateTime createdAt;
  final DateTime? assignedAt;
  final DateTime? resolvedAt;
  final DateTime? verifiedAt;
  final String? imageUrl;
  final String? resolutionNote;
  final String? rejectionReason;
  final List<String>? imageUrls; // Multiple images
  final double? priority; // Auto-calculated priority score
  final bool? isDuplicate;
  final String? duplicateOf; // Reference to original issue if duplicate
  final int? daysToResolve; // SLA tracking
  final String? severity; // 'low', 'medium', 'high', 'critical'

  IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.reportedBy,
    required this.location,
    required this.address,
    required this.createdAt,
    this.reportedByName,
    this.assignedWorkerId,
    this.assignedWorkerName,
    this.verifiedBy,
    this.resolvedBy,
    this.assignedAt,
    this.resolvedAt,
    this.verifiedAt,
    this.imageUrl,
    this.resolutionNote,
    this.rejectionReason,
    this.imageUrls,
    this.priority,
    this.isDuplicate,
    this.duplicateOf,
    this.daysToResolve,
    this.severity,
  });

  // Convert Firestore document to IssueModel
  factory IssueModel.fromFirestore(Map<String, dynamic> data, {String? id}) {
    return IssueModel(
      id: id ?? data['id'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      status: data['status'] as String? ?? 'reported',
      reportedBy: data['reportedBy'] as String?,
      reportedByName: data['reportedByName'] as String?,
      assignedWorkerId: data['assignedWorkerId'] as String?,
      assignedWorkerName: data['assignedWorkerName'] as String?,
      verifiedBy: data['verifiedBy'] as String?,
      resolvedBy: data['resolvedBy'] as String?,
      location: data['location'] as GeoPoint? ?? GeoPoint(0, 0),
      address: data['address'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      assignedAt: (data['assignedAt'] as Timestamp?)?.toDate(),
      resolvedAt: (data['resolvedAt'] as Timestamp?)?.toDate(),
      verifiedAt: (data['verifiedAt'] as Timestamp?)?.toDate(),
      imageUrl: data['imageUrl'] as String?,
      resolutionNote: data['resolutionNote'] as String?,
      rejectionReason: data['rejectionReason'] as String?,
      imageUrls: (data['imageUrls'] as List?)?.cast<String>(),
      priority: (data['priority'] as num?)?.toDouble(),
      isDuplicate: data['isDuplicate'] as bool?,
      duplicateOf: data['duplicateOf'] as String?,
      daysToResolve: data['daysToResolve'] as int?,
      severity: data['severity'] as String?,
    );
  }

  // Convert IssueModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'reportedBy': reportedBy,
      'reportedByName': reportedByName,
      'assignedWorkerId': assignedWorkerId,
      'assignedWorkerName': assignedWorkerName,
      'verifiedBy': verifiedBy,
      'resolvedBy': resolvedBy,
      'location': location,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'assignedAt': assignedAt != null ? Timestamp.fromDate(assignedAt!) : null,
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
      'imageUrl': imageUrl,
      'resolutionNote': resolutionNote,
      'rejectionReason': rejectionReason,
      'imageUrls': imageUrls,
      'priority': priority,
      'isDuplicate': isDuplicate,
      'duplicateOf': duplicateOf,
      'daysToResolve': daysToResolve,
      'severity': severity,
    };
  }

  /// Create a copy with modified fields
  IssueModel copyWith({
    String? title,
    String? description,
    String? category,
    String? status,
    String? reportedBy,
    String? reportedByName,
    String? assignedWorkerId,
    String? assignedWorkerName,
    String? verifiedBy,
    String? resolvedBy,
    GeoPoint? location,
    String? address,
    DateTime? createdAt,
    DateTime? assignedAt,
    DateTime? resolvedAt,
    DateTime? verifiedAt,
    String? imageUrl,
    String? resolutionNote,
    String? rejectionReason,
    List<String>? imageUrls,
    double? priority,
    bool? isDuplicate,
    String? duplicateOf,
    int? daysToResolve,
    String? severity,
  }) {
    return IssueModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      reportedBy: reportedBy ?? this.reportedBy,
      reportedByName: reportedByName ?? this.reportedByName,
      assignedWorkerId: assignedWorkerId ?? this.assignedWorkerId,
      assignedWorkerName: assignedWorkerName ?? this.assignedWorkerName,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      location: location ?? this.location,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      assignedAt: assignedAt ?? this.assignedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      resolutionNote: resolutionNote ?? this.resolutionNote,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      imageUrls: imageUrls ?? this.imageUrls,
      priority: priority ?? this.priority,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      duplicateOf: duplicateOf ?? this.duplicateOf,
      daysToResolve: daysToResolve ?? this.daysToResolve,
      severity: severity ?? this.severity,
    );
  }

  @override
  String toString() {
    return 'IssueModel(id: $id, title: $title, status: $status, category: $category)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
