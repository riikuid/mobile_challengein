import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_challengein/pages/savings/detail_saving_page.dart';
import 'package:mobile_challengein/provider/inbox_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/notification_tile.dart';
import 'package:mobile_challengein/widget/saving_card_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late InboxProvider inboxProvider =
      Provider.of<InboxProvider>(context, listen: false);
  String errorGetNotifications = "Failed to get notification history";
  late Future<void> futureGetNotification;

  Future<bool> getAllNotifications() async {
    bool result = await inboxProvider.getNotificationHistory(
      (p0) => setState(() {
        errorGetNotifications = p0;
      }),
    );
    return result;
  }

  @override
  void initState() {
    super.initState();
    futureGetNotification = getAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            FutureBuilder(
              future: futureGetNotification,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                      child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.separated(
                      itemCount: 10,
                      separatorBuilder: (context, index) => const Divider(
                        height: 30,
                      ),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 14,
                              width: screenWidth / 2.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: blackColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 12,
                                  width: screenWidth / 1.6,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: blackColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 14,
                                  width: screenWidth / 3,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: blackColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ));
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        errorGetNotifications,
                        style: primaryTextStyle.copyWith(
                          color: subtitleTextColor,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Consumer<InboxProvider>(
                      builder: (context, inboxProvider, _) {
                    if (inboxProvider.notifications.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            errorGetNotifications,
                            style: primaryTextStyle.copyWith(
                              color: subtitleTextColor,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () {
                            return Future.delayed(const Duration(seconds: 1),
                                () {
                              setState(() {
                                getAllNotifications();
                              });
                            });
                          },
                          color: secondaryColor500,
                          child: ListView.separated(
                            itemCount: context
                                .read<InboxProvider>()
                                .notifications
                                .length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 30,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      // Ambil data dari provider
                                      final savings = context
                                          .read<SavingProvider>()
                                          .savings;
                                      final notifications = context
                                          .read<InboxProvider>()
                                          .notifications;

                                      // Ambil ID savings dari notifikasi
                                      final idSavings =
                                          notifications[index].idSavings;

                                      // Temukan saving yang cocok
                                      final saving = savings.firstWhere(
                                        (element) => element.id == idSavings,
                                      );

                                      return DetailSavingPage(
                                        saving: saving,
                                      );
                                    },
                                  ));
                                },
                                child: NotificationTile(
                                  notificationModel: context
                                      .read<InboxProvider>()
                                      .notifications[index],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
