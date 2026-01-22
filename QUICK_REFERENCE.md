# 🚀 Quick Reference - Civic Resolve Development

## File Structure Overview

```
lib/
├── main.dart                          # App entry point with theme
├── firebase_options.dart              # Firebase configuration (pre-configured)
├── auth/                              # Authentication screens (coming)
│   ├── login_screen.dart
│   ├── register_citizen.dart
│   ├── register_worker.dart
│   ├── register_authority.dart
│   └── email_verification.dart
├── screens/                           # Role-based dashboards (coming)
│   ├── citizen/
│   │   ├── citizen_home.dart
│   │   ├── report_issue.dart
│   │   └── issue_detail.dart
│   ├── worker/
│   │   ├── worker_home.dart
│   │   ├── available_issues.dart
│   │   └── assigned_issues.dart
│   └── authority/
│       ├── authority_home.dart
│       └── issue_management.dart
├── models/                            # Data models ✅
│   ├── user_model.dart               # User data structure ✅
│   └── issue_model.dart              # Issue data structure ✅
├── services/                          # Business logic ✅
│   ├── auth_service.dart             # Firebase authentication ✅
│   └── user_repository.dart          # Firestore user operations ✅
├── theme/                             # Design system ✅
│   └── app_theme.dart                # Material 3 themes and styles ✅
├── providers/                         # State management ✅
│   └── theme_provider.dart           # Theme toggle state ✅
├── widgets/                           # Reusable components ✅
│   ├── app_shell.dart                # Layout shell ✅
│   └── common_widgets.dart           # Reusable UI widgets ✅
└── utils/                             # Utilities ✅
    └── validation_utils.dart          # Input validation ✅
```

---

## Key Services (Singletons)

### AuthService
```dart
import 'package:civic_resolve/services/auth_service.dart';

final authService = AuthService();

// Register
await authService.registerCitizen(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  phone: '1234567890',
  address: '123 Main St',
  location: GeoPoint(40.7128, -74.0060),
);

// Login
String role = await authService.loginAndFetchRole(
  email: 'john@example.com',
  password: 'password123',
);
// Returns: 'citizen', 'worker', or 'authority'

// Get current user
User? user = authService.currentUser;

// Listen to auth changes
authService.authStateChanges.listen((user) {
  if (user != null) {
    print('User logged in: ${user.email}');
  } else {
    print('User logged out');
  }
});
```

### UserRepository
```dart
import 'package:civic_resolve/services/user_repository.dart';

final userRepo = UserRepository();

// Get user
UserModel? user = await userRepo.getUserByUid(uid);

// Watch user in real-time
userRepo.getUserStream(uid).listen((user) {
  print('User updated: ${user?.name}');
});

// Update user
await userRepo.updateUser(uid: uid, data: {
  'name': 'Jane Doe',
  'phone': '0987654321',
});

// Find nearby workers
List<UserModel> workers = await userRepo.getNearbyWorkers(
  centerLocation: currentLocation,
  radiusInKm: 5,
);
```

---

## Theme Usage

### Access Current Theme
```dart
import 'package:civic_resolve/theme/app_theme.dart';

// In build method:
@override
Widget build(BuildContext context) {
  final primaryColor = Theme.of(context).colorScheme.primary;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Text(
      'Hello',
      style: AppTextStyles.title1,
    ),
  );
}
```

### Common Spacings
```dart
SizedBox(height: AppSpacing.sm);      // 8
SizedBox(height: AppSpacing.md);      // 16
SizedBox(height: AppSpacing.lg);      // 24
SizedBox(height: AppSpacing.xl);      // 32
```

### Text Styles
```dart
Text('Main heading', style: AppTextStyles.headline1);
Text('Section title', style: AppTextStyles.title1);
Text('Body text', style: AppTextStyles.body1);
Text('Caption', style: AppTextStyles.caption);
```

### Common Components
```dart
// Loading overlay
LoadingOverlay(
  isLoading: isLoading,
  child: YourContent(),
  message: 'Processing...',
)

// Primary button
PrimaryButton(
  label: 'Submit',
  onPressed: () {},
  isLoading: isLoading,
  width: double.infinity,
)

// Empty state
EmptyState(
  icon: Icons.inbox,
  title: 'No Issues',
  subtitle: 'Start by reporting an issue',
  action: ElevatedButton(
    onPressed: () {},
    child: Text('Report Issue'),
  ),
)

// Error display
ErrorWidget(
  message: 'Failed to load issues',
  onRetry: () => fetchIssues(),
)
```

---

## Validation

### Validate User Input
```dart
import 'package:civic_resolve/utils/validation_utils.dart';

// In form field
TextFormField(
  validator: ValidationUtils.validateEmail,
  decoration: InputDecoration(labelText: 'Email'),
)

// Custom validation
String? error = ValidationUtils.validatePassword(passwordValue);
if (error != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(error)),
  );
}

// All available validators:
ValidationUtils.validateName(value)
ValidationUtils.validateEmail(value)
ValidationUtils.validatePassword(value)
ValidationUtils.validatePasswordMatch(password, confirm)
ValidationUtils.validatePhone(value)
ValidationUtils.validateAddress(value)
ValidationUtils.validateCity(value)
ValidationUtils.validateSkill(value)
ValidationUtils.validateJurisdiction(value)
ValidationUtils.validateIssueTitle(value)
ValidationUtils.validateIssueDescription(value)
ValidationUtils.validateIssueCategory(value)
```

---

## Error Handling Pattern

```dart
try {
  final role = await authService.loginAndFetchRole(
    email: email,
    password: password,
  );
  // Navigate based on role
  _navigateToDashboard(role);
} on FirebaseAuthException catch (e) {
  // Service already provides user-friendly messages
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message ?? 'Authentication failed')),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Unexpected error: $e')),
  );
}
```

---

## Creating New Screens

### Template
```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class YourScreen extends StatefulWidget {
  const YourScreen({Key? key}) : super(key: key);

  @override
  State<YourScreen> createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Loading...',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Screen', style: AppTextStyles.title1),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Content', style: AppTextStyles.headline1),
              SizedBox(height: AppSpacing.md),
              // Your content here
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Common Patterns

### Real-time Data Listening
```dart
StreamBuilder<UserModel?>(
  stream: userRepository.getUserStream(uid),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LoadingIndicator();
    }
    if (snapshot.hasError) {
      return ErrorWidget(message: snapshot.error.toString());
    }
    if (!snapshot.hasData || snapshot.data == null) {
      return EmptyState(
        icon: Icons.person,
        title: 'User Not Found',
        subtitle: 'Please try again',
      );
    }
    
    final user = snapshot.data!;
    return UserProfileCard(user: user);
  },
)
```

### Async Operations
```dart
Future<void> submitForm() async {
  setState(() => isLoading = true);
  try {
    await authService.registerCitizen(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      address: addressController.text,
      location: currentLocation,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration successful!')),
    );
    Navigator.of(context).pop();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    setState(() => isLoading = false);
  }
}
```

---

## Firestore Collections

### Users Collection
```
/users/{uid}
├── uid: string
├── name: string
├── email: string
├── phone: string
├── role: string ('citizen', 'worker', 'authority')
├── address: string
├── city: string
├── location: GeoPoint
├── isEmailVerified: boolean
├── createdAt: timestamp
└── updatedAt: timestamp
```

### Issues Collection
```
/issues/{issueId}
├── id: string
├── title: string
├── description: string
├── category: string
├── status: string (reported, assigned, in-progress, resolved, verified)
├── reportedBy: string (user UID)
├── location: GeoPoint
├── address: string
├── createdAt: timestamp
└── [other fields as needed]
```

---

## Debug Tips

### Check Theme
```dart
print('Theme: ${Theme.of(context).brightness}');
print('Primary: ${Theme.of(context).colorScheme.primary}');
```

### Log Firebase User
```dart
final user = authService.currentUser;
print('User: ${user?.email}');
print('Email Verified: ${user?.emailVerified}');
```

### Check Firestore Data
```dart
// In Firebase Console:
// Go to Firestore Database
// Check 'users' and 'issues' collections
// Verify document structure matches models
```

---

## Adding New Features

### Step 1: Create Model (if needed)
- Add to `lib/models/`
- Implement `fromFirestore()` and `toFirestore()`

### Step 2: Create Service (if needed)
- Add to `lib/services/`
- Use singleton pattern
- Implement CRUD methods

### Step 3: Create Screen
- Add to `lib/screens/`
- Use theme system
- Include loading states
- Handle errors with SnackBars

### Step 4: Test
- Verify theme works (light & dark)
- Check responsive layout
- Test error cases
- Verify Firestore integration

### Step 5: Commit
```bash
git add .
git commit -m "feat: add [feature name]"
git push origin main
```

---

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Flutter](https://firebase.flutter.dev/)
- [Material 3 Design](https://m3.material.io/)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)

---

**Last Updated**: January 22, 2026
**Project**: Civic Resolve
**Status**: Phase 1 ✅ Complete
