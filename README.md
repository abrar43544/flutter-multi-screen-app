# Flutter Offline CRUD Application

## Branch Name
feature/offline-cache-and-state-manangement

## API Used
JSONPlaceholder API

https://jsonplaceholder.typicode.com/

## Packages Used

- provider
- shared_preferences
- connectivity_plus
- http

## Architecture

UI → Provider → Repository → API Service → Local Storage

### Layers

- UI Layer (Screens)
- Provider State Management
- Repository Layer
- API Service Layer
- Local Storage Layer (SharedPreferences)

## Features

### CRUD Operations

- Fetch Courses
- Add Course
- Update Course
- Delete Course

### Offline Support

- Courses are cached locally using SharedPreferences.
- Cached courses are loaded when internet is unavailable.

### State Management

Provider is used to manage:

- Loading State
- Success State
- Error State
- Empty State

### Additional Features

- Pull To Refresh
- Search Courses
- Optimistic UI Updates

## Offline Strategy

When internet is available:

- Data is fetched from API
- Data is cached locally

When internet is unavailable:

- Cached data is loaded from local storage

## State Management Approach

Provider handles application state and notifies UI whenever data changes.