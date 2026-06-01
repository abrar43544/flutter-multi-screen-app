import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

class CourseFormScreen extends StatefulWidget {
  final Course? course;

  const CourseFormScreen({super.key, this.course});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final CourseService courseService = CourseService();

  bool isLoading = false;

  bool get isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      _titleController.text = widget.course!.title;
      _descriptionController.text = widget.course!.description;
    }
  }

  Future<void> saveCourse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isEdit) {
        final updatedCourse = await courseService.updateCourse(
          Course(
            id: widget.course!.id,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
          ),
        );

        if (!mounted) return;

        Navigator.pop(context, updatedCourse);
      } else {
        final newCourse = await courseService.addCourse(
          Course(
            id: 0,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
          ),
        );

        if (!mounted) return;

        Navigator.pop(context, newCourse);
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Course' : 'Add Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Course Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Course Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveCourse,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(isEdit ? 'Update Course' : 'Add Course'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}