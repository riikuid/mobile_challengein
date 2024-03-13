import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';

class MainHistoryTile extends StatelessWidget {
  const MainHistoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: subtitleTextColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Top Up",
                    style: labelLargeTextStyle.copyWith(
                      color: blackColor,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Today",
                    style: labelNormalTextStyle.copyWith(
                      color: subtitleTextColor,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+Rp150,000",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: labelLargeTextStyle.copyWith(
                    color: blackColor,
                    fontWeight: medium,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  "Success",
                  style: labelNormalTextStyle.copyWith(
                    color: greenLableColor,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
