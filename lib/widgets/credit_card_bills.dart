import 'package:flutter/material.dart';
import '../models/credit_card_bill.dart';
import '../widgets/credit_card_bill_card.dart';

class CreditCardBills extends StatelessWidget {
  final List<CreditCardBill> bills;
  final Function(CreditCardBill) onBillTap;

  const CreditCardBills({super.key, required this.bills, required this.onBillTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Credit Card Bills',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: bills.length,
            itemBuilder: (context, index) {
              final bill = bills[index];
              return CreditCardBillCard(
                bill: bill,
                onTap: () => onBillTap(bill),
              );
            },
          ),
        ),
      ],
    );
  }
}