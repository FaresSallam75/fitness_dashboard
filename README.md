# Fitness Dashboard Documentation

This document provides a comprehensive overview of the **Fitness Dashboard** Flutter application. It covers core utilities, theming, business logic (Cubits/States), data models, repositories, networking, routing, services, and the presentation layer (screens & widgets). Diagrams illustrate the high-level architecture and data flow.  



   <div style="display: flex; flex-wrap: wrap; gap: 10px;">
  <img src="assets/screenshot/Screenshot (41).png" width="200">
  <img src="assets/screenshot/Screenshot (35).png" width="200">
  <img src="assets/screenshot/Screenshot (36).png" width="200">
  <img src="assets/screenshot/Screenshot (37).png" width="200">
  <img src="assets/screenshot/Screenshot (38).png" width="200">
  <img src="assets/screenshot/Screenshot (39).png" width="200">
  <img src="assets/screenshot/Screenshot (40).png" width="200">
  </div>
  

## Core Utilities

Utilities that support UI styling, file handling, notifications, validation, routing, and dependency management.

### UI Utilities

| File                             | Purpose                                                  |
|----------------------------------|----------------------------------------------------------|
| **colors.dart**                  | Defines the app’s color palette                         |
| **clip_path.dart**               | Custom `CustomClipper<Path>` for curved backgrounds     |
| **circuler_progress_indicztor.dart** | Centered circular loading indicator with theme color |
| **show_toast_notification.dart** | Wrapper for toast notifications (success/error)         |
| **valid_input.dart**             | Input validation utilities with regex rules             |
| **show_shimmer_loading.dart**    | (Commented) Shimmer loading placeholders                |
| **fileupload.dart**              | Image/file picking and simulated upload handlers        |

### Routing

| File               | Purpose                                                          |
|--------------------|------------------------------------------------------------------|
| **routes.dart**    | Defines constant route names (`AppRoutes`)                       |
| **app_route.dart** | Builds and provides Flutter routes, injects Cubits per screen    |
| **base_route.dart**| Custom `PageRouteBuilder` with slide-in transition               |

### Services & Initialization

| File                          | Purpose                                                |
|-------------------------------|--------------------------------------------------------|
| **get_it_services.dart**      | Registers singletons (Repositories, SecureStorage etc.)|
| **secure_storage.dart**       | Wraps `flutter_secure_storage` for admin data         |
| **user_app.dart**             | Checks/stores admin authorization flag using Hive      |

## Networking

Handles HTTP requests, endpoints, error handling, and file uploads.

### api_end_point.dart

Defines all REST API endpoints used by the app.

```dart
abstract class ApiEndPoints {
  static const String basicUrl = "http://localhost/fitness";
  static const String login                    = "$basicUrl/admin/auth/login.php";
  static const String searchUsers              = "$basicUrl/admin/users/search.php";
  static const String viewUsers                = "$basicUrl/admin/users/view.php";
  static const String countUsers               = "$basicUrl/admin/users/count.php";
  static const String addPayment               = "$basicUrl/admin/payment/add.php";
  static const String viewPayment              = "$basicUrl/admin/payment/view.php";
  static const String viewTotalPrice           = "$basicUrl/admin/payment/total.php";
  static const String viewCoaches              = "$basicUrl/admin/coaches/view.php";
  static const String addCoaches               = "$basicUrl/admin/coaches/add.php";
  static const String countCoaches             = "$basicUrl/admin/coaches/count.php";
  static const String addExports               = "$basicUrl/admin/export/add.php";
  static const String viewExports              = "$basicUrl/admin/export/view.php";
  static const String viewExportsTotalPrice    = "$basicUrl/admin/export/total.php";
  static const String addOffer                 = "$basicUrl/admin/offers/add.php";
  static const String viewOffer                = "$basicUrl/admin/offers/view.php";
}
```

### dio.dart

Configures a single `Dio` instance for GET/POST/PUT/PATCH/DELETE and file uploads/downloads.

```dart
class DioService {
  static late Dio dio;

  static Future<void> init() async {
    dio = Dio(BaseOptions(
      baseUrl: ApiEndPoints.basicUrl,
      contentType: Headers.formUrlEncodedContentType,
    ));
  }
  // getData(), postData(), putData(), patchData(), deleteData(),
  // downloadImage(), uploadImage()...
}
```

### failure.dart

Represents API call failures.

```dart
abstract class Failure {
  final String message;
  Failure(this.message);
}
class ServerFailure extends Failure {
  ServerFailure(super.message);
}
```

#### API Endpoints Documentation

Below are interactive API blocks for every endpoint. Each block follows the required format and includes request/response examples.

```api
{
  "title": "Admin Login",
  "description": "Authenticate admin user.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/auth/login.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "form",
  "formData": [
    { "key": "email", "value": "admin@example.com", "required": true },
    { "key": "password", "value": "secret", "required": true }
  ],
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\": \"success\",\n  \"data\": [{ \"id\": 1, \"name\": \"Admin\" }]\n}"
    },
    "400": {
      "description": "Invalid credentials",
      "body": "{\n  \"status\": \"error\",\n  \"message\": \"Invalid credentials\"\n}"
    }
  }
}
```

```api
{
  "title": "Search Users",
  "description": "Search users by name or email.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/users/search.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "form",
  "formData": [
    { "key": "search", "value": "john", "required": true }
  ],
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\": \"success\",\n  \"data\": [ { \"id\":\"2\", \"name\":\"John Doe\" } ]\n}"
    },
    "404": {
      "description": "No users found",
      "body": "{\n  \"status\": \"error\",\n  \"message\": \"no found user .\"\n}"
    }
  }
}
```

```api
{
  "title": "View All Users",
  "description": "Get a list of all users.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/users/view.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "none",
  "requestBody": "",
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\": \"success\",\n  \"data\": [ { \"id\":\"1\",\"name\":\"Alice\" } ]\n}"
    },
    "500": {
      "description": "Server error",
      "body": "{\n  \"status\": \"error\",\n  \"message\": \"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "Count Users",
  "description": "Get total user count.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/users/count.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "none",
  "requestBody": "",
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\": \"success\",\n  \"data\": [ { \"countUsers\": 42 } ]\n}"
    },
    "500": {
      "description": "Failure",
      "body": "{\n  \"status\": \"error\",\n  \"message\": \"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "Add Payment",
  "description": "Record a new payment for a user.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/payment/add.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "form",
  "formData": [
    { "key": "userId", "value": "2", "required": true },
    { "key": "adminId", "value": "1", "required": true },
    { "key": "price", "value": "150", "required": true },
    { "key": "startDate", "value": "2025-10-01", "required": true },
    { "key": "endDate", "value": "2025-11-01", "required": true },
    { "key": "type", "value": "cash", "required": true }
  ],
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\": \"success\",\n  \"data\": {\"paymentId\": 5 }\n}"
    },
    "400": {
      "description": "Failure",
      "body": "{\n  \"status\": \"error\",\n  \"message\": \"Error Of Getting Failed.\"\n}"
    }
  }
}
```

```api
{
  "title": "View Payments",
  "description": "Retrieve all payment records.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/payment/view.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "none",
  "requestBody": "",
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\": \"success\",\n  \"data\": [ { \"paymentId\":1, \"userId\":2, \"price\":150 } ]\n}"
    },
    "500": {
      "description": "Failure",
      "body": "{\n  \"status\": \"error\",\n  \"message\": \"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "View Total Payment Price",
  "description": "Get sum of all payments.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/payment/total.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "none",
  "requestBody": "",
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\": \"success\",\n  \"data\": [ { \"totalPrice\": \"6300\" } ]\n}"
    },
    "500": {
      "description": "Failure",
      "body": "{\n  \"status\": \"error\",\n  \"message\": \"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "View Coaches",
  "description": "Fetch all coaches.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/coaches/view.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "none",
  "requestBody": "",
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\": \"success\",\n  \"data\": [ {\"id\":1, \"name\":\"Coach A\"} ]\n}"
    },
    "500": {
      "description": "Error",
      "body": "{\n  \"status\": \"error\",\n  \"message\": \"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "Add Coaches",
  "description": "Create a new coach (with optional image).",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/coaches/add.php",
  "headers": [
    { "key": "Content-Type", "value": "multipart/form-data", "required": true }
  ],
  "bodyType": "form",
  "formData": [
    { "key": "name",     "value": "Coach B", "required": true },
    { "key": "email",    "value": "b@coach.com", "required": true },
    { "key": "password", "value": "secret", "required": true },
    { "key": "phone",    "value": "+123456", "required": true },
    { "key": "gender",   "value": "M", "required": true },
    { "key": "age",      "value": "30", "required": true },
    { "key": "twon",     "value": "Town X", "required": true },
    { "key": "file",     "value": "<binary>", "required": false }
  ],
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\":\"success\",\n  \"data\":[{\"id\":2,...}]\n}"
    },
    "400": {
      "description": "Failure",
      "body": "{\n  \"status\":\"error\",\n  \"message\":\"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "Count Coaches",
  "description": "Get total coach count.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/coaches/count.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "none",
  "requestBody": "",
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\":\"success\",\n  \"data\":[{\"countCoaches\":5}]\n}"
    },
    "500": {
      "description": "Error",
      "body": "{\n  \"status\":\"error\",\n  \"message\":\"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "Add Exports",
  "description": "Record an export transaction.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/export/add.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "form",
  "formData": [
    { "key": "name",    "value": "Gloves", "required": true },
    { "key": "count",   "value": "10", "required": true },
    { "key": "price",   "value": "500", "required": true },
    { "key": "adminId", "value": "1", "required": true }
  ],
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\":\"success\",\n  \"data\":[...]\n}"
    },
    "400": {
      "description": "Failure",
      "body": "{\n  \"status\":\"error\",\n  \"message\":\"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "View Exports",
  "description": "Fetch all export records.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/export/view.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "none",
  "requestBody": "",
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\":\"success\",\n  \"data\":[ {\"id\":1,\"name\":\"Gloves\"} ]\n}"
    },
    "500": {
      "description": "Error",
      "body": "{\n  \"status\":\"error\",\n  \"message\":\"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "View Exports Total Price",
  "description": "Get sum of all exports.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/export/total.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "none",
  "requestBody": "",
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\":\"success\",\n  \"data\":[{\"totalPrice\":\"2000\"}]\n}"
    },
    "500": {
      "description": "Error",
      "body": "{\n  \"status\":\"error\",\n  \"message\":\"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "Add Offer",
  "description": "Create a new offer (with optional image).",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/offers/add.php",
  "headers": [
    { "key": "Content-Type", "value": "multipart/form-data", "required": true }
  ],
  "bodyType": "form",
  "formData": [
    { "key": "name",   "value": "Fall Promo", "required": true },
    { "key": "period", "value": "30 days", "required": true },
    { "key": "price",  "value": "300", "required": true },
    { "key": "file",   "value": "<binary>", "required": false }
  ],
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\":\"success\",\n  \"data\":[...]\n}"
    },
    "400": {
      "description": "Error",
      "body": "{\n  \"status\":\"error\",\n  \"message\":\"Error Of Getting Data.\"\n}"
    }
  }
}
```

```api
{
  "title": "View Offers",
  "description": "Retrieve all current offers.",
  "method": "POST",
  "baseUrl": "http://localhost/fitness",
  "endpoint": "/admin/offers/view.php",
  "headers": [
    { "key": "Content-Type", "value": "application/x-www-form-urlencoded", "required": true }
  ],
  "bodyType": "none",
  "requestBody": "",
  "responses": {
    "200": {
      "description": "Success",
      "body": "{\n  \"status\":\"success\",\n  \"data\":[ {\"id\":1,\"name\":\"Fall Promo\"} ]\n}"
    },
    "500": {
      "description": "Error",
      "body": "{\n  \"status\":\"error\",\n  \"message\":\"Error Of Getting Data.\"\n}"
    }
  }
}
```

---

## Theme

Styling and localization support for English, Arabic, and Dark modes.

### theme.dart

Defines three `ThemeData` instances: **English**, **Arabic**, and **Dark**.  
- Configures fonts, colors, AppBar, buttons, and text styles.

### theme_state.dart

Holds the current locale, theme data, and dark mode flag.  
- Provides `copyWith()` for immutable updates.

### theme_cubit.dart

Manages theme and language changes.  
- Reads/Writes Hive flags (`isDark`, `lang`).  
- Emits new `AppSettingsState` on toggles.

---

## Business Logic (Cubit & State)

Uses **flutter_bloc** to manage UI state across features.

### Authentication

#### login_state.dart

Defines `LoginState` subclasses:  
- `LoginInitial` (with password visibility flag)  
- `LoginLoadingState`  
- `LoginSuccessState`  
- `LoginFailedState` (with error message)

#### login_cubit.dart

Handles admin login flow:  
- Holds controllers & form key.  
- Toggles password visibility.  
- Calls `AuthRepositary.loginData()`.  
- Saves admin info in Hive & `SecureStorage`.

### Users

#### users_state.dart

Defines `UsersState` subclasses:  
- `UsersStateInitial` (refresh flag)  
- `UsersStateLoading`  
- `UsersStateLoaded` (users & search results)  
- `UsersStateFailure`

#### users_cubit.dart

Manages users data:  
- Fetches all users & count.  
- Performs search.  
- Emits loading, loaded, failure states.

### Coaches

#### coach_state.dart

Defines `CoachState` subclasses:  
- `CoachStateInitial` (loading flag)  
- `CoachStateLoading`  
- `CoachStateLoaded` (coach list)  
- `CoachStateFailure`

#### coach_cubit.dart

Manages coaches:  
- Fetches list and count.  
- Adds new coach (with file upload).  
- Chooses file from device/web.

### Offers

#### offer_state.dart

Defines `OfferState` subclasses:  
- `OfferStateInitial` (loading)  
- `OfferStateLoading`  
- `OfferStateLoaded` (offers list)  
- `OfferStateFailure`

#### offer_cubit.dart

Handles offer CRUD:  
- Fetches all offers.  
- Adds offers with optional image.  
- File picking logic.

### Exports

#### export_state.dart

Defines `ExportState` subclasses:  
- `ExportStateInitial` (refresh)  
- `ExportStateLoading`  
- `ExportStateLoaded` (export list)  
- `ExportStateFailure`

#### export_cubit.dart

Manages exports:  
- Fetches all exports & total price.  
- Adds export records.  
- Toggles loading state.

### Payments

#### payment_state.dart

Defines `PaymentState` subclasses:  
- `PaymentStateInitial` (refresh)  
- `PaymentStateLoading`  
- `PaymentStateLoaded` (payment list)  
- `PaymentStateFailure`

#### payment_cubit.dart

Handles payments:  
- Fetches all payments, total price, coach count.  
- Adds new payments.

---

## Data Models

Six simple Dart classes representing JSON entities:

| Model             | Fields                                           |
|-------------------|--------------------------------------------------|
| **AdminModel**    | id, name, email, password, phone, image, datetime|
| **CoachModel**    | id, name, email, password, phone, gender, age, twon, image, emailCreate |
| **UserModel**     | id, name, email, password                        |
| **PaymentModel**  | paymentId, userId, adminId, price, startDate, endDate, type, status |
| **ExportModel**   | id, name, count, price, adminId, exportDate      |
| **OfferModel**    | id, name, period, price, image, offerDateTime    |

Each model has `fromJson()` and `toJson()` methods.

---

## Repositories

Each repository uses `DioService` and returns `Either<Failure, List<Map<String,dynamic>>>`.

| Repository           | Responsibilities                                  |
|----------------------|----------------------------------------------------|
| **AuthRepositary**   | `loginData()`                                     |
| **UserRepository**   | `getUserData()`, `searchUserData()`, `getCountUsers()` |
| **CoachRepository**  | `getCoachesData()`, `addCoachesData()`            |
| **OfferRepository**  | `getAllOffersData()`, `addOfferData()`            |
| **ExportRepository** | `getExportData()`, `addExportData()`, `viewExportsTotalPrice()` |
| **PaymentRepository**| `viewPaymentData()`, `addPaymentData()`, `viewTotlaPrice()`, `getCountCoaches()` |

---

## Presentation Layer

### Screens

| Screen File        | Purpose                                                       |
|--------------------|---------------------------------------------------------------|
| **login.dart**     | Admin login form with BlocConsumer for login flow             |
| **home.dart**      | Dashboard showing stats, chart, profile panel, sidebar routes |
| **users.dart**     | User table, search, renew payments                            |
| **coaches.dart**   | Coaches list with search and FAB to add new coach             |
| **add_coaches.dart** | Form to create a new coach                                   |
| **offeres.dart**   | Offers list and form to add new offers                        |
| **payments.dart**  | (Placeholder) payments view                                   |
| **exports.dart**   | Exports list and form to add new exports                      |
| **checkemail.dart**| (Commented) password reset step 1                             |
| **forgetpassword.dart** | (Commented) password reset step 2                        |
| **signup.dart**    | (Commented) registration screen                               |
| **add_export.dart**| (Commented) export creation UI                                |

### Widgets

| Widget File                   | Purpose                                                   |
|-------------------------------|-----------------------------------------------------------|
| **customtext.dart**           | `CustomText` wrapper for styled `Text`                   |
| **custom_elevated_button.dart** | `CustomElevatedButton` for full-width buttons         |
| **customtextformfield.dart**  | `CustomTextFormField` with label, icons, validation      |
| **search_testformfield.dart** | `CustomSearchTextFormField` for search input UI         |
| **list_search_users.dart**    | Renders search results table rows for users              |

---

Each section above explains file responsibilities, how they integrate, and showcases code snippets and API contracts. This documentation should guide you through the architecture, state management, data flow, and UI components of the **Fitness Dashboard** application.
