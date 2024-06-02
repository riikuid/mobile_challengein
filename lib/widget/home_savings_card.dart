// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/app_helper.dart';
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
                decoration: BoxDecoration(
                  color: greyBackgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      saving.pathImage,
                    ),
                    colorFilter: !saving.isDone
                        ? const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.multiply,
                          )
                        : const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
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
                    saving.goalName,
                    style: headingSmallTextStyle.copyWith(
                      color: subtitleTextColor,
                      fontWeight: medium,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        saving.isDone
                            ? "COMPLETED"
                            : AppHelper.formatCurrency(saving.savingAmount),
                        style: headingNormalTextStyle.copyWith(
                          fontWeight: semibold,
                        ),
                      ),
                      Text(
                        '${(saving.progressSavings * 100).toStringAsFixed(0)}%',
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
                value: saving.progressSavings,
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
