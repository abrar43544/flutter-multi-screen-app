import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
import 'course_form_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CourseService courseService = CourseService();
  List<Course> courses = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedCourses = await courseService.fetchCourses();

      if (!mounted) return;

      setState(() {
        courses = fetchedCourses;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  Future<void> deleteCourse(Course course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Course'),
          content: Text('Are you sure you want to delete "${course.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirm == true) {
      try {
        await courseService.deleteCourse(course.id);

        if (!mounted) return;

        setState(() {
          courses.removeWhere((item) => item.id == course.id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted successfully')),
        );
      } catch (error) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  Future<void> openAddCourse() async {
    final newCourse = await Navigator.push<Course>(
      context,
      MaterialPageRoute(
        builder: (context) => const CourseFormScreen(),
      ),
    );

    if (!mounted) return;

    if (newCourse != null) {
      setState(() {
        courses.insert(0, newCourse);
      });
    }
  }

  Future<void> openEditCourse(Course course) async {
    final updatedCourse = await Navigator.push<Course>(
      context,
      MaterialPageRoute(
        builder: (context) => CourseFormScreen(course: course),
      ),
    );

    if (!mounted) return;

    if (updatedCourse != null) {
      setState(() {
        final index = courses.indexWhere((item) => item.id == updatedCourse.id);
        if (index != -1) {
          courses[index] = updatedCourse;
        }
      });
    }
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loadCourses,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadCourses,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              title: Text(
                course.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('ID: ${course.id}\n${course.description}'),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    openEditCourse(course);
                  } else if (value == 'delete') {
                    deleteCourse(course);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses API CRUD'),
        centerTitle: true,
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddCourse,
        child: const Icon(Icons.add),
      ),
    );
  }
}