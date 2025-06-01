enum JobRecordStatus {
  pending,
  approved;

  String get displayName {
    switch (this) {
      case JobRecordStatus.pending:
        return 'Pending';
      case JobRecordStatus.approved:
        return 'Approved';
    }
  }

  String get icon {
    switch (this) {
      case JobRecordStatus.pending:
        return '⏳';
      case JobRecordStatus.approved:
        return '✅';
    }
  }
}