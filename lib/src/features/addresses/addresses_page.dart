import '../../data/repositories/address/models/address_dtos.dart';
import '../../imports/imports.dart';
import '../widgets/elite_top_bar.dart';
import '../widgets/elite_empty_state.dart';
import 'providers/address_notifier.dart';
import 'providers/address_providers.dart';

@RoutePage()
class AddressesPage extends HookConsumerWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addressNotifierProvider);
    final notifier = ref.read(addressNotifierProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Load addresses on mount
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.loadAddresses();
      });
      return null;
    }, []);

    // Show success message
    useEffect(() {
      if (state.successMessage != null) {
        AppToast.success(context, message: state.successMessage!);
        notifier.clearSuccessMessage();
      }
      return null;
    }, [state.successMessage]);

    // Show error message
    useEffect(() {
      if (state.errorMessage != null) {
        AppToast.error(context, message: state.errorMessage!);
        notifier.clearError();
      }
      return null;
    }, [state.errorMessage]);

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      appBar: const EliteTopBar(title: 'العناوين المحفوظة', showBack: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.router.push(AddLocationRoute()).then((_) {
            notifier.loadAddresses();
          });
        },
        icon: const Icon(Icons.add_location_rounded),
        label: const Text('إضافة عنوان'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.addresses.isEmpty
          ? const EliteEmptyState(
              icon: Icons.location_off_outlined,
              title: 'لا توجد عناوين',
              description:
                  'لم تقم بحفظ أي عناوين بعد. أضف عنواناً جديداً للبدء.',
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final addr = state.addresses[index];
                return _buildAddressCard(
                  context,
                  addr,
                  notifier,
                  colors,
                  textTheme,
                );
              },
            ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    AddressResponseDto addr,
    AddressNotifier notifier,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: addr.isDefault
              ? colors.primary.withValues(alpha: 0.4)
              : colors.outlineVariant.withValues(alpha: 0.35),
          width: addr.isDefault ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: addr.isDefault
                  ? colors.primaryContainer
                  : colors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: addr.isDefault ? colors.primary : colors.onSurfaceVariant,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      addr.label,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (addr.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'افتراضي',
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  addr.formattedAddress,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: colors.onSurfaceVariant),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  context.router.push(AddLocationRoute(address: addr));
                  break;
                case 'default':
                  notifier.setDefaultAddress(addr.id);
                  break;
                case 'delete':
                  _showDeleteDialog(context, addr.id, notifier);
                  break;
              }
            },
            itemBuilder: (context) => [
              if (!addr.isDefault)
                const PopupMenuItem(
                  value: 'default',
                  child: Text('تعيين كافتراضي'),
                ),
              const PopupMenuItem(value: 'edit', child: Text('تعديل')),
              const PopupMenuItem(value: 'delete', child: Text('حذف')),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    int addressId,
    AddressNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العنوان'),
        content: const Text('هل أنت متأكد من حذف هذا العنوان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              notifier.deleteAddress(addressId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
