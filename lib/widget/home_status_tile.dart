// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:mobile_challengein/theme.dart';

class HomeStatusTile extends StatelessWidget {
  final String icon;
  final String lable;
  final String value;
  const HomeStatusTile({
    super.key,
    required this.icon,
    required this.lable,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          height: 40,
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          lable,
          style: labelSmallTextStyle.copyWith(
            color: subtitleTextColor,
            fontWeight: medium,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          value,
          style: labelNormalTextStyle.copyWith(
            fontWeight: medium,
          ),
        ),
      ],
    );
  }
}
