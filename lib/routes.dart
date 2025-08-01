import 'package:flutter/material.dart';

// 🧭 Core Screens
import 'package:agrix_beta_2025/screens/core/auth_gate.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/screens/core/sync_screen.dart';
import 'package:agrix_beta_2025/screens/notifications/notifications_screen.dart';

// 🔐 Auth
import 'package:agrix_beta_2025/screens/auth/login_screen.dart';
import 'package:agrix_beta_2025/screens/auth/register_user_screen.dart';

// 🧑‍🌾 Profile
import 'package:agrix_beta_2025/screens/profile/farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/edit_farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/credit_score_screen.dart';

// 💰 Loans
import 'package:agrix_beta_2025/screens/loan/loan_screen.dart';
import 'package:agrix_beta_2025/screens/loan/loan_application_screen.dart';
import 'package:agrix_beta_2025/screens/loan/loan_list_screen.dart';

// 📒 Logs
import 'package:agrix_beta_2025/screens/logs/logbook_screen.dart';

// 📊 Diagnostics
import 'package:agrix_beta_2025/screens/diagnostics/upload_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/crops_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/livestock_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/soil_screen.dart';

// 🛒 Market
import 'package:agrix_beta_2025/screens/market/market_screen.dart';
import 'package:agrix_beta_2025/screens/market/market_item_form.dart';
import 'package:agrix_beta_2025/screens/market/market_detail_screen.dart';
import 'package:agrix_beta_2025/screens/market/market_invite_screen.dart';
import 'package:agrix_beta_2025/models/market/market_item.dart';

// 📈 Investments
import 'package:agrix_beta_2025/screens/investments/investor_list_screen.dart';
import 'package:agrix_beta_2025/screens/investments/investor_registration_screen.dart';
import 'package:agrix_beta_2025/screens/investments/investment_offer_screen.dart';
import 'package:agrix_beta_2025/screens/investments/investment_offers_screen.dart';
import 'package:agrix_beta_2025/screens/investments/investor_dashboard_screen.dart';

// 🤝 Contracts
import 'package:agrix_beta_2025/screens/contracts/contract_list_screen.dart';
import 'package:agrix_beta_2025/screens/contracts/contract_offer_form.dart';
import 'package:agrix_beta_2025/screens/contracts/contract_detail_screen.dart';
import 'package:agrix_beta_2025/models/contracts/contract_offer.dart';

// 🧑‍🏫 Officers
import 'package:agrix_beta_2025/screens/officers/task_entry_screen.dart';
import 'package:agrix_beta_2025/screens/officers/field_assessment_screen.dart';

// 📋 Programs
import 'package:agrix_beta_2025/screens/programs/program_tracking_screen.dart';
import 'package:agrix_beta_2025/screens/programs/program_form_screen.dart';
import 'package:agrix_beta_2025/screens/programs/program_detail_screen.dart';
import 'package:agrix_beta_2025/models/programs/program.dart';

// 🌿 Sustainability
import 'package:agrix_beta_2025/screens/sustainability/sustainability_log_screen.dart';

// 🧠 Training
import 'package:agrix_beta_2025/screens/training/training_log_screen.dart';

// 🛠 Admin
import 'package:agrix_beta_2025/screens/admin/admin_panel.dart';

// 💬 Help & Chat
import 'package:agrix_beta_2025/screens/chat_help/chat_screen.dart';
import 'package:agrix_beta_2025/screens/chat_help/help_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // 🚪 Entry & Auth
  '/': (context) => const LandingPage(), // ✅ All roles start here
  '/authGate': (context) => const AuthGate(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterUserScreen(),

  // 🔁 Sync & Notifications
  '/sync': (context) => const SyncScreen(),
  '/notifications': (context) => const NotificationsScreen(),

  // 👤 Profile
  '/farmerProfile': (context) => const FarmerProfileScreen(),
  '/editFarmerProfile': (context) => const EditFarmerProfileScreen(userId: 'default', name: 'default'),
  '/creditScore': (context) => const CreditScoreScreen(),

  // 💸 Loans
  '/loan': (context) => const LoanScreen(),
  '/loanApplication': (context) => const LoanApplicationScreen(),
  '/loanList': (context) => const LoanListScreen(),

  // 📘 Logs
  '/logbook': (context) => const LogbookScreen(),

  // 🌾 Diagnostics
  '/upload': (context) => const UploadScreen(),
  '/crops': (context) => const CropsScreen(),
  '/livestock': (context) => const LivestockScreen(),
  '/soil': (context) => const SoilScreen(),

  // 🛒 Market
  '/market': (context) => const MarketScreen(),
  '/market/add': (context) => MarketItemForm(onSubmit: (_) {}),
  '/market/detail': (context) {
    final item = ModalRoute.of(context)!.settings.arguments as MarketItem;
    return MarketDetailScreen(marketItem: item);
  },
  '/market/invite': (context) => const MarketInviteScreen(),
  '/market/trade': (context) => const MarketScreen(),

  // 📈 Investments
  '/investors': (context) => const InvestorListScreen(),
  '/investors/register': (context) => const InvestorRegistrationScreen(),
  '/investmentOffer': (context) => const InvestmentOfferScreen(),
  '/investmentOffers': (context) => const InvestmentOffersScreen(),
  '/investmentAgreements': (context) => const InvestorDashboardScreen(investorId: 'dummy'),

  // 🤝 Contracts
  '/contracts/list': (context) => const ContractListScreen(),
  '/contracts/new': (context) => const ContractOfferForm(),
  '/contracts/detail': (context) {
    final offer = ModalRoute.of(context)!.settings.arguments as ContractOffer;
    return ContractDetailScreen(contract: offer);
  },

  // 🧑‍🏫 AREX Officer
  '/officer/tasks': (context) => const TaskEntryScreen(),
  '/officer/assessments': (context) => const FieldAssessmentScreen(),

  // 📋 Programs
  '/programs': (context) => const ProgramTrackingScreen(),
  '/program_form': (context) => const ProgramFormScreen(),
  '/program_detail': (context) {
    final program = ModalRoute.of(context)!.settings.arguments as ProgramLog;
    return ProgramDetailScreen(program: program);
  },

  // 🌿 Sustainability
  '/sustainabilityLog': (context) => const SustainabilityLogScreen(),

  // 🧠 Training
  '/trainingLog': (context) => const TrainingLogScreen(),

  // 🛠 Admin
  '/adminPanel': (context) => const AdminPanel(),

  // 💬 Chat & Help
  '/chat': (context) => const ChatScreen(),
  '/help': (context) => const HelpScreen(),
};
