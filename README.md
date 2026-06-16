# Flutter Multi Screen App - Course API CRUD Integration

## Student Information

Name: Abrar Ahmed

Course: Mobile Application Development

Assignment: CRUD API Integration using JSONPlaceholder

Branch Name: feature/course-api-integration

---

## Project Overview

This project is an extension of the previously developed Flutter Multi-Screen Authentication Application.

The application includes:

- User Registration
- User Login
- Dashboard Navigation
- Form Validation
- State Management
- API Integration
- CRUD Operations

---

## API Used

JSONPlaceholder REST API

Endpoint:

https://jsonplaceholder.typicode.com/posts

---

## Documentation Followed

Official JSONPlaceholder Documentation:

https://jsonplaceholder.typicode.com/guide

---

## Implemented CRUD Operations

### Create (POST)

Users can add a new course using the Add Course form.

### Read (GET)

Courses are fetched from the API and displayed in a list.

### Update (PUT)

Users can edit existing course information.

### Delete (DELETE)

Users can delete courses with confirmation dialog.

---

## Architecture

The project follows a layered architecture:

### Models

- course_model.dart
- user_model.dart
- subject_model.dart

### Services

- course_service.dart

### Screens

- login_screen.dart
- register_screen.dart
- dashboard_screen.dart
- detail_screen.dart
- course_list_screen.dart
- course_form_screen.dart

### Controllers

- auth_controller.dart

### Validators

- app_validator.dart

---

## Features Implemented

- Authentication System
- Form Validation
- Navigation Between Screens
- REST API Integration
- Loading State Handling
- Error State Handling
- Create Course
- Read Courses
- Update Course
- Delete Course
- Confirmation Dialog Before Delete

---

## GitHub Branch

feature/course-api-integration