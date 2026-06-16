import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../repositories/course_repository.dart';

enum CourseState {
  loading,
  success,
  error,
  empty,
}

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider({required this.repository});

  List<Course> courses = [];
  CourseState state = CourseState.loading;
  String? errorMessage;

  Future<void> loadCourses() async {
    try {
      state = CourseState.loading;
      errorMessage = null;
      notifyListeners();

      courses = await repository.getCourses();

      if (courses.isEmpty) {
        state = CourseState.empty;
      } else {
        state = CourseState.success;
      }

      notifyListeners();
    } catch (error) {
      state = CourseState.error;
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      final newCourse = await repository.addCourse(course);

      courses.insert(0, newCourse);
      state = CourseState.success;
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCourse(Course updatedCourse) async {
    final index = courses.indexWhere((course) => course.id == updatedCourse.id);

    if (index == -1) {
      return;
    }

    final oldCourse = courses[index];

    courses[index] = updatedCourse;
    notifyListeners();

    try {
      final apiUpdatedCourse = await repository.updateCourse(updatedCourse);
      courses[index] = apiUpdatedCourse;
      notifyListeners();
    } catch (error) {
      courses[index] = oldCourse;
      errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCourse(Course course) async {
    final index = courses.indexWhere((item) => item.id == course.id);

    if (index == -1) {
      return;
    }

    courses.removeAt(index);
    notifyListeners();

    try {
      await repository.deleteCourse(course.id);

      if (courses.isEmpty) {
        state = CourseState.empty;
      }

      notifyListeners();
    } catch (error) {
      courses.insert(index, course);
      errorMessage = error.toString();
      state = CourseState.success;
      notifyListeners();
      rethrow;
    }
  }

  void searchCourses(String query) {
    if (query.isEmpty) {
      loadCourses();
      return;
    }

    final filtered = courses.where((course) {
      return course.title.toLowerCase().contains(query.toLowerCase()) ||
          course.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    courses = filtered;

    if (courses.isEmpty) {
      state = CourseState.empty;
    } else {
      state = CourseState.success;
    }

    notifyListeners();
  }
}