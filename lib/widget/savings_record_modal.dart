import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/primary_button.dart';

enum SavingsRecordModalType { increase, decrease }

class SavingsRecordModal extends StatefulWidget {
  final SavingsRecordModalType modalType;
  const SavingsRecordModal({super.key, required this.modalType});

  @override
  State<SavingsRecordModal> createState() => _SavingsRecordModalState();
}

class _SavingsRecordModalState extends State<SavingsRecordModal>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateModal) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        widget.modalType == SavingsRecordModalType.increase
                            ? Icons.move_to_inbox
                            : Icons.outbox,
                        size: 40,
                        color: primaryColor500,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.modalType == SavingsRecordModalType.increase
                                ? 'Increase'
                                : 'Decrease',
                            style: primaryTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semibold,
                            ),
                          ),
                          Text(
                            'IPHONE 14 PRO MAX',
                            style: labelSmallTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: regular,
                              color: subtitleTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.close,
                    size: 20,
                    color: subtitleTextColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                textFieldType: CustomTextFieldType.outline,
                style: paragraphLargeTextStyle,
                hintStyle: paragraphLargeTextStyle.copyWith(
                  color: subtitleTextColor,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    int amount = int.parse(value.replaceAll(",", ""));
                    if (amount > 1) {
                      setStateModal(() {
                        isValid = true;
                      });
                    } else {
                      setStateModal(() {
                        isValid = false;
                      });
                    }
                  } else {
                    setStateModal(() {
                      isValid = false;
                    });
                  }
                },
                isCurrency: true,
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: Text(
                    "Rp",
                    style: paragraphNormalTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semibold,
                    ),
                  ),
                ),
                labelText: "",
                hintText: "0",
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Balance Rp20,000,000',
                style: labelSmallTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                  color: subtitleTextColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              PrimaryButton(
                isEnabled: isValid,
                child: Text(
                  "SUBMIT",
                  style: paragraphLargeTextStyle.copyWith(
                    color: whiteColor,
                    fontWeight: semibold,
                  ),
                ),
                onPressed: () {},
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
