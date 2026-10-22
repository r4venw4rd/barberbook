import 'package:barberbook/src/features/appointments/domain/entities/service_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_service.freezed.dart';

@freezed
abstract class ShopService with _$ShopService {
  const factory({
    required String id,
    required String name,
    required String description,
    required double price,
    required int durationMinutes,
    required int iconCodePoint,
    required ServiceCategory category,
  }) = _ShopService;
  const new _();

  String get durationLabel => '$durationMinutes min';
  String get priceLabel => '\$${price.toStringAsFixed(0)}';
}
