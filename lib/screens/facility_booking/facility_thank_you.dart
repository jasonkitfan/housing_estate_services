import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../provider/facility_booking_provider.dart';
import '../../provider/navigation_provider.dart';

class ThankYouPaymentScreen extends StatefulWidget {
  const ThankYouPaymentScreen({Key? key}) : super(key: key);

  @override
  State<ThankYouPaymentScreen> createState() => _ThankYouPaymentScreenState();
}

class _ThankYouPaymentScreenState extends State<ThankYouPaymentScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    Future.delayed(const Duration(milliseconds: 500), () {
      _animationController.forward();
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          ended = true;
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool ended = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<FacilityBookingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Payment Succeed"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: size.width / 3,
                  width: size.width / 3,
                  child: Lottie.asset("assets/lottie/payment_succeed.json",
                      controller: _animationController),
                ),
                const SizedBox(height: 30),
                AnimatedOpacity(
                  opacity: ended ? 1 : 0,
                  duration: const Duration(milliseconds: 1000),
                  child: Column(
                    children: [
                      const Text(
                        "Your booking is accepted.\nThank You!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "\$${provider.totalAmount}",
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Order Reference"),
                                SizedBox(height: 10),
                                Text("Transaction Date"),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(provider.orderReference),
                                const SizedBox(height: 10),
                                Text(provider.transactionDate)
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                          width: size.width / 2,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  side: const BorderSide(color: Colors.blue)),
                              onPressed: () => Provider.of<NavigationProvider>(
                                      context,
                                      listen: false)
                                  .changeIndex(
                                      NavigationIndex.appointment.index),
                              child: const Text("View appointment"))),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: size.width / 2,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder()),
                            onPressed: () => Provider.of<NavigationProvider>(
                                    context,
                                    listen: false)
                                .changeIndex(NavigationIndex.home.index),
                            child: const Text("Return to home page")),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
