import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'provider/neighbour_interactive_provider.dart';
import 'provider/defect_report_provider.dart';
import 'provider/navigation_provider.dart';
import 'provider/facility_booking_provider.dart';
import 'screens/neighbour_interactive_screen/neighbour_interactive_main_screen.dart';
import 'screens/message_screen.dart';
import 'screens/appointment_screen.dart';
import 'screens/defect_report_screen/defect_main_screen.dart';
import 'screens/facility_booking/facility_booking_screen.dart';
import 'screens/facility_booking/facility_modification.dart';
import 'screens/facility_booking/facility_thank_you.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'custom_widget/my_bottom_nav_bar.dart';
import 'custom_widget/my_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Stripe.publishableKey =
      "pk_test_51Ls0j1Ax84mW2vsjFgKR5lFhdQ1o1w8Rl9EWomWJsMLWXJidLNzrzFsk02LLYLPBDdIy2kOSInd4UCUi5N7NOesS00lgVS1F9O";
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NavigationProvider()),
    ChangeNotifierProvider(create: (_) => FacilityBookingProvider()),
    ChangeNotifierProvider(create: (_) => DefectReportProvider()),
    ChangeNotifierProvider(create: (_) => NeighbourInteractiveProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      debugShowCheckedModeBanner: false,
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? "login" : "home",
      routes: {
        "login": (context) => const LoginScreen(),
        "register": (context) => const RegisterScreen(),
        "home": (context) => const WelcomeScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const MessageScreen(),
    const AppointmentScreen(),
    const SizedBox(height: 800, child: Center(child: Text("Setting"))),
    const SizedBox(height: 800, child: Center(child: Text("Smart Home"))),
    const SizedBox(height: 800, child: Center(child: Text("Mailbox"))),
    const FacilityBookingScreen(),
    const FacilityModification(),
    const ThankYouPaymentScreen(),
    const SizedBox(height: 800, child: Center(child: Text("Locker"))),
    const SizedBox(height: 800, child: Center(child: Text("Access Control"))),
    const SizedBox(height: 800, child: Center(child: Text("Bills"))),
    const SizedBox(height: 800, child: Center(child: Text("Events"))),
    const SizedBox(height: 800, child: Center(child: Text("Cabinet"))),
    const SizedBox(height: 800, child: Center(child: Text("More Notices"))),
    const SizedBox(height: 800, child: Center(child: Text("Lost and Found"))),
    const NeighbourInteractiveMainScreen(),
    const DefectMainScreen(),
    const SizedBox(height: 800, child: Center(child: Text("Inquiry"))),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Expanded(flex: 10, child: _widgetOptions[provider.currentIndex]),
          const Expanded(
            child: CustomBottomNavBar(),
          )
        ],
      ),
    );
  }
}
