import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/products.dart';
import 'components/product_images.dart';
import '../../globals.dart';

class DetailsScreen extends StatefulWidget {
  static String routeName = "/details";
  const DetailsScreen({super.key});
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  int _selectedSizeIndex = 2; // default middle size
  int _selectedColorIndex = 0;
  int _quantity = 1;
  bool _isFavourite = false;
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<Color> _colors = [
    const Color(0xFF1B263B),
    const Color(0xFF415A77),
    const Color(0xFF778DA9),
    const Color(0xFF8B5A2B),
    const Color(0xFF2C2C2C),
  ];

  // Detect category from product category field
  List<String> _getSizes(Product product) {
    final cat = product.category.toLowerCase();
    if (cat.contains('shoe') || cat.contains('sneaker') || cat.contains('boot')) {
      return ['39', '40', '41', '42', '43', '44'];
    }
    if (cat.contains('pant') || cat.contains('jean') || cat.contains('trouser') || cat.contains('short')) {
      return ['28', '30', '32', '34', '36', '38'];
    }
    return ['S', 'M', 'L', 'XL', 'XXL', 'XXXL']; // tops default
  }

  String _getSizeLabel(Product product) {
    final cat = product.category.toLowerCase();
    if (cat.contains('shoe') || cat.contains('sneaker') || cat.contains('boot')) {
      return 'Size (EU)';
    }
    if (cat.contains('pant') || cat.contains('jean') || cat.contains('trouser') || cat.contains('short')) {
      return 'Waist (inch)';
    }
    return 'Size';
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _addToCart(int productId) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.5/add_to_cart.php'),
      body: {
        'user_id': userId.toString(),
        'product_id': productId.toString(),
      },
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['status'] == 'success'
            ? 'Added to cart!'
            : 'Failed to add to cart'),
        backgroundColor: result['status'] == 'success'
            ? const Color(0xFF415A77)
            : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    final product = args.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: Color(0xFF1B263B), size: 18),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => setState(() => _isFavourite = !_isFavourite),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _isFavourite ? const Color(0xFFFFE6E6) : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavourite ? Colors.red : const Color(0xFF778DA9),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Product image
          ProductImages(product: product),

          // Slide-up animated info panel
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E1DD),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Name + Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D1B2A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${product.price.toStringAsFixed(0)} DA',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF415A77),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Brand + Gender badges
                        Row(
                          children: [
                            _Badge(label: product.brand, icon: Icons.store),
                            const SizedBox(width: 8),
                            _Badge(
                              label: product.gender,
                              icon: product.gender.toLowerCase() == 'female'
                                  ? Icons.female
                                  : Icons.male,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Description
                        const Text('Description',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D1B2A))),
                        const SizedBox(height: 6),
                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF778DA9),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Color selector
                        const Text('Color',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D1B2A))),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(_colors.length, (i) {
                            final selected = i == _selectedColorIndex;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedColorIndex = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.only(right: 12),
                                width: selected ? 36 : 30,
                                height: selected ? 36 : 30,
                                decoration: BoxDecoration(
                                  color: _colors[i],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected
                                        ? const Color(0xFF415A77)
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                            color: _colors[i].withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : [],
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 22),

                        // Size selector — dynamic based on product type
                        Builder(builder: (context) {
                          final sizes = _getSizes(product);
                          final label = _getSizeLabel(product);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(label,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0D1B2A))),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(sizes.length, (i) {
                                  final selected = i == _selectedSizeIndex;
                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedSizeIndex = i),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      width: 52,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: selected ? const Color(0xFF415A77) : const Color(0xFFF4F5F7),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selected ? const Color(0xFF415A77) : const Color(0xFFE0E1DD),
                                        ),
                                        boxShadow: selected ? [
                                          BoxShadow(
                                            color: const Color(0xFF415A77).withOpacity(0.3),
                                            blurRadius: 8, offset: const Offset(0, 3),
                                          )
                                        ] : [],
                                      ),
                                      child: Center(
                                        child: Text(
                                          sizes[i],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: sizes[i].length > 2 ? 11 : 14,
                                            color: selected ? Colors.white : const Color(0xFF1B263B),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 22),

                        // Quantity + Total
                        const Text('Quantity',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D1B2A))),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _QtyButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (_quantity > 1)
                                  setState(() => _quantity--);
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(scale: anim, child: child),
                                child: Text(
                                  '$_quantity',
                                  key: ValueKey(_quantity),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0D1B2A),
                                  ),
                                ),
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.add,
                              onTap: () => setState(() => _quantity++),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Total',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF778DA9))),
                                Text(
                                  '${(product.price * _quantity).toStringAsFixed(0)} DA',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF415A77),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Add to Cart button
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: ElevatedButton(
          onPressed: () => _addToCart(product.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF415A77),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)),
            elevation: 4,
            shadowColor: const Color(0xFF415A77).withOpacity(0.4),
          ),
          child: Builder(builder: (context) {
            final sizes = _getSizes(product);
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Add to Cart  •  ${sizes[_selectedSizeIndex]}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ── Helpers ─────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final IconData icon;
  const _Badge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E1DD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF415A77)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B263B),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E1DD)),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF1B263B)),
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;
  ProductDetailsArguments({required this.product});
}
