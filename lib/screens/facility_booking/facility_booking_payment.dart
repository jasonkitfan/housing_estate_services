import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/facility_booking_provider.dart';

class BookingPaymentScreen extends StatefulWidget {
  const BookingPaymentScreen({Key? key, required this.function})
      : super(key: key);

  final VoidCallback function;

  @override
  State<BookingPaymentScreen> createState() => _BookingPaymentScreenState();
}

class _BookingPaymentScreenState extends State<BookingPaymentScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<FacilityBookingProvider>(context, listen: false)
          .getDataFromCart();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FacilityBookingProvider>(context);
    return Container(
        padding: const EdgeInsets.all(10),
        child: provider.cartList.isEmpty
            ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 3),
                  const Text("Your booking list is empty!"),
                ],
              )
            : Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: ListView.separated(
                        itemBuilder: (context, index) => buildCartCard(
                              provider,
                              provider.cartList[index].name,
                              provider.cartList[index].selectedVenue,
                              provider.cartList[index].date,
                              provider.cartList[index].timeSection,
                              provider.cartList[index].imagePath,
                              provider.cartList[index].venues,
                              provider.cartList[index].price,
                            ),
                        separatorBuilder: (context, _) =>
                            const SizedBox(height: 10),
                        itemCount: provider.cartList.length),
                  ),
                  const Expanded(child: BottomPaymentField())
                ],
              ));
  }

  Widget buildCartCard(
      FacilityBookingProvider provider,
      String facility,
      String selectedVenues,
      String date,
      List timeSection,
      String imagePath,
      String totalVenues,
      String price) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 7,
            offset: Offset(0, 5),
            color: Colors.grey,
          )
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.8),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  provider.insertFacility(
                      facility, totalVenues, imagePath, price);
                  provider.currentVenuesNo = selectedVenues;
                  provider.insertDate(DateTime.parse(date));
                  widget.function();
                  // DefaultTabController.of(context)?.animateTo(1);
                },
                child: Image.network(
                  imagePath,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const VerticalDivider(
              color: Colors.red,
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(facility),
                    Text("date: $date"),
                    Text("venue: $selectedVenues"),
                    Text("section: ${timeSection.join(", ")}"),
                  ],
                ),
              ),
            ),
            const VerticalDivider(
              color: Colors.red,
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Text(
                  "\$${int.parse(price) * timeSection.length}",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BottomPaymentField extends StatefulWidget {
  const BottomPaymentField({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomPaymentField> createState() => _BottomPaymentFieldState();
}

class _BottomPaymentFieldState extends State<BottomPaymentField> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FacilityBookingProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 5),
              color: Colors.orange,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Total: \$${provider.getTotalCharges()}",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.indigoAccent),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  await provider.initPaymentSheet(context);
                  setState(() {
                    loading = false;
                  });
                },
                child: !loading
                    ? const Text("Purchase")
                    : const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1,
                        ))),
          )
        ],
      ),
    );
  }
}
