# Minimalist CV with Flutter

This is a simple Flutter Web app which was inspired by Bartosz Jarocki.

# Features

- Setup with only one file.
- Built with Flutter, hosted with Github Pages via [peanut](https://pub.dev/packages/peanut)
- Auto generated layout.
- Responsive with any devices (should be!)

## Tech Stack

- **Flutter:** 3.35.x (tested on 3.35.5)
- **Dart:** 3.9.x (tested on 3.9.2)
- **Target platform:** Web (Chrome)

Minimum requirement: Flutter SDK >= 3.35.0. If your local SDK is older, upgrade Flutter before running the project.

## Run Locally

Quick steps to clone and run this project on your machine:

```bash
# clone the repo
git clone https://github.com/huajiann/flutter-minimalist-cv.git
cd flutter-minimalist-cv

# install dependencies
flutter pub get

# run on Chrome (dev)
flutter run -d chrome

# or build the web release (then deploy or serve locally)
flutter build web --release --base-href /flutter-minimalist-cv/
```

Notes:

- Make sure you have Flutter installed and on your PATH. See https://docs.flutter.dev/get-started/install.
- Use an incognito window or unregister the service worker after a deploy to avoid cached assets during testing.

## Build & Deploy (GitHub Pages)

To build the web app for GitHub Pages and ensure scripts load correctly, set the `--base-href` to your repository path. Example for this repo (served at `https://huajiann.github.io/flutter-minimalist-cv/`):

```bash
cd C:\Playground\Github\cv
flutter build web --release --base-href /flutter-minimalist-cv/
```

Then deploy the `build/web` contents to the `gh-pages` branch. A minimal sequence:

```bash
cd build/web
git init
git remote add origin https://github.com/huajiann/flutter-minimalist-cv.git
git checkout -b gh-pages
git add .
git commit -m "Deploy site"
git push -f origin gh-pages
```

Notes:

- If you host at the user site (`username.github.io`) use `--base-href /` instead.
- After deployment, clear or unregister the service worker in DevTools (Application → Service Workers → Unregister) or open the site in an incognito window to avoid stale cached assets.
- Do not manually edit the generated `build/web/index.html`; use `--base-href` to inject the correct base path.

If you'd like, I can add a small deploy script to automate this.

### Deploy using `peanut` (recommended)

If you prefer `peanut` to handle deploying, run:

```bash
# install peanut if you haven't already
flutter pub global activate peanut

cd C:\Playground\Github\cv
flutter pub global run peanut --extra-args "--base-href /flutter-minimalist-cv/"
```

After `peanut` runs you can push the `gh-pages` branch (if needed):

```bash
git push origin --set-upstream gh-pages
```

This sequence keeps the `--base-href` consistent and avoids manual edits to `index.html`.
