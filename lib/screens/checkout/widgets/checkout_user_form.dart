import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_colors.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_flower_shop/data/services/address_search_service.dart';

class CheckoutUserForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final bool isDelivery;

  final void Function(AddressSuggestion suggestion) onAddressSelected;
  final VoidCallback onAddressChanged;

  const CheckoutUserForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.isDelivery,
    required this.onAddressSelected,
    required this.onAddressChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          'Full name',
          nameController,
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Please enter your full name'
              : null,
          capitalize: true,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          'Email',
          emailController,
          keyboard: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Email is required';
            if (!v.contains('@')) return 'Enter a valid email address';
            return null;
          },
        ),
        const SizedBox(height: 12),
        _buildTextField(
          'Phone number',
          phoneController,
          keyboard: TextInputType.phone,
          validator: (v) =>
              v == null || v.isEmpty ? 'Phone number is required' : null,
        ),
        const SizedBox(height: 12),
        if (isDelivery) _buildAddressField(context),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    bool capitalize = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      textCapitalization: capitalize
          ? TextCapitalization.words
          : TextCapitalization.none,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return TypeAheadField<AddressSuggestion>(
      suggestionsCallback: AddressSearchService.search,
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(
            suggestion.displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
      onSelected: (suggestion) {
        addressController.text = suggestion.displayName;
        FocusManager.instance.primaryFocus?.unfocus();
        onAddressSelected(suggestion);
      },
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: (v) {
            if (!isDelivery) return null;
            if (v == null || v.isEmpty) {
              return 'Delivery address is required';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Delivery address',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.streetAddress,
          onChanged: (_) => onAddressChanged(),
        );
      },
    );
  }
}
