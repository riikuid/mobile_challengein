import 'package:flutter/material.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/provider/history_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
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

  Future<void> _onRefresh() async {
    await context.read<HistoryProvider>().refreshGetHistory();
  }

  Future<void> getRecentHistory() async {
    await historyProvider.refreshGetHistory();
  }

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && context.read<HistoryProvider>().hasMore) {
      context
          .read<HistoryProvider>()
          .getHistory(token: authProvider.user.refreshToken);
    }
  }

  @override
  void initState() {
    context.read<HistoryProvider>().refreshGetHistory();

    _scrollController.addListener(onScroll);
    futureGetHistories = getRecentHistory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget listHistory() {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: FutureBuilder(
            future: futureGetHistories,
            builder: (context, snapshot) {
              // builder: (context) {
              return Consumer<HistoryProvider>(
                builder: (__, state, _) {
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
                },
              );
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
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            const SearchFilterWidget(),
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
