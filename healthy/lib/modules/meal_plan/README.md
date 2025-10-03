# Meal Plan Module

A comprehensive meal plan management system for the DietiHealth Flutter app.

## 🎯 Features

### ✅ 1. Meal Plan Dashboard
- **Meal Plan Title**: Displays the name of the current meal plan
- **Status Badge**: Shows plan status (Active, Draft, Archived) with color-coded indicators
- **Meal Plan Notes**: Displays any additional notes or instructions from nutritionists

### ✅ 2. Statistics Box
- **Total Meal Types**: Count of different meal categories (Breakfast, Lunch, Dinner, Snacks)
- **Total Meal Options**: Total number of available meal options across all types
- **Calorie Range**: Shows the range of calories available across all options
- **Total Calories**: Sum of all estimated calories in the meal plan

### ✅ 3. Meal Type Sections
Each meal type (Breakfast, Lunch, Dinner, Snacks) includes:
- **Title + Description**: Clear meal type identification with option count
- **Meal Options Cards**: 
  - Option name and number
  - Estimated calories display
  - Selection highlighting with visual feedback
  - Expandable details

### ✅ 4. Food Items in Each Option
Food items are organized by category:
- **Category Grouping**: Carbs, Protein, Fats, Vegetables, Fruits, Dairy
- **Food Item Details**:
  - Food item name
  - Portion size + unit
  - Individual calories
  - Category color coding

### ✅ 5. Responsive Design
- **Collapsible Accordions**: Mobile-friendly expandable sections
- **Touch-Friendly Selection**: Easy tap targets for meal option selection
- **Responsive Layout**: Adapts to different screen sizes
- **Pull-to-Refresh**: Swipe down to refresh meal plan data

## 🏗️ Architecture

### Models
- `FoodItem`: Individual food items with nutritional information
- `MealOption`: Meal options containing multiple food items
- `MealType`: Meal categories (Breakfast, Lunch, etc.)
- `MealPlan`: Complete meal plan with all meal types

### Services
- `MealPlanService`: API integration for meal plan operations
- Safe parsing utilities for handling mixed API response types
- Comprehensive error handling with ApiException

### Controllers
- `MealPlanController`: State management with GetX
- Observable variables for reactive UI updates
- Selection tracking and statistics calculation

### Views
- `MealPlanView`: Main meal plan interface
- Integrated into dashboard navigation
- Modern, accessible UI design

## 🎨 UI Components

### Dashboard Integration
- Meal plan card in main dashboard
- Quick access to meal plan functionality
- Visual indicators for meal plan status

### Color Coding
- **Status Colors**: Green (Active), Orange (Draft), Grey (Archived)
- **Category Colors**: 
  - Protein: Red
  - Carbs: Orange
  - Fats: Yellow
  - Vegetables: Green
  - Fruits: Pink
  - Dairy: Blue

### Interactive Elements
- **Selection Feedback**: Visual highlighting of selected options
- **Expandable Sections**: Collapsible meal type and option details
- **Progress Tracking**: Daily summary with selected calories and meal count

## 🔧 API Integration

### Endpoints
- `GET /meal-plan/current`: Fetch current user's meal plan
- `GET /meal-plans`: Get all meal plans
- `POST /meal-plans`: Create new meal plan
- `PUT /meal-plans/{id}`: Update existing meal plan
- `DELETE /meal-plans/{id}`: Delete meal plan
- `POST /meal-plans/{id}/select-option`: Select meal option

### Error Handling
- Comprehensive ApiException handling
- User-friendly error messages
- Retry functionality for failed requests
- Network error recovery

## 📱 User Experience

### Loading States
- Smooth loading indicators
- Skeleton screens for better perceived performance
- Progressive data loading

### Error States
- Clear error messages
- Retry buttons for failed operations
- Graceful degradation

### Empty States
- Helpful messages when no meal plan is assigned
- Guidance for next steps
- Contact information for nutritionists

## 🚀 Getting Started

### Dependencies
```yaml
dependencies:
  get: ^4.6.5
  http: ^0.13.6
  flutter_expandable: ^1.0.0
```

### Usage
```dart
// Navigate to meal plan
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const MealPlanView(),
  ),
);

// Or use GetX navigation
Get.to(() => const MealPlanView());
```

### Integration
The meal plan module is automatically integrated into the dashboard and can be accessed via:
1. Dashboard meal plan card
2. Direct navigation to MealPlanView
3. Future: Bottom navigation integration

## 🔮 Future Enhancements

### Planned Features
- [ ] Meal plan history and tracking
- [ ] Nutritional goal setting
- [ ] Meal plan sharing and social features
- [ ] Offline support and caching
- [ ] Meal plan customization
- [ ] Nutritional analysis and insights
- [ ] Meal plan recommendations
- [ ] Shopping list generation

### Technical Improvements
- [ ] Advanced caching strategies
- [ ] Real-time updates
- [ ] Push notifications for meal reminders
- [ ] Integration with fitness tracking
- [ ] AI-powered meal suggestions

## 🧪 Testing

### Unit Tests
- Model parsing tests
- Controller logic tests
- Service API tests

### Widget Tests
- UI component tests
- User interaction tests
- Responsive design tests

### Integration Tests
- End-to-end meal plan workflow
- API integration tests
- Error handling scenarios

## 📋 Requirements Met

✅ **STEP 1: UI Components Required**
- ✅ Meal Plan Dashboard with title, status, and notes
- ✅ Statistics Box with meal types, options, and calories
- ✅ Meal Type Sections with expandable options
- ✅ Food Items grouped by category with detailed information
- ✅ Responsive design with collapsible accordions

✅ **STEP 2: Dependencies**
- ✅ HTTP package for API calls
- ✅ Flutter expandable for accordion functionality

✅ **STEP 3: Models**
- ✅ Complete model structure with safe parsing
- ✅ JSON serialization/deserialization
- ✅ Type-safe data handling

✅ **STEP 4: API Service**
- ✅ Comprehensive API integration
- ✅ Error handling and logging
- ✅ Safe parsing utilities

✅ **STEP 5: UI Screen**
- ✅ Complete meal plan interface
- ✅ Interactive meal selection
- ✅ Modern, accessible design

## 🎉 Summary

The meal plan module provides a complete, production-ready solution for managing personalized meal plans. It includes all requested features with modern UI design, robust error handling, and seamless integration with the existing app architecture. 