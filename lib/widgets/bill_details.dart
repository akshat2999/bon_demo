import 'package:flutter/material.dart';
import '../models/credit_card_bill.dart';
import '../utils/constants.dart';

class BillDetails extends StatelessWidget {
  final CreditCardBill bill;

  const BillDetails({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Text(
            'Bill Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          // Card Name
          _buildDetailRow(Icons.credit_card, 'Card', bill.cardName),

          // Divider
          Divider(color: Colors.grey[300], thickness: 1, height: 24),

          // Amount
          _buildDetailRow(Icons.attach_money, 'Amount', '\$${bill.amount.toStringAsFixed(2)}'),

          // Divider
          Divider(color: Colors.grey[300], thickness: 1, height: 24),

          // Due Date
          _buildDetailRow(Icons.calendar_today, 'Due Date', _formatDate(bill.dueDate)),

          // Divider
          Divider(color: Colors.grey[300], thickness: 1, height: 24),

          // Status
          _buildDetailRow(
            _getStatusIcon(bill.status),
            'Status',
            _getStatusText(bill.status),
            color: _getStatusColor(bill.status),
          ),

          const SizedBox(height: 20),

          // Close Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build a row for each detail
  Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, color: color ?? Colors.blue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  // Format the due date
  String _formatDate(DateTime date) {
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Get the color for the status
  Color _getStatusColor(BillStatus status) {
    switch (status) {
      case BillStatus.paid:
        return Colors.green;
      case BillStatus.pending:
        return Colors.orange;
      case BillStatus.overdue:
        return Colors.red;
    }
  }

  // Get the icon for the status
  IconData _getStatusIcon(BillStatus status) {
    switch (status) {
      case BillStatus.paid:
        return Icons.check_circle;
      case BillStatus.pending:
        return Icons.access_time;
      case BillStatus.overdue:
        return Icons.warning;
    }
  }

  // Get the text for the status
  String _getStatusText(BillStatus status) {
    switch (status) {
      case BillStatus.paid:
        return 'Paid';
      case BillStatus.pending:
        return 'Pending';
      case BillStatus.overdue:
        return 'Overdue';
    }
  }
}