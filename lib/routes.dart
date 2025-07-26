import 'package:flutter/material.dart';

// Core
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/screens/core/notifications_screen.dart';
import 'package:agrix_beta_2025/screens/core/sync_screen.dart';

// Auth
import 'package:agrix_beta_2025/screens/auth/login_screen.dart';
import 'package:agrix_beta_2025/screens/auth/register_user_screen.dart';

// Chat & Help
import 'package:agrix_beta_2025/screens/chat_help/chat_screen.dart';
import 'package:agrix_beta_2025/screens/chat_help/help_screen.dart';

// Diagnostics
import 'package:agrix_beta_2025/screens/diagnostics/upload_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/livestock_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/soil_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/crops_screen.dart';

// Contracts
import 'package:agrix_beta_2025/screens/contracts/contract_offer_form.dart';
import 'package:agrix_beta_2025/screens/contracts/contract_list_screen.dart';

// Investments
import 'package:agrix_beta_2025/screens/investments/investment_offer_screen.dart';
import 'package:agrix_beta_2025/screens/investments/investor_registration_screen.dart';
import 'package:agrix_beta_2025/screens/investments/investor_list_screen.dart';

// Loans
import 'package:agrix_beta_2025/screens/loans/loan_application.dart';
import 'package:agrix_beta_2025/screens/loans/loan_screen.dart';

// Logs
import 'package:agrix_beta_2025/screens/logs/logbook_screen.dart';
import 'package:agrix_beta_2025/screens/logs/training_log_screen.dart';
import 'package:agrix_beta_2025/screens/logs/sustainability_log_screen.dart';

// Market
import 'package:agrix_beta_2025/screens/market/market_screen.dart';
import 'package:agrix_beta_2025/screens/market/market_detail_screen.dart';
import 'package:agrix_beta_2025/screens/market/market_item_form.dart';
import 'package:agrix_beta_2025/screens/market/market_invite_screen.dart';

// Officers & Tasks
import 'package:agrix_beta_2025/screens/officers/officer_tasks_screen.dart';
import 'package:agrix_beta_2025/screens/officers/officer_assessments_screen.dart';
import 'package:agrix_beta_2025/screens/tasks/task_entry_screen.dart';
import 'package:agrix_beta_2025/screens/assessments/field_assessment_screen.dart';

// Dashboards
import 'package:agrix_beta_2025/screens/dashboards/official_dashboard.dart';
import 'package:agrix_beta_2025/screens/dashboards/trader_dashboard.dart';

// Official / Programs / Sustainability
import 'package:agrix_beta_2025/screens/programs/program_tracking_screen.dart';
import 'package:agrix_beta_2025/screens/sustainability/sustainability_log_screen.dart';

// Profile
import 'package:agrix_beta_2025/screens/profile/farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/edit_farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/credit_score_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // Core
  '/': (context) => const LandingPage(),
  '/notifications': (context) => const NotificationsScreen(),
  '/sync': (context) => const SyncScreen(),

  // Auth
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterUserScreen(),

  // Chat & Help
  '/chat': (context) => const ChatScreen(),
  '/help': (context) => const HelpScreen(),

  // Diagnostics
  '/diagnostic-upload': (context) => const UploadScreen(),       // AI crop scanner
  '/livestockScreen': (context) => const LivestockScreen(),      // Rule-based
  '/soilScreen': (context) => const SoilScreen(),                // Rule-based
  '/cropsScreen': (context) => const CropsScreen(),              // Optional crop menu

  // Contracts
  '/contractOffer': (context) => const ContractOfferForm(),
  '/contractList': (context) => const ContractListScreen(),

  // Investments
  '/investmentOffer': (context) => const InvestmentOfferScreen(),
  '/investorRegister': (context) => const InvestorRegistrationScreen(),
  '/investorList': (context) => const InvestorListScreen(),

  // Loans
  '/loanApplication': (context) => const LoanApplication(),
  '/loan': (context) => const LoanScreen(),

  // Logs
  '/logbook': (context) => const LogbookScreen(),
  '/trainingLog': (context) => const TrainingLogScreen(),
  '/sustainabilityLog': (context) => const SustainabilityLogScreen(),

  // Market
  '/market': (context) => const MarketScreen(),
  '/marketDetail': (context) => const MarketDetailScreen(),
  '/marketForm': (context) => const MarketItemForm(),
  '/marketInvite': (context) => const MarketInviteScreen(),

  // Officers & Assessments
  '/officerTasks': (context) => const OfficerTasksScreen(),
  '/officerAssessments': (context) => const OfficerAssessmentsScreen(),
  '/task_entry': (context) => const TaskEntryScreen(),
  '/field_assessment': (context) => const FieldAssessmentScreen(),

  // Dashboards
  '/official/dashboard': (context) => const OfficialDashboard(),
  '/trader/dashboard': (context) => const TraderDashboard(),

  // Profile
  '/profile': (context) => const FarmerProfileScreen(),
  '/editProfile': (context) => const EditFarmerProfileScreen(),
  '/creditScore': (context) => const CreditScoreScreen(),

  // Programs & Sustainability
  '/program_tracking': (context) => const ProgramTrackingScreen(),
  '/sustainability_log': (context) => const SustainabilityLogScreen(),

  // Training (redundant but mapped)
  '/training': (context) => const TrainingLogScreen(),
};
