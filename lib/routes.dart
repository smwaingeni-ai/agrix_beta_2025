import 'package:flutter/material.dart';

// 🧭 Core Screens
import 'package:agrix_beta_2025/screens/core/auth_gate.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/screens/core/sync_screen.dart';
import 'package:agrix_beta_2025/screens/core/notifications_screen.dart';

// 🔐 Auth
import 'package:agrix_beta_2025/screens/auth/login_screen.dart';
import 'package:agrix_beta_2025/screens/auth/register_user_screen.dart';

// 🧑‍🌾 Profile
import 'package:agrix_beta_2025/screens/profile/farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/edit_farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/credit_score_screen.dart';

// 💰 Loans
import 'package:agrix_beta_2025/screens/loans/loan_screen.dart';
import 'package:agrix_beta_2025/screens/loans/loan_application.dart';

// 📒 Logs
import 'package:agrix_beta_2025/screens/logs/logbook_screen.dart';
import 'package:agrix_beta_2025/screens/logs/sustainability_log_screen.dart';
import 'package:agrix_beta_2025/screens/logs/training_log_screen.dart';

// 📊 Diagnostics
import 'package:agrix_beta_2025/screens/diagnostics/upload_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/crops_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/livestock_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/soil_screen.dart';

// 🛒 Market
import 'package:agrix_beta_2025/screens/market/market_screen.dart';
import 'package:agrix_beta_2025/screens/market/market_item_form.dart';
import 'package:agrix_beta_2025/screens/market/market_detail_screen.dart';

// 📈 Investments
import 'package:agrix_beta_2025/screens/investments/investor_list_screen.dart';
import 'package:agrix_beta_2025/screens/investments/investor_registration_screen.dart';
import 'package:agrix_beta_2025/screens/investments/investment_offer_screen.dart';
import 'package:agrix_beta_2025/screens/investments/investment_offers_screen.dart';

// 🤝 Contracts
import 'package:agrix_beta_2025/screens/contracts/contract_list_screen.dart';
import 'package:agrix_beta_2025/screens/contracts/contract_offer_form.dart';
import 'package:agrix_beta_2025/screens/contracts/contract_detail_screen.dart';
import 'package:agrix_beta_2025/models/contracts/contract_offer.dart';

// 🧑‍🏫 Officers
import 'package:agrix_beta_2025/screens/officers/officer_tasks_screen.dart';
import 'package:agrix_beta_2025/screens/officers/task_entry_screen.dart';
import 'package:agrix_beta_2025/screens/officers/field_assessment_screen.dart';
import 'package:agrix_beta_2025/screens/officers/officer_assessments_screen.dart';
import 'package:agrix_beta_2025/screens/officers/arex_officer_dashboard.dart';

// 🏛️ Officials
import 'package:agrix_beta_2025/screens/official/official_dashboard.dart';

// 📋 Programs
import 'package:agrix_beta_2025/screens/programs/program_tracking_screen.dart';
import 'package:agrix_beta_2025/screens/programs/program_form_screen.dart';
import 'package:agrix_beta_2025/screens/programs/program_detail_screen.dart';

// 🌿 Sustainability
import 'package:agrix_beta_2025/screens/sustainability/sustainability_log_screen.dart';

// 🛍️ Traders
import 'package:agrix_beta_2025/screens/trader/trader_dashboard.dart';

// 💬 Help & Chat
import 'package:agrix_beta_2025/screens/chat_help/chat_screen.dart';
import 'package:agrix_beta_2025/screens/chat_help/help_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // ✅ Core & Auth
  '/': (context) => const LandingPage(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterUserScreen(),
  '/authGate': (context) => const AuthGate(),
  '/notifications': (context) => const NotificationsScreen(),
  '/sync': (context) => const SyncScreen(),

  // ✅ Profile
  '/farmerProfile': (context) => const FarmerProfileScreen(),
  '/editFarmerProfile': (context) => const EditFarmerProfileScreen(),
  '/creditScore': (context) => const CreditScoreScreen(),

  // ✅ Loans
  '/loan': (context) => const LoanScreen(),
  '/loanApplication': (context) => const LoanApplicationScreen(),

  // ✅ Logs
  '/logbook': (context) => const LogbookScreen(),
  '/sustainabilityLog': (context) => const SustainabilityLogScreen(),
  '/trainingLog': (context) => const TrainingLogScreen(),

  // ✅ Diagnostics
  '/upload': (context) => const UploadScreen(),
  '/crops': (context) => const CropsScreen(),
  '/livestock': (context) => const LivestockScreen(),
  '/soil': (context) => const SoilScreen(),

  // ✅ Market
  '/market': (context) => const MarketScreen(),
  '/market/add': (context) => MarketItemForm(onSubmit: (_) {}),
  '/market/detail': (context) => const MarketDetailScreen(),

  // ✅ Investments
  '/investors': (context) => const InvestorListScreen(),
  '/investors/register': (context) => const InvestorRegistrationScreen(),
  '/investment/offer': (context) => const InvestmentOfferScreen(),
  '/investment/offers': (context) => const InvestmentOffersScreen(),

  // ✅ Contracts
  '/contracts/list': (context) => const ContractListScreen(),
  '/contracts/new': (context) => const ContractOfferForm(),
  '/contracts/detail': (context) {
    final offer = ModalRoute.of(context)!.settings.arguments as ContractOffer;
    return ContractDetailScreen(contract: offer);
  },

  // ✅ Officers & AREX
  '/officer/tasks': (context) => const OfficerTasksScreen(),
  '/task_entry': (context) => const TaskEntryScreen(),
  '/field_assessment': (context) => const FieldAssessmentScreen(),
  '/officer/assessments': (context) => const OfficerAssessmentsScreen(),
  '/officer/dashboard': (context) => const ArexOfficerDashboard(),

  // ✅ Government Officials
  '/official/dashboard': (context) => const OfficialDashboard(),

  // ✅ Programs
  '/program_tracking': (context) => const ProgramTrackingScreen(),
  '/program_form': (context) => const ProgramFormScreen(),

  // ✅ Trader
  '/trader/dashboard': (context) => const TraderDashboard(),

  // ✅ Help & Chat
  '/chat': (context) => const ChatScreen(),
  '/help': (context) => const HelpScreen(),
};
