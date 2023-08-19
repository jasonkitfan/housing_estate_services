import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/navigation_provider.dart';
import '../../model/home_screen_services_model.dart';

class ServiceItems extends StatelessWidget {
  const ServiceItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<NavigationProvider>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 210,
            child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 4,
                    childAspectRatio: 1 / 1.2),
                itemCount: servicesList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          provider.changeIndex(servicesList[index]["index"]);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          width: size.width * 0.15,
                          decoration: BoxDecoration(
                              color: servicesList[index]["color"]
                                  .withOpacity(0.85),
                              borderRadius: BorderRadius.circular(15)),
                          child: Image.asset(
                            servicesList[index]["image"],
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 100,
                        child: Center(
                          child: Text(
                            servicesList[index]["text"],
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
