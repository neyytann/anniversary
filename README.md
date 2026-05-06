# 💕 Nathan & Frenzy — One Year Anniversary App

A romantic Flutter app celebrating your first anniversary. Built with Dart & Flutter.

---

## ✨ Features

- **Hero Section** — Full-screen animated entrance with falling rose petals
- **Live Countdown** — Ticking down to June 4, 2026 in real time
- **Photo Gallery** — 6 placeholder slots, ready for your own photos
- **Memory Timeline** — 3 milestones with fade-in scroll animations
- **Love Letter** — Ornate bordered letter card
- **Responsive** — Works on mobile, tablet & desktop

---

## 🚀 Setup & Run

### Prerequisites
- Flutter SDK ≥ 3.10.0 → https://flutter.dev/docs/get-started/install
- Dart SDK ≥ 3.0.0 (bundled with Flutter)

### Steps

```bash
# 1. Navigate to the project folder
cd anniversary_app

# 2. Get dependencies
flutter pub get

# 3a. Run as Flutter app (desktop/mobile)
flutter run

# 3b. Run as Web app
flutter run -d chrome

# 4. Build for web (deployable)
flutter build web
# Output will be in build/web/ — host on any static server
```

---

## 📸 Adding Your Photos

Open `lib/widgets/gallery_section.dart` and replace the `_GalleryPlaceholder` widgets with real images:

```dart
// Option 1: Asset image (add to assets/images/)
Image.asset('assets/images/your-photo.jpg', fit: BoxFit.cover)

// Option 2: Network image
Image.network('https://your-url.com/photo.jpg', fit: BoxFit.cover)
```

Don't forget to add asset images to `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/photo1.jpg
    - assets/images/photo2.jpg
```

---

## ✏️ Customization

| File | What to edit |
|------|-------------|
| `lib/widgets/timeline_section.dart` | Milestone dates, titles, descriptions |
| `lib/widgets/letter_section.dart` | Love letter text |
| `lib/widgets/countdown_section.dart` | Anniversary date |
| `lib/app.dart` | Color palette (`AppColors`) |

---

## 🏗 Project Structure

```
lib/
├── main.dart                  # Entry point
├── app.dart                   # Theme & colors
├── screens/
│   └── home_screen.dart       # Main scrollable screen
└── widgets/
    ├── nav_bar.dart            # Fixed top navigation
    ├── hero_section.dart       # Animated hero + petals
    ├── countdown_section.dart  # Live countdown timer
    ├── gallery_section.dart    # Photo grid
    ├── timeline_section.dart   # Memory milestones
    ├── letter_section.dart     # Love letter
    └── footer_section.dart     # Footer
```

---

Made with 💕 for Nathan & Frenzy
