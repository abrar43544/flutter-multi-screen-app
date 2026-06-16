import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_model.dart';

class CourseLocalService {
  static const String coursesKey = 'cached_courses';

  Future<void> saveCourses(List<Course> courses) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = courses.map((course) => course.toJson()).toList();

    await prefs.setString(
      coursesKey,
      jsonEncode(jsonList),
    );
  }

  Future<List<Course>> getCourses() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(coursesKey);

    if (data == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(data);

    return decoded
        .map((json) => Course.fromJson(json))
        .toList();
  }
}