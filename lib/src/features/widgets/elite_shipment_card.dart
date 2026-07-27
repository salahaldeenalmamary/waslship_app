import 'package:flutter/material.dart';

class EliteShipmentData {
  const EliteShipmentData({
    required this.id,
    required this.date,
    required this.status,
    required this.customer,
    required this.location,
    required this.count,
    required this.statusType,
    this.errorReason,
  });

  final String id;
  final String date;
  final String status;
  final String customer;
  final String location;
  final int count;
  final EliteShipmentStatus statusType;
  final String? errorReason;
}

enum EliteShipmentStatus { delivered, inTransit, returned, pending }

/// Shipment card used in the Shipments screen list.
/// Mirrors the ShipmentCard component from waslship-elite.
class EliteShipmentCard extends StatelessWidget {
  const EliteShipmentCard({super.key, required this.shipment, this.onTrack});

  final EliteShipmentData shipment;
  final VoidCallback? onTrack;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color badgeBg;
    Color badgeFg;

    switch (shipment.statusType) {
      case EliteShipmentStatus.delivered:
        badgeBg = const Color(0xFF10B981).withValues(alpha: 0.1);
        badgeFg = const Color(0xFF10B981);
      case EliteShipmentStatus.inTransit:
        badgeBg = Colors.blue.withValues(alpha: 0.1);
        badgeFg = Colors.blue.shade700;
      case EliteShipmentStatus.returned:
        badgeBg = colors.errorContainer;
        badgeFg = colors.error;
      case EliteShipmentStatus.pending:
        badgeBg = colors.surfaceContainerHighest;
        badgeFg = colors.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                shipment.id,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  shipment.status,
                  style: textTheme.labelSmall?.copyWith(
                    color: badgeFg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            shipment.date,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),

          // Customer & Location
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 16,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  shipment.customer,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  shipment.location,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${shipment.count} طرد',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          if (shipment.errorReason != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colors.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 14,
                    color: colors.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    shipment.errorReason!,
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          // Track Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onTrack,
              icon: const Icon(Icons.location_searching_rounded, size: 16),
              label: const Text('تتبع الشحنة'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: BorderSide(color: colors.primary.withValues(alpha: 0.4)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
