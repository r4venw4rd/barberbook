class AppointmentMockService {
  Future<List<Map<String, dynamic>>> fetchServices() async {
    // Raw mock data returning JSON-like maps
    return const [
      {
        'id': 'classic-cut',
        'name': 'Classic Cut',
        'description': 'Consultation, precision cut and style finish',
        'price': 28.0,
        'durationMinutes': 30,
        'iconCodePoint': 0xe190, // Icons.content_cut.codePoint
        'category': 'haircut',
      },
      {
        'id': 'skin-fade',
        'name': 'Skin Fade',
        'description': 'Zero fade with razor detailing and styling',
        'price': 34.0,
        'durationMinutes': 45,
        'iconCodePoint': 0xe0e7, // Icons.blur_on.codePoint
        'category': 'haircut',
      },
      {
        'id': 'beard-trim',
        'name': 'Beard Trim',
        'description': 'Shape, line-up and beard oil treatment',
        'price': 18.0,
        'durationMinutes': 20,
        'iconCodePoint': 0xe253, // Icons.face.codePoint
        'category': 'beard',
      },
      {
        'id': 'hot-towel-shave',
        'name': 'Hot Towel Shave',
        'description': 'Classic straight razor shave with hot towels',
        'price': 26.0,
        'durationMinutes': 30,
        'iconCodePoint': 0xeb48, // Icons.spa.codePoint
        'category': 'shave',
      },
      {
        'id': 'wash-style',
        'name': 'Wash & Style',
        'description': 'Deep wash, scalp massage and blow-dry finish',
        'price': 22.0,
        'durationMinutes': 25,
        'iconCodePoint': 0xe119, // Icons.brush.codePoint
        'category': 'styling',
      },
      {
        'id': 'kids-cut',
        'name': 'Kids Cut',
        'description': 'Patient, friendly cut for children under 12',
        'price': 20.0,
        'durationMinutes': 25,
        'iconCodePoint': 0xeb3f, // Icons.child_friendly.codePoint
        'category': 'haircut',
      },
      {
        'id': 'full-package',
        'name': 'Full Package',
        'description': 'Skin fade, beard trim, hot towel and styling',
        'price': 45.0,
        'durationMinutes': 60,
        'iconCodePoint': 0xe1d6, // Icons.diamond.codePoint
        'category': 'package',
      },
    ];
  }

  Future<List<Map<String, dynamic>>> fetchBarbers() async {
    return const [
      {
        'id': 'marcus',
        'name': 'Marcus Reed',
        'specialty': 'Master barber · classic cuts',
        'yearsExperience': 12,
        'rating': 4.9,
        'reviewCount': 328,
        'initials': 'MR',
        'accentColorValue': 0xFFE5A93C,
        'isAvailableToday': true,
        'avatarUrl':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&auto=format&fit=crop&q=80',
      },
      {
        'id': 'diego',
        'name': 'Diego Santos',
        'specialty': 'Fade specialist · designs',
        'yearsExperience': 8,
        'rating': 4.8,
        'reviewCount': 214,
        'initials': 'DS',
        'accentColorValue': 0xFF3A3F4D,
        'isAvailableToday': true,
        'avatarUrl':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&auto=format&fit=crop&q=80',
      },
      {
        'id': 'liam',
        'name': "Liam O'Connor",
        'specialty': 'Beard sculpting · wet shaves',
        'yearsExperience': 6,
        'rating': 4.9,
        'reviewCount': 176,
        'initials': 'LO',
        'accentColorValue': 0xFF4A453A,
        'isAvailableToday': true,
        'avatarUrl':
            'https://images.unsplash.com/photo-1628157582853-a796fa650a6a?w=300&auto=format&fit=crop&q=80',
      },
      {
        'id': 'sofia',
        'name': 'Sofia Marin',
        'specialty': 'Stylist · cuts and colour',
        'yearsExperience': 10,
        'rating': 5.0,
        'reviewCount': 291,
        'initials': 'SM',
        'accentColorValue': 0xFF4E3D42,
        'isAvailableToday': false,
        'avatarUrl':
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300&auto=format&fit=crop&q=80',
      },
    ];
  }

  Future<List<Map<String, dynamic>>> fetchSeedAppointments() async {
    final now = DateTime.now();
    final upcoming = DateTime(now.year, now.month, now.day + 2, 14, 30);
    final past = DateTime(now.year, now.month, now.day - 6, 11);
    return [
      {
        'id': 'apt-1',
        'service': {
          'id': 'skin-fade',
          'name': 'Skin Fade',
          'description': 'Zero fade with razor detailing and styling',
          'price': 34.0,
          'durationMinutes': 45,
          'iconCodePoint': 0xe0e7,
          'category': 'haircut',
        },
        'barber': {
          'id': 'marcus',
          'name': 'Marcus Reed',
          'specialty': 'Master barber · classic cuts',
          'yearsExperience': 12,
          'rating': 4.9,
          'reviewCount': 328,
          'initials': 'MR',
          'accentColorValue': 0xFFE5A93C,
          'isAvailableToday': true,
          'avatarUrl':
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&auto=format&fit=crop&q=80',
        },
        'startIso': upcoming.toIso8601String(),
        'notes': 'Same length on top as last time',
        'status': 'confirmed',
        'price': 34.0,
      },
      {
        'id': 'apt-2',
        'service': {
          'id': 'hot-towel-shave',
          'name': 'Hot Towel Shave',
          'description': 'Classic straight razor shave with hot towels',
          'price': 26.0,
          'durationMinutes': 30,
          'iconCodePoint': 0xeb48,
          'category': 'shave',
        },
        'barber': {
          'id': 'liam',
          'name': "Liam O'Connor",
          'specialty': 'Beard sculpting · wet shaves',
          'yearsExperience': 6,
          'rating': 4.9,
          'reviewCount': 176,
          'initials': 'LO',
          'accentColorValue': 0xFF047857,
          'isAvailableToday': true,
          'avatarUrl':
              'https://images.unsplash.com/photo-1628157582853-a796fa650a6a?w=300&auto=format&fit=crop&q=80',
        },
        'startIso': past.toIso8601String(),
        'notes': '',
        'status': 'completed',
        'price': 26.0,
      },
      {
        'id': 'apt-3',
        'service': {
          'id': 'beard-trim',
          'name': 'Beard Trim',
          'description': 'Shape, line-up and beard oil treatment',
          'price': 18.0,
          'durationMinutes': 20,
          'iconCodePoint': 0xe253,
          'category': 'beard',
        },
        'barber': {
          'id': 'diego',
          'name': 'Diego Santos',
          'specialty': 'Fade specialist · designs',
          'yearsExperience': 8,
          'rating': 4.8,
          'reviewCount': 214,
          'initials': 'DS',
          'accentColorValue': 0xFF0891B2,
          'isAvailableToday': true,
          'avatarUrl':
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&auto=format&fit=crop&q=80',
        },
        'startIso': past.add(const Duration(days: -21)).toIso8601String(),
        'notes': '',
        'status': 'completed',
        'price': 18.0,
      },
    ];
  }
}
