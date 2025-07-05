# Sarva Suvidhan Pvt. Ltd. - Digital Score Card

## Project Setup Instructions
1. Clone the repository or unzip the project folder to `D:\Download 2.0\sarva_suvidhan_new`.
2. Open in Android Studio/Visual Studio Code with Flutter SDK installed.
3. Run `flutter pub get` to fetch dependencies.
4. Connect an emulator or device and click **Run**.

## Key Features Implemented
- **Form Structure**: Includes Station Name, Inspection Date, and categories (Platform Cleanliness, Urinals, Water Booths, Waiting Area) with scores (0-10) and remarks.
- **UI**: Multi-section form with dropdowns for scores and text fields for remarks, scrollable with `SingleChildScrollView`.
- **State Management**: Uses `Provider` to manage form data.


## Assumptions/Limitations
- Categories based on assignment description (adjust per `1_SCORE CARD.pdf`).
- Offline upload requires network check logic (not fully implemented).
- No PDF export (requires additional package).

## Known Issues
- Basic validation; enhance per PDF requirements.
- Single screen layout (no tabs for simplicity).

## Submission Requirements
- Upload source code to GitHub or zip.
- Record demo as `AshutoshKumar_scorecard_assignment.mp4` and host on Google Drive.