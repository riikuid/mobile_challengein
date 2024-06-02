import 'package:flutter/material.dart';
import 'package:mobile_challengein/widget/saving_type_card.dart';

class SavingsTypeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'CHOOSE YOUR SAVING TYPE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Determine the type of savings you will make for your goals',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 16.0),
          SavingsTypeCard(
            color: Colors.green,
            title: 'WALLET SAVINGS',
            description:
                'Savings that you can top up using real money by payment gateway',
          ),
          SizedBox(height: 16.0),
          SavingsTypeCard(
            color: Colors.orange,
            title: 'SAVINGS RECORD',
            description:
                'A savings recorder that can be used for savings managers without top up with real money',
          ),
        ],
      ),
    );
  }
}
