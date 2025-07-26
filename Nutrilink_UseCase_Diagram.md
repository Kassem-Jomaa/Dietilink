# Nutrilink - Use Case Diagram

## System Overview
Nutrilink is a web-based nutrient dashboard that provides comprehensive health and nutrition management capabilities.

## Actors

### Primary Actors
- **User** - Individual users seeking health and nutrition management
- **Nutritionist** - Health professionals providing dietary guidance
- **AI Assistant** - AI-powered chatbot for nutrition advice

### Secondary Actors
- **API System** - External RESTful API services
- **Python Server** - AI/ML backend for nutrition recommendations

## Use Case Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              NUTRILINK SYSTEM                                     │
│                                                                                   │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐              │
│  │     USER        │    │  NUTRITIONIST   │    │  AI ASSISTANT   │              │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘              │
│         │                       │                       │                        │
│         │                       │                       │                        │
│         ▼                       ▼                       ▼                        │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                           AUTHENTICATION                                  │  │
│  │  • Login                                                                  │  │
│  │  • Register                                                               │  │
│  │  • Logout                                                                 │  │
│  │  • Password Reset                                                         │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
│         │                       │                       │                        │
│         ▼                       ▼                       ▼                        │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                           DASHBOARD                                       │  │
│  │  • View Overview Statistics                                               │  │
│  │  • Access Quick Actions                                                   │  │
│  │  • View Recent Activities                                                 │  │
│  │  • Navigate to Modules                                                    │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
│         │                       │                       │                        │
│         ▼                       ▼                       ▼                        │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                        PROFILE MANAGEMENT                                 │  │
│  │  • View Profile                                                           │  │
│  │  • Edit Personal Information                                              │  │
│  │  • Update Health Data                                                     │  │
│  │  • View BMI Calculations                                                  │  │
│  │  • Change Password                                                        │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
│         │                       │                       │                        │
│         ▼                       ▼                       ▼                        │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                        MEAL PLAN MANAGEMENT                               │  │
│  │  • View Current Meal Plan                                                 │  │
│  │  • Select Meal Options                                                    │  │
│  │  • View Nutritional Information                                           │  │
│  │  • Track Daily Calories                                                   │  │
│  │  • View Food Categories                                                   │  │
│  │  • Refresh Meal Plan Data                                                 │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
│         │                       │                       │                        │
│         ▼                       ▼                       ▼                        │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                        PROGRESS TRACKING                                  │  │
│  │  • Add Progress Entry                                                     │  │
│  │  • View Progress History                                                  │  │
│  │  • Edit Progress Entry                                                    │  │
│  │  • Delete Progress Entry                                                  │  │
│  │  • Upload Progress Images                                                 │  │
│  │  • View Progress Statistics                                               │  │
│  │  • Track Body Measurements                                                │  │
│  │  • Monitor Weight Changes                                                 │  │
│  │  • View Progress Charts                                                   │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
│         │                       │                       │                        │
│         ▼                       ▼                       ▼                        │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                        APPOINTMENT MANAGEMENT                             │  │
│  │  • Book Appointment                                                       │  │
│  │  • View Upcoming Appointments                                            │  │
│  │  • View Appointment History                                               │  │
│  │  • Cancel Appointment                                                     │  │
│  │  • Reschedule Appointment                                                 │  │
│  │  • View Appointment Details                                               │  │
│  │  • Select Appointment Type                                                │  │
│  │  • Choose Available Time Slots                                           │  │
│  │  • View Dietitian Information                                             │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
│         │                       │                       │                        │
│         ▼                       ▼                       ▼                        │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                        AI CHATBOT                                        │  │
│  │  • Send Message                                                           │  │
│  │  • Receive Nutrition Advice                                               │  │
│  │  • Get Meal Recommendations                                               │  │
│  │  • Ask Health Questions                                                   │  │
│  │  • View Chat History                                                      │  │
│  │  • Use Quick Replies                                                      │  │
│  │  • Get Personalized Guidance                                              │  │
│  │  • Access Meal Plan Context                                               │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
│         │                       │                       │                        │
│         ▼                       ▼                       ▼                        │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                        SETTINGS & PREFERENCES                             │  │
│  │  • Manage Theme Settings                                                  │  │
│  │  • Configure Notifications                                                │  │
│  │  • Update Language Preferences                                            │  │
│  │  • Manage Privacy Settings                                                │  │
│  │  • Export Data                                                            │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
│                                                                                   │
│  ┌─────────────────┐    ┌─────────────────┐                                     │
│  │   API SYSTEM    │    │ PYTHON SERVER   │                                     │
│  └─────────────────┘    └─────────────────┘                                     │
│         │                       │                                               │
│         ▼                       ▼                                               │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │                        EXTERNAL INTEGRATIONS                              │  │
│  │  • RESTful API Communication                                              │  │
│  │  • Data Synchronization                                                   │  │
│  │  • AI Model Integration                                                   │  │
│  │  • Health Device Integration (Future)                                     │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

## Detailed Use Cases

### 1. Authentication Use Cases
- **Login**: User authenticates with email/password
- **Register**: New user creates account
- **Logout**: User ends session
- **Password Reset**: User resets forgotten password

### 2. Dashboard Use Cases
- **View Overview**: User sees summary statistics
- **Quick Actions**: User accesses common functions
- **Recent Activities**: User views latest updates
- **Navigation**: User moves between modules

### 3. Profile Management Use Cases
- **View Profile**: User sees personal information
- **Edit Profile**: User updates personal data
- **Update Health Data**: User modifies health information
- **View BMI**: User sees calculated BMI
- **Change Password**: User updates security credentials

### 4. Meal Plan Use Cases
- **View Meal Plan**: User sees current meal plan
- **Select Options**: User chooses meal alternatives
- **View Nutrition**: User sees nutritional details
- **Track Calories**: User monitors daily intake
- **View Categories**: User sees food groupings

### 5. Progress Tracking Use Cases
- **Add Entry**: User records new progress data
- **View History**: User sees past entries
- **Edit Entry**: User modifies existing data
- **Delete Entry**: User removes data
- **Upload Images**: User adds progress photos
- **View Statistics**: User sees progress analytics
- **Track Measurements**: User records body metrics
- **Monitor Weight**: User tracks weight changes
- **View Charts**: User sees visual progress

### 6. Appointment Use Cases
- **Book Appointment**: User schedules consultation
- **View Upcoming**: User sees future appointments
- **View History**: User sees past appointments
- **Cancel Appointment**: User cancels booking
- **Reschedule**: User changes appointment time
- **View Details**: User sees appointment information
- **Select Type**: User chooses appointment category
- **Choose Slots**: User picks available times
- **View Dietitian**: User sees provider information

### 7. AI Chatbot Use Cases
- **Send Message**: User types question/request
- **Receive Advice**: User gets nutrition guidance
- **Get Recommendations**: User receives meal suggestions
- **Ask Questions**: User queries health topics
- **View History**: User sees chat log
- **Use Quick Replies**: User selects preset options
- **Get Guidance**: User receives personalized help
- **Access Context**: User gets meal plan integration

### 8. Settings Use Cases
- **Manage Theme**: User changes appearance
- **Configure Notifications**: User sets alerts
- **Update Language**: User changes language
- **Manage Privacy**: User controls data sharing
- **Export Data**: User downloads information

## Relationships

### Include Relationships
- Authentication includes Login/Register
- Dashboard includes all module access
- Progress Tracking includes Statistics
- Appointment Management includes Booking
- AI Chatbot includes Nutrition Advice

### Extend Relationships
- Profile Management extends User Data
- Meal Plan extends Nutrition Data
- Progress Tracking extends Health Data
- Appointment extends Professional Support
- AI Chatbot extends Personalized Guidance

## System Boundaries

### Internal System
- User Interface (Flutter Web)
- State Management (GetX)
- Local Data Storage
- Navigation System

### External Systems
- RESTful API Services
- Python AI/ML Server
- Authentication Services
- File Storage Services

This use case diagram provides a comprehensive view of how different actors interact with the Nutrilink system and the various functionalities available within the web-based nutrient dashboard. 