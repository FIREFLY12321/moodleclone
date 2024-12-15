class Quote {
  late String title;
  late String semester;
  late String courseCode;

  Quote({
    required this.title,
    required this.semester,
    required this.courseCode,
  });

  // 基礎的 fromJson 工廠方法
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      title: json['title'] ?? '',
      semester: json['semester'],
      courseCode: json['course_code'] ?? '',
    );
  }

  // 用於子類覆寫的方法，處理標題格式
  String formatTitle(Map<String, dynamic> json) {
    return json['title'] ?? '';
  }
}