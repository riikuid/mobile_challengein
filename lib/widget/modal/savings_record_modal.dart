import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';
import 'package:provider/provider.dart';

enum SavingsRecordModalType { increase, decrease }

class SavingsRecordModal extends StatefulWidget {
  final SavingModel saving;
  final SavingsRecordModalType modalType;
  const SavingsRecordModal(
      {super.key, required this.modalType, required this.saving});

  @override
  State<SavingsRecordModal> createState() => _SavingsRecordModalState();
}

class _SavingsRecordModalState extends State<SavingsRecordModal>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;
  bool _isLoading = false;
  String errorText = "";
  int amount = 0;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateModal) {
        Future<void> handleSubmit() async {
          SavingProvider savingProvider =
              Provider.of<SavingProvider>(context, listen: false);
          AuthProvider authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          setStateModal(() {
            _isLoading = true;
          });
          // print(SavingsRecordModalType.values.toString());
          await savingProvider
              .updateSavingsRecord(
            amount: amount.toString(),
            idSaving: widget.saving.id,
            updateType: widget.modalType.name,
            errorCallback: (error) {
              errorText = error.toString();
            },
          )
              .then((value) {
            if (value) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              ThrowSnackbar().showError(context, errorText);
            }
          });
          setStateModal(() {
            _isLoading = false;
          });
        }

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
                      SvgPicture.asset(
                        widget.modalType == SavingsRecordModalType.increase
                            ? "assets/icon/icon_modal_increase.svg"
                            : "assets/icon/icon_modal_decrease.svg",
                        height: 35,
                      ),
                      const SizedBox(
                        width: 10,
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
                            widget.saving.goalName,
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
                  GestureDetector(
                    onTap: _isLoading ? null : () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: subtitleTextColor,
                    ),
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
                    setStateModal(
                      () {
                        amount = int.parse(
                          value.replaceAll(",", ""),
                        );
                        if (amount > 1) {
                          _isValid = true;
                        } else {
                          _isValid = false;
                        }
                      },
                    );
                  } else {
                    setStateModal(() {
                      _isValid = false;
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
                'Balance ${AppHelper.formatCurrency(widget.saving.savingAmount)}',
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
                isLoading: _isLoading,
                isEnabled: _isValid,
                onPressed: handleSubmit,
                child: Text(
                  "SUBMIT",
                  style: paragraphLargeTextStyle.copyWith(
                    color: whiteColor,
                    fontWeight: semibold,
                  ),
                ),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
