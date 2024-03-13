import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/savings_label.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [defaultShadow],
          image: const DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1533050487297-09b450131914?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: GestureDetector(
          onTap: () {},
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
                              "IPHONE 14 XR",
                              style: headingSmallTextStyle.copyWith(
                                color: whiteColor,
                                fontWeight: medium,
                              ),
                            ),
                            Text(
                              "Rp150,000,000",
                              style: headingMediumTextStyle.copyWith(
                                color: whiteColor,
                                fontWeight: semibold,
                              ),
                            ),
                            Text(
                              "GOAL: Rp500,000,000",
                              style: headingSmallTextStyle.copyWith(
                                color: whiteColor,
                                fontWeight: medium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          child: CircularPercentIndicator(
                            radius: 40,
                            lineWidth: 10.0,
                            backgroundColor: whiteColor.withOpacity(0.5),
                            percent: 0.6,
                            progressColor: whiteColor,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Text(
                              "100%",
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
                    const SavingsTypeLable(
                      savingsType: "savings_record",
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
