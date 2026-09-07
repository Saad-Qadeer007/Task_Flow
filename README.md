# 📋 TaskFlow

> **A smart and simple productivity app for managing tasks, habits, reminders, and daily progress.**

TaskFlow is a Flutter-based productivity application designed to help users organize their daily tasks and habits in one place. It provides task management, advanced filtering, recurring tasks, reminders, habit tracking, streaks, weekly progress, and productivity statistics.

The project was built to strengthen my practical understanding of **Flutter application development, Firebase, Provider state management, local notifications, asynchronous programming, date/time handling, and application logic**.

---

## ✨ Features

### 📝 Task Management

* Create, update, and delete tasks
* Set task titles and descriptions
* Set task due dates and times
* Assign task categories
* Set task priorities
* Mark tasks as completed
* View upcoming tasks
* View today's tasks
* View completed tasks
* View expired tasks

### 🔎 Advanced Task Filtering

TaskFlow provides a flexible filtering system that allows multiple filters to work together.

Users can filter tasks using:

* 🔍 Search bar
* ⭐ Priority
* 🏷️ Task category
* 📋 Task status

Status filters include:

* All
* Today
* Upcoming
* Completed

These filters can be combined together to narrow down the task list.

For example, a user can search for a specific task while simultaneously filtering by a particular **category and priority**.

---

### 🔁 Recurring Tasks

TaskFlow supports recurring tasks:

* Daily
* Weekly
* Monthly
* Yearly
* Never

When a recurring task is completed, TaskFlow automatically creates the next occurrence with the appropriate due date.

This allows users to create tasks that repeat without manually creating them again.

---

### 🔔 Notifications & Reminders

* Schedule notifications for tasks
* Schedule reminders before task deadlines
* Uses device local notifications
* Supports scheduled notifications
* Handles notification time zones
* Notifications can work even when the application is not actively open

---

### 🌱 Habit Tracking

Users can create and track daily habits.

Currently, TaskFlow focuses on **Everyday habits**.

For each habit, users can:

* Mark the habit as completed
* View weekly progress
* View completion history
* Track current streak
* Track best streak
* See completed days of the current week
* View progress through a visual progress bar

---

### 🔥 Habit Streaks

TaskFlow calculates two types of streaks:

**Current Streak**

> The number of consecutive days the habit has been completed.

**Best Streak**

> The longest consecutive streak achieved throughout the habit's history.

This allows users to see both their current consistency and their personal best.

---

### 📊 Statistics

TaskFlow provides a productivity overview using the user's task data.

Statistics include information such as:

* Total tasks
* Completed tasks
* Pending tasks
* Expired tasks
* Completion progress
* Task completion percentage

---

### 🎨 User Interface

* Clean and minimal interface
* Consistent color system
* Bottom navigation
* Responsive Flutter layouts
* Visual indicators for task and habit states
* Progress indicators
* Informational UI elements
* Animated UI elements
* Clear task and habit status representation

---

## 🛠️ Technologies Used

| Technology                      | Purpose                                |
| ------------------------------- | -------------------------------------- |
| **Flutter**                     | Cross-platform application development |
| **Dart**                        | Programming language                   |
| **Firebase Authentication**     | User authentication                    |
| **Cloud Firestore**             | Cloud database                         |
| **Provider**                    | State management                       |
| **flutter_local_notifications** | Local notifications                    |
| **timezone**                    | Notification scheduling                |
| **SharedPreferences**           | Local data persistence                 |
| **Material Design**             | UI components                          |

---

## 🏗️ Project Structure

```text
lib/
│
├── Models/
│   ├── Task_Model.dart
│   └── Habit_Model.dart
│
├── Provider/
│   ├── Task_Provider.dart
│   └── Habit_Provider.dart
│
├── Screens/
│   ├── Home/
│   ├── Habits/
│   ├── Statistics/
│   ├── Profile/
│   └── ...
│
├── Services/
│   ├── Firebase Services
│   └── Notification Services
│
├── Utilities/
│   └── App Colors
│
└── main.dart
```

> The exact folder structure may vary as the project continues to evolve.

---

## 🧠 Concepts Learned

Building TaskFlow helped me move from learning Flutter concepts individually to using them together in a complete application.

### Flutter

* Stateful and Stateless Widgets
* Widget lifecycle
* Navigation
* Forms and validation
* ListView
* Bottom Navigation
* Animations
* Responsive layouts
* Date and time handling
* Timers
* Async/Await
* UI state updates

### State Management

* Provider
* ChangeNotifier
* notifyListeners()
* Managing application state
* Updating UI from provider data
* Separating UI and application logic

### Firebase

* Firebase Authentication
* Cloud Firestore
* CRUD operations
* Firestore documents and collections
* Querying data
* Updating and deleting documents
* Working with Firebase asynchronously
* User-specific data handling

### Notifications

* Local notifications
* Scheduled notifications
* Timezone handling
* Notification IDs
* Reminder scheduling
* Android notification permissions

### Data & Logic

* Task filtering
* Search functionality
* Multiple filters working together
* Priority filtering
* Category filtering
* Status filtering
* Recurring task generation
* Date comparison
* Weekly date calculations
* Habit completion history
* Current streak calculation
* Best streak calculation
* Progress percentage calculation

---

## 🔄 How Recurring Tasks Work

TaskFlow doesn't keep a separate recurring-task entity.

Instead, when a recurring task is completed:

```text
Complete Task
      ↓
Check Recurrence
      ↓
Calculate Next Due Date
      ↓
Create New Task
      ↓
Reset Completion Status
      ↓
Display New Occurrence
```

This keeps the task system relatively simple while still allowing recurring tasks.

---

## 🔎 How Task Filtering Works

TaskFlow combines multiple filtering options instead of treating each filter independently.

```text
                    Task List
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
       Search       Priority     Category
          │            │            │
          └────────────┼────────────┘
                       ↓
                  Status Filter
                       ↓
                Filtered Task List
```

For example:

```text
Search: "Project"
Priority: High
Category: Work
Status: Upcoming
```

The application then displays only the tasks matching the selected conditions.

---

## 🔥 How Habit Streaks Work

Habit completion dates are stored in the habit's history.

For example:

```text
September 2  ✅
September 3  ✅
September 4  ✅
September 5  ❌
September 6  ✅
```

The application can determine:

```text
Current Streak = 1 day
Best Streak    = 3 days
```

The weekly progress system also checks which days of the current week contain a completion record.

---

## 📱 Screenshots

### Home Screen

*Add your Home Screen screenshot here.*

### Task Filtering

*Add your filtering/search screenshot here.*

### Habit Screen

*Add your Habit Screen screenshot here.*

### Habit Details & Streaks

*Add your Habit Details screenshot here.*

### Statistics

*Add your Statistics screenshot here.*

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/Saad-Qadeer007/Task_Flow.git
```

### 2. Open the project

```bash
cd Task_Flow
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Configure Firebase

Create a Firebase project and connect it to the Flutter application.

Configure:

* Firebase Authentication
* Cloud Firestore
* Android/iOS Firebase configuration

### 5. Configure notifications

Make sure the required Android notification permissions and notification receivers are configured according to the project's notification package requirements.

### 6. Run the application

```bash
flutter run
```

---

## 🔐 Firebase Security

TaskFlow uses Firebase Authentication to identify users and Cloud Firestore to store application data.

Firestore security rules should ensure that authenticated users can only access their own task and habit data.

---

## 📌 Current Limitations

TaskFlow is still an evolving project.

Current limitations include:

* Habits currently support **Everyday** frequency only.
* More advanced habit schedules can be added in the future.
* Statistics can be expanded with more detailed analytics.
* Additional productivity insights can be introduced later.

These limitations were intentionally kept out of the current version so the core functionality could be implemented properly.

---

## 🔮 Future Improvements

Possible future improvements include:

* 📈 Advanced productivity charts
* 🌱 Weekly/custom habit frequencies
* 🏆 Habit achievements and badges
* 🔔 More advanced notification settings
* 🎨 More customization options
* 🌙 Additional theme options
* 📊 Monthly and yearly productivity reports
* 🤖 AI-powered productivity suggestions

---

## 🎯 Project Goal

The main goal of TaskFlow was not simply to create another to-do application.

It was to learn how to build a **complete Flutter application from the ground up**, combining:

```text
Flutter
   +
Firebase
   +
State Management
   +
Notifications
   +
Task & Habit Logic
   +
Date/Time Handling
   +
Real Application UI
```

The project helped me understand how individual Flutter concepts work together inside a real application and gave me practical experience building, debugging, and structuring a complete mobile application.

---

## 👨‍💻 Developer

**Saad Qadeer**

This project was developed as part of my journey to become a stronger **Flutter and AI/Software Engineer**.

---

## ⭐ Acknowledgements

Built with ❤️ using Flutter and Dart.

If you found this project interesting, consider giving the repository a ⭐.
