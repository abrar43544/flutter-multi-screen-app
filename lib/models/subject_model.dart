import 'package:flutter/material.dart';

class SubjectModel {
  final String name;
  final String description;
  final String schedule;
  final IconData icon;

  SubjectModel({
    required this.name,
    required this.description,
    required this.schedule,
    required this.icon,
  });
}