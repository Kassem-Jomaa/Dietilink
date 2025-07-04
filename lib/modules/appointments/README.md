# Appointments Module

A comprehensive appointment management system for the DietiHealth Flutter app, providing booking, scheduling, and reminder functionality.

## 📁 Module Structure

```
lib/modules/appointments/
├── appointments_module.dart          # Module exports
├── bindings/
│   └── appointments_binding.dart     # Dependency injection
├── controllers/
│   └── appointments_controller.dart  # Business logic
├── models/
│   └── appointment_model.dart        # Data models
├── services/
│   └── appointments_service.dart     # API integration
├── views/
│   ├── appointments_view.dart        # Main appointments screen
│   ├── book_appointment_view.dart    # Booking screen
│   ├── appointment_history_view.dart # History screen
│   └── appointment_detail_view.dart  # Details screen
├── widgets/
│   ├── appointment_card.dart         # Appointment display cards
│   ├── appointment_calendar.dart     # Calendar widget
│   ├── appointment_slot_picker.dart  # Time slot selection
│   ├── appointment_form.dart         # Booking form
│   └── appointment_reminder.dart     # Reminder notifications
└── README.md                         # This file
```

## 🚀 Features

### Core Functionality
- **Appointment Booking**: Schedule new appointments with date/time selection
- **Slot Management**: View and select available appointment slots
- **History Tracking**: View past and upcoming appointments
- **Status Management**: Track appointment status (scheduled, confirmed, completed, etc.)
- **Reminder System**: Set and manage appointment reminders

### UI Components
- **Appointment Cards**: Beautiful cards displaying appointment information
- **Calendar Integration**: Visual calendar for date selection
- **Slot Picker**: Grid-based time slot selection
- **Reminder Widgets**: Notification-style appointment reminders
- **Form Components**: Comprehensive booking forms

### API Integration
- **RESTful API**: Full CRUD operations for appointments
- **Real-time Updates**: Live status updates and notifications
- **Error Handling**: Comprehensive error management
- **Pagination**: Efficient data loading for large appointment lists

## 📋 Models

### Appointment
```dart
class Appointment {
  final int id;
  final DateTime appointmentDate;
  final String? reason;
  final String? notes;
  final AppointmentStatus status;
  final AppointmentType type;
  final String? doctorName;
  final String? doctorSpecialty;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasReminder;
  final DateTime? reminderTime;
}
```

### AppointmentSlot
```dart
class AppointmentSlot {
  final DateTime dateTime;
  final bool isAvailable;
  final String? doctorName;
  final String? specialty;
}
```

### Enums
- `AppointmentStatus`: scheduled, confirmed, completed, cancelled, noShow
- `AppointmentType`: consultation, followUp, nutrition, fitness, general

## 🎮 Controllers

### AppointmentsController
Main controller managing appointment state and business logic:

```dart
class AppointmentsController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final RxList<AppointmentSlot> availableSlots = <AppointmentSlot>[].obs;
  
  // Methods
  Future<void> loadUpcomingAppointments();
  Future<void> bookAppointment();
  Future<void> cancelAppointment(int appointmentId);
  Future<void> rescheduleAppointment(int appointmentId);
  Future<void> getAvailableSlots();
}
```

## 🔧 Services

### AppointmentsService
Handles all API communication:

```dart
class AppointmentsService {
  Future<Appointment> bookAppointment({...});
  Future<List<AppointmentSlot>> getAvailableSlots({...});
  Future<AppointmentHistory> getAppointmentHistory({...});
  Future<Appointment> updateAppointment({...});
  Future<void> cancelAppointment(int appointmentId);
  Future<Appointment> rescheduleAppointment({...});
  Future<void> setAppointmentReminder({...});
}
```

## 🎨 Widgets

### AppointmentCard
Displays appointment information in a card format with status indicators and action buttons.

### AppointmentSlotPicker
Grid-based time slot selection with date navigation and availability status.

### AppointmentForm
Comprehensive form for booking appointments with validation and field management.

### AppointmentReminder
Notification-style widget displaying upcoming appointments with reminder indicators.

### AppointmentCalendar
Calendar widget for date selection and appointment visualization.

## 🛠️ Setup & Usage

### 1. Dependency Injection
```dart
// In your app's main.dart or binding
Get.put(AppointmentsBinding());
```

### 2. Navigation
```dart
// Navigate to appointments screen
Get.toNamed('/appointments');

// Navigate to booking screen
Get.toNamed('/appointments/book');
```

### 3. Widget Usage
```dart
// Use appointment reminder widget
AppointmentReminder(
  upcomingAppointments: controller.appointments,
  onViewAll: () => Get.toNamed('/appointments/history'),
  onAppointmentTap: (appointment) => _showDetails(appointment),
)

// Use appointment card
AppointmentCard(
  appointment: appointment,
  onTap: () => _showDetails(appointment),
  onEdit: () => _editAppointment(appointment),
  onCancel: () => _cancelAppointment(appointment),
)
```

## 🔌 API Endpoints

The module integrates with these API endpoints:

- `POST /appointments/book` - Book new appointment
- `GET /appointments/slots` - Get available slots
- `GET /appointments` - Get appointment history
- `GET /appointments/{id}` - Get appointment details
- `PUT /appointments/{id}` - Update appointment
- `DELETE /appointments/{id}` - Cancel appointment
- `PATCH /appointments/{id}/reschedule` - Reschedule appointment
- `POST /appointments/{id}/reminder` - Set reminder
- `DELETE /appointments/{id}/reminder` - Remove reminder

## 🎯 Key Features

### Smart Date Handling
- Automatic detection of today/tomorrow appointments
- Relative date formatting (Today, Tomorrow, etc.)
- Past/upcoming appointment filtering

### Status Management
- Visual status indicators with color coding
- Status-based action availability
- Automatic status updates

### Reminder System
- Configurable reminder times
- Visual reminder indicators
- Push notification integration (future)

### Responsive Design
- Adaptive layouts for different screen sizes
- Touch-friendly interface elements
- Accessibility support

## 🔒 Security & Validation

- Input validation for all form fields
- Date/time validation (no past appointments)
- API error handling and user feedback
- Secure data transmission

## 🧪 Testing

The module includes comprehensive testing:

```dart
// Test appointment booking
test('should book appointment successfully', () async {
  final result = await controller.bookAppointment();
  expect(result, isTrue);
});

// Test slot availability
test('should load available slots', () async {
  await controller.getAvailableSlots();
  expect(controller.availableSlots.length, greaterThan(0));
});
```

## 🚀 Future Enhancements

- [ ] Push notification integration
- [ ] Calendar sync (Google Calendar, Apple Calendar)
- [ ] Video call integration
- [ ] Multi-language support
- [ ] Advanced filtering and search
- [ ] Appointment templates
- [ ] Recurring appointments
- [ ] Waitlist management

## 📞 Support

For issues or questions about the appointments module:

1. Check the API connectivity
2. Verify appointment data format
3. Review error logs
4. Test with sample data

## 📄 License

This module is part of the DietiHealth app and follows the same licensing terms. 