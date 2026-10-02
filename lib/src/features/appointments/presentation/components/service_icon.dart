import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';

IconData serviceIcon(ShopService service) => switch (service.id) {
  'classic-cut' => Icons.content_cut,
  'skin-fade' => Icons.blur_on,
  'beard-trim' => Icons.face,
  'hot-towel-shave' => Icons.spa,
  'wash-style' => Icons.brush,
  'kids-cut' => Icons.child_friendly,
  'full-package' => Icons.diamond,
  _ => Icons.content_cut,
};
