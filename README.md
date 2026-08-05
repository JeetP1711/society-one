# SocietyOne 🏢

> **SocietyOne** is a modern, feature-rich, and elegant Residential Society Management application built with **Flutter** and **Riverpod**. It provides a comprehensive solution for residents, security personnel, committee members, and super admins to seamlessly manage society operations, visitor passes, complaints, dues, amenity bookings, announcements, and NOC requests.

---

## ✨ Features Overview

### 🚪 1. Visitor Management & Gate Passes
- **Digital Gate Pass**: Generate instant QR-coded digital gate passes for guests, delivery agents, and service providers.
- **Visitor Logs**: Track visitor entry and exit states (`Expected`, `Checked-In`, `Checked-Out`, `Denied`).
- **Quick Actions**: Security guards and residents can quickly record new visitor entries or verify QR passes.

### 🛠️ 2. Complaint & Service Desk
- **Lodge Complaints**: Residents can register complaints with categorization (Plumbing, Electrical, Cleanliness, Security, Noise), priority levels (`Low`, `Medium`, `High`, `Urgent`), location details, and descriptions.
- **Real-Time Tracking**: Interactive status progression (`Open` ➔ `In Progress` ➔ `Resolved`).
- **Management View**: Filter complaints by status or priority for efficient resolution.

### 💳 3. Maintenance & Bill Payments
- **Monthly Dues Tracker**: Clear breakdown of maintenance dues, water charges, parking fees, and late penalties.
- **Status Badges**: Easily identify payment states (`Paid`, `Pending`, `Overdue`).
- **Payment History & Receipts**: View billing history and download payment receipts.

### 📅 4. Amenity Booking
- **Facility Reservation**: Book society amenities including Clubhouse, Gymnasium, Swimming Pool, Tennis Court, and Party Hall.
- **Slot Availability**: Check available slots, view booking terms/rules, and receive instant confirmation.

### 📢 5. Announcements & Meetings
- **Notice Board**: Stay informed with official society announcements and updates.
- **Society Meetings**: Agenda tracking and schedule for Annual General Meetings (AGM) and Committee sessions, along with meeting minutes.

### 📄 6. NOC Requests (No Objection Certificates)
- **Digital Application**: Submit requests for Flat Renovation, Move-In / Move-Out, and Vehicle Parking Permits.
- **Approval Workflow**: Track status from application submission to committee approval.

### 📞 7. Resident & Emergency Directory
- **Resident Directory**: Search for residents by Block/Flat number with contact access options.
- **Emergency Contacts**: One-tap access to gate security, society management office, plumbers, electricians, fire station, and police.

### 🔐 8. Role-Based Access Control (RBAC) & Society Switcher
- Supports **Resident**, **Security Guard**, **Committee Member**, and **Super Admin** roles.
- **Super Admin Multi-Society Switcher**: Manage multiple residential societies from a single dashboard.

### 🎨 9. Modern Glassmorphic UI & Dark Mode
- Built using modern design principles: custom glassmorphism cards (`GlassCard`), dynamic metric counters (`MetricCard`), priority chips, and sleek status badges.
- **Light & Dark Mode**: Full theme switching support powered by `themeProvider`.

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `>=3.0.0 <4.0.0`)
- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) (`^2.5.1`)
- **UI & Styling**:
  - [google_fonts](https://pub.dev/packages/google_fonts) (`^6.2.1`) - Google Fonts styling (Inter)
  - [flutter_svg](https://pub.dev/packages/flutter_svg) (`^2.0.10+1`) - Vector asset rendering
  - [percent_indicator](https://pub.dev/packages/percent_indicator) (`^4.2.3`) - Visual progress indicators
  - Custom Glassmorphic & Material 3 components
- **QR Code Generation**: [qr_flutter](https://pub.dev/packages/qr_flutter) (`^4.1.0`) - Digital gate pass QR codes
- **Storage & Helpers**:
  - [shared_preferences](https://pub.dev/packages/shared_preferences) (`^2.2.3`) - Local state persistence
  - [intl](https://pub.dev/packages/intl) (`^0.19.0`) - Date formatting and currency displays
  - [uuid](https://pub.dev/packages/uuid) (`^4.4.0`) - Unique identifier generation

---

## 📁 Project Architecture

```
lib/
├── main.dart                   # Application entry point & ProviderScope wrapper
├── models/                     # Data models
│   ├── amenity_model.dart
│   ├── announcement_model.dart
│   ├── complaint_model.dart
│   ├── directory_model.dart
│   ├── maintenance_model.dart
│   ├── meeting_model.dart
│   ├── noc_model.dart
│   ├── society_model.dart
│   ├── user_model.dart
│   └── visitor_model.dart
├── providers/                  # Riverpod providers & state notifier management
│   ├── amenity_provider.dart
│   ├── announcement_provider.dart
│   ├── auth_provider.dart
│   ├── complaint_provider.dart
│   ├── directory_provider.dart
│   ├── maintenance_provider.dart
│   ├── mock_data.dart          # Seed dataset for demo & testing
│   ├── noc_provider.dart
│   ├── society_provider.dart
│   ├── theme_provider.dart
│   └── visitor_provider.dart
├── screens/                    # Application screens by feature module
│   ├── admin/                  # Super Admin society management
│   ├── amenities/              # Facility booking UI
│   ├── announcements/          # Notices & meeting details
│   ├── auth/                   # Authentication & login
│   ├── complaints/             # Complaint listing, submission & detail view
│   ├── dashboard/              # Main interactive dashboard
│   ├── directory/              # Society resident & emergency contacts directory
│   ├── maintenance/            # Bills & payment overview
│   ├── noc/                    # NOC applications & tracking
│   ├── visitors/               # Visitor logs, gate pass & entry forms
│   └── main_shell.dart         # Main app shell with bottom nav & drawer
├── theme/                      # Styling definitions
│   ├── app_colors.dart         # Color palette tokens
│   └── app_theme.dart          # Light and Dark ThemeData configuration
└── widgets/                    # Reusable custom UI components
    ├── app_drawer.dart         # Side navigation drawer
    ├── empty_state.dart        # Empty state graphics & messages
    ├── glass_card.dart         # Glassmorphic card container
    ├── metric_card.dart        # Dashboard metric widget
    ├── priority_chip.dart      # Priority indicator pill
    ├── quick_action_card.dart  # Quick action tile
    └── status_badge.dart       # Status badge widget
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0.0 or higher)
- [Dart SDK](https://dart.dev/get-started) (version 3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions installed
- An Android Emulator, iOS Simulator, or web browser

### Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/JeetP1711/society-one.git
   cd society-one
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Application**
   ```bash
   flutter run
   ```

---

## 🔑 Demo Login Credentials

You can test different user roles using the pre-configured mock credentials on the login screen:

| Role | Email | Password | Access Level |
| :--- | :--- | :--- | :--- |
| **Resident** | `resident@societyone.com` | `password` | Personal dashboard, Gate Pass, Complaints, Dues, Bookings |
| **Security Guard** | `security@societyone.com` | `password` | Gate Check-in, Visitor Pass verification & logs |
| **Committee Member** | `committee@societyone.com` | `password` | Society oversight, NOC approvals, Announcements |
| **Super Admin** | `admin@societyone.com` | `password` | Multi-society management & society switcher |

---

## 🧪 Testing

To run the automated tests:

```bash
flutter test
```

---

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).
