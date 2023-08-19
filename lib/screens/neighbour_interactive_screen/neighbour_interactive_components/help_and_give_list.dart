import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_banners/super_banners.dart';

import '../post_detail_view.dart';
import '../../../constant.dart';
import '../../../provider/neighbour_interactive_provider.dart';

class HelpAndGiftList extends StatelessWidget {
  const HelpAndGiftList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoading =
        Provider.of<NeighbourInteractiveProvider>(context).isLoadingMore;
    bool noMoreData =
        Provider.of<NeighbourInteractiveProvider>(context).noDataMore;
    List allRequest =
        Provider.of<NeighbourInteractiveProvider>(context).allRequest;

    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: isLoading ? allRequest.length + 1 : allRequest.length,
        itemBuilder: (context, index) {
          if (index < allRequest.length) {
            return Card(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PostDetailView(
                            title: allRequest[index]["title"],
                            content: allRequest[index]["content"],
                            posterEmail: allRequest[index]["user_email"],
                            timestamp: allRequest[index]["created_at"],
                            imageUrlList: allRequest[index]["optional_image"],
                            postId: allRequest[index]["id"],
                            interestedPeopleList: allRequest[index]
                                ["interested_people"],
                            assignedPerson: allRequest[index]
                                ["assigned_neighbour"],
                          )));
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
                              child: allRequest[index]["optional_image"].isEmpty
                                  ? Image.asset("assets/images/no_image.png")
                                  : Image.network(
                                      "${allRequest[index]["optional_image"][0]}",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            PositionedCornerBanner(
                                bannerPosition: CornerBannerPosition.topLeft,
                                bannerColor:
                                    getBannerColor(allRequest[index]["type"]),
                                child: Text(
                                  "${allRequest[index]["type"]}",
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
                                  allRequest[index]["title"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  allRequest[index]["content"],
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
            );
          } else {
            return !noMoreData
                ? const Center(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: CircularProgressIndicator()))
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Center(child: Text("No more data")));
          }
        });
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
