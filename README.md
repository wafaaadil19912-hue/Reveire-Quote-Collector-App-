
## Project Brief: Quote Collector Application

## 1. Project Overview

The **Quote Collector** is a mobile application developed using the Flutter framework. Its primary purpose is to allow users to curate a personal collection of meaningful quotes. Users can add new quotes, organize them by category, mark favorites, and filter their view based on these categories or a favorites list. The application emphasizes a clean user interface, smooth navigation, and core data management functionality.

## 2. Technical Specifications

- **Framework:** Flutter (Dart)
- **Architecture:** Component-based with separation of concerns (Screens, Models, Widgets)
- **Data Persistence:** (Implied, but for full functionality, local storage like SQLite, Hive, or SharedPreferences is recommended, though not detailed in the core spec)
- **Target Platform:** Cross-platform (iOS & Android)

## 3. Functional Requirements

The application is divided into five distinct screens and five core features.

### 3.1 Screens & Navigation Flow

| Screen | Primary Function | Navigation Trigger |
| :--- | :--- | :--- |
| **Splash Screen** | Displays the app name and icon. Auto-navigates to the Home screen. | Automatic after loading. |
| **Home Screen** | Displays a scrollable list of all quotes in a card format. Contains buttons to add a quote and navigate to favorites. | From Splash Screen. |
| **Add Quote Screen** | Provides a form with input fields (quote text, book name, author) and a category dropdown. Includes a save button. | From Home Screen ('+' button). |
| **Categories Screen** | Displays a list of predefined categories (e.g., Motivation, Love, Life). | From Home Screen. |
| **Favorites Screen** | Displays a list of quotes marked as favorite, using the same UI card layout as the Home screen. | From Home Screen. |

**Navigation Flow Diagram:**
`Splash → Home → (Add Quote | Favorites | Categories)`

### 3.2 Core Features (Minimum Viable Product)

The following features are mandatory for the application to be considered complete:

1.  **Add Quote:** The user must be able to input and save a new quote with its associated metadata (text, book, author, category).
2.  **Display Quotes:** All saved quotes must be rendered as a list on the Home screen.
3.  **Favorite Toggle:** The user must be able to mark or unmark a quote as a favorite (e.g., via a ❤️ icon button on each quote card).
4.  **Category Filter:** Clicking a category from the Categories screen must display a filtered list showing only quotes belonging to that category.
5.  **Data Model:** A `Quote` class must exist with the following fields:
    - `String quoteText`
    - `String bookName`
    - `String author`
    - `String category`
    - `bool isFavorite`

## 4. User Interface & Design Specifications

Adherence to these UI principles is required for a satisfactory user experience and will positively impact evaluation.

- **Layout:** All quotes must be presented using **Card** widgets.
- **Icons:** Standard Flutter icons must be used for key actions:
    - `Icons.favorite` (or `Icons.favorite_border`) for the favorite button.
    - `Icons.add` for the add quote button.
- **Spacing:** Consistent margins and padding must be applied to avoid crowded or cluttered layouts.
- **Color Scheme:** A consistent color palette should be applied across all screens to create a cohesive visual identity.

## 5. Optional Enhancements (For Distinction)

The following features are not required but may be implemented for additional credit or portfolio distinction:

- **Dark Mode:** A theme toggle that switches the app between light and dark color schemes.
- **Search Bar:** A search field on the Home screen that filters quotes by text or author.
- **Share Button:** A UI button on each quote card to invoke the native share dialog (UI-only implementation is acceptable).

## 6. Quality Assurance & Testing Protocol

Before final submission, the following test cases must be executed and pass successfully:

| Test Case | Expected Result |
| :--- | :--- |
| Add a new quote with valid data. | The quote appears on the Home screen immediately after saving. |
| Tap the favorite icon on a quote. | The icon changes state (e.g., outline to filled), and the quote appears on the Favorites screen. |
| Tap the favorite icon again. | The icon reverts state, and the quote is removed from the Favorites screen. |
| Navigate from Home → Add Quote → Save. | User is returned to the Home screen, and the new quote is visible. |
| Navigate to Categories and select a category. | The Home screen updates to show only quotes from the selected category. |

