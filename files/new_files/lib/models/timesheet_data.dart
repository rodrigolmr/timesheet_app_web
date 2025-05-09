class TimesheetData {
  final String id;
  final String userId;
  String jobName;
  DateTime? date;
  String tm;
  String jobSize;
  String material;
  String jobDesc;
  String foreman;
  String vehicle;
  String notes;
  List<Map<String, String>> workers;

  TimesheetData({
    this.id = '',
    this.userId = '',
    this.jobName = '',
    this.date,
    this.tm = '',
    this.jobSize = '',
    this.material = '',
    this.jobDesc = '',
    this.foreman = '',
    this.vehicle = '',
    this.notes = '',
    List<Map<String, String>>? workers,
  }) : workers = workers ?? [];

  TimesheetData copyWith({
    String? id,
    String? userId,
    String? jobName,
    DateTime? date,
    String? tm,
    String? jobSize,
    String? material,
    String? jobDesc,
    String? foreman,
    String? vehicle,
    String? notes,
    List<Map<String, String>>? workers,
  }) {
    return TimesheetData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobName: jobName ?? this.jobName,
      date: date ?? this.date,
      tm: tm ?? this.tm,
      jobSize: jobSize ?? this.jobSize,
      material: material ?? this.material,
      jobDesc: jobDesc ?? this.jobDesc,
      foreman: foreman ?? this.foreman,
      vehicle: vehicle ?? this.vehicle,
      notes: notes ?? this.notes,
      workers: workers ?? this.workers,
    );
  }
}
