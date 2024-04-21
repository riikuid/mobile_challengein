import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/savings_label.dart';
import 'package:shimmer/shimmer.dart';

class HomeSavingCardSkeleton extends StatelessWidget {
  const HomeSavingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 225,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          color: whiteColor.withOpacity(0.2),
          border: Border.all(
            width: 0.5,
            color: blackColor,
          ),
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
                child: const Align(
                  alignment: Alignment.topRight,
                  child: SavingsTypeLable(
                    savingsType: "savings_record",
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 14,
                  width: screenWidth / 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: blackColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 14,
                      width: screenWidth / 3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: blackColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            LinearProgressIndicator(
              value: 0.4,
              minHeight: 14,
              color: primaryColor500,
              backgroundColor: greyBackgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
