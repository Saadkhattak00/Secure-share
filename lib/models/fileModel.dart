// ignore: file_names
class FileModel {
  final String filename;
  final String url;
  final DateTime dateTime;

  FileModel({
    required this.filename,
    required this.url,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'filename': filename,
      'url': url,
      'dateTime': dateTime,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      filename: map['filename'] ?? '',
      url: map['url'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
    );
  }
}
