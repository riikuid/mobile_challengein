import 'package:flutter/material.dart';
import 'package:mobile_challengein/model/filter_model.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/modal/filter_modal.dart';

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [name, targetAmount, targetDate];
  static const List<MenuItem> secondItems = [allRule];

  static const name = MenuItem(text: 'Name', icon: Icons.abc);
  static const targetAmount =
      MenuItem(text: 'Target Amount', icon: Icons.money_rounded);
  static const targetDate =
      MenuItem(text: 'Target Date', icon: Icons.calendar_month);
  static const allRule = MenuItem(text: 'All Rule', icon: Icons.filter_list);

  static Widget buildSecondItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: primaryColor700, size: 18),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: TextStyle(
              color: primaryColor700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildFirstItem(MenuItem item) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.text,
            style: TextStyle(
              color: primaryColor700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged({
    required BuildContext context,
    required MenuItem item,
    required bool isNested,
    void Function(FilterModel?)? callback,
  }) {
    switch (item) {
      case MenuItems.name:
        showModalBottomSheet<FilterModel>(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return FilterModal(
              item: item,
              isNested: isNested,
            );
          },
        ).then(
          (value) {
            callback?.call(value);
          },
        );
        break;
      case MenuItems.targetAmount:
        showModalBottomSheet<FilterModel>(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return FilterModal(
              item: item,
              isNested: isNested,
            );
          },
        ).then(
          (value) {
            callback?.call(value);
          },
        );
        break;
      case MenuItems.targetDate:
        showModalBottomSheet<FilterModel>(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return FilterModal(
              item: item,
              isNested: isNested,
            );
          },
        ).then(
          (value) {
            callback?.call(value);
          },
        );
        break;
      case MenuItems.allRule:
        showModalBottomSheet<FilterModel>(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return FilterModal(
              item: item,
              isNested: isNested,
            );
          },
        ).then(
          (value) {
            callback?.call(value);
          },
        );
        break;
    }
  }
}
