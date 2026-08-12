import '../../../imports/imports.dart';
import '../../../data/repositories/address/models/address_dtos.dart';
import '../providers/create_shipment_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Main Screen Widget
// ─────────────────────────────────────────────────────────────────────────────

class Step1ShipmentForm extends ConsumerWidget {
  const Step1ShipmentForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createShipmentProvider);
    final notifier = ref.read(createShipmentProvider.notifier);
    final errors = state.errors;
    final data = state.formData;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errors.isNotEmpty) _ErrorBanner(errors: errors),

          const SizedBox(height: 16),

          const _SectionHeader(icon: Icons.person, title: 'عنوان المرسل'),
          const SizedBox(height: 12),
          state.addresses.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(e.toString()),
            data: (list) => _AddressPicker(
              addresses: list,
              selected: state.senderAddress,
              error: errors['senderAddress'],
              onSelect: notifier.selectSenderAddress,
            ),
          ),

          const SizedBox(height: 24),

          const _SectionHeader(
            icon: Icons.local_shipping,
            title: 'عنوان المستلم',
          ),
          const SizedBox(height: 12),
          state.addresses.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(e.toString()),
            data: (list) => _AddressPicker(
              addresses: list,
              selected: state.recipientAddress,
              error: errors['recipientAddress'],
              onSelect: notifier.selectRecipientAddress,
            ),
          ),

          const SizedBox(height: 24),

          const _SectionHeader(
            icon: Icons.inventory_2,
            title: 'تفاصيل الطرد والأبعاد',
          ),
          const SizedBox(height: 12),
          _InfoCard(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _FormTextField(
                      label: 'نوع المحتوى *',
                      value: data.package.contentType,
                      error: errors['contentType'],
                      onChanged: notifier.updateContentType,
                      placeholder: 'ملابس، إلكترونيات...',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FormTextField(
                      label: 'الوزن (كجم) *',
                      value: data.package.weight,
                      error: errors['weight'],
                      onChanged: notifier.updateWeight,
                      placeholder: '2.5',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _DimensionsRow(
                length: data.package.length,
                width: data.package.width,
                height: data.package.height,
                errors: errors,
                onLengthChanged: notifier.updateLength,
                onWidthChanged: notifier.updateWidth,
                onHeightChanged: notifier.updateHeight,
              ),
              const SizedBox(height: 16),
              _FormTextField(
                label: 'رسوم الشحن المتوقعة (ر.س) *',
                value: data.package.shippingCost,
                error: errors['shippingCost'],
                onChanged: notifier.updateShippingCost,
                placeholder: '32.00',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          const _SectionHeader(
            icon: Icons.receipt_long,
            title: 'القيم المالية والدفع',
          ),
          const SizedBox(height: 12),
          _InfoCard(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _FormTextField(
                      label: 'إجمالي قيمة الطلب (ر.س) *',
                      value: data.payment.orderAmount,
                      error: errors['amount'],
                      onChanged: notifier.updateOrderAmount,
                      placeholder: '150.00',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      helperText: 'إجمالي قيمة المنتجات بالطرود',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FormTextField(
                      label: 'مبلغ الدفع عند الاستلام *',
                      value: data.payment.codAmount,
                      error: errors['codAmount'],
                      onChanged: notifier.updateCodAmount,
                      placeholder: '0 = مدفوع مسبقاً',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      helperText: 'ضع 0 للشحنات المدفوعة مسبقاً',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _CodStatusBadge(codAmount: data.payment.codAmount),
            ],
          ),

          const SizedBox(height: 24),

          const _DeliveryInfoBanner(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.errors});

  final Map<String, String> errors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.errorContainerColor.withValues(alpha: 0.5),
        border: Border.all(color: context.errorColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: context.errorColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يرجى استكمال البيانات المطلوبة وتصحيح الأخطاء التالية:',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.errorColor,
                  ),
                ),
                const SizedBox(height: 4),
                ...errors.values.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      '• $e',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.errorColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: context.brandGold, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.brandGold,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.children,
    this.backgroundColor,
    this.borderColor,
  });

  final List<Widget> children;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.surfaceContainerLowestColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              borderColor ?? context.outlineVariantColor.withValues(alpha: 0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: context.onSurfaceColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _AddressPicker extends StatelessWidget {
  const _AddressPicker({
    required this.addresses,
    required this.selected,
    required this.error,
    required this.onSelect,
  });

  final List<AddressResponseDto> addresses;
  final AddressResponseDto? selected;
  final String? error;
  final ValueChanged<AddressResponseDto> onSelect;

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.surfaceContainerLowColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.outlineVariantColor),
        ),
        child: Text(
          'لا توجد عناوين محفوظة. أضف عنواناً من صفحة العناوين.',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.onSurfaceVariantColor,
          ),
        ),
      );
    }

    return Column(
      children: [
        ...addresses.map(
          (addr) => _AddressCard(
            address: addr,
            isSelected: selected?.id == addr.id,
            onTap: () => onSelect(addr),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(
            error!,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.errorColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  final AddressResponseDto address;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.brandGoldLight
              : context.surfaceContainerLowestColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? context.brandGold : context.outlineVariantColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? context.brandGold
                  : context.outlineVariantColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.label,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.onSurfaceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: context.brandGoldLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'افتراضي',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.brandGold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address.fullName,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.onSurfaceColor,
                    ),
                  ),
                  Text(
                    address.shortAddress,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.onSurfaceVariantColor,
                    ),
                  ),
                  Text(
                    address.phone,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.outlineColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormTextField extends StatelessWidget {
  const _FormTextField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.error,
    this.placeholder,
    this.keyboardType,
    this.inputFormatters,
    this.helperText,
  });

  final String label;
  final String value;
  final String? error;
  final ValueChanged<String> onChanged;
  final String? placeholder;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.onSurfaceVariantColor,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.collapsed(offset: value.length),
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textDirection: TextDirection.rtl,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.onSurfaceColor,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: context.outlineVariantColor,
              fontWeight: FontWeight.normal,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: error != null
                    ? context.errorColor
                    : context.outlineVariantColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: error != null
                    ? context.errorColor
                    : context.outlineVariantColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: error != null ? context.errorColor : context.brandGold,
                width: 2,
              ),
            ),
            errorText: error,
            errorStyle: context.textTheme.bodySmall?.copyWith(
              color: context.errorColor,
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.outlineColor,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }
}

class _DimensionsRow extends StatelessWidget {
  const _DimensionsRow({
    required this.length,
    required this.width,
    required this.height,
    required this.errors,
    required this.onLengthChanged,
    required this.onWidthChanged,
    required this.onHeightChanged,
  });

  final String length;
  final String width;
  final String height;
  final Map<String, String> errors;
  final ValueChanged<String> onLengthChanged;
  final ValueChanged<String> onWidthChanged;
  final ValueChanged<String> onHeightChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.straighten, size: 14, color: context.brandGold),
            const SizedBox(width: 4),
            Text(
              'أبعاد الطرد (سم) - [الطول × العرض × الارتفاع] *',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.onSurfaceVariantColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _DimensionField(
                label: 'الطول',
                value: length,
                error: errors['length'],
                onChanged: onLengthChanged,
                placeholder: '30',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DimensionField(
                label: 'العرض',
                value: width,
                error: errors['width'],
                onChanged: onWidthChanged,
                placeholder: '20',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DimensionField(
                label: 'الارتفاع',
                value: height,
                error: errors['height'],
                onChanged: onHeightChanged,
                placeholder: '15',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DimensionField extends StatelessWidget {
  const _DimensionField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.placeholder,
    this.error,
  });

  final String label;
  final String value;
  final String? error;
  final ValueChanged<String> onChanged;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.outlineColor,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.collapsed(offset: value.length),
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.onSurfaceColor,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: context.textTheme.bodySmall?.copyWith(
              color: context.outlineVariantColor,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: error != null
                    ? context.errorColor
                    : context.outlineVariantColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: error != null
                    ? context.errorColor
                    : context.outlineVariantColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: error != null ? context.errorColor : context.brandGold,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CodStatusBadge
// ─────────────────────────────────────────────────────────────────────────────

class _CodStatusBadge extends StatelessWidget {
  const _CodStatusBadge({required this.codAmount});

  final String codAmount;

  @override
  Widget build(BuildContext context) {
    final isPrePaid = (double.tryParse(codAmount) ?? 0) <= 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceContainerLowColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.outlineVariantColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'نوع التحصيل المالي:',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.onSurfaceVariantColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isPrePaid
                  ? context.successLightColor
                  : context.warningLightColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isPrePaid
                    ? context.successColor.withValues(alpha: 0.3)
                    : context.warningColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              isPrePaid
                  ? 'مدفوع مسبقاً (Pre-paid)'
                  : 'تحصيل عند الاستلام ($codAmount ر.س)',
              style: context.textTheme.labelSmall?.copyWith(
                color: isPrePaid ? context.successColor : context.warningColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryInfoBanner extends StatelessWidget {
  const _DeliveryInfoBanner();

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      backgroundColor: context.successLightColor,
      borderColor: context.successColor.withValues(alpha: 0.2),
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.surfaceContainerLowestColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.access_time,
                color: context.successColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'توصيل سريع وموثوق',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.onSurfaceColor,
                    ),
                  ),
                  Text(
                    'شحناتك تصل خلال 24-48 ساعة كحد أقصى.',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.onSurfaceVariantColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
