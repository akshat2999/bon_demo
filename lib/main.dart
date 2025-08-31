import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reward Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: RewardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RewardScreen extends StatefulWidget {
  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> with TickerProviderStateMixin {
  late AnimationController _rewardController;
  late AnimationController _cardController;
  late Animation<double> _rewardScaleAnimation;
  late Animation<double> _cardSlideAnimation;
  late ConfettiController _confettiController; // Add ConfettiController

  // Mock credit card bills data
  final List<CreditCardBill> mockBills = [
    CreditCardBill(
      cardName: "Chase Freedom",
      amount: 1247.89,
      dueDate: DateTime(2025, 9, 15),
      status: BillStatus.pending,
      cardNumber: "**** 4532",
    ),
    CreditCardBill(
      cardName: "Amex Platinum",
      amount: 892.45,
      dueDate: DateTime(2025, 9, 22),
      status: BillStatus.paid,
      cardNumber: "**** 1009",
    ),
    CreditCardBill(
      cardName: "Capital One Venture",
      amount: 567.32,
      dueDate: DateTime(2025, 9, 28),
      status: BillStatus.overdue,
      cardNumber: "**** 7854",
    ),
  ];

  @override
  void initState() {
    super.initState();

    _rewardController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _rewardScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rewardController,
      curve: Curves.elasticOut,
    ));

    _cardSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));

    _confettiController = ConfettiController(duration: Duration(seconds: 2)); // Initialize ConfettiController

    // Start animations
    _rewardController.forward();
    Future.delayed(Duration(milliseconds: 300), () {
      _cardController.forward();
    });

    // Start confetti
    _confettiController.play();
  }

  @override
  void dispose() {
    _rewardController.dispose();
    _cardController.dispose();
    _confettiController.dispose(); // Dispose ConfettiController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Reward Section
                  ScaleTransition(
                    scale: _rewardScaleAnimation,
                    child: _buildRewardSection(),
                  ),

                  SizedBox(height: 30),

                  // Credit Card Bills Section
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _cardSlideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _cardSlideAnimation.value),
                          child: Opacity(
                            opacity: 1 - (_cardSlideAnimation.value / 50),
                            child: _buildCreditCardBills(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confetti Widget
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 20, // Increased number of particles
              colors: [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.pink[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Reward Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_giftcard,
              size: 30,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 16),

          // Reward Text
          Text(
            "You've unlocked a",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),

          Text(
            "\$10 reward!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          // Choose Brand Button
          _buildChooseBrandButton(),
        ],
      ),
    );
  }

  Widget _buildChooseBrandButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: () {
          // Simulate navigation with haptic feedback
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Navigating to brand selection...'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple[600],
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Brand',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardBills() {
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

        SizedBox(height: 16),

        Expanded(
          child: ListView.builder(
            itemCount: mockBills.length,
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300 + (index * 100)),
                margin: EdgeInsets.only(bottom: 12),
                child: _buildBillCard(mockBills[index], index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBillCard(CreditCardBill bill, int index) {
    // Define a list of gradients
    final List<List<Color>> gradients = [
      [Colors.blue[400]!, Colors.blue[700]!],
      [Colors.purple[400]!, Colors.purple[700]!],
      [Colors.green[400]!, Colors.green[700]!],
      [Colors.orange[400]!, Colors.orange[700]!],
      [Colors.red[400]!, Colors.red[700]!],
    ];

    // Cycle through the gradients based on the index
    final gradientColors = gradients[index % gradients.length];

    Color statusColor = _getStatusColor(bill.status);
    IconData statusIcon = _getStatusIcon(bill.status);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        _showBillDetails(bill);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Name and Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bill.cardName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  bill.cardNumber,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Amount
            Text(
              '\$${bill.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),

            // Due Date and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Due: ${_formatDate(bill.dueDate)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 14,
                        color: statusColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _getStatusText(bill.status),
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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

  String _formatDate(DateTime date) {
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showBillDetails(CreditCardBill bill) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Bill Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),

            // Card Name
            Row(
              children: [
                Icon(Icons.credit_card, color: Colors.blue, size: 20),
                SizedBox(width: 12),
                Text(
                  bill.cardName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Amount
            Row(
              children: [
                Icon(Icons.attach_money, color: Colors.green, size: 20),
                SizedBox(width: 12),
                Text(
                  '\$${bill.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Due Date
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.orange, size: 20),
                SizedBox(width: 12),
                Text(
                  'Due: ${_formatDate(bill.dueDate)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Status
            Row(
              children: [
                Icon(
                  _getStatusIcon(bill.status),
                  color: _getStatusColor(bill.status),
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  _getStatusText(bill.status),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(bill.status),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
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
      ),
    );
  }
}

// Data Models
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

enum BillStatus { paid, pending, overdue }
