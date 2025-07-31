
# 📘 AgriX Beta 2025 – Full Project Documentation

## 🌍 Overview

AgriX Beta 2025 is a comprehensive, AI-powered, offline-first agricultural assistant platform built for the **Africa Deep Tech Challenge 2025**. Designed to empower **farmers**, **traders**, **AREX officers**, **investors**, and **government officials**, AgriX addresses critical gaps in African agriculture using intelligent technology and modular design.

> 🌱 Africa's economy is agro-based. Yet, smallholder farmers lack access to quality advice, financing, and markets. AgriX bridges these gaps.

---

## 🎯 Problem Statement

Despite agriculture being the economic backbone of many African nations, most smallholder farmers face:

- ❌ Limited access to real-time expert diagnosis for crop/livestock issues
- ❌ Lack of financing due to poor documentation and low trust from investors
- ❌ Inability to market produce directly
- ❌ No tools for field officers to monitor training, programs, and impact
- ❌ Poor accountability in subsidy tracking and agricultural investment
- ❌ Lack of macro-level data for policy or economic analysis

**AgriX Beta 2025** aims to provide a scalable, offline-capable, intelligent solution that integrates stakeholders into a digital ecosystem.

---

## 🧩 Modular Architecture & Feature Breakdown

### 1. `screens/admin/`
- Future provisioning for platform administration
- Controls user access, monitors modules
- 🔒 Reserved for system superusers

---

### 2. `screens/auth/`
- Role-based login with **passcode** or **biometric login**
- Session management via secure local storage
- Demo uses `UserModel` with roles:
  - Farmer
  - AREX Officer
  - Trader
  - Investor
  - Official (Government)
  - Admin

---

### 3. `screens/chat_help/`
- Real-time **Chat** for farmers to contact traders or officers
- Help screen (FAQs, guides) integrated for offline use

---

### 4. `screens/contracts/`
- Farmers and investors sign **digital investment contracts**
- Contracts include title, amount, terms, parties, and status
- Legal digital footprint enabled via persistent IDs

---

### 5. `screens/core/`
- `landing_page.dart`: Modular role-based dashboard
- Routes user to all other modules
- Profile loading and QR-based navigation

---

### 6. `screens/diagnostics/`
- `crops/`, `livestock/`, `soil/` modules
- Farmers upload images or answer questions for AI diagnosis
- ✅ Uses TensorFlow Lite (TFLite) models (crop model frozen for demo due to time)
- 📍 Provides disease names, treatment, severity, and cost estimation

---

### 7. `screens/investments/`
- Investors post offers with terms and return expectations
- Farmers can access approved investments
- 💼 `InvestmentAgreement` and `InvestmentOffer` are core models

---

### 8. `screens/loan/`
- Credit scoring logic based on farm profile, training, sustainability
- Loan application screen integrated with bank/MFI options
- Loan status tracking for farmers

---

### 9. `screens/logs/`
- Core logbook to track all farmer activities
- Timestamped entries for:
  - Crop spraying
  - Soil treatment
  - Livestock medication
  - Weather conditions

---

### 10. `screens/market/`
- Farmers and traders can:
  - Post products
  - Request barter/trade
  - Track supply & demand
- Contact enabled via phone, WhatsApp, and SMS

---

### 11. `screens/notifications/`
- Government and AREX officers push field alerts
- Farmers get subsidy updates, disease warnings
- Alerts stored offline and rendered on dashboard

---

### 12. `screens/officers/`
- AREX officers assigned to monitor:
  - Specific farmers
  - Tasks (visits, inspections)
  - Provide advice or escalate issues
- Track KPIs, generate field logs

---

### 13. `screens/official/`
- Regional dashboards
- Subsidy disbursement tracking
- Aggregated data for yield reports
- MACRO agricultural metrics to feed into:
  - GDP forecasts
  - Climate risk models
  - Sustainability goals

---

### 14. `screens/profile/`
- Farmer registration with:
  - Full name
  - Photo
  - QR Code ID
  - Farm size
  - Region
  - Subsidy flag

---

### 15. `screens/programs/`
- Officers can:
  - Launch new agricultural programs
  - Track impact (success, resource distribution)
  - Tag beneficiaries

---

### 16. `screens/sustainability/`
- Log sustainable practices (e.g., crop rotation, zero tillage)
- Flags farms for ESG (Environmental, Social, Governance) scoring
- Supports national and international sustainability commitments

---

### 17. `screens/trader/`
- Traders browse farmer listings
- Can engage in digital bartering or cash transactions
- Interface similar to online marketplaces

---

### 18. `screens/training/`
- Track training sessions attended by farmers
- Upload documentation, rating, and impact scores
- Officers update logs post-training
- Helps in credit scoring and subsidy eligibility

---

## 🧠 Technologies Used

| Stack       | Details                                 |
|------------|------------------------------------------|
| Framework  | Flutter (Web + Mobile)                  |
| Storage    | SharedPreferences + Local Files         |
| AI         | TensorFlow Lite (TFLite)                |
| Security   | Biometric + Secure Storage              |
| Connectivity | Optional Firebase                     |
| Media      | ImagePicker, File, SharePlus            |
| Code Style | Modular Architecture, `models/`, `services/`, `screens/` folders |

---

## ⚙️ Setup & Run Locally

```bash
git clone https://github.com/simba-mwaingeni/agrix_beta_2025.git
cd agrix_beta_2025
flutter pub get
flutter run -d chrome   # For web
flutter run -d android  # For mobile
```

Make sure:
- Dart SDK ≥ 3.2
- Flutter ≥ 3.16
- If testing AI modules, load `.tflite` models into `assets/tflite/` and `.csv` rules into `assets/data/`

---

## 🧪 Screenshots & Sample Data

- `/assets/screenshots/` – UI captures
- `/assets/data/advice.json`, `symptoms.csv` – Diagnosis sample data
- `/assets/tflite/` – TFLite models (currently frozen for crop AI)

---

## 🚧 Challenges Faced

- ⏳ Working solo over 10+ days, balancing logic + UI + storage + testing
- 🧠 Integrating AI models (some components like crop AI are frozen due to runtime & time constraints)
- ⚖️ Designing for offline-first but extensible cloud integration
- 👤 Managing session logic for 6+ user types
- 🔄 Debugging shared logic across 20+ screens

---

## 🚀 Future Roadmap

- 🌐 Cloud sync of all modules (Firebase or REST API)
- 🧪 Re-enable full AI models for crop/livestock/soil
- 🛰️ Geo-tagging and satellite integration
- 🔒 Admin panel & approval workflows
- 📈 Macro-agric analytics to support ministries
- 🌦️ Climate risk scoring engine
- 💱 Token economy for farmers (credit, rewards)

---

## 💰 Monetization Potential

- 📊 Sell dashboards to Ministries for **impact evaluation**
- 🤝 Partner with MFIs/Banks to score farmers for **credit**
- 💼 Investors subscribe to real-time data dashboards
- 📦 Enable B2B input deals (fertilizer, seed)
- 🌍 NGOs use it for **monitoring & evaluation**
- 🎓 Trainings as paid micro-courses via mobile

---

## 🏁 Submission

- Submitted to: **Africa Deep Tech Challenge 2025**
- Track: **AgriTech & Public Impact**
- Format: Modular, scalable, AI-enhanced, offline-first

---

## 📄 License

MIT License © 2025 AgriX Africa Team

---

## 📬 Contact

**Simba Mwaingeni**  
📧 simba.mwaingeni@protonmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/simba-mwaingeni)  
🔗 [GitHub](https://github.com/simba-mwaingeni)

---

*Thank you for reviewing AgriX Beta 2025 – transforming agriculture with AI, data, and African resilience.* 🌾
