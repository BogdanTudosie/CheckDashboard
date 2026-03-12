# CheckDashboard

A macOS security dashboard application built with SwiftUI that monitors system security settings.

## Features

- **Firewall Status**: Monitor macOS Application Firewall state
- **FileVault Status**: Check disk encryption status
- **Auto Updates**: Verify automatic update configuration
- **Gatekeeper**: Check app installation security settings

## Requirements

- macOS 14.0+ (Sonoma or later)
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/BogdanTudosie/CheckDashboard.git
   cd CheckDashboard
   ```

2. Open the project in Xcode:
   ```bash
   open CheckDashboard.xcodeproj
   ```

3. Build and run the project (⌘R)

## Architecture

- **MVVM Pattern**: Separation of concerns with ViewModels
- **SwiftUI**: Modern declarative UI framework
- **Async/Await**: Asynchronous security checks
- **SwiftData**: Data persistence

## Project Structure

```
CheckDashboard/
├── Views/           # SwiftUI views
├── ViewModels/      # Business logic
├── Model/           # Data models
└── Helpers/         # Utility functions and security checks
```

## License

Copyright © 2026 Bogdan Tudosie. All rights reserved.
