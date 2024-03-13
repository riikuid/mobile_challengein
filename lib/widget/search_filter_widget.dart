import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_challengein/theme.dart';

class SearchFilterWidget extends StatelessWidget {
  const SearchFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            // selectionHeightStyle: BoxHeightStyle.tight,
            style: paragraphNormalTextStyle.copyWith(),
            cursorColor: primaryColor500,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(),
              hintText: "Find Your History",
              hintStyle: paragraphNormalTextStyle.copyWith(
                color: hintTextColor,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
                borderSide: BorderSide(
                  color: hintTextColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
                borderSide: BorderSide(
                  color: blackColor,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 22,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 8),
                child: SvgPicture.asset(
                  "assets/icon/icon_search.svg",
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {},
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 48,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
                border: Border.all(
                  color: hintTextColor,
                ),
                shape: BoxShape.rectangle,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.tune,
                    size: 22,
                    color: blackColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Filter",
                    style: paragraphNormalTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
