# 📰 SquickNews

A modern iOS News Reader app built with **SwiftUI**, **MVVM + Clean Architecture**, and **async/await networking**.  
It fetches headlines from [NewsAPI.org](https://newsapi.org) and demonstrates robust architecture, persistence with **SwiftData**, and modular UI using [LibraryUI](https://github.com/MrcoAlba/LibraryUI).

---

## ✨ Features
- Clean MVVM with **Clean Architecture** separation (Data / Domain / Presentation layers).
- Fetches headlines from [NewsAPI](https://newsapi.org).
- Pull-to-refresh and infinite scroll.
- Article detail screen with:
  - Full-size image
  - Snippet & metadata
  - Safari integration to read full article
  - Share article
  - Save / like articles to **SwiftData**
- Dark Mode and Dynamic Type support.
- Modular UI components via [LibraryUI](https://github.com/MrcoAlba/LibraryUI).
- Basic error handling (network issues, API limits, etc.).

---

## 📂 Project Structure

SquickNews/
├── App/
│   ├── CompositionRoot/     # Factories and dependency injection
│   └── SquickNewsApp.swift
├── Features/
│   ├── Headlines/           # Headlines list (Home)
│   ├── ArticleDetail/       # Detail screen + SwiftData integration
│   ├── Favourites/          # (WIP) Liked articles
│   └── Onboarding/          # Onboarding flow
├── Infraestructure/
│   ├── Networking           # URLSessionHTTPClient, ErrorResolver, etc.
│   └── SwiftData            # Persistence for liked articles
└── Shared/                  # Extensions, helpers

---

## 🛠 Requirements
- iOS 18.0+
- Xcode *16.4*+
- Swift 6

---

## 🔑 API Key Setup

This project requires a [NewsAPI](https://newsapi.org) key.

We don’t commit API keys to the repository. Instead, we use **xcconfig** files for local configuration.

1. Create a folder `Config/` in the root of the project.
2. Inside, create a file named `Debug.xcconfig` (ignored in `.gitignore`).
3. Add your key:
   ```xcconfig
   NEWS_API_KEY = your_api_key_here

	4.	In Xcode, go to:

Project > SquickNews > Build Settings > Debug > Use Debug.xcconfig


	5.	The app reads the key like this:

let apiKey = Bundle.main.object(forInfoDictionaryKey: "NewsAPIKey") as? String ?? ""



👉 Check Config/Example.xcconfig for reference.

⸻

📦 Dependencies

LibraryUI

A local Swift Package with reusable UI components.
Integrated via Swift Package Manager:

dependencies: [
    .package(url: "https://github.com/MrcoAlba/LibraryUI", branch: "main")
]


⸻

🚀 Running the Project
	1.	Clone the repo:

git clone https://github.com/MrcoAlba/SquickNews.git


	2.	Install dependencies via Swift Package Manager (Xcode will auto-resolve).
	3.	Add your Debug.xcconfig with your NewsAPI key.
	4.	Build & Run ✅

⸻

📱 Screenshots

(add screenshots here once available)

⸻

🧪 Testing
	•	The architecture is built with dependency injection to allow easy mocking.
	•	Unit tests (optional, WIP) can be added for:
	•	Networking layer
	•	Use cases
	•	ViewModels

⸻

🔐 Security
	•	API keys are not hardcoded.
	•	All requests use HTTPS.
	•	API keys are excluded from version control (.gitignore).

⸻

📖 License

MIT License.
Feel free to use and adapt.

⸻

👤 Author

Developed by Marco Antonio Landauro Alba
