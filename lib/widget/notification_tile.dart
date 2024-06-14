import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/notification_model.dart';
import 'package:mobile_challengein/theme.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notificationModel;
  const NotificationTile({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppHelper.formatDateTimeWithWIB(notificationModel.createdAt),
          style: primaryTextStyle.copyWith(
            color: subtitleTextColor,
            fontSize: 11,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          notificationModel.title,
          style: primaryTextStyle.copyWith(
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          notificationModel.body,
          style: primaryTextStyle.copyWith(
            color: subtitleTextColor,
            fontSize: 12,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
