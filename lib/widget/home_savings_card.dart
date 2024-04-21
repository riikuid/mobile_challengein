// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mobile_challengein/model/savings_model.dart';

import 'package:mobile_challengein/pages/savings/detail_saving_page.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/savings_label.dart';

class HomeSavingsCard extends StatelessWidget {
  final SavingModel saving;
  const HomeSavingsCard({
    super.key,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailSavingPage(
                      saving: saving,
                    )));
      },
      child: Container(
        width: 225,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          color: whiteColor,
          boxShadow: [
            defaultShadow,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/image/example_savings.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SavingsTypeLable(
                    savingsType: saving.savingType,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rumah Kcuing",
                    style: headingSmallTextStyle.copyWith(
                      color: subtitleTextColor,
                      fontWeight: medium,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp50,0000",
                        style: headingNormalTextStyle.copyWith(
                          fontWeight: semibold,
                        ),
                      ),
                      Text(
                        "15%",
                        style: labelNormalTextStyle.copyWith(
                          fontWeight: semibold,
                          color: primaryColor500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: LinearProgressIndicator(
                value: 0.4,
                minHeight: 10,
                color: primaryColor500,
                backgroundColor: greyBackgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
