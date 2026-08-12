// File: lib/features/create_shipment/models/carrier.dart

import 'package:flutter/material.dart';

enum CarrierBadgeType { trusted, fastest, international, nearest }

class Carrier {
  final String id;
  final String name;
  final String logoAsset;

  /// Remote logo URL returned by the API (takes priority over [logoAsset]).
  final String? logoUrl;
  final String estimatedTime;
  final String price;
  final String paymentType;
  final String badge;
  final CarrierBadgeType badgeType;
  final bool isRecommended;

  /// The numerical delivery-option ID required by ShipmentRepo to trigger shipment.
  final int? deliveryOptionId;

  const Carrier({
    required this.id,
    required this.name,
    required this.logoAsset,
    this.logoUrl,
    required this.estimatedTime,
    required this.price,
    required this.paymentType,
    required this.badge,
    required this.badgeType,
    required this.isRecommended,
    this.deliveryOptionId,
  });

  IconData get badgeIcon {
    switch (badgeType) {
      case CarrierBadgeType.trusted:
        return Icons.shield_outlined;
      case CarrierBadgeType.fastest:
        return Icons.bolt;
      case CarrierBadgeType.international:
        return Icons.public;
      case CarrierBadgeType.nearest:
        return Icons.location_on_outlined;
    }
  }
}
