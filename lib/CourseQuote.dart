

// 擴展的 Quote 類，用於課程列表 (course_quote.dart)
import 'Quote.dart';

class CourseQuote extends Quote {
  final String? teacherName;
  final String? description;

  CourseQuote({
    required String title,
    String? semester,
    required String courseCode,
    this.teacherName,
    this.description,
  }) : super(
    title: title,
    semester: "",
    courseCode: courseCode,
  );

  // 覆寫工廠方法
  factory CourseQuote.fromJson(Map<String, dynamic> json) {
    return CourseQuote(
      title: "${json['title']} - ${json['teacher_name'] ?? '未指定教師'}",
      semester: "113-1",
      courseCode: json['course_code'] ?? '',
      teacherName: json['teacher_name'],
      description: json['description'],
    );
  }
}

// 學生課程的 Quote 類 (student_quote.dart)
class StudentQuote extends Quote {
  final String? studentId;
  final DateTime? enrollmentDate;

  StudentQuote({
    required String title,
    String? semester,
    required String courseCode,
    this.studentId,
    this.enrollmentDate,
  }) : super(
    title: title,
    semester: "",
    courseCode: courseCode,
  );

  factory StudentQuote.fromJson(Map<String, dynamic> json) {
    return StudentQuote(
      title: "${json['courseCode']} ${json['title']} ${json['teacher']}",
      semester: "113-1",
      courseCode: json['courseCode'] ?? '',
      studentId: json['student_id'],
      enrollmentDate: json['enrollment_date'] != null
          ? DateTime.parse(json['enrollment_date'])
          : null,
    );
  }
}