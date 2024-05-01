import 'package:flutter/material.dart';
import 'package:mobile_challengein/model/user_model.dart';
import 'package:mobile_challengein/pages/savings/create_saving_page.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/saving_card.dart';
import 'package:mobile_challengein/widget/saving_card_skeleton.dart';
import 'package:mobile_challengein/widget/search_filter_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SavingsPage extends StatefulWidget {
  // final UserModel user;
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  late AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late UserModel user = authProvider.user;
  late SavingProvider savingProvider =
      Provider.of<SavingProvider>(context, listen: false);
  String errorGetSavingText = "Failed to get savings";
  late Future<void> futureGetSavings;

  Future<bool> getAllSavings() async {
    bool result = await savingProvider.getSavings(
      user.refreshToken,
      (p0) => setState(() {
        errorGetSavingText = p0;
      }),
      "",
    );
    return result;
  }

  @override
  void initState() {
    super.initState();
    futureGetSavings = getAllSavings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        surfaceTintColor: transparentColor,
        backgroundColor: whiteColor,
        actions: [
          SizedBox(
            height: 32,
            width: 120,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateSavingPage(
                      savingType: "savings_record",
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
                backgroundColor: primaryColor500,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                elevation: 0,
                // fixedSize: Size(150, 20),
              ),
              child: Text(
                "Create Goal",
                style: labelNormalTextStyle.copyWith(
                  color: whiteColor,
                  fontWeight: semibold,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        title: Text(
          "Savings",
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
            FutureBuilder(
              future: futureGetSavings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                      child: ListView.custom(
                    childrenDelegate: SliverChildBuilderDelegate(
                      childCount: 3,
                      (context, index) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const SavingCardSkeleton(),
                      ),
                    ),
                  ));
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        errorGetSavingText,
                        style: primaryTextStyle.copyWith(
                          color: subtitleTextColor,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Consumer<SavingProvider>(
                      builder: (context, savingProvider, _) {
                    if (savingProvider.savings.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            errorGetSavingText,
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
                                getAllSavings();
                              });
                            });
                          },
                          color: secondaryColor500,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 1),
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemCount: savingProvider.savings.length,
                            itemBuilder: (context, index) {
                              final saving =
                                  savingProvider.savings.toList()[index];
                              return SavingCard(saving: saving);
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
