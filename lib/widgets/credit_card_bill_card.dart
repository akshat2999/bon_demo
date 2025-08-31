import 'package:flutter/material.dart';
import '../models/credit_card_bill.dart';
import '../utils/constants.dart';

class CreditCardBillCard extends StatelessWidget {
  final CreditCardBill bill;
  final VoidCallback onTap;

  const CreditCardBillCard({super.key, required this.bill, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(20),
        height: 209, // Set a fixed height for the card
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getCardGradient(bill.cardName),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header: Card Brand and Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    bill.cardName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
                const SizedBox(width: 8), // Add spacing between text and logo
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 55, // Set the desired height for the logo
                    maxWidth: 52, // Ensure the logo doesn't exceed this size
                  ),
                  child: _getCardLogo(bill.cardName),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card Chip and Card Number
            Row(
              children: [
                Icon(
                  Icons.credit_card, // Mimic a chip icon
                  color: Colors.white.withOpacity(0.8),
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _formatCardNumber(bill.cardNumber),
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 2,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
              ],
            ),
            const Spacer(), // Push the expiration date and amount to the bottom

            // Expiration Date and Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exp: 12/25', // Mock expiration date
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Flexible(
                  child: Text(
                    '\$${bill.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Card Footer: Due Date and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Due: ${_formatDate(bill.dueDate)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
                const SizedBox(width: 8), // Add spacing between text and badge
                _buildStatusBadge(bill.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Get unique gradient for each card
  List<Color> _getCardGradient(String cardName) {
    switch (cardName) {
      case "Chase Freedom":
        return [Colors.blue, Colors.blueAccent];
      case "Amex Platinum":
        return [Colors.grey, Colors.black];
      case "Capital One Venture":
        return [Colors.teal, Colors.green];
      default:
        return [Colors.purple, Colors.deepPurple];
    }
  }

  // Get card logo based on card name
  Widget _getCardLogo(String cardName) {
    switch (cardName) {
      case "Chase Freedom":
        return const Icon(Icons.credit_card, color: Colors.white, size: 28);
      case "Amex Platinum":
        return Image.asset(
          'assets/amex_logo.png', // Add Amex logo image to assets
          fit: BoxFit.contain, // Ensure the image scales properly
        );
      case "Capital One Venture":
        return Image.asset(
          'assets/capital_one_logo.png', // Add Capital One logo image to assets
          fit: BoxFit.contain, // Ensure the image scales properly
        );
      default:
        return const Icon(Icons.credit_card, color: Colors.white, size: 28);
    }
  }

  // Format the card number into groups
  String _formatCardNumber(String cardNumber) {
    return cardNumber.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
  }

  // Format the due date
  String _formatDate(DateTime date) {
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Build the status badge
  Widget _buildStatusBadge(BillStatus status) {
    Color statusColor;
    String statusText;

    switch (status) {
      case BillStatus.paid:
        statusColor = Colors.green;
        statusText = 'Paid';
        break;
      case BillStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case BillStatus.overdue:
        statusColor = Colors.red;
        statusText = 'Overdue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: statusColor,
        ),
      ),
    );
  }
}