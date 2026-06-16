import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/course_model.dart';
import '../services/course_local_service.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService apiService;
  final CourseLocalService localService;

  CourseRepository({
    required this.apiService,
    required this.localService,
  });

  Future<bool> hasInternet() async {
  final List<ConnectivityResult> result =
      await Connectivity().checkConnectivity();

  return !result.contains(ConnectivityResult.none);
  }

  Future<List<Course>> getCourses() async {
    final online = await hasInternet();

    if (online) {
      final courses = await apiService.fetchCourses();
      await localService.saveCourses(courses);
      return courses;
    } else {
      return await localService.getCourses();
    }
  }

  Future<Course> addCourse(Course course) async {
    final online = await hasInternet();

    if (!online) {
      throw Exception('No internet connection. Course cannot be added offline.');
    }

    return await apiService.addCourse(course);
  }

  Future<Course> updateCourse(Course course) async {
    final online = await hasInternet();

    if (!online) {
      throw Exception('No internet connection. Course cannot be updated offline.');
    }

    return await apiService.updateCourse(course);
  }

  Future<void> deleteCourse(int id) async {
    final online = await hasInternet();

    if (!online) {
      throw Exception('No internet connection. Course cannot be deleted offline.');
    }

    await apiService.deleteCourse(id);
  }
}  