import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/savings_label.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SavingCardSkeleton extends StatelessWidget {
  const SavingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: blackColor.withOpacity(0.4),
          boxShadow: [defaultShadow],
          border: Border.all(
            width: 1.0,
            color: blackColor,
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
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                            width: screenWidth / 4,
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
                            width: 30,
                          ),
                          SizedBox(
                            height: 16,
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
                            width: 30,
                          ),
                          SizedBox(
                            height: 16,
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
                      ),
                    ),
                    SizedBox(
                      child: CircularPercentIndicator(
                        radius: 40,
                        lineWidth: 10.0,
                        backgroundColor: whiteColor.withOpacity(0.5),
                        percent: 1,
                        progressColor: whiteColor,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    )
                  ],
                ),
                const SavingsTypeLable(
                  savingsType: "savings_record",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
