import 'package:flutter/material.dart';

import '../../../constant.dart';
import '../view_history.dart';
import 'request_button.dart';
import 'raise_request_form.dart';

class RaiseRequestSection extends StatelessWidget {
  const RaiseRequestSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Column(
        children: [
          Row(children: [
            AddPostViewPostButton(
              icon: Icons.people_outline,
              buttonText: "Seek Help",
              color: seekHelpColor,
              widget: const AddHelpOrGiftRequestForm(formType: "help"),
            ),
            AddPostViewPostButton(
              icon: Icons.card_giftcard,
              buttonText: "Give a Gift",
              color: giftGivenColor,
              widget: const AddHelpOrGiftRequestForm(
                formType: "gift",
              ),
            ),
            AddPostViewPostButton(
              icon: Icons.history,
              buttonText: "History",
              color: viewHistoryColor,
              widget: const ViewHistory(),
            ),
          ]),
        ],
      ),
    );
  }
}
