// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/pages/savings/detail_saving_page.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/savings_label.dart';

class SavingCard extends StatelessWidget {
  final SavingModel saving;
  const SavingCard({
    super.key,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: disabledColor,
          boxShadow: [defaultShadow],
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
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailSavingPage(saving: saving),
              ),
            );
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  blackColor,
                  transparentColor,
                ],
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              saving.goalName,
                              style: headingSmallTextStyle.copyWith(
                                color: whiteColor,
                                fontWeight: medium,
                              ),
                            ),
                            Text(
                              saving.isDone
                                  ? "COMPLETED"
                                  : AppHelper.formatCurrency(
                                      saving.savingAmount),
                              style: headingMediumTextStyle.copyWith(
                                color: whiteColor,
                                fontWeight: semibold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.savings,
                                  color: whiteColor,
                                  size: 14,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  AppHelper.formatCurrency(saving.targetAmount),
                                  style: headingSmallTextStyle.copyWith(
                                    color: whiteColor,
                                    fontWeight: medium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          child: CircularPercentIndicator(
                            radius: 40,
                            lineWidth: 10.0,
                            backgroundColor: whiteColor.withOpacity(0.5),
                            percent: saving.progressSavings,
                            progressColor: primaryColor400,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Text(
                              '${(saving.progressSavings * 100).toStringAsFixed(0)}%',
                              style: headingSmallTextStyle.copyWith(
                                color: whiteColor,
                                fontWeight: bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SavingsTypeLable(
                      savingsType: saving.savingType,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
