import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';

class CourseService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .take(10)
          .map((item) => Course.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch courses');
    }
  }

  Future<Course> addCourse(Course course) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 201) {
      return Course.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add course');
    }
  }

  Future<Course> updateCourse(Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${course.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 200) {
      return Course.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update course');
    }
  }

  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete course');
    }
  }
}