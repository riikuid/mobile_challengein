import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/format_currency.dart';
import 'package:mobile_challengein/model/user_saving.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/home_status_tile.dart';

class HomeUserSavingsWidget extends StatefulWidget {
  final UserSaving? userSaving;
  const HomeUserSavingsWidget({super.key, this.userSaving});

  @override
  State<HomeUserSavingsWidget> createState() => _HomeUserSavingsWidgetState();
}

class _HomeUserSavingsWidgetState extends State<HomeUserSavingsWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Savings Amount",
                style: labelNormalTextStyle.copyWith(
                  color: subtitleTextColor,
                  fontWeight: semibold,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                child: Icon(
                  _isObscure ? Icons.remove_red_eye : Icons.visibility_off,
                  size: 16,
                  color: subtitleTextColor,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            _isObscure
                ? "Rp---"
                : widget.userSaving != null
                    ? formatCurrency(widget.userSaving!.savingsAmount)
                    : "Loading",
            style: headingLargeTextStyle.copyWith(
              fontWeight: semibold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: HomeStatusTile(
                  icon: "assets/icon/icon_wallet_savings.svg",
                  lable: "Wallet Savings",
                  value: _isObscure
                      ? "Rp---"
                      : widget.userSaving != null
                          ? formatCurrency(widget.userSaving!.walletSavings)
                          : "Loading",
                ),
              ),
              Expanded(
                child: HomeStatusTile(
                  icon: "assets/icon/icon_savings_record.svg",
                  lable: "Savings Record",
                  value: _isObscure
                      ? "Rp---"
                      : widget.userSaving != null
                          ? formatCurrency(widget.userSaving!.savingsRecord)
                          : "Loading",
                ),
              ),
              Expanded(
                child: HomeStatusTile(
                  icon: "assets/icon/icon_savings_count.svg",
                  lable: "Savings Count",
                  value: widget.userSaving != null
                      ? "${widget.userSaving!.countSavings} Savings"
                      : "0 Savings",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
