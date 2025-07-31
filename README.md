# 🌱 AgriX Beta 2025 – AI-Powered Agricultural Assistant

AgriX Beta 2025 is an **offline-first**, AI-powered mobile and web application that empowers African **farmers**, **traders**, **agricultural officers**, **investors**, and **government stakeholders**.

Built for the **Africa Deep Tech Challenge 2025**, it delivers scalable, intelligent agricultural services to underserved rural communities.

---

## 🌍 Why AgriX?

- 🛰️ Rural farmers often lack reliable internet or access to expert advice  
- 📱 Officers and governments need scalable tools for monitoring and support  
- 💰 Investors lack verified farmer data to make smart investment decisions  

**AgriX bridges this gap using:**

- ✅ Offline AI Models (Crop, Soil, Livestock)
- ✅ Role-Based Dashboards
- ✅ QR-Verified Identities
- ✅ Modular Design for Farmers, Traders, Officers, and Investors

---

## 👤 Role-Based Features

### 👩🏾‍🌾 Farmers
- 📷 Image-based diagnosis (crops, livestock)
- 🧪 Soil health & treatment advice
- 📊 Credit scoring & loan applications
- 🛒 Marketplace for trading goods
- 📚 Training & sustainability logs

### 🧑🏾‍🌾 AREX Officers
- ✅ Assign and log farmer support tasks
- 🧾 Conduct field assessments and visits
- 📈 Track training programs and impact
- 📚 Sustainability and compliance monitoring

### 💸 Investors
- 📝 Register and post investment offers
- 🤝 Create & digitally sign investment agreements
- 📃 Track investments and agreement statuses

### 🛍️ Traders
- 📦 List and manage product, crop, or livestock offers
- 🔄 Barter, buy, or sell directly with farmers
- 🗨️ Communicate via built-in chat

### 🏛️ Government Officials
- 💵 Monitor and track subsidies
- 📊 Analyze regional reports
- 🔔 Deliver policy updates and alerts

---

## 🤖 AI & Technology Highlights

- 🧠 TensorFlow Lite (TFLite) for offline AI diagnosis models
- 📷 ImagePicker for crop/livestock/soil uploads
- 🔐 Biometric authentication and secure session handling
- 📱 Flutter-based web + mobile deployment
- 💾 SharedPreferences + Local JSON + optional Firebase support

---

## 📁 Project Folder Structure

```
lib/
├── models/              # Data models (users, profiles, contracts, etc.)
├── screens/             # UI screens grouped by module (auth, core, market, AI, etc.)
├── services/            # Logic for data handling, auth, storage
├── assets/
│   ├── images/          # Crops, livestock, soil samples
│   ├── tflite/          # Offline ML models
│   └── data/            # JSON rules and mappings
├── main.dart            # App entry point
└── routes.dart          # Navigation config
```

---

## 🧪 Screenshots

> Include images or point to `/assets/screenshots/` if applicable.

---

## 🧑‍💻 Contributors

- **Simba Mwaingeni** – Architecture, AI Models, Credit Scoring, Full-Stack  
- **AgriX Beta 2025 Team** – Africa Deep Tech Challenge participants

---

## 📄 License

**MIT License**  
© 2025 AgriX Africa Team

---

## 📬 Contact

- 📧 Email: simba.mwaingeni@protonmail.com  
- 🔗 [GitHub](https://github.com/YOUR_USERNAME)  
- 🔗 [LinkedIn](https://linkedin.com/in/YOUR_PROFILE)  

---

## 🔧 Setup & Run Locally

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/agrix_beta_2025.git
cd agrix_beta_2025
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the application

```bash
# For Web
flutter run -d chrome

# For Android
flutter run -d android
```

---

> ✅ Place this `README.md` file at the **root** of your project folder:  
> `agrix_beta_2025/README.md`
