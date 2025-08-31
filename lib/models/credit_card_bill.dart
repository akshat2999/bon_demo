enum BillStatus { paid, pending, overdue }

class CreditCardBill {
  final String cardName;
  final double amount;
  final DateTime dueDate;
  final BillStatus status;
  final String cardNumber;

  CreditCardBill({
    required this.cardName,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.cardNumber,
  });
}