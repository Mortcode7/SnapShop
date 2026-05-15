import 'package:flutter/material.dart';

class DiscountBanner extends StatefulWidget {
  const DiscountBanner({Key? key}) : super(key: key);

  @override
  _DiscountBannerState createState() => _DiscountBannerState();
}

class _DiscountBannerState extends State<DiscountBanner> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_BannerData> _banners = const [
    _BannerData(
      gradient: [Color(0xFF1B263B), Color(0xFF415A77)],
      badge: '🎉 Flash Sale',
      title: 'Up to 40% OFF',
      subtitle: 'On selected sneakers this weekend only',
      icon: Icons.local_fire_department_rounded,
    ),
    _BannerData(
      gradient: [Color(0xFF415A77), Color(0xFF778DA9)],
      badge: '🎮 Spin & Win',
      title: 'Play for Discounts',
      subtitle: 'Spin the wheel and win up to 25% off your order',
      icon: Icons.casino_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll every 4 seconds
    Future.delayed(Duration.zero, _startAutoScroll);
  }

  void _startAutoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) break;
      final next = (_currentIndex + 1) % _banners.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            height: 110,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, i) => _BannerCard(data: _banners[i]),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (i) {
              final active = i == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF415A77)
                      : const Color(0xFFE0E1DD),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Banner data model ────────────────────────────────────

class _BannerData {
  final List<Color> gradient;
  final String badge;
  final String title;
  final String subtitle;
  final IconData icon;

  const _BannerData({
    required this.gradient,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

// ── Banner card ──────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  final _BannerData data;
  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Decorative circle in background
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          data.badge,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        data.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Big icon on the right
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
