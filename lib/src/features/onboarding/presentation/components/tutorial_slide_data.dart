import 'package:flutter/material.dart';

/// Content displayed on a single onboarding slide.
class TutorialSlideData {
  const new({
    required this.tag,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String tag;
  final String title;
  final String description;
  final IconData icon;
}

/// The app's three introductory tutorial slides.
const tutorialSlides = [
  TutorialSlideData(
    tag: 'ARTISAN CRAFT',
    title: 'Master Barbers,\nSignature Cuts',
    description:
        'Experience precision grooming tailored to your style. From razor-sharp skin fades to executive beard detailing.',
    icon: Icons.content_cut_rounded,
  ),
  TutorialSlideData(
    tag: 'SEAMLESS BOOKING',
    title: 'Reserve Your Chair\nin 60 Seconds',
    description:
        'Browse live barber availability, select your signature services, and lock in your appointment with zero wait time.',
    icon: Icons.calendar_month_rounded,
  ),
  TutorialSlideData(
    tag: 'VIP EXPERIENCE',
    title: 'The Ultimate\nLounge Retreat',
    description:
        'Indulge in complimentary craft refreshments, hot steam towels, and premium organic styling treatments.',
    icon: Icons.workspace_premium_rounded,
  ),
];
