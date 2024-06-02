import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/primary_button.dart';

class DeleteAlert extends StatefulWidget {
  final VoidCallback onTapDelete;
  const DeleteAlert({
    super.key,
    required this.onTapDelete,
  });

  @override
  State<DeleteAlert> createState() => _DeleteAlertState();
}

class _DeleteAlertState extends State<DeleteAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: whiteColor,
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      content: IntrinsicHeight(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: secondaryColor500.withOpacity(0.3),
              child: Icon(
                Icons.error,
                size: 30,
                color: secondaryColor500,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Delete Saving",
              style: headingMediumTextStyle.copyWith(
                fontWeight: semibold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Are you sure to delete this saving?\nThis action can't be undone",
              textAlign: TextAlign.center,
              style: paragraphLargeTextStyle.copyWith(
                fontSize: 12,
                color: subtitleTextColor,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      elevation: 0,
                      color: transparentColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: paragraphNormalTextStyle.copyWith(
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      elevation: 0,
                      color: secondaryColor500,
                      onPressed: widget.onTapDelete,
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
