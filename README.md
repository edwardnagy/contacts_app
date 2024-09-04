# contacts_app

Contacts app based on the design of the iOS native Contacts app.

## SDK requirements

**Flutter version:** 3.24.1

Entry point: `lib/main.dart`

## Architecture

The app utilizes a [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) approach, separating concerns into distinct layers.

It organizes the code into two main directories, keeping the business logic separate from the UI:
- `lib/core`: Encapsulates business logic, data models, and interactions with data sources.
- `lib/presentation`: Handles UI components, navigation, and user interactions.

Not all principles of Clean Architecture are strictly followed. For example, dependency inversion was not implemented, as it would have introduced unnecessary complexity for this project.
