// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/filter_saving_model.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/modal/filter_modal.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:provider/provider.dart';

class ListFilterModal extends StatefulWidget {
  const ListFilterModal({Key? key}) : super(key: key);

  @override
  State<ListFilterModal> createState() => _ListFilterModalState();
}

class _ListFilterModalState extends State<ListFilterModal> {
  bool isLoading = false;
  bool isLoading1 = false;

  List<String> fillingFrequencyItem = ['AND', 'OR'];

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateModal) {
        return Consumer<SavingProvider>(builder: (context, provider, _) {
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: subtitleTextColor,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: false,
                                style: const TextStyle(
                                  decorationStyle: TextDecorationStyle.solid,
                                ),
                                value: provider.selectedFilterCondition,
                                dropdownColor: whiteColor,
                                items: fillingFrequencyItem
                                    .map<DropdownMenuItem<String>>(
                                      (String item) => DropdownMenuItem<String>(
                                        value: item,
                                        // enabled: item == selectedFrequency,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                          ),
                                          child: Text(
                                            item,
                                            style: paragraphNormalTextStyle
                                                .copyWith(
                                              fontWeight: regular,
                                              color: subtitleTextColor,
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ...provider.filters.map((filter) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 180,
                              width: 180,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
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
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    // showModalBottomSheet<void>(
                                    //   shape: const ContinuousRectangleBorder(
                                    //     borderRadius: BorderRadius.only(
                                    //       topLeft: Radius.circular(20.0),
                                    //       topRight: Radius.circular(20.0),
                                    //     ),
                                    //   ),
                                    //   backgroundColor: Colors.white,
                                    //   context: context,
                                    //   isScrollControlled: true,
                                    //   builder: (BuildContext context) {
                                    //     return const FilterModal();
                                    //   },
                                    // );
                                  },
                                  alignment: Alignment.topLeft,
                                  icon: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Name',
                                            style: primaryTextStyle.copyWith(
                                              color: subtitleTextColor,
                                              fontWeight: regular,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            " (${AppHelper.formatConditionFilter(filter.goalNameCondition)})",
                                            style: primaryTextStyle.copyWith(
                                              color: subtitleTextColor,
                                              fontWeight: regular,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        filter.goalName != ''
                                            ? filter.goalName!
                                            : '-',
                                        textAlign: TextAlign.center,
                                        style: primaryTextStyle.copyWith(
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          fontWeight: regular,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Target Amount',
                                        style: primaryTextStyle.copyWith(
                                          color: subtitleTextColor,
                                          fontWeight: regular,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        AppHelper.formatRangeAmount(
                                          amount1: filter.lowesTargetAmound!,
                                          amount2: filter.highestTargetAmound!,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: primaryTextStyle.copyWith(
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          fontWeight: regular,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Target Date',
                                        style: primaryTextStyle.copyWith(
                                          color: subtitleTextColor,
                                          fontWeight: regular,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        AppHelper.formatRangeDate(
                                          startDate: filter.startTargetDate,
                                          endDate: filter.endTargetDate,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: primaryTextStyle.copyWith(
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          fontWeight: regular,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Positioned(
                                right: 5,
                                top: -5,
                                child: IconButton(
                                  onPressed: () {
                                    provider.deleteFilter(item: filter);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: secondaryColor600,
                                  ),
                                ))
                          ],
                        );
                      }),
                      DottedBorder(
                        radius: const Radius.circular(12),
                        color: primaryColor500,
                        dashPattern: const [9, 5],
                        borderType: BorderType.RRect,
                        child: SizedBox(
                          height: 180,
                          width: 180,
                          child: IconButton(
                              style: IconButton.styleFrom(
                                elevation: 2,
                                // fixedSize: const Size(double.infinity, double.infinity),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: primaryColor50,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: primaryColor500,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showModalBottomSheet<void>(
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
                                    return const FilterModal();
                                  },
                                );
                              },
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Add Filter",
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle.copyWith(
                                      fontWeight: regular,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        border: Border.all(
                                          width: 1.5,
                                          color: primaryColor500,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        weight: 2,
                                        color: primaryColor500,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
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
                          context.read<SavingProvider>().resetFilter();

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
    );
  }
}
