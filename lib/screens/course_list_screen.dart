import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course_model.dart';
import '../providers/course_provider.dart';
import 'course_form_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CourseProvider>().loadCourses();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> deleteCourse(Course course) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<CourseProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Course'),
          content: Text('Are you sure you want to delete "${course.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await provider.deleteCourse(course);

        messenger.showSnackBar(
          const SnackBar(content: Text('Course deleted successfully')),
        );
      } catch (error) {
        messenger.showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }

    navigator;
  }

  Future<void> openAddCourse() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<CourseProvider>();

    final newCourse = await navigator.push<Course>(
      MaterialPageRoute(
        builder: (context) => const CourseFormScreen(),
      ),
    );

    if (newCourse != null) {
      try {
        await provider.addCourse(newCourse);

        messenger.showSnackBar(
          const SnackBar(content: Text('Course added successfully')),
        );
      } catch (error) {
        messenger.showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  Future<void> openEditCourse(Course course) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<CourseProvider>();

    final updatedCourse = await navigator.push<Course>(
      MaterialPageRoute(
        builder: (context) => CourseFormScreen(course: course),
      ),
    );

    if (updatedCourse != null) {
      try {
        await provider.updateCourse(updatedCourse);

        messenger.showSnackBar(
          const SnackBar(content: Text('Course updated successfully')),
        );
      } catch (error) {
        messenger.showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  Widget buildStateBody(CourseProvider provider) {
    if (provider.state == CourseState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.state == CourseState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 70, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage ?? 'Something went wrong',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.loadCourses,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.state == CourseState.empty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.menu_book, size: 70, color: Colors.indigo),
              const SizedBox(height: 12),
              const Text(
                'No courses found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pull down to refresh or add a new course.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.loadCourses,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadCourses,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.courses.length,
        itemBuilder: (context, index) {
          final course = provider.courses[index];

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
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses Offline CRUD'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search courses',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          context.read<CourseProvider>().loadCourses();
                          setState(() {});
                        },
                      ),
              ),
              onChanged: (value) {
                context.read<CourseProvider>().searchCourses(value);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: buildStateBody(provider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddCourse,
        child: const Icon(Icons.add),
      ),
    );
  }
}