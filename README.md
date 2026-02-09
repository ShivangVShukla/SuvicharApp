# Suvichar | Premium Java EE Wisdom Engine

**Suvichar** is a sophisticated full-stack web application built on **Java EE** and **Tomcat 11**, designed to deliver daily inspiration through a highly interactive, glassmorphism-inspired user interface.

## 🚀 Key Features

* **Daily Wisdom Hero:** An intelligent "Quote of the Day" section using time-seeded randomization.
* **Glassmorphism UI:** Translucent, high-end aesthetic with native **Dark Mode** support.
* **Image Export (📸):** Convert any quote into a high-quality shareable PNG using `html2canvas`.
* **AJAX Favorites:** Save quotes to your personal collection instantly via the **Jakarta Servlet API** without page reloads.
* **Excel Integration:** Uses an XLSX-based data layer (Apache POI) for easy content management.

## 🛠️ Tech Stack

* **Backend:** Java EE, Jakarta Servlets (Tomcat 11 compatible)
* **Frontend:** JSP, CSS3 (Glassmorphism), JavaScript (ES6+)
* **Data Layer:** Apache POI (Excel XLSX Database), DAO Pattern
* **Libraries:** `html2canvas` for image generation, Google Inter Fonts

## 📂 Project Structure

```text
├── src/main/java
│   ├── com.project.controller  # Jakarta Servlets (Auth, Fav, Delete)
│   ├── com.project.dao         # Excel Data Access Objects
│   └── com.project.model       # Java Objects (Quote, User)
├── WebContent/
│   ├── home.jsp                # Main Dashboard
│   ├── login.jsp               # Auth Portal
│   ├── my-quotes.jsp           # Favorites Gallery
│   └── assets/                 # CSS & Images
└── Database/
    └── quotes.xlsx             # Master Dataset

📝 ****Author****
Created by Shivang Shukla — 2026 Suvichar Project
