<p align="center">
  <img src="assets/icons/app_icons.png" width="120" alt="HealthFlo Icon" />
</p>

<h1 align="center">HealthFlo – Flutter + Firebase Healthcare Super App</h1>

HealthFlo is a secure, scalable healthcare experience for patients, doctors, and administrators. Built with Flutter for mobile and web, Firebase for identity and data, and an Express-powered Cloud Functions backend for AI workflows and appointment management.

---

## ✨ Feature Highlights

- **Role-based access** for patients, doctors, and administrators.
- **Doctor discovery** with detailed profiles and availability management.
- **End-to-end appointment lifecycle** with patient booking, doctor triage, and admin oversight.
- **AI assistant** powered by OpenAI via Firebase Functions for conversational care guidance.
- **Medical report summarisation** from pasted text or uploaded PDF/TXT files.
- **Secure REST API** hosted on Firebase Functions with token verification using the Admin SDK.

---

## 🛠 Tech Stack

| Layer            | Tools |
|------------------|-------|
| Frontend         | Flutter (Material 3), Provider state management |
| Auth             | Firebase Authentication (Email/Password) |
| Data             | Cloud Firestore + Firebase Storage |
| Backend API      | Firebase Functions (Express + Node.js 20) |
| AI Integrations  | OpenAI GPT models via Functions routes |
| Hosting          | Firebase Hosting serving Flutter web & API rewrites |

---

## 📁 Project Structure

```
lib/
  models/           # Core data models (users, doctors, appointments, chat)
  providers/        # ChangeNotifier providers for auth, doctors, bookings, chat, uploads
  screens/          # Auth, home, explore, doctor detail, bookings, chat, reports
  widgets/          # Reusable UI components
  services/         # API client wrappers
  utils/            # Routing and configuration helpers
functions/
  index.js          # Express app with REST + AI endpoints
  authMiddleware.js # Firebase ID token verification middleware
  .env.example      # Sample environment configuration
firebase.json        # Hosting + Functions rewrites configuration
.firebaserc          # Firebase project alias placeholder
```

---

## 🚀 Getting Started

1. **Configure Firebase**
    - Create a Firebase project and enable Authentication (email/password) and Cloud Firestore.
    - Populate Firestore collections: `users`, `doctors`, `appointments`.
    - Generate Firebase config and update `lib/firebase_options.dart` with your project values.

2. **Install Flutter Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Flutter App**
   ```bash
   flutter run
   ```
   The app supports Android, iOS, and Web targets.

4. **Set up Cloud Functions**
   ```bash
   cd functions
   cp .env.example .env        # add your OpenAI key
   npm install
   npm run serve               # emulators, or
   firebase deploy --only functions
   ```

5. **Deploy Flutter Web (optional)**
   ```bash
   flutter build web
   firebase deploy --only hosting
   ```

---

## 🔐 Security Model

- Every `/api/**` request passes through `authMiddleware.js`, verifying Firebase ID tokens with the Admin SDK and attaching role metadata.
- Firestore security rules should mirror provider logic: patients access their own appointments, doctors see assigned bookings, admins have elevated rights.
- AI endpoints require authentication and validate payload size before invoking OpenAI.

---

## 🗄 Firestore Collections

| Collection        | Fields (example)                                  |
|-------------------|----------------------------------------------------|
| `users/{uid}`      | `name`, `email`, `role` (`patient`, `doctor`, `admin`) |
| `doctors/{id}`     | `name`, `specialty`, `bio`, `rating`, `slots[]`    |
| `appointments/{id}`| `doctorId`, `doctorName`, `patientId`, `patientName`, `slotTime`, `status`, `notes` |

Slot times are stored as ISO 8601 strings to work across platforms and simplify hosting rewrites.

---

## 🤖 AI Integrations

- `POST /api/ai/chat` – contextual chat assistant using GPT with conversation history.
- `POST /api/ai/summarise` – summarises text or uploaded PDF/TXT content into key insights and recommended follow-up actions.

Both endpoints require a valid Firebase ID token and an `OPENAI_API_KEY` configured in the Functions environment.

---

## 🧪 Testing & Development Notes

- The repository does not include generated Firebase options or secrets. Supply them before running locally.
- Run `npm run lint` inside `functions/` to check the backend.
- Use the Firebase Emulator Suite to iterate on Firestore rules, functions, and hosting locally.

---

## 📄 License

This project is released under the MIT License. See [LICENSE](LICENSE) for details.
