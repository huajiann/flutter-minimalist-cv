# Minimalist CV with Flutter

A simple Flutter Web app to create your own online CV/resume, inspired by Bartosz Jarocki's minimalist design.

## Features

- Setup with only one file (`assets/data/data.json`)
- Built with Flutter, easily hosted with GitHub Pages
- Auto-generated responsive layout
- Works on any device

## Tech Stack

- **Flutter:** 3.35.x (tested on 3.35.5)
- **Dart:** 3.9.x (tested on 3.9.2)
- **Target platform:** Web (Chrome)

**Minimum requirement:** Flutter SDK >= 3.35.0. If your local SDK is older, upgrade Flutter before running the project.

> **💡 Tip:** If you work with multiple Flutter projects requiring different versions, consider using [FVM (Flutter Version Management)](https://fvm.app/). It allows you to easily switch between Flutter versions per project without conflicts.
>
> Quick FVM setup:
>
> ```bash
> # Install FVM
> dart pub global activate fvm
>
> # Use specific Flutter version for this project
> fvm use 3.35.5
>
> # Run commands with FVM
> fvm flutter pub get
> fvm flutter run -d chrome
> ```

## Getting Started

### 1. Fork the Repository

1. Go to https://github.com/huajiann/flutter-minimalist-cv
2. Click the **Fork** button in the top-right corner
3. This creates a copy of the repository in your GitHub account

### 2. Clone Your Fork

```bash
# Replace YOUR_USERNAME with your GitHub username
git clone https://github.com/YOUR_USERNAME/flutter-minimalist-cv.git
cd flutter-minimalist-cv
```

### 3. Customize Your CV

Edit the file `assets/data/data.json` with your information:

```json
{
  "name": "Your Name",
  "location": "Your City, Country",
  "locationLink": "",
  "quote": "Your professional tagline",
  "imageUrl": "",
  "aboutMe": "Your bio/summary",
  "contact": [
    {
      "id": 1,
      "name": "email",
      "url": "your.email@example.com"
    },
    {
      "id": 2,
      "name": "github",
      "url": "https://github.com/YOUR_USERNAME"
    }
  ],
  "work": [...],
  "education": [...],
  "skills": [...],
  "projects": [...]
}
```

**Optional:** Add profile images and other assets:

- Place images in `assets/images/`
- Update `imageUrl` in `data.json` to reference your image (e.g., `"assets/images/profile.jpg"`)
- Remember to register any new assets in `pubspec.yaml` under the `assets:` section

### 4. Install Dependencies

Make sure you have Flutter installed. See https://docs.flutter.dev/get-started/install if needed.

```bash
flutter pub get
```

### 5. Run Locally

Test your CV locally before deploying:

```bash
# Run in Chrome
flutter run -d chrome
```

**Note:** Use an incognito window or clear your browser cache to see latest changes after rebuilding.

## Deploy to GitHub Pages

### Option A: Using `peanut` (Recommended)

This tool automates the deployment process:

```bash
# Install peanut (one-time setup)
flutter pub global activate peanut

# Deploy to GitHub Pages
# Replace YOUR_REPO_NAME with your repository name (e.g., flutter-minimalist-cv)
flutter pub global run peanut --extra-args "--base-href /YOUR_REPO_NAME/"

# Push the gh-pages branch
git push origin gh-pages
```

### Option B: Manual Deployment

```bash
# Replace YOUR_REPO_NAME with your repository name
flutter build web --release --base-href /YOUR_REPO_NAME/

# Navigate to build output
cd build/web

# Initialize git and deploy
git init
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git checkout -b gh-pages
git add .
git commit -m "Deploy CV site"
git push -f origin gh-pages
```

### Enable GitHub Pages

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages**
3. Under "Source", select the `gh-pages` branch
4. Click **Save**
5. Your CV will be live at: `https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/`

**Note:** If you're hosting at `YOUR_USERNAME.github.io` (user site), use `--base-href /` instead.

## Tips & Troubleshooting

- **Cached assets:** After deployment, clear browser cache or use incognito mode to see the latest changes. You can also unregister the service worker in DevTools (Application → Service Workers → Unregister).
- **Base href:** Always use `--base-href /YOUR_REPO_NAME/` to ensure scripts and assets load correctly.
- **Data structure:** Check the existing `data.json` for the complete structure including `work`, `education`, `skills`, and `projects` arrays.

## Updating Your CV

1. Edit `assets/data/data.json` with your new information
2. Test locally: `flutter run -d chrome`
3. Redeploy using `peanut` or manual build
4. Push to `gh-pages` branch

---

Inspired by [Bartosz Jarocki's CV](https://github.com/BartoszJarocki/cv)
