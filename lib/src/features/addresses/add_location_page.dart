import '../../data/repositories/address/models/address_dtos.dart';
import '../../imports/imports.dart';
import 'providers/address_providers.dart';

@RoutePage()
class AddLocationPage extends HookConsumerWidget {
  final AddressResponseDto? address;

  const AddLocationPage({super.key, @queryParam this.address});

  bool get isEditing => address != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks
    final labelController = useTextEditingController(
      text: address?.label ?? 'المنزل',
    );
    final streetController = useTextEditingController(
      text: address?.street ?? '',
    );
    final cityController = useTextEditingController(text: address?.city ?? '');
    final buildingController = useTextEditingController(
      text: address?.buildingNumber ?? '',
    );
    final apartmentController = useTextEditingController(
      text: address?.apartmentNumber ?? '',
    );
    final isDefault = useState(address?.isDefault ?? false);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Notifier
    final notifier = ref.read(addressNotifierProvider.notifier);
    final state = ref.watch(addressNotifierProvider);

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      body: Column(
        children: [
          // Map Placeholder
          Stack(
            children: [
              Container(
                height: 280,
                color: colors.surfaceContainerHighest,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 64,
                        color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اضغط لتحديد الموقع على الخريطة',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Back button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () => context.router.maybePop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.shadow.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              // Location pin
              const Center(
                child: Icon(
                  Icons.location_on_rounded,
                  size: 48,
                  color: Color(0xFFC5A059),
                ),
              ),
            ],
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'تعديل العنوان' : 'تفاصيل العنوان',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      context,
                      'تسمية العنوان *',
                      labelController,
                      Icons.label_outline_rounded,
                      validator: (v) => v?.isEmpty == true
                          ? 'يرجى إدخال تسمية العنوان'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      context,
                      'الشارع *',
                      streetController,
                      Icons.signpost_outlined,
                      validator: (v) =>
                          v?.isEmpty == true ? 'يرجى إدخال الشارع' : null,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      context,
                      'المدينة *',
                      cityController,
                      Icons.location_city_outlined,
                      validator: (v) =>
                          v?.isEmpty == true ? 'يرجى إدخال المدينة' : null,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      context,
                      'رقم المبنى',
                      buildingController,
                      Icons.apartment_outlined,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      context,
                      'رقم الشقة',
                      apartmentController,
                      Icons.door_front_door,
                    ),
                    const SizedBox(height: 16),

                    // Default toggle
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_border_rounded,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'تعيين كعنوان افتراضي',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Switch(
                            value: isDefault.value,
                            onChanged: (v) => isDefault.value = v,
                            activeColor: colors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    AsyncButton.primary(
                      label: isEditing ? 'تحديث العنوان' : 'حفظ العنوان',
                      icon: Icons.save_rounded,
                      onPressed: () async {
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return Result.err('يرجى استكمال الحقول المطلوبة');
                        }

                        if (isEditing) {
                          final request = UpdateAddressRequestDto(
                            label: labelController.text.trim(),
                            street: streetController.text.trim(),
                            city: cityController.text.trim(),
                            buildingNumber: buildingController.text.trim(),
                            apartmentNumber: apartmentController.text.trim(),
                            isDefault: isDefault.value,
                          );
                          return notifier.updateAddress(address!.id, request);
                        } else {
                          final request = AddAddressRequestDto(
                            label: labelController.text.trim(),
                            fullName: '', // Get from user profile
                            phone: '', // Get from user profile
                            street: streetController.text.trim(),
                            city: cityController.text.trim(),
                            district: '',
                            buildingNumber: buildingController.text.trim(),
                            apartmentNumber: apartmentController.text.trim(),
                            isDefault: isDefault.value,
                          );
                          return notifier.addAddress(request);
                        }
                      },

                      successMessage: isEditing
                          ? 'تم تحديث العنوان بنجاح'
                          : 'تمت إضافة العنوان بنجاح',
                      onSuccess: () {
                        context.router.maybePop();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    BuildContext context,
    String label,
    TextEditingController ctrl,
    IconData icon, {
    String? Function(String?)? validator,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          textDirection: TextDirection.rtl,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: colors.onSurfaceVariant, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
