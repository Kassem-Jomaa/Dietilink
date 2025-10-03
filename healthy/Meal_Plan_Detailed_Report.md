# Meal Plan Module - Detailed Report

## Table: Meal Plan Page Detailed Report

| Features | Description | Validation and Functionality |
|---------|-------------|------------------------------|
| **Authentication Check** | Ensures that the user is logged in before accessing meal plan features. | • Checks if an authentication token exists in secure storage.<br>• If no token is found, redirects to the login page.<br>• Validates token expiration and refreshes if needed.<br>• Handles unauthorized access with proper error messages. |
| **Current Meal Plan Loading** | Retrieves the user's current active meal plan from the server. | • `fetchCurrentPlan()`: Sends a GET request to `/v1/meal-plan/current`.<br>• Checks `has_active_plan` flag in response.<br>• If successful, stores meal plan data in state.<br>• Handles cases where no active plan is assigned.<br>• Validates meal plan data structure and required fields. |
| **Meal Plan Dashboard** | Displays meal plan title, status, and notes in a dashboard card. | • Shows meal plan name and status badge with color coding.<br>• Displays meal plan notes and instructions from nutritionists.<br>• Status colors: Green (Active), Orange (Draft), Grey (Archived).<br>• Handles missing or incomplete meal plan data gracefully. |
| **Statistics Box** | Shows comprehensive meal plan statistics and metrics. | • Displays total meal types (Breakfast, Lunch, Dinner, Snacks).<br>• Shows total meal options available across all types.<br>• Displays calorie range and total estimated calories.<br>• Updates statistics in real-time when meal plan changes.<br>• Handles empty states when no meal plan is assigned. |
| **Meal Type Sections** | Organizes meals by type with expandable sections. | • Groups meals by type: Breakfast, Lunch, Dinner, Snacks.<br>• Shows meal type title, description, and option count.<br>• Uses collapsible accordions for mobile-friendly design.<br>• Displays meal type icons for visual identification.<br>• Handles different meal type configurations. |
| **Meal Options Cards** | Displays individual meal options with selection functionality. | • Shows option number, title, and estimated calories.<br>• Displays selection state with visual highlighting.<br>• Provides expandable details for each option.<br>• Handles option selection with local state management.<br>• Shows check mark for selected options. |
| **Food Items Display** | Shows detailed food items within each meal option. | • Groups food items by category (Protein, Carbs, Fats, Vegetables, Fruits, Dairy).<br>• Displays food item name, portion size, and calories.<br>• Uses color coding for different food categories.<br>• Shows individual item calories and nutritional information.<br>• Handles missing or incomplete food item data. |
| **Meal Option Selection** | Allows users to select meal options for each meal type. | • `selectMealOption()`: Updates local selection state.<br>• Validates selection eligibility and availability.<br>• Provides visual feedback for selected options.<br>• Tracks selections across all meal types.<br>• Shows selection confirmation messages. |
| **Progress Summary Card** | Displays summary of selected meals and total calories. | • Shows total selected calories from all meal choices.<br>• Displays count of meals selected vs. total available.<br>• Updates in real-time as selections change.<br>• Only appears when user has made selections.<br>• Provides clear progress indication. |
| **Refresh Functionality** | Allows users to refresh meal plan data. | • `refreshMealPlan()`: Reloads current meal plan from API.<br>• Shows loading indicator during refresh.<br>• Handles refresh errors gracefully.<br>• Updates all meal plan data and statistics.<br>• Maintains user selections after refresh. |
| **Error Handling** | Comprehensive error handling for all meal plan operations. | • Displays user-friendly error messages for API failures.<br>• Shows retry buttons for failed operations.<br>• Handles network errors and server issues.<br>• Provides fallback UI for error states.<br>• Logs errors for debugging purposes. |
| **Loading States** | Visual feedback during data loading operations. | • Shows loading indicators for API calls.<br>• Displays skeleton screens for better perceived performance.<br>• Handles loading states for individual components.<br>• Prevents user interaction during loading.<br>• Provides smooth loading transitions. |
| **Empty State Handling** | Displays helpful messages when no meal plan is assigned. | • Shows informative message when no active plan exists.<br>• Provides guidance for contacting nutritionists.<br>• Displays appropriate icons and styling.<br>• Offers clear next steps for users.<br>• Maintains consistent UI design. |
| **Responsive Design** | Adapts to different screen sizes and orientations. | • Uses flexible layouts for different screen sizes.<br>• Implements collapsible accordions for mobile.<br>• Handles text overflow with ellipsis.<br>• Maintains touch-friendly interface elements.<br>• Supports both portrait and landscape orientations. |
| **Color Coding System** | Visual organization using color-coded elements. | • Status colors for meal plan status indicators.<br>• Category colors for food items (Protein: Red, Carbs: Orange, etc.).<br>• Selection colors for chosen meal options.<br>• Consistent color scheme throughout the interface.<br>• Accessibility considerations for color-blind users. |
| **Pull-to-Refresh** | Allows users to refresh data by pulling down. | • Implements pull-to-refresh functionality.<br>• Shows refresh indicator during operation.<br>• Handles refresh errors gracefully.<br>• Updates all meal plan data after refresh.<br>• Maintains user selections after refresh. |
| **Meal Plan History** | Displays historical meal plans and selections. | • `fetchAllMealPlans()`: Retrieves all user meal plans.<br>• Shows meal plan history with dates and status.<br>• Allows navigation between different meal plans.<br>• Handles pagination for large meal plan lists.<br>• Provides meal plan comparison functionality. |
| **Meal Plan Creation** | Allows nutritionists to create new meal plans. | • `createMealPlan()`: Sends POST request to `/v1/meal-plans`.<br>• Validates meal plan data structure and required fields.<br>• Handles meal plan creation confirmation.<br>• Updates meal plan list after creation.<br>• Provides feedback for successful creation. |
| **Meal Plan Updates** | Enables editing and updating existing meal plans. | • `updateMealPlan()`: Sends PUT request to `/v1/meal-plans/{id}`.<br>• Validates update data and permissions.<br>• Handles meal plan update confirmation.<br>• Refreshes meal plan data after updates.<br>• Provides error handling for update failures. |
| **Meal Plan Deletion** | Allows removal of meal plans with confirmation. | • `deleteMealPlan()`: Sends DELETE request to `/v1/meal-plans/{id}`.<br>• Shows confirmation dialog before deletion.<br>• Validates deletion permissions and eligibility.<br>• Updates meal plan list after deletion.<br>• Handles deletion errors gracefully. |
| **Meal Option API Selection** | Sends meal option selections to server. | • `selectMealOption()`: Sends POST request to `/v1/meal-plans/{id}/select-option`.<br>• Validates selection data and meal plan ID.<br>• Handles selection confirmation and feedback.<br>• Updates server with user selections.<br>• Provides error handling for selection failures. |
| **Meal Plan Statistics** | Retrieves and displays meal plan analytics. | • `getMealPlanStats()`: Sends GET request to `/v1/meal-plans/{id}/stats`.<br>• Shows nutritional analysis and insights.<br>• Displays calorie tracking and goal progress.<br>• Provides meal plan performance metrics.<br>• Handles statistics calculation errors. |

## **API Interaction**

| Item | Details |
|------|---------|
| **Current Meal Plan API** | • URL: `/v1/meal-plan/current`<br>• Method: GET<br>• Headers: Auth token required<br>• Response: Current active meal plan data |
| **Meal Plan by ID API** | • URL: `/v1/meal-plan/{id}`<br>• Method: GET<br>• Headers: Auth token required<br>• Response: Specific meal plan details |
| **All Meal Plans API** | • URL: `/v1/meal-plans`<br>• Method: GET<br>• Headers: Auth token required<br>• Response: List of all user meal plans |
| **Create Meal Plan API** | • URL: `/v1/meal-plans`<br>• Method: POST<br>• Headers: Auth token required<br>• Body: New meal plan data<br>• Response: Created meal plan confirmation |
| **Update Meal Plan API** | • URL: `/v1/meal-plans/{id}`<br>• Method: PUT<br>• Headers: Auth token required<br>• Body: Updated meal plan data<br>• Response: Updated meal plan confirmation |
| **Delete Meal Plan API** | • URL: `/v1/meal-plans/{id}`<br>• Method: DELETE<br>• Headers: Auth token required<br>• Response: Deletion confirmation |
| **Select Meal Option API** | • URL: `/v1/meal-plans/{id}/select-option`<br>• Method: POST<br>• Headers: Auth token required<br>• Body: Meal type and option number<br>• Response: Selection confirmation |
| **Meal Plan Stats API** | • URL: `/v1/meal-plans/{id}/stats`<br>• Method: GET<br>• Headers: Auth token required<br>• Response: Meal plan statistics and analytics |

## **User Interface**

| Item | Details |
|------|---------|
| **Responsive Layout** | Uses Column, ListView, and Card widgets for adaptive layouts.<br>Handles different screen sizes and orientations.<br>Implements collapsible accordions for mobile devices.<br>Uses flexible and expanded widgets for proper spacing. |
| **Loading Indicators** | Shows spinners while fetching meal plan data.<br>Displays skeleton screens for better perceived performance.<br>Disables interactions during loading operations.<br>Provides smooth loading transitions. |
| **Error Handling** | Displays error messages for failed API calls.<br>Shows retry buttons for failed operations.<br>Provides fallback UI for error states.<br>Logs errors for debugging purposes. |
| **Overflow Handling** | Uses Expanded and Flexible widgets to prevent UI overflow.<br>Implements text truncation with ellipsis.<br>Handles long meal plan names and descriptions.<br>Maintains responsive design across devices. |
| **Visual Feedback** | Provides selection highlighting for chosen meal options.<br>Uses color coding for different food categories.<br>Shows status indicators for meal plan status.<br>Implements smooth animations and transitions. |

## **Security Considerations**

| Item | Details |
|------|---------|
| **Auth Protection** | Meal plan page is protected by auth middleware.<br>Redirects to login if not authenticated.<br>Validates user permissions for meal plan access.<br>Ensures secure access to meal plan data. |
| **Secure API Calls** | All API requests require a valid JWT token.<br>Token stored securely using flutter_secure_storage.<br>Implements token refresh for expired sessions.<br>Validates API responses for security. |
| **Data Privacy** | User meal plan data is only fetched after authentication.<br>No sensitive nutritional data in logs.<br>Implements secure data transmission.<br>Protects user privacy and confidentiality. |
| **Input Validation** | Validates all meal plan data before processing.<br>Sanitizes user inputs to prevent injection attacks.<br>Validates API response data structure.<br>Implements proper error handling for invalid data. |

## **Restrictions & Limitations**

| Item | Details |
|------|---------|
| **No Offline Mode** | Meal plan data requires internet connection.<br>No local caching of meal plan data.<br>Cannot access meal plans without network.<br>Requires active internet for all operations. |
| **No Guest Access** | Only authenticated users can access meal plan features.<br>No preview or demo mode available.<br>Requires valid user account for access.<br>No public meal plan browsing. |
| **No Real-time Sync** | Data is fetched on page load or refresh, not in real-time.<br>No push notifications for meal plan updates.<br>Requires manual refresh for latest data.<br>No automatic synchronization with server. |
| **Limited Customization** | Users cannot modify meal plan structure.<br>Cannot add or remove meal types.<br>Cannot customize food item categories.<br>Limited to nutritionist-assigned plans. |
| **No Meal Plan Sharing** | Cannot share meal plans with other users.<br>No social features for meal plan collaboration.<br>No export functionality for meal plans.<br>Limited to individual user access. |
| **No Advanced Analytics** | Basic statistics only, no detailed nutritional analysis.<br>No progress tracking over time.<br>No goal setting or achievement tracking.<br>Limited to current meal plan data only. |

## **Add Meal Plan Page: Overview**

The Add Meal Plan Page is where nutritionists can create personalized meal plans for patients. This page requires nutritionist authentication and provides a comprehensive meal plan creation interface that includes meal type configuration, food item selection, and nutritional analysis. Nutritionists need to complete all required fields including meal types, food items, and nutritional information before submitting the meal plan. Upon successful submission, the meal plan is assigned to the patient and becomes available in their meal plan interface.

### **Key Features:**
- **Comprehensive meal plan creation** with multiple meal types
- **Food item selection** with nutritional database integration
- **Calorie calculation** and nutritional analysis
- **Meal plan validation** and error checking
- **Patient assignment** and notification system
- **Meal plan preview** before submission
- **Nutritional goal alignment** with patient requirements
- **Responsive design** for different screen sizes

### **Validation Requirements:**
- Nutritionist must be authenticated
- All meal types must be configured
- Food items must have valid nutritional data
- Calorie calculations must be accurate
- Patient assignment must be valid
- All required fields must be completed
- Nutritional goals must be achievable

### **API Integration:**
- Creates meal plans via `/v1/meal-plans`
- Fetches food database from `/v1/foods`
- Calculates nutrition via `/v1/nutrition/calculate`
- Assigns to patients via `/v1/meal-plans/{id}/assign`
- Validates data via `/v1/meal-plans/validate`

### **User Experience:**
- Intuitive meal plan creation flow
- Real-time nutritional calculations
- Visual feedback for all operations
- Comprehensive validation and error handling
- Patient assignment confirmation
- Success notifications and meal plan activation 