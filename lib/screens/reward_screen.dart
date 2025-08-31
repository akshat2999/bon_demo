import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import '../widgets/reward_section.dart';
import '../widgets/credit_card_bills.dart';
import '../widgets/bill_details.dart';
import '../models/credit_card_bill.dart';





class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}
class _RewardScreenState extends State<RewardScreen> with TickerProviderStateMixin {
  late AnimationController _rewardController;
  late AnimationController _cardController;
  late Animation<double> _rewardScaleAnimation;
  late Animation<double> _cardSlideAnimation;
  late ConfettiController _confettiController;

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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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

    _confettiController = ConfettiController(duration: const Duration(seconds: 2));

    _rewardController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardController.forward();
    });

    _confettiController.play();
  }

  @override
  void dispose() {
    _rewardController.dispose();
    _cardController.dispose();
    _confettiController.dispose();
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _rewardScaleAnimation,
                    child: RewardSection(onChooseBrand: _onChooseBrand),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _cardSlideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _cardSlideAnimation.value),
                          child: Opacity(
                            opacity: 1 - (_cardSlideAnimation.value / 50),
                            child: CreditCardBills(
                              bills: mockBills,
                              onBillTap: _showBillDetails,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
              colors: const [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }

  void _onChooseBrand() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigating to brand selection...'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showBillDetails(CreditCardBill bill) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BillDetails(bill: bill),
    );
  }
}