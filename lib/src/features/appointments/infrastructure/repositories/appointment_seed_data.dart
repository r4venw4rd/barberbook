import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment_status.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/service_category.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';

/// Builds the initial local demo appointments for an empty store.
List<Appointment> buildAppointmentSeedData(DateTime now) {
  final upcoming = DateTime(now.year, now.month, now.day + 2, 14, 30);
  final past = DateTime(now.year, now.month, now.day - 6, 11);
  return [
    Appointment(
      id: 'apt-1',
      service: const ShopService(
        id: 'skin-fade',
        name: 'Skin Fade',
        description: 'Zero fade with razor detailing and styling',
        price: 34,
        durationMinutes: 45,
        iconCodePoint: 0xe0e7,
        category: ServiceCategory.haircut,
      ),
      barber: const Barber(
        id: 'marcus',
        name: 'Marcus Reed',
        specialty: 'Master barber · classic cuts',
        yearsExperience: 12,
        rating: 4.9,
        reviewCount: 328,
        initials: 'MR',
        accentColorValue: 0xFFE5A93C,
        avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&auto=format&fit=crop&q=80',
      ),
      start: upcoming,
      notes: 'Same length on top as last time',
      status: AppointmentStatus.confirmed,
      price: 34,
    ),
    Appointment(
      id: 'apt-2',
      service: const ShopService(
        id: 'hot-towel-shave',
        name: 'Hot Towel Shave',
        description: 'Classic straight razor shave with hot towels',
        price: 26,
        durationMinutes: 30,
        iconCodePoint: 0xeb48,
        category: ServiceCategory.shave,
      ),
      barber: const Barber(
        id: 'liam',
        name: "Liam O'Connor",
        specialty: 'Beard sculpting · wet shaves',
        yearsExperience: 6,
        rating: 4.9,
        reviewCount: 176,
        initials: 'LO',
        accentColorValue: 0xFF047857,
        avatarUrl: 'https://images.unsplash.com/photo-1628157582853-a796fa650a6a?w=300&auto=format&fit=crop&q=80',
      ),
      start: past,
      notes: '',
      status: AppointmentStatus.completed,
      price: 26,
    ),
    Appointment(
      id: 'apt-3',
      service: const ShopService(
        id: 'beard-trim',
        name: 'Beard Trim',
        description: 'Shape, line-up and beard oil treatment',
        price: 18,
        durationMinutes: 20,
        iconCodePoint: 0xe253,
        category: ServiceCategory.beard,
      ),
      barber: const Barber(
        id: 'diego',
        name: 'Diego Santos',
        specialty: 'Fade specialist · designs',
        yearsExperience: 8,
        rating: 4.8,
        reviewCount: 214,
        initials: 'DS',
        accentColorValue: 0xFF0891B2,
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&auto=format&fit=crop&q=80',
      ),
      start: past.subtract(const Duration(days: 21)),
      notes: '',
      status: AppointmentStatus.completed,
      price: 18,
    ),
  ];
}
