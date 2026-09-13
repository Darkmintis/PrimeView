# PrimeView

**Your media. Your way. No accounts. No tracking.**

Open-source media hub for Android, iOS, and desktop. Watch IPTV channels, browse YouTube, and play local videos — all in one app.

---

## Download

[![Get it on GitHub](https://img.shields.io/badge/Download-APK-blue?style=for-the-badge&logo=github)](https://github.com/Darkmintis/PrimeView/releases/latest)

Latest release: [GitHub Releases](https://github.com/Darkmintis/PrimeView/releases)

---

## Features

### Live TV
- Watch 10,000+ free IPTV channels from around the world
- Load your own M3U playlists from URL or file
- Channels organized by category, country, and language

### YouTube
- Search and watch any YouTube video
- Trending videos and free movies
- No account required

### Local Media Player
- Play any video file from your device (MP4, MKV, AVI, WebM)
- Resume playback where you left off
- Browse by folders
- Watch history with progress tracking

### Subtitles & Audio
- Switch between embedded subtitle tracks
- Load external .srt, .ass, and .vtt subtitle files
- Switch between audio tracks in multi-language videos

### Recording
- Record any live stream to your device
- Background recording support
- Manage all recordings in one place

### Player Controls
- Full-screen with landscape rotation
- Picture-in-Picture (PiP) mode
- Volume, brightness, and playback speed controls
- Gesture-based seeking

### Design
- Premium dark theme with gradient accents
- Smooth shimmer loading animations
- Responsive layout for phones and tablets

---

## Screenshots

<p align="center">
  <img src="screenshots/home.png" width="250" />
  <img src="screenshots/player.png" width="250" />
  <img src="screenshots/youtube.png" width="250" />
  <img src="screenshots/library.png" width="250" />
</p>

---

## Why PrimeView?

| | PrimeView | Other Apps |
|---|---|---|
| **Price** | Free forever | Free with ads or paid |
| **Accounts** | None required | Usually required |
| **Open source** | GPL v3 | Closed source |
| **YouTube** | Built-in | Separate app |
| **Local player** | Built-in | Separate app |
| **Tracking** | None | Analytics, ads |
| **Privacy** | Your data stays on device | Data collected |

---

## Install

### Android
1. Download the APK from [GitHub Releases](https://github.com/Darkmintis/PrimeView/releases)
2. Enable "Install from unknown sources" if prompted
3. Open the APK and install

### iOS
1. Download the IPA from [GitHub Releases](https://github.com/Darkmintis/PrimeView/releases)
2. Sideload using AltStore, Sideloadly, or similar
3. Trust the developer certificate in Settings > General > VPN & Device Management

### Build from Source
```bash
# Clone the repo
git clone https://github.com/Darkmintis/PrimeView.git
cd PrimeView

# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Build release APK
flutter build apk --release
```

---

## Tech Stack

- **Framework**: Flutter 3.44 / Dart 3.12
- **State Management**: Riverpod
- **Video Player**: media_kit (libmpv based)
- **YouTube**: youtube_explode_dart
- **Storage**: Hive
- **Networking**: Dio

---

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting a PR.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

PrimeView is licensed under the [GNU General Public License v3.0](LICENSE).

This means you can:
- Use it freely
- Modify it
- Distribute it

But you must:
- Share any modifications under the same license
- Include the original copyright notice
- Not use the "PrimeView" name/trademark for derivative works

---

## Disclaimer

PrimeView does not host or provide any media content. All IPTV channels and YouTube content are sourced from third-party providers. Users are responsible for ensuring they have the right to access content in their region.

---

<p align="center">
  Made with ❤️ by the PrimeView community
</p>
