import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../widgets/atm_card.dart';
import '../widgets/transaction_item.dart';
import '../models/transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _slideController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _startAutoScroll();
  }

  void _startAutoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!_pageController.hasClients) continue;
      int nextPage = _currentPage + 1;
      if (nextPage >= 6) nextPage = 0;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ===== Transactions diperbarui =====
    final transactions = [
      TransactionModel('Coffee Shop', '-Rp35.000', 'Food & Beverage'),
      TransactionModel('Grab Ride', '-Rp25.000', 'Transport'),
      TransactionModel('Gym Membership', '-Rp150.000', 'Health & Fitness'),
      TransactionModel('Movie Ticket', '-Rp60.000', 'Entertainment'),
      TransactionModel('Salary', '+Rp5.000.000', 'Income'),
      TransactionModel('Shopee Purchase', '-Rp320.000', 'Shopping'),
      TransactionModel('Electric Bill', '-Rp210.000', 'Utilities'),
      TransactionModel('Friend Transfer', '+Rp100.000', 'Transfer'),
      TransactionModel('Google Drive', '-Rp27.000', 'Subscription'),
      TransactionModel('Starbucks', '-Rp58.000', 'Food & Beverage'),
    ];

    // ===== Tambah 2 ATM lagi (total 6) =====
    final atmCards = const [
  AtmCard(
    bankName: 'Bank BRI',
    cardNumber: '**** 2345',
    balance: 'Rp15.500.000',
    color1: Color(0xFF6E22EF),
    color2: Color(0xFF100AD6),
    cardHolderName: 'Ade Barkah',
  ),
  AtmCard(
    bankName: 'Bank BNI',
    cardNumber: '**** 8765',
    balance: 'Rp10.350.000',
    color1: Color(0xFF6E22EF),
    color2: Color(0xFF100AD6),
    cardHolderName: 'Ade Barkah',
  ),
  AtmCard(
    bankName: 'DANA',
    cardNumber: '**** 1122',
    balance: 'Rp6.750.000',
    color1: Color(0xFF6E22EF),
    color2: Color(0xFF100AD6),
    cardHolderName: 'Ade Barkah',
  ),
  AtmCard(
    bankName: 'OVO',
    cardNumber: '**** 3344',
    balance: 'Rp3.200.000',
    color1: Color(0xFF6E22EF),
    color2: Color(0xFF100AEF),
    cardHolderName: 'Ade Barkah',
  ),
  AtmCard(
    bankName: 'Bank Mandiri',
    cardNumber: '**** 9988',
    balance: 'Rp8.850.000',
    color1: Color(0xFF6E22EF),
    color2: Color(0xFF100AEF),
    cardHolderName: 'Ade Barkah',
  ),
  AtmCard(
    bankName: 'Gopay',
    cardNumber: '**** 5566',
    balance: 'Rp2.500.000',
    color1: Color(0xFF6E22EF),
    color2: Color(0xFF100AEF),
    cardHolderName: 'Ade Barkah',
  ),
];


    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Mate'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6E22EF),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // ===== Animated Background (Bubbles + Gradient) =====
          AnimatedBuilder(
            animation: _bubbleController,
            builder: (context, _) {
              return CustomPaint(
                painter: BubbleBackgroundPainter(_bubbleController.value),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFB3E5FC), Color(0xFFE1BEE7)],
                    ),
                  ),
                ),
              );
            },
          ),

          // ===== Foreground Content =====
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Cards',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // ATM Cards
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: atmCards.length,
                        onPageChanged: (index) => setState(() => _currentPage = index),
                        itemBuilder: (context, index) {
                          final isActive = index == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            margin: EdgeInsets.symmetric(
                              horizontal: isActive ? 4 : 12,
                              vertical: isActive ? 0 : 12,
                            ),
                            transform: Matrix4.identity()
                              ..scale(isActive ? 1.05 : 0.95),
                            child: AnimatedOpacity(
                              opacity: isActive ? 1 : 0.8,
                              duration: const Duration(milliseconds: 400),
                              child: atmCards[index],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Dots
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          atmCards.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 12 : 8,
                            height: _currentPage == index ? 12 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? const Color(0xFF5D58F0)
                                  : Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===== Grid Menu =====
                    GridView.count(
                      crossAxisCount: 5,
                      shrinkWrap: true,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        GridMenuItem(icon: Icons.health_and_safety, label: 'Health'),
                        GridMenuItem(icon: Icons.travel_explore, label: 'Travel'),
                        GridMenuItem(icon: Icons.fastfood, label: 'Food'),
                        GridMenuItem(icon: Icons.event, label: 'Event'),
                        GridMenuItem(icon: Icons.school, label: 'Education'),
                        GridMenuItem(icon: Icons.shopping_bag, label: 'Shopping'),
                        GridMenuItem(icon: Icons.savings, label: 'Savings'),
                        GridMenuItem(icon: Icons.directions_car, label: 'Transport'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Recent Transactions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) =>
                          TransactionItem(transaction: transactions[index]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Grid Menu Item =====
class GridMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  const GridMenuItem({super.key, required this.icon, required this.label});

  @override
  State<GridMenuItem> createState() => _GridMenuItemState();
}

class _GridMenuItemState extends State<GridMenuItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menu "${widget.label}" diklik'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isPressed ? 1.08 : 1.0)
          ..translate(0, _isPressed ? -3 : 0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isPressed ? 0.2 : 0.1),
              blurRadius: _isPressed ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 32, color: const Color(0xFF5D58F0)),
            const SizedBox(height: 6),
            Text(widget.label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF444444))),
          ],
        ),
      ),
    );
  }
}

// ===== Bubble Background Painter =====
class BubbleBackgroundPainter extends CustomPainter {
  final double progress;
  final math.Random random = math.Random();

  BubbleBackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final double radius = 10 + (i % 5) * 6;
      final double dx = (size.width / 20) * (i + 2) +
          math.sin(progress * 2 * math.pi + i) * 20;
      final double dy =
          (size.height * ((i * 23) % 100) / 100) - progress * size.height;

      final color = Colors.white.withOpacity(0.12 + (i % 3) * 0.05);
      paint.color = color;
      canvas.drawCircle(Offset(dx % size.width, dy % size.height), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}