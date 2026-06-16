import 'package:flutter/material.dart';
import '../models/course_model.dart';

class CourseFormScreen extends StatefulWidget {
  final Course? course;

  const CourseFormScreen({super.key, this.course});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  bool get isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      titleController.text = widget.course!.title;
      descriptionController.text = widget.course!.description;
    }
  }

  void saveCourse() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final course = Course(
      id: isEdit ? widget.course!.id : DateTime.now().millisecondsSinceEpoch,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
    );

    Navigator.pop(context, course);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Course' : 'Add Course'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Course Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Course Description',
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: saveCourse,
                  icon: Icon(isEdit ? Icons.edit : Icons.add),
                  label: Text(isEdit ? 'Update Course' : 'Add Course'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}