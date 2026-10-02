import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/service_category.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';

part 'shop_service_dto.freezed.dart';
part 'shop_service_dto.g.dart';

@freezed
abstract class ShopServiceDto with _$ShopServiceDto {
  const factory({
    required String id,
    required String name,
    required String description,
    required double price,
    required int durationMinutes,
    required int iconCodePoint,
    required String category,
  }) = _ShopServiceDto;
  const new _();

  factory fromJson(Map<String, dynamic> json) => _$ShopServiceDtoFromJson(json);

  factory fromDomain(ShopService service) => ShopServiceDto(
    id: service.id,
    name: service.name,
    description: service.description,
    price: service.price,
    durationMinutes: service.durationMinutes,
    iconCodePoint: service.iconCodePoint,
    category: service.category.name,
  );

  ShopService toDomain() => ShopService(
    id: id,
    name: name,
    description: description,
    price: price,
    durationMinutes: durationMinutes,
    iconCodePoint: iconCodePoint,
    category: ServiceCategory.values.byName(category),
  );
}
