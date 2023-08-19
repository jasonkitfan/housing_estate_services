import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_banners/super_banners.dart';

import 'post_detail_view.dart';
import '../../constant.dart';
import '../../provider/neighbour_interactive_provider.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({Key? key}) : super(key: key);

  @override
  State<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<NeighbourInteractiveProvider>(context, listen: false)
            .getHistoryData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List history = Provider.of<NeighbourInteractiveProvider>(context).history;

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: history.length,
          itemBuilder: (context, index) => Card(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PostDetailView(
                            title: history[index]["title"],
                            content: history[index]["content"],
                            posterEmail: history[index]["user_email"],
                            timestamp: history[index]["created_at"],
                            imageUrlList: history[index]["optional_image"],
                            postId: history[index]["id"],
                            interestedPeopleList: history[index]
                                ["interested_people"])));
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: history[index]["optional_image"].isEmpty
                                    ? Image.asset("assets/images/no_image.png")
                                    : Image.network(
                                        "${history[index]["optional_image"][0]}",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              PositionedCornerBanner(
                                  bannerPosition: CornerBannerPosition.topLeft,
                                  bannerColor:
                                      getBannerColor(history[index]["type"]),
                                  child: Text(
                                    "${history[index]["type"]}",
                                    style: const TextStyle(fontSize: 10),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    history[index]["title"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    history[index]["content"],
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              )),
    );
  }

  Color getBannerColor(String type) {
    switch (type) {
      case "help":
        return seekHelpColor;
      case "gift":
        return giftGivenColor;
      default:
        return Colors.grey;
    }
  }
}
