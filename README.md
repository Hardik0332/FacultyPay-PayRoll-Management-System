<div align="center">
  <h1>FacultyPay</h1>
  <img src="assets/app_icon.png" alt="FacultyPay Logo" width="120" height="120" /><br /><br />
<a href="https://github.com/Hardik0332/FacultyPay-PayRoll-Management-System/releases/latest"><img src="https://img.shields.io/badge/Download-APK-2D80EC?logo=android" width="226" ></a> &nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://facultypay.web.app"><img src="https://img.shields.io/badge/Open_Web-APP-ff9a00?logo=firebase&logoColor=FFCA28" width="230"></a><br><br>
</div>

---
### 📖 Description

<img src="assets/cover.png" alt="FacultyPay Cover" width="100%" />

**FacultyPay** is a comprehensive payroll and attendance management system designed to streamline how educational institutions track faculty hours and process payments. Built with dual dedicated portals, it bridges the gap between management and teaching staff. Faculty can effortlessly log their hours, while Admins can verify attendance, generate official PDF salary slips, and process one-click UPI payments directly from the dashboard.

> [!IMPORTANT]
> **Disclaimer**: FacultyPay automates financial calculations based on user-inputted hourly rates and logged lectures. Always verify final payout amounts with official bank and institution records before clearing dues.
>
> **Privacy Note**: FacultyPay securely stores sensitive user data, payment logs, and UPI IDs using Firebase Cloud Firestore with robust security rules.

---

### 📸 Screenshots

### 🎓 Faculty
<div align="center">
  <img src="assets/faculty.png" alt="App Screenshots" width="100%" />
</div>

### 🏢 Admin
<div align="center">
  <img src="assets/admin.png" alt="App Screenshots" width="100%" />
</div>
  
---

### ✨ Features
- 👥 **Role-Based Portals**: Dedicated, secure environments for Admins (Management) and Faculty (Logging & History).
- 💸 **Integrated Payments**: Instantly pay faculty via dynamic UPI QR codes and deep-link app integrations.
- 📄 **Automated PDF Reports**: Generate, export, and print professional master ledgers and individual salary slips on the fly.
- 🌓 **Premium Theming**: Seamless Light/Dark mode switching with a beautiful circular reveal ripple effect.
- 🪄 **Fluid Navigation**: Enjoy a highly polished UI featuring morph transitions and frosted glass layouts.
- 🔔 **Smart Notifications**: Real-time push notifications for log approvals, rejections, and successfully processed payments.
- ☁️ **Cloud Synchronized**: A truly unified experience across Android and Web with real-time Firebase Cloud Firestore sync.

---

### 🛠 Requirements
Before you begin, ensure you have met the following requirements:
* **Flutter SDK**: `^3.10.4` or higher.
* **Dart SDK**: Compatible with the Flutter version.
* **IDE**: [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter/Dart plugins.
* **Platform**:
  - **Android**: SDK 21 (Android 5.0) or higher.
  - **Web**: Modern browser with JavaScript enabled.

---

### 🛠 Tech Stack
<a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-00CCFF?labelColor=333333&logo=Flutter&logoColor=00CCFF" height="30" width="106" align="left"></a>
<a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-40C4FF?labelColor=333333&logo=Dart&logoColor=40C4FF" height="30" width="88" align="left"></a>
<a href="https://firebase.google.com/"><img src="https://img.shields.io/badge/Firebase-FFCA28?labelColor=333333&logo=Firebase&logoColor=FFCA28" height="30" width="120" align="left"></a>
<a href="https://firebase.google.com/docs/hosting"><img src="https://img.shields.io/badge/Hosting-039BE5?labelColor=333333&logo=Firebase&logoColor=039BE5" height="30" width="115" align="left"></a><br><br>

- **Key Packages**:
  - `animated_theme_switcher` (Circular Theme Reveal)
  - `animations` (Shared Axis Transitions)
  - `pdf` & `printing` (Receipt & Ledger Generation)
  - `qr_flutter` & `url_launcher` (UPI Integration)
  - `firebase_auth` & `cloud_firestore` (Backend)
  - `firebase_messaging` (Push Notifications)

---

### 💻 Run Locally
1. Clone the repository:
```bash
git clone https://github.com/Hardik0332/FacultyPay-PayRoll-Management-System.git
```
2. Navigate to project directory:
```bash
cd FacultyPay-PayRoll-Management-System
```
3. Run the application:
```bash
flutter pub get
flutter run
```
---
### 📂 Folder Structure
```text
FacultyPay/
├── lib/               # Core Flutter application source files
│   ├── pages/         # Feature-specific UI components
│   │   ├── admin/     # Verification, Payouts, and Report screens
│   │   └── faculty/   # Dashboard, Attendance Logging, and History
│   ├── services/      # Firebase, PDF Generation, and Push Notifications
│   ├── theme/         # Custom color palettes and ThemeManager logic
│   └── widgets/       # Shared UI components (Sidebars, Badges, etc.)
└── assets/            # App icons, theme images, and static resources
```
---
### 📄 License

Released under the <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" height="20" align="center"></a>
