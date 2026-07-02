import 'package:flutter/material.dart';
import 'package:bloc_app_demo/domain/entities/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 3; 

  final List<Color> _colors = [Colors.black, const Color(0xFFC00010), Colors.white];
  final List<String> _sizes = ['US 7', 'US 8', 'US 9', 'US 10', 'US 11', 'US 12', 'US 13'];
  final List<bool> _isSizeAvailable = [true, true, true, true, true, true, false]; 

  final Color _primaryRed = const Color(0xFFC00010);

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'ELITE ATHLETE',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18),
        ),
      ),

       body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartRequireAuth) {
            // Chưa đăng nhập -> Hiện Dialog
            _showLoginRequiredDialog(context);
          } else if (state is CartItemAddedSuccess) {
            // Thêm thành công -> Hiện SnackBar xanh lá báo hiệu
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã thêm sản phẩm vào giỏ hàng!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProductImage(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 24),
                  _buildColorSelection(),
                  const SizedBox(height: 24),
                  _buildSizeSelection(),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                  const SizedBox(height: 32),
                  _buildShippingInfo(),
                  const Divider(height: 48, thickness: 1, color: Color(0xFFEEEEEE)),
                  _buildDescription(),
                  const SizedBox(height: 32),
                  _buildKeyFeatures(),
                  const SizedBox(height: 32),
                  _buildTechnicalSpecs(),
                  const SizedBox(height: 32),
                  _buildPromoBanner(),
                ],
              ),
            )
          ],
        ),
      ),

    ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 300,
      width: double.infinity,
      color: const Color(0xFFF0F0F0),
      child: Image.network(
        widget.product.imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.category.toUpperCase(), 
          style: TextStyle(color: _primaryRed, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.name.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${widget.product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildColorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('product_detail.select_color'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: List.generate(_colors.length, (index) {
            bool isSelected = _selectedColorIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedColorIndex = index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _colors[index],
                  border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: isSelected ? 2 : 1),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('product_detail.select_size'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('product_detail.size_guide'.tr(), style: TextStyle(fontSize: 12, color: Colors.grey.shade600, decoration: TextDecoration.underline)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_sizes.length, (index) {
            bool isSelected = _selectedSizeIndex == index;
            bool isAvailable = _isSizeAvailable[index];
            return GestureDetector(
              onTap: isAvailable ? () => setState(() => _selectedSizeIndex = index) : null,
              child: Container(
                width: (MediaQuery.of(context).size.width - 40 - 24) / 4, 
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : (isAvailable ? Colors.white : Colors.grey.shade100),
                  border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
                ),
                alignment: Alignment.center,
                child: Text(
                  _sizes[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : (isAvailable ? Colors.black : Colors.grey.shade400),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            final cartItem = CartItem (
              id: widget.product.id,
              product: widget.product,
              quantity: 1,
            );
            context.read<CartBloc>().add(AddToCartEvent(cartItem));
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryRed,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 0,
          ),
          child: Text('product_detail.add_to_cart'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Colors.black, width: 1.5),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Text('product_detail.buy_now'.tr(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildShippingInfo() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.local_shipping_outlined, size: 16, color: Colors.black54),
            const SizedBox(width: 12),
            Text('product_detail.express_shipping'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.assignment_return_outlined, size: 16, color: Colors.black54),
            const SizedBox(width: 12),
            Text('product_detail.returns'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('product_detail.performance'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Text(
          widget.product.description, 
          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildKeyFeatures() {
    final features = [
      'product_detail.feature_1'.tr(),
      'product_detail.feature_2'.tr(),
      'product_detail.feature_3'.tr(),
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('product_detail.key_features'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Divider(color: Colors.black, thickness: 1),
        const SizedBox(height: 8),
        ...features.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('✓ ', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Expanded(child: Text(e, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5))),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildTechnicalSpecs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('product_detail.tech_specs'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Divider(color: Colors.black, thickness: 1),
        _buildSpecRow('product_detail.offset'.tr(), '8mm'),
        _buildSpecRow('product_detail.surface'.tr(), 'product_detail.road_track'.tr()),
        _buildSpecRow('product_detail.support'.tr(), 'product_detail.neutral'.tr()),
      ],
    );
  }

  Widget _buildSpecRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      height: 400,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF222222), Colors.black],
              )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'product_detail.promo_1'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              Text(
                'product_detail.promo_2'.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Yêu cầu Đăng nhập', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Bạn cần phải đăng nhập để thêm sản phẩm vào giỏ hàng.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('HỦY', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(dialogContext); 
                context.pop(); 
                StatefulNavigationShell.of(context).goBranch(3); 
              },
              child: const Text('ĐĂNG NHẬP NGAY', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
