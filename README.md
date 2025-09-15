
# TH Platform Channel Demo

An MVP to demonstrate communication between Flutter and iOS Native code.

## Data Flow

1. **Flutter UI** receives an event from the user (e.g., tapping the Sync button).
2. Flutter calls the iOS native code using a platform channel.
3. The iOS native code processes the request using HealthKit to collect health data (e.g., step count).
4. The native code returns the collected data to Flutter via the platform channel.
5. Flutter displays the data in the UI.

## Preview
https://github.com/user-attachments/assets/0294ad80-4a8b-4c1d-b4c7-220411cb3ad5

