import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/neighbour_interactive_provider.dart';
import 'neighbour_interactive_components/help_and_give_list.dart';
import 'neighbour_interactive_components/raise_request_section.dart';

class NeighbourInteractiveMainScreen extends StatefulWidget {
  const NeighbourInteractiveMainScreen({Key? key}) : super(key: key);

  @override
  State<NeighbourInteractiveMainScreen> createState() =>
      _NeighbourInteractiveMainScreenState();
}

class _NeighbourInteractiveMainScreenState
    extends State<NeighbourInteractiveMainScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<NeighbourInteractiveProvider>(context, listen: false)
            .initData());
    _scrollController.addListener(_scrolling);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrolling() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // print("scrolling at the end, show load more data");
      Provider.of<NeighbourInteractiveProvider>(context, listen: false)
          .loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Neighborhood Interaction"),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Raise a Request",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            RaiseRequestSection(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Help and Gifts",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            HelpAndGiftList()
          ],
        ),
      ),
    );
  }
}
