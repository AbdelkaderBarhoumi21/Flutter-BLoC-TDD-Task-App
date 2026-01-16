# 📱 Flutter Task Management App

A **production-ready** Flutter application demonstrating **Clean Architecture**, **Test-Driven Development (TDD)**, and **BLoC** state management pattern.

## ✨ Features

- ✅ **Create, Read, Update, Delete (CRUD)** tasks
- 🎯 **Task prioritization** (Low, Medium, High)
- 📊 **Status tracking** (Pending, In Progress, Completed)
- 💾 **Offline-first architecture** with local caching
- 🔄 **Automatic cache synchronization**
- 🌐 **Network-aware** operations
- ⚡ **Real-time state management** with BLoC
- ✨ **Material Design 3** UI

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three distinct layers:
```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│    (UI + BLoC + State Management)   │
├─────────────────────────────────────┤
│          Domain Layer               │
│  (Entities + Use Cases + Contracts) │
├─────────────────────────────────────┤
│           Data Layer                │
│ (Models + DataSources + Repository) │
└─────────────────────────────────────┘
```

### Key Architectural Benefits:
- 🎯 **Separation of Concerns**: Each layer has a single responsibility
- 🔄 **Dependency Inversion**: Dependencies point inward (towards domain)
- 🧪 **Highly Testable**: Easy to mock and test each layer independently
- 🔧 **Maintainable**: Easy to add features without breaking existing code
- 📦 **Scalable**: Structure supports growth

## 🛠️ Technologies & Packages

### Core
- **Flutter SDK** `>=3.0.0`
- **Dart** `>=3.0.0`

### State Management
- `flutter_bloc` ^8.1.3 - BLoC pattern implementation
- `bloc` ^8.1.2 - Core BLoC library
- `equatable` ^2.0.5 - Value equality

### Dependency Injection
- `get_it` ^7.6.0 - Service locator

### Networking & Storage
- `http` ^1.1.0 - HTTP client
- `shared_preferences` ^2.2.2 - Local storage
- `connectivity_plus` ^5.0.1 - Network status

### Utilities
- `dartz` ^0.10.1 - Functional programming (Either, Option)
- `uuid` ^4.0.0 - Unique ID generation
- `intl` ^0.18.1 - Internationalization

### Testing
- `flutter_test` - Flutter testing framework
- `bloc_test` ^9.1.4 - BLoC testing utilities
- `mocktail` ^1.0.0 - Mocking library

## 🚀 Getting Started

### Prerequisites
```bash
flutter --version
# Flutter 3.0.0 or higher
```

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/flutter-task-app.git
cd flutter-task-app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/task/domain/usecases/get_tasks_test.dart
```

### Code Analysis
```bash
flutter analyze
```

## 📁 Project Structure
```
lib/
├── core/
│   ├── error/              # Custom exceptions & failures
│   ├── network/            # Network connectivity
│   ├── usecases/           # Base use case class
│   └── utils/              # Constants & validators
├── features/
│   └── task/
│       ├── data/
│       │   ├── datasources/    # Remote & local data sources
│       │   ├── models/         # Data models (JSON serialization)
│       │   └── repositories/   # Repository implementations
│       ├── domain/
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Repository contracts
│       │   └── usecases/       # Business logic
│       └── presentation/
│           ├── bloc/           # BLoC (events, states, logic)
│           ├── pages/          # UI screens
│           └── widgets/        # Reusable UI components
├── injection_container.dart    # Dependency injection setup
└── main.dart                   # App entry point

test/
├── core/
├── features/
│   └── task/
│       ├── data/           # Data layer tests
│       ├── domain/         # Domain layer tests
│       └── presentation/   # Presentation layer tests
└── fixtures/               # Test data (JSON files)
```

## 🧪 Testing Strategy (TDD)

This project follows **Test-Driven Development** with comprehensive test coverage:

### Test Coverage
- ✅ **Unit Tests**: Domain (Use Cases), Data (Models, DataSources)
- ✅ **Integration Tests**: Repository implementation
- ✅ **Widget Tests**: BLoC state management
- ✅ **Mock Objects**: Using Mocktail for dependencies

### TDD Workflow
1. 🔴 **Red**: Write a failing test
2. 🟢 **Green**: Write minimal code to pass
3. 🔵 **Refactor**: Clean up while keeping tests green

### Test Examples
```bash
# Domain layer tests
test/features/task/domain/usecases/

# Data layer tests
test/features/task/data/models/
test/features/task/data/datasources/
test/features/task/data/repositories/

# Presentation layer tests
test/features/task/presentation/bloc/
```

## 🎯 Key Features Implementation

### Offline-First Architecture
- Tasks are cached locally using `SharedPreferences`
- Automatic fallback to cache when offline
- Smart sync when connection restored

### Network-Aware Operations
- Checks connectivity before remote operations
- Provides meaningful error messages
- Graceful degradation when offline

### State Management with BLoC
- Clear separation: Events → BLoC → States
- Easy to test and debug
- Predictable state changes

### Validation
- Input validation in domain layer
- Clear error messages
- Prevents invalid data from reaching repository

## 📝 Use Cases

- **GetTasks**: Fetch all tasks (remote + cache fallback)
- **GetTaskById**: Fetch single task by ID
- **AddTask**: Create new task with validation
- **UpdateTask**: Modify existing task
- **DeleteTask**: Remove task from system

## 🔐 Error Handling

Custom failure types for better error management:
- `ServerFailure` - API/server errors
- `NetworkFailure` - No internet connection
- `CacheFailure` - Local storage errors
- `ValidationFailure` - Input validation errors
- `UnexpectedFailure` - Unexpected errors

## 🚦 CI/CD

GitHub Actions workflow included:
- ✅ Code analysis (`flutter analyze`)
- ✅ Run all tests
- ✅ Generate coverage report
- ✅ Runs on push/PR to main branch


## 🙏 Acknowledgments

- Clean Architecture by Robert C. Martin
- BLoC pattern by Felix Angelov
- Flutter community

---



- [Another Flutter Project](https://github.com/...)
- [Clean Architecture Example](https://github.com/...)
