import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/bank_model.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/pages/savings/succes_withdraw_page.dart';
import 'package:mobile_challengein/pages/savings/top_up_page.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/bank_tile.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';
import 'package:provider/provider.dart';

enum SavingsWalletModalType { topup, withdraw }

class SavingsWalletModal extends StatefulWidget {
  final SavingModel saving;
  final SavingsWalletModalType modalType;
  const SavingsWalletModal(
      {super.key, required this.modalType, required this.saving});

  @override
  State<SavingsWalletModal> createState() => _SavingsWalletModalState();
}

class _SavingsWalletModalState extends State<SavingsWalletModal>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _noRekController = TextEditingController();
  final TextEditingController _bankSearchController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  final PageController pageController = PageController();

  String searchBank = "";

  bool _isValid = false;
  bool _isValidWd = false;
  bool _isLoading = false;

  bool _isLoading2 = false;
  bool _isEnabled = true;

  String errorText = "";
  String errorCheck = "";
  int amount = 0;

  String type = "Bank Account";

  BankModel selectedBank = BankModel(kodeBank: "014", namaBank: "BANK BCA");
  // late PayoutAccountModel selectedAccount;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationCon
    //troller(vsync: this);
  }

  void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null)
      FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    SavingProvider savingProvider =
        Provider.of<SavingProvider>(context, listen: false);
    return StatefulBuilder(
      builder: (context, setStateModal) {
        Future<void> handleSubmit() async {
          // log("TES");
          setStateModal(() {
            _isLoading = true;
          });
          await savingProvider.checkQrExpired().then(
            (value) async {
              if (value) {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    bool alertLoading = false;
                    return StatefulBuilder(builder: (context, setStateAlert) {
                      return AlertDialog(
                        backgroundColor: whiteColor,
                        insetPadding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 40),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        content: IntrinsicHeight(
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    secondaryColor500.withOpacity(0.3),
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
                                "You Still Have Outstanding\nTransactions",
                                textAlign: TextAlign.center,
                                style: headingMediumTextStyle.copyWith(
                                  fontWeight: semibold,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Do you want to create new QR for this transaction?",
                                textAlign: TextAlign.center,
                                style: paragraphLargeTextStyle.copyWith(
                                  fontSize: 12,
                                  color: subtitleTextColor,
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              PrimaryButton(
                                isLoading: alertLoading,
                                elevation: 0,
                                color: secondaryColor500,
                                onPressed: () async {
                                  log("REQ BARU");
                                  setStateAlert(() {
                                    alertLoading = true;
                                  });
                                  await savingProvider
                                      .topUpSavingWallet(
                                    amount: amount.toString(),
                                    idSaving: widget.saving.id,
                                  )
                                      .then(
                                    (value) {
                                      if (value) {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TopUpPage(
                                              topUpModel:
                                                  savingProvider.topUpModel!,
                                            ),
                                          ),
                                        );
                                      } else {
                                        ThrowSnackbar().showError(
                                            context, "Something went wrong!");
                                      }
                                    },
                                  );

                                  setStateAlert(() {
                                    alertLoading = false;
                                  });
                                },
                                child: const Text(
                                  "Generate New QR",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              PrimaryButton(
                                elevation: 0,
                                color: transparentColor,
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TopUpPage(
                                        topUpModel: savingProvider.topUpModel!,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Open The Last Transaction",
                                  style: paragraphNormalTextStyle.copyWith(
                                    color: blackColor,
                                    fontWeight: regular,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              } else {
                log(" TOP UP" + value.toString());
                await savingProvider
                    .topUpSavingWallet(
                  amount: amount.toString(),
                  idSaving: widget.saving.id,
                )
                    .then(
                  (value) {
                    if (value) {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopUpPage(
                            topUpModel: savingProvider.topUpModel!,
                          ),
                        ),
                      );
                    } else {
                      ThrowSnackbar().showError(
                        context,
                        "Something went wrong!",
                      );
                    }
                  },
                );
              }
            },
          );
          // print(SavingsWalletModalType.values.toString());

          setStateModal(() {
            _isLoading = false;
          });
        }

        Future<void> handleSubmitWD() async {
          setStateModal(() {
            _isLoading = true;
          });
          if (_nominalController.text.isEmpty) {
            Fluttertoast.showToast(
              msg: "Amount can't be empty",
            );
          } else if (amount.toInt() < 10000) {
            Fluttertoast.showToast(
              msg: "Amount must be at least Rp10.000",
            );
          } else if (amount.toInt() > widget.saving.savingAmount) {
            Fluttertoast.showToast(msg: "Insufficient amount of saving.");
          } else {
            await savingProvider
                .createPayout(
              account: savingProvider.payoutAccountModel!,
              amount: amount,
              idSaving: widget.saving.id,
              errorCallback: (p0) => setStateModal(() {
                errorText = p0.toString();
              }),
            )
                .then(
              (value) {
                if (value) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuccessWithdrawPage(
                          payoutModel: savingProvider.payoutModel!,
                        ),
                      ));
                } else {
                  Fluttertoast.showToast(
                    msg: errorText,
                  );
                }
              },
            );
          }

          setStateModal(() {
            _isLoading = false;
          });
        }

        Future<void> handleCheck() async {
          setStateModal(() {
            _isLoading = true;
          });
          await savingProvider
              .checkAccountPayout(
            type: type == "Bank Account" ? "rekening" : "ewallet",
            accountNumber: _accountNumberController.text,
            bank: selectedBank,
            errorCallback: (p0) => setStateModal(() {
              errorCheck = p0.toString();
            }),
          )
              .then(
            (value) async {
              if (value) {
                // setStateModal(() {
                //   selectedAccount = savingProvider.payoutAccountModel!;
                // });
                pageController.animateToPage(
                  3,
                  duration: const Duration(microseconds: 300),
                  curve: Curves.linear,
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setStateAlert) {
                      return AlertDialog(
                        backgroundColor: whiteColor,
                        insetPadding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 40),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        content: IntrinsicHeight(
                          child: Column(
                            children: [
                              Text(
                                "Account Not Found",
                                style: headingMediumTextStyle.copyWith(
                                  fontWeight: semibold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Please try again and make sure you\nentered the corect number",
                                textAlign: TextAlign.center,
                                style: paragraphLargeTextStyle.copyWith(
                                  fontSize: 12,
                                  color: subtitleTextColor,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              PrimaryButton(
                                elevation: 0,
                                color: secondaryColor500,
                                onPressed: () async {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: Text(
                                  "OKAY",
                                  style: paragraphNormalTextStyle.copyWith(
                                    color: whiteColor,
                                    fontWeight: regular,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }
            },
          );
          // print(SavingsWalletModalType.values.toString());

          setStateModal(() {
            _isLoading = false;
          });
        }

        Widget nominalPage() {
          return Column(
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
                      widget.modalType == SavingsWalletModalType.topup
                          ? SvgPicture.asset(
                              "assets/icon/icon_topup.svg",
                              height: 35,
                            )
                          : SvgPicture.asset(
                              "assets/icon/icon_withdraw.svg",
                              height: 35,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Top Up',
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
                        if (amount > 10000) {
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
                // enableError: true,
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
                controller: _nominalController,
              ),
              const SizedBox(
                height: 10,
              ),
              PrimaryButton(
                isLoading: _isLoading,
                // isEnabled: _isValid,
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
          );
        }

        Widget nominalPageWD() {
          return Column(
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
                      CircleAvatar(
                        child: Text(
                            savingProvider.payoutAccountModel?.accountname[0] ??
                                "C"),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            savingProvider.payoutAccountModel?.accountname ??
                                "Kosong",
                            style: primaryTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semibold,
                            ),
                          ),
                          Text(
                            "${savingProvider.payoutAccountModel?.bankname ?? "Kosong"} - ${savingProvider.payoutAccountModel?.accountnumber ?? "Kosong"}",
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
                        if (amount > widget.saving.savingAmount) {
                          _isValidWd = true;
                        } else {
                          _isValidWd = false;
                        }
                      },
                    );
                  } else {
                    setStateModal(() {
                      _isValidWd = false;
                    });
                  }
                },
                // enableError: true,
                isCurrency: true,
                errorText: errorText,
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
                controller: _nominalController,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Balance ${AppHelper.formatCurrency(widget.saving.savingAmount)}",
                style: primaryTextStyle.copyWith(
                  color: subtitleTextColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              PrimaryButton(
                isLoading: _isLoading,
                isEnabled: _isValidWd,
                onPressed: handleSubmitWD,
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
          );
        }

        Widget checkAccountPage() {
          return Column(
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
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          pageController.animateToPage(
                            1,
                            duration: const Duration(microseconds: 300),
                            curve: Curves.linear,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
                      Icon(
                        Icons.account_balance,
                        color: primaryColor500,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        selectedBank.namaBank,
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semibold,
                        ),
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
                  fontWeight: light,
                  fontSize: 16,
                ),
                onChanged: (value) {},
                labelText: "",
                hintText: "Account Number",
                keyboardType: TextInputType.number,
                controller: _accountNumberController,
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                isLoading: _isLoading,
                onPressed: handleCheck,
                child: Text(
                  "CHECK",
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
          );
        }

        Widget secondPage(String type) {
          return Column(
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
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          pageController.animateToPage(
                            0,
                            duration: Duration(microseconds: 300),
                            curve: Curves.linear,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
                      Icon(
                        type == "Bank Account"
                            ? Icons.account_balance
                            : Icons.account_balance_wallet,
                        color: primaryColor500,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        type,
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semibold,
                        ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomTextField(
                  textFieldType: CustomTextFieldType.outline,
                  style: paragraphNormalTextStyle,
                  hintStyle: paragraphNormalTextStyle.copyWith(
                    color: subtitleTextColor,
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.search,
                    ),
                  ),
                  onChanged: (value) {
                    setStateModal(() {
                      searchBank = value;
                    });
                  },
                  labelText: "",
                  hintText: "Search",
                  keyboardType: TextInputType.name,
                  controller: _bankSearchController,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView(
                  children: savingProvider.listBank
                      .map(
                        (bank) => BankTile(
                          bankModel: bank,
                          onTapModel: () {
                            setStateModal(() {
                              selectedBank = bank;
                            });
                            pageController.animateToPage(
                              2,
                              duration: const Duration(microseconds: 300),
                              curve: Curves.linear,
                            );
                          },
                        ),
                      )
                      .where(
                        (bank) =>
                            bank.bankModel.namaBank.toLowerCase().contains(
                                  searchBank.toLowerCase(),
                                ),
                      )
                      .toList(),
                ),
              )
            ],
          );
        }

        Widget firstPage() {
          return Column(
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
                        "assets/icon/icon_withdraw.svg",
                        height: 35,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Withdraw',
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
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      isLoading: _isLoading,
                      isEnabled: _isEnabled,
                      color: whiteColor,
                      reverseLoading: true,
                      borderColor: primaryColor500,
                      height: 120,
                      child: Column(
                        children: [
                          Icon(
                            Icons.account_balance,
                            color: primaryColor500,
                            size: 30,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Bank Account",
                            style: primaryTextStyle.copyWith(
                              color: primaryColor500,
                              fontWeight: semibold,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      onPressed: () async {
                        setStateModal(() {
                          _isLoading = true;
                          _isEnabled = !_isLoading;
                          type = "Bank Account";
                        });
                        await savingProvider.getListBank(type: "bank").then(
                          (value) {
                            pageController.jumpToPage(1);
                            setStateModal(() {
                              _isLoading = false;
                              _isEnabled = !_isLoading;
                            });
                          },
                        );
                        setStateModal(() {
                          _isLoading = false;
                          _isEnabled = !_isLoading;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      color: whiteColor,
                      borderColor: primaryColor500,
                      height: 120,
                      isLoading: _isLoading2,
                      isEnabled: _isEnabled,
                      reverseLoading: true,
                      child: Column(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: primaryColor500,
                            size: 30,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "E-Wallet",
                            style: primaryTextStyle.copyWith(
                              color: primaryColor500,
                              fontWeight: semibold,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      onPressed: () async {
                        setStateModal(() {
                          _isLoading2 = true;
                          _isEnabled = !_isLoading2;
                          type = "E-Wallet";
                        });
                        await savingProvider.getListBank(type: "ewallet").then(
                          (value) {
                            pageController.jumpToPage(1);
                            setStateModal(() {
                              _isLoading = false;
                              _isEnabled = !_isLoading;
                            });
                          },
                        );
                        setStateModal(() {
                          _isLoading2 = false;
                          _isEnabled = !_isLoading2;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          );
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom,
          ),
          child: widget.modalType == SavingsWalletModalType.topup
              ? nominalPage()
              : ExpandablePageView(
                  onPageChanged: (value) {
                    closeKeyboard(context);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  padEnds: true,
                  children: [
                    firstPage(),
                    secondPage(type),
                    checkAccountPage(),
                    nominalPageWD(),
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
