class DestinationTimingsModel {
  String title;
  bool status;
  DateTime? startTime;
  DateTime? endTime;

  DestinationTimingsModel({required this.title, this.status = true, this.startTime, this.endTime});
}
