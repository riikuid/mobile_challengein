import 'package:flutter/material.dart';
import 'package:mobile_challengein/model/bank_model.dart';

class BankTile extends StatelessWidget {
  final BankModel bankModel;
  final VoidCallback onTapModel;
  const BankTile({
    super.key,
    required this.bankModel,
    required this.onTapModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(bankModel.namaBank),
      onTap: onTapModel,
    );
  }
}
