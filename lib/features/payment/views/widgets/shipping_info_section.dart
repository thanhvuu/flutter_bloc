import 'package:flutter/material.dart';

class ShippingInfoSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController zipCodeController;
  final TextEditingController phoneController;
  final VoidCallback? onGetLocation;
  final bool isLocationLoading;

  const ShippingInfoSection(
      {super.key,
      required this.firstNameController,
      required this.lastNameController,
      required this.addressLine1Controller,
      required this.addressLine2Controller,
      required this.cityController,
      required this.zipCodeController,
      required this.phoneController,
      this.onGetLocation,
      this.isLocationLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_shipping_outlined, size: 20),
              SizedBox(width: 8),
              Text('SHIPPING INFORMATION',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildTextField('FIRST NAME', firstNameController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('LAST NAME', lastNameController)),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: onGetLocation,
              icon: isLocationLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.black))
                  : const Icon(Icons.gps_fixed, size: 16, color: Colors.black),
              label: const Text(
                'USE MY CURRENT LOCATION',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          _buildTextField('ADDRESS LINE 1', addressLine1Controller),
          const SizedBox(height: 12),
          _buildTextField('ADDRESS LINE 2 (OPTIONAL)', addressLine2Controller),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField('CITY', cityController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('ZIP CODE', zipCodeController)),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField('PHONE NUMBER', phoneController),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
          ),
        ),
      ],
    );
  }
}
