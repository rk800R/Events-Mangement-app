# HarmoniCal

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0+-blue?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</div>

A beautifully crafted calendar application built with Flutter that helps you organize your life with ease and elegance.

## 📋 Table of Contents

- [Features](#-features)
  - [Multiple Calendar Views](#multiple-calendar-views)
  - [Event Management](#event-management)
  - [Categories](#categories)
  - [Settings](#settings)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
- [Technical Details](#technical-details)
- [License](#license)

##  Features

### Multiple Calendar Views

Switch between four distinct views to match your planning style:

- **Month View**: See your entire month at a glance, with events marked on their respective dates
- **Week View**: Focus on the coming week, perfect for detailed planning
- **Day View**: Dive into a single day's schedule with time-based layout
- **Agenda View**: A clean list of upcoming events organized by date

### Event Management

Create and edit events with all the details that matter to you:

- **Title, description, and location**
- **All-day events** for full-day activities
- **Category-based organization** with color coding
- **Priority levels** (low, medium, high) to highlight important events
- **Flexible recurrence options** (daily, weekly, monthly, yearly)
- **Customizable reminders** before your events

### Categories

Events are organized into meaningful categories, each with its own distinct color:

- Work • Personal • Health • Education • Social • Travel • Finance • Other

### Settings

Customize the app to fit your preferences:

- Light, dark, or system theme
- Choose your preferred start of the week (Monday, Sunday, or Saturday)
- Set default event duration for new entries

## Screenshots

| Month View | Day View | Week View | Agenda View |
|:----------:|:---------:|:--------:|:-----------:|
| <img src="Screenshots/WhatsApp Image 2026-07-15 at 10.53.31 PM.jpeg" width="200"> | <img src="Screenshots/WhatsApp Image 2026-07-15 at 10.53.32 PM (1).jpeg" width="200"> | <img src="Screenshots/WhatsApp Image 2026-07-15 at 10.53.32 PM (2).jpeg" width="200"> | <img src="Screenshots/WhatsApp Image 2026-07-15 at 10.53.32 PM.jpeg" width="200"> |

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK
- Android or iOS development environment for mobile deployment

### Installation

1. Clone the repository:

```bash
git clone https://github.com/rk800R/Events-Mangement-app.git
cd Events-Mangement-app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Technical Details

### Built With

- **Flutter** - UI framework
- **Provider** - State management
- **Intl** - Internationalization and date formatting
- **Shared Preferences** - Local settings storage

### Project Structure

```
lib/
├── core/
│   ├── constants/       # App constants and configuration
│   ├── theme/           # Colors, typography, and theme definitions
│   └── utils/           # Utility functions
├── data/                # Local storage and data handling
├── database/
│   └── tables/          # Database table definitions
├── models/              # Calendar event model and related classes
├── providers/           # State management providers
└── features/
    ├── calendar/
    │   ├── screens/     # Calendar screens
    │   └── widgets/     # Calendar view widgets (month, week, day, agenda)
    ├── events/
    │   └── screens/     # Event creation and detail screens
    └── settings/
        └── screens/     # Settings screen
```

## License

This project is open source and available under the MIT License.
