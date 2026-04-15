# GHOST Portfolio — Ahmed Allaw

Flutter Web portfolio for Ahmed Allaw (GHOST), Flutter Mobile Developer.

## Quick Start

```bash
flutter pub get
flutter run -d chrome
```

## Build for Production

```bash
flutter build web --release --web-renderer canvaskit
```

Deploy the `build/web/` folder to Vercel. The `vercel.json` handles SPA routing.

## Customization

| What | File | Key |
|---|---|---|
| Style (startup / classic) | `lib/config/app_style.dart` | `activeStyle` |
| All content | `lib/config/portfolio_data.dart` | constants |
| Add project | `lib/config/portfolio_data.dart` | `projects` list |
| Avatar | `lib/config/portfolio_data.dart` | `avatarUrl` |
| Email | `lib/config/portfolio_data.dart` | `email` |
| Colors | `lib/core/theme/app_colors.dart` | `AppColors` |

## Add a Project

Open `lib/config/portfolio_data.dart` and add a map to `projects`:

```dart
{
  'title': 'My New App',
  'description': 'Description here.',
  'tech': ['Flutter', 'Riverpod'],
  'github': 'https://github.com/GHOST3030/my-new-app',
  'image': '',
},
```

## Switch to Classic Style

In `lib/config/app_style.dart`:

```dart
static const PortfolioStyle activeStyle = PortfolioStyle.classic;
```

## Deploy to Vercel

Option A — CLI:
```bash
flutter build web --release
cd build/web
vercel deploy --prod
```

Option B — GitHub:
1. Push repo to GitHub
2. Import project in Vercel dashboard
3. Set output directory to `build/web`
4. Set build command to `flutter build web --release`
