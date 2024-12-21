// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/modal/filter_modal.dart';
import 'package:mobile_challengein/widget/modal/menu_items.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:provider/provider.dart';

class ListFilterModal extends StatefulWidget {
  const ListFilterModal({super.key});

  @override
  State<ListFilterModal> createState() => _ListFilterModalState();
}

class _ListFilterModalState extends State<ListFilterModal> {
  bool isLoading = false;
  bool isLoading1 = false;

  List<String> fillingFrequencyItem = ['AND', 'OR'];

  final List<String> addFilterItem = [
    'Name',
    'Target Date',
    'Target Amount',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  width: 30.0,
                  height: 3.0,
                  decoration: BoxDecoration(
                    color: subtitleTextColor,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                StatefulBuilder(
                  builder: (context, setStateModal) {
                    return Consumer<SavingProvider>(
                        builder: (context, provider, _) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          20,
                          20,
                          MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Filter',
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: semibold,
                                  ),
                                ),
                                provider.filters.length > 1
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: subtitleTextColor,
                                            style: BorderStyle.solid,
                                            width: 0.80,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: false,
                                            style: const TextStyle(
                                              decorationStyle:
                                                  TextDecorationStyle.solid,
                                            ),
                                            value: provider
                                                .selectedFilterCondition,
                                            dropdownColor: whiteColor,
                                            items: fillingFrequencyItem
                                                .map<DropdownMenuItem<String>>(
                                                  (String item) =>
                                                      DropdownMenuItem<String>(
                                                    value: item,
                                                    // enabled: item == selectedFrequency,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: whiteColor,
                                                      ),
                                                      child: Text(
                                                        item,
                                                        style:
                                                            paragraphNormalTextStyle
                                                                .copyWith(
                                                          fontWeight: regular,
                                                          color:
                                                              subtitleTextColor,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              provider.setFilterCondition(
                                                conditions: value!,
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListView(
                              shrinkWrap: true,
                              children: [
                                ...provider.filters.map(
                                  (filter) {
                                    return Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          // height: 100,
                                          width: screenSize.width,
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(12.0),
                                            ),
                                            border: Border.all(
                                              style: BorderStyle.solid,
                                              width: 1.0,
                                              color: primaryColor500,
                                            ),
                                          ),
                                          child: IconButton(
                                            style: IconButton.styleFrom(
                                              elevation: 2,
                                              padding: const EdgeInsets.all(20),
                                              backgroundColor: primaryColor50,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: subtitleTextColor,
                                                  style: BorderStyle.none,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(12.0),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              log('ini menu item dari filter ${filter.menuItem}');
                                              showModalBottomSheet<void>(
                                                shape:
                                                    const ContinuousRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    topRight:
                                                        Radius.circular(20.0),
                                                  ),
                                                ),
                                                backgroundColor: Colors.white,
                                                context: context,
                                                isScrollControlled: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return FilterModal(
                                                    modelForedit: filter,
                                                    item: filter.menuItem,
                                                  );
                                                },
                                              );
                                            },
                                            alignment: Alignment.topLeft,
                                            icon: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '(${filter.condiniton ?? ''}) Filter',
                                                  style:
                                                      primaryTextStyle.copyWith(
                                                    // color: blackColor,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                if (filter.goalName != null)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Name',
                                                            style:
                                                                primaryTextStyle
                                                                    .copyWith(
                                                              color:
                                                                  subtitleTextColor,
                                                              fontWeight:
                                                                  regular,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                          Text(
                                                            " (${AppHelper.formatConditionFilter(filter.goalNameCondition)})",
                                                            style:
                                                                primaryTextStyle
                                                                    .copyWith(
                                                              color:
                                                                  subtitleTextColor,
                                                              fontWeight:
                                                                  regular,
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        filter.goalName ?? '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: primaryTextStyle
                                                            .copyWith(
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          fontWeight: regular,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                if (filter.lowesTargetAmound !=
                                                        null ||
                                                    filter.highestTargetAmound !=
                                                        null)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Target Amount',
                                                        style: primaryTextStyle
                                                            .copyWith(
                                                          color:
                                                              subtitleTextColor,
                                                          fontWeight: regular,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        AppHelper
                                                            .formatRangeAmount(
                                                          amount1: filter
                                                              .lowesTargetAmound,
                                                          amount2: filter
                                                              .highestTargetAmound,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: primaryTextStyle
                                                            .copyWith(
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          fontWeight: regular,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                if (filter.startTargetDate !=
                                                        null ||
                                                    filter.endTargetDate !=
                                                        null)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Target Date',
                                                        style: primaryTextStyle
                                                            .copyWith(
                                                          color:
                                                              subtitleTextColor,
                                                          fontWeight: regular,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        AppHelper
                                                            .formatRangeDate(
                                                          startDate: filter
                                                              .startTargetDate,
                                                          endDate: filter
                                                              .endTargetDate,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: primaryTextStyle
                                                            .copyWith(
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          fontWeight: regular,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if (filter.nestedFilter
                                                        ?.isNotEmpty ??
                                                    false)
                                                  Text(
                                                    '+ ${filter.nestedFilter?.length ?? ''} Nested Filter',
                                                    style: primaryTextStyle
                                                        .copyWith(
                                                      color: subtitleTextColor,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 5,
                                          top: -5,
                                          child: IconButton(
                                            onPressed: () {
                                              provider.deleteFilter(
                                                  item: filter);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: secondaryColor600,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                                DottedBorder(
                                  radius: const Radius.circular(12),
                                  color: primaryColor500,
                                  dashPattern: const [9, 5],
                                  borderType: BorderType.RRect,
                                  child: SizedBox(
                                    height: 60,
                                    width: screenSize.width,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        isExpanded: true,
                                        hint: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: primaryColor500,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(100.0),
                                                ),
                                                border: Border.all(
                                                  width: 1.5,
                                                  color: primaryColor500,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 15,
                                                weight: 8,
                                                color: whiteColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Add New Conditions',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: semibold,
                                                color: primaryColor500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        items: [
                                          DropdownMenuItem<Divider>(
                                              enabled: false,
                                              child: Text(
                                                'Filter by',
                                                style:
                                                    primaryTextStyle.copyWith(
                                                  fontSize: 10,
                                                  color: subtitleTextColor
                                                      .withOpacity(0.7),
                                                ),
                                              )),
                                          ...MenuItems.firstItems.map(
                                            (item) =>
                                                DropdownMenuItem<MenuItem>(
                                              value: item,
                                              child: MenuItems.buildFirstItem(
                                                  item),
                                            ),
                                          ),
                                          const DropdownMenuItem<Divider>(
                                            enabled: false,
                                            child: Divider(),
                                          ),
                                          ...MenuItems.secondItems.map(
                                            (item) =>
                                                DropdownMenuItem<MenuItem>(
                                              value: item,
                                              child: MenuItems.buildSecondItem(
                                                  item),
                                            ),
                                          ),
                                        ],
                                        value: selectedValue,
                                        onChanged: (value) {
                                          MenuItems.onChanged(
                                            context: context,
                                            item: value! as MenuItem,
                                            isNested: false,
                                          );
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 500,
                                          // width: 160,
                                          padding: const EdgeInsets.only(
                                              left: 14, right: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: primaryColor50,
                                          ),
                                        ),
                                        iconStyleData: IconStyleData(
                                          icon: const Icon(
                                            Icons.arrow_forward_ios_outlined,
                                          ),
                                          iconSize: 0,
                                          iconEnabledColor: primaryColor500,
                                          iconDisabledColor: Colors.grey,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 500,
                                          isOverButton: true,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                              width: 0.5,
                                              color: primaryColor300,
                                            ),
                                            color: whiteColor,
                                          ),
                                          offset: const Offset(0, 220),
                                          elevation: 0,
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                MaterialStateProperty.all(6),
                                            thumbVisibility:
                                                MaterialStateProperty.all(true),
                                          ),
                                        ),
                                        menuItemStyleData: MenuItemStyleData(
                                          customHeights: [
                                            20,
                                            ...List<double>.filled(
                                                MenuItems.firstItems.length,
                                                40),
                                            10,
                                            ...List<double>.filled(
                                                MenuItems.secondItems.length,
                                                40),
                                          ],
                                          // height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    isLoading: isLoading1,
                                    isEnabled: !isLoading,
                                    borderColor: primaryColor500,
                                    color: whiteColor,
                                    height: 40,
                                    child: Text(
                                      "RESET",
                                      style: primaryTextStyle.copyWith(
                                        color: primaryColor500,
                                      ),
                                    ),
                                    onPressed: () async {
                                      setStateModal(() {
                                        isLoading1 = true;
                                      });
                                      Navigator.pop(context);
                                      context
                                          .read<SavingProvider>()
                                          .resetFilter();

                                      setStateModal(() {
                                        isLoading1 = false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: PrimaryButton(
                                    isLoading: isLoading,
                                    isEnabled: provider.filters.isNotEmpty &&
                                        !provider.isAppliedFilter,
                                    height: 40,
                                    child: Text(
                                      "APPLY",
                                      style: primaryTextStyle.copyWith(
                                        color: whiteColor,
                                      ),
                                    ),
                                    onPressed: () async {
                                      setStateModal(() {
                                        isLoading = true;
                                      });
                                      provider.applyFilter();
                                      Navigator.pop(context);
                                      setStateModal(() {
                                        isLoading = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          );
        });
  }
}
