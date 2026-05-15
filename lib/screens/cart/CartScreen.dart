import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/CartItem.dart';
import '../../globals.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";
  const CartScreen({super.key});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];
  bool _loading = true;
  bool _isSummaryExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    setState(() => _loading = true);
    final response = await http
        .get(Uri.parse('http://192.168.1.5/get_cart.php?user_id=$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      setState(() {
        _cartItems = json.map((j) => CartItem.fromJson(j)).toList();
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _removeItem(int itemId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.5/remove_from_cart.php'),
        body: {
          'user_id': userId.toString(),
          'product_id': itemId.toString(),
        },
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          _fetchCartItems();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Item removed'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF415A77),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ));
        }
      }
    } catch (e) {
      // ignore
    }
  }

  void _goToOrderScreen() {
    final productIds = _cartItems.map((item) => item.id).toList();
    Navigator.pushNamed(context, '/order', arguments: productIds);
  }

  double get _subtotal => _cartItems.fold(
      0, (sum, item) => sum + double.tryParse(item.price)!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Color(0xFF0D1B2A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF1B263B), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E1DD),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_cartItems.length} items',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B263B),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF415A77)))
          : _cartItems.isEmpty
              ? _buildEmptyCart()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          return _CartItemCard(
                            item: _cartItems[index],
                            onRemove: () =>
                                _removeItem(_cartItems[index].id),
                          );
                        },
                      ),
                    ),
                    _buildOrderSummary(),
                  ],
                ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E1DD),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                size: 60, color: Color(0xFF415A77)),
          ),
          const SizedBox(height: 20),
          const Text('Your cart is empty',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B2A))),
          const SizedBox(height: 8),
          const Text('Add items to get started',
              style: TextStyle(fontSize: 14, color: Color(0xFF778DA9))),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -5) {
          if (!_isSummaryExpanded) setState(() => _isSummaryExpanded = true);
        } else if (details.delta.dy > 5) {
          if (_isSummaryExpanded) setState(() => _isSummaryExpanded = false);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 20,
              offset: Offset(0, -4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            GestureDetector(
              onTap: () => setState(() => _isSummaryExpanded = !_isSummaryExpanded),
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E1DD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal',
                    style: TextStyle(fontSize: 14, color: Color(0xFF778DA9))),
                Text('${_subtotal.toStringAsFixed(0)} DA',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D1B2A))),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery',
                    style: TextStyle(fontSize: 14, color: Color(0xFF778DA9))),
                Text('Free',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF415A77))),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Taxes', style: TextStyle(fontSize: 14, color: Color(0xFF778DA9))),
                      Text('Included', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0D1B2A))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Discount', style: TextStyle(fontSize: 14, color: Color(0xFF778DA9))),
                      Text('- 0 DA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F5F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.local_shipping_outlined, color: Color(0xFF415A77), size: 20),
                        SizedBox(width: 10),
                        Expanded(child: Text('Estimated delivery in 2-4 business days', style: TextStyle(fontSize: 12, color: Color(0xFF778DA9)))),
                      ],
                    ),
                  ),
                ],
              ),
              crossFadeState: _isSummaryExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
            const Divider(height: 24, color: Color(0xFFE0E1DD)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B2A))),
                Text('${_subtotal.toStringAsFixed(0)} DA',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF415A77))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _goToOrderScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF415A77),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 4,
                  shadowColor: const Color(0xFF415A77).withOpacity(0.3),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 20),
                    SizedBox(width: 8),
                    Text('Place Order',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Cart Item Card ────────────────────────────────────────

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  const _CartItemCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    Future<bool?> showDeleteConfirmation() async {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Remove Item', style: TextStyle(color: Color(0xFF0D1B2A), fontWeight: FontWeight.bold)),
            content: const Text('Are you sure you want to remove this item from your cart?', style: TextStyle(color: Color(0xFF778DA9))),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF778DA9))),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Remove', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }

    return Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDeleteConfirmation(),
      onDismissed: (_) => onRemove(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 26),
            SizedBox(height: 4),
            Text('Remove',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Image.network(
                item.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: const Color(0xFFE0E1DD),
                  child: const Icon(Icons.image_not_supported,
                      color: Color(0xFF778DA9)),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B2A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.brand,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF778DA9)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${item.price} DA',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF415A77),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Remove button
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () async {
                  final bool? confirm = await showDeleteConfirmation();
                  if (confirm == true) {
                    onRemove();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline,
                      color: Color(0xFF778DA9), size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
