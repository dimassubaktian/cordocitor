class QrcodeModel {
  final int id;
  final String text;
  final String time;

  QrcodeModel({required this.id, required this.text, required this.time});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "text": text,
      "time": time,
    };
  }
}
