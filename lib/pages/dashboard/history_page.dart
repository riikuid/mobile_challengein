import 'package:flutter/material.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/provider/history_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/main_history_tile.dart';
import 'package:mobile_challengein/widget/main_history_tile_skeleton.dart';
import 'package:mobile_challengein/widget/search_filter_widget.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late HistoryProvider historyProvider =
      Provider.of<HistoryProvider>(context, listen: false);
  final ScrollController _scrollController = ScrollController();
  late Future<void> futureGetHistories;
  String errorGetHistory = "No History Found";

  bool _isLoading = false;

  Future<void> getRecentHistory() async {
    setState(() {
      _isLoading = true;
    });
    await historyProvider.refreshGetHistory();
    setState(() {
      _isLoading = false;
    });
  }

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && context.read<HistoryProvider>().hasMore) {
      context.read<HistoryProvider>().getHistory(
            token: authProvider.user.refreshToken,
            errorCallback: (p0) {
              setState(() {
                errorGetHistory = p0;
              });
            },
          );
    }
  }

  @override
  void initState() {
    _scrollController.addListener(onScroll);
    futureGetHistories = getRecentHistory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget listHistory() {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: getRecentHistory,
          child: FutureBuilder(
            future: futureGetHistories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  children: [
                    MainHistoryTileSkeleton(),
                    MainHistoryTileSkeleton(),
                  ],
                );
              } else {
                return Consumer<HistoryProvider>(
                  builder: (context, state, _) {
                    if (state.histories.isEmpty) {
                      return Center(
                        child: Text(
                          errorGetHistory,
                          style: primaryTextStyle.copyWith(
                            color: subtitleTextColor,
                          ),
                        ),
                      );
                    }
                    // else if (state.serviceLoading) {
                    //   return const Column(
                    //     children: [
                    //       MainHistoryTileSkeleton(),
                    //       MainHistoryTileSkeleton(),
                    //     ],
                    //   );
                    // }
                    else {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: state.hasMore
                            ? state.histories.length + 1
                            : state.histories.length,
                        itemBuilder: (context, index) {
                          if (index < state.histories.length) {
                            return MainHistoryTile(
                              history: state.histories[index],
                            );
                          } else {
                            return const Column(
                              children: [
                                MainHistoryTileSkeleton(),
                                MainHistoryTileSkeleton(),
                              ],
                            );
                          }
                        },
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        surfaceTintColor: transparentColor,
        backgroundColor: whiteColor,
        title: Text(
          "History Transaction",
          style: headingMediumTextStyle.copyWith(
            fontWeight: semibold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            // InkWell(
            //   onTap: () {},
            //   child: Ink(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(4),
            //     ),
            //     child: Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 12),
            //       height: 48,
            //       decoration: BoxDecoration(
            //         borderRadius: const BorderRadius.all(
            //           Radius.circular(4.0),
            //         ),
            //         border: Border.all(
            //           color: hintTextColor,
            //         ),
            //         shape: BoxShape.rectangle,
            //       ),
            //       child: Row(
            //         children: [
            //           Icon(
            //             Icons.tune,
            //             size: 22,
            //             color: blackColor,
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           Text(
            //             "Filter",
            //             style: paragraphNormalTextStyle,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            listHistory()
          ],
        ),
      ),
    );
  }
}
