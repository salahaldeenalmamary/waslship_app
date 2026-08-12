import '../../../imports/imports.dart';
import '../models/shipment_form_data.dart';
import '../providers/create_shipment_provider.dart';

class Step3Confirmation extends ConsumerWidget {
  const Step3Confirmation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createShipmentProvider);
    final data = state.formData;
    final carrier = state.selectedCarrier;
    final sender = state.senderAddress;
    final recipient = state.recipientAddress;
    final shippingCost = double.tryParse(data.package.shippingCost) ?? 0;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Confirmation Header ──────────────────────────────────────────────
          Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: context.successLightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: context.successColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'جاهز للطباعة',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: context.brandGold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تمت مراجعة جميع البيانات والبيانات المالية وتأكيد رصيدك',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.onSurfaceVariantColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Shipment Summary Card ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.surfaceContainerLowestColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.outlineVariantColor,
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
              children: [
                // Carrier Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.surfaceContainerLowColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: context.outlineVariantColor,
                            ),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(
                            carrier?.logoAsset ?? '',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.local_shipping,
                                color: context.outlineVariantColor,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'شركة الشحن',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.outlineColor,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              carrier?.name ?? state.selectedCarrierId ?? '',
                              style: context.textTheme.titleSmall?.copyWith(
                                color: context.onSurfaceColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.successLightColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'مستعجل',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.successColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Route Timeline
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.surfaceContainerLowColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.outlineVariantColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: context.brandGold,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'مسار الشحنة المباشر',
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: context.brandGold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: context.successLightColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: context.successColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: context.successColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'جاهز للإنشاء والطباعة',
                                  style: context.textTheme.labelSmall?.copyWith(
                                    color: context.successColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTimelineNode(
                        context,
                        icon: Icons.business,
                        iconColor: context.brandGold,
                        label: 'نقطة الانطلاق (Origin)',
                        time: 'اليوم - جاهز',
                        title: sender?.fullName ?? 'المرسل',
                        subtitle:
                            sender?.shortAddress ??
                            'الرياض، المملكة العربية السعودية',
                        code: 'HUB-RUH',
                        isFirst: true,
                      ),
                      _buildTimelineNode(
                        context,
                        icon: Icons.local_shipping,
                        iconColor: context.brandGold,
                        label: 'الناقل المعتمد',
                        time: carrier?.name ?? '',
                        title: 'مركز التجميع والتوزيع الرئيسي',
                        subtitle:
                            'التسليم المتوقع خلال ${carrier?.estimatedTime ?? '24-48 ساعة'}',
                        isTransit: true,
                      ),
                      _buildTimelineNode(
                        context,
                        icon: Icons.navigation,
                        iconColor: context.outlineColor,
                        label: 'وجهة التسليم (Destination)',
                        title: recipient?.fullName ?? 'المستلم',
                        subtitle: recipient?.shortAddress ?? '',
                        phone: recipient?.phone,
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  height: 1,
                  color: context.outlineVariantColor.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 16),
                _buildParametersGrid(context, data),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Cost Breakdown Card ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.primaryColor,
                  context.primaryColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildCostRow(
                  context,
                  label: 'رسوم الشحن:',
                  value: '${data.package.shippingCost} SAR',
                  isBold: false,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: context.onPrimaryColor.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 12),
                _buildCostRow(
                  context,
                  label: 'إجمالي الخصم المستقطع:',
                  value: '${shippingCost.toStringAsFixed(2)} SAR',
                  isBold: true,
                  isLarge: true,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: context.onPrimaryColor.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 12),
                _buildCostRow(
                  context,
                  label: 'رصيدك المتبقي بعد الخصم',
                  value: '${(1250 - shippingCost).toStringAsFixed(2)} SAR',
                  isBold: true,
                  icon: Icons.account_balance_wallet,
                  iconColor: context.onPrimaryColor.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Warning Banner ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.surfaceContainerHighColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: context.brandGold, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'بمجرد الضغط على طباعة، سيتم حسم ${shippingCost.toStringAsFixed(2)} ر.س من محفظتك وتوليد البوليصة فوراً.',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.onSurfaceVariantColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Success Toast ────────────────────────────────────────────────────
          if (state.showSuccessToast)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.successColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'تم توليد البوليصة وطباعتها بنجاح! جاري تحويلك...',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 140),
        ],
      ),
    );
  }

  Widget _buildCostRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isBold = false,
    bool isLarge = false,
    IconData? icon,
    Color? iconColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color:
                    iconColor ?? context.onPrimaryColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.onPrimaryColor.withValues(alpha: 0.7),
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
        Text(
          value,
          style:
              (isLarge
                      ? context.textTheme.headlineMedium
                      : context.textTheme.bodySmall)
                  ?.copyWith(
                    color: context.onPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
        ),
      ],
    );
  }

  Widget _buildTimelineNode(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    String? time,
    required String title,
    required String subtitle,
    String? code,
    String? phone,
    bool isFirst = false,
    bool isTransit = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isTransit || isFirst
                        ? context.brandGold
                        : context.surfaceContainerHighColor,
                    shape: BoxShape.circle,
                    border: isLast
                        ? Border.all(
                            color: context.outlineVariantColor,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: 13,
                    color: isFirst || isTransit ? Colors.white : iconColor,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: context.brandGold.withValues(alpha: 0.4),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isTransit || isFirst
                            ? context.brandGoldLight
                            : context.surfaceContainerHighColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        label,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: isTransit || isFirst
                              ? context.brandGold
                              : context.outlineColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if (time != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          time,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.outlineColor,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.onSurfaceColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.onSurfaceVariantColor,
                    fontSize: 11,
                  ),
                ),
                if (phone != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '📞 $phone',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.outlineColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (code != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: context.surfaceContainerLowestColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: context.outlineVariantColor.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                code,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.outlineColor,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParametersGrid(BuildContext context, ShipmentFormData data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildParamItem(
                context,
                label: 'نوع المحتوى',
                value: data.package.contentType,
              ),
            ),
            Expanded(
              child: _buildParamItem(
                context,
                label: 'الوزن',
                value: '${data.package.weight} kg',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildParamItem(
                context,
                label: 'الأبعاد (L × W × H)',
                value:
                    '${data.package.length} × ${data.package.width} × ${data.package.height} cm',
              ),
            ),
            Expanded(
              child: _buildParamItem(
                context,
                label: 'قيمة الطلب',
                value: '${data.payment.orderAmount} SAR',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildParamItem(
                context,
                label: 'مبلغ التحصيل',
                value: (double.tryParse(data.payment.codAmount) ?? 0) > 0
                    ? '${data.payment.codAmount} SAR'
                    : '0 (مدفوع مسبقاً)',
              ),
            ),
            Expanded(
              child: _buildParamItem(
                context,
                label: 'تكلفة الشحن',
                value: '${data.package.shippingCost} SAR',
                valueColor: context.brandGold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParamItem(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.outlineColor,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(
            color: valueColor ?? context.onSurfaceColor,
          ),
        ),
      ],
    );
  }
}
