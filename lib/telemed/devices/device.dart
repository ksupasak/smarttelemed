abstract class Device {
  String name;
  String id;
  String type;
  String status;
  bool autoStart;

  Device({
    required this.name,
    required this.id,
    required this.type,
    required this.status,
    this.autoStart = false,
  });

  void connect();

  Map<String, dynamic> toJson();
}
