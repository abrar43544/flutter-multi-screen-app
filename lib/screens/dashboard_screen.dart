import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/subject_model.dart';
import '../models/user_model.dart';
import 'detail_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  final UserModel user;

  DashboardScreen({super.key, required this.user});

  final List<SubjectModel> subjects = [
    SubjectModel(
      name: 'Mobile App Development',
      description: 'This subject focuses on building modern mobile applications using Flutter, Dart, widgets, layouts, navigation, forms, and state handling.',
      schedule: 'Monday and Wednesday, 10:00 AM - 11:30 AM',
      icon: Icons.phone_android,
    ),
    SubjectModel(
      name: 'Software Re-engineering',
      description: 'This subject teaches software maintenance, reverse engineering, restructuring, refactoring, and improving existing software systems.',
      schedule: 'Tuesday and Thursday, 12:00 PM - 1:30 PM',
      icon: Icons.engineering,
    ),
    SubjectModel(
      name: 'MIS',
      description: 'Management Information Systems explains how organizations use technology, databases, reports, and decision support systems for better management.',
      schedule: 'Friday, 9:00 AM - 12:00 PM',
      icon: Icons.business_center,
    ),
  ];

  void logout(BuildContext context) {
    AuthController.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void openDetail(BuildContext context, SubjectModel subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(subject: subject),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Screen'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.person, size: 38, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(user.email),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Current Subjects',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: Icon(subject.icon, color: Colors.indigo),
                      ),
                      title: Text(
                        subject.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(subject.schedule),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => openDetail(context, subject),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}