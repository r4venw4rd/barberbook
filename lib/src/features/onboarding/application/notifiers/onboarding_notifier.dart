import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_dryer_app/src/core/database/local_storage_service.dart';

const String _onboardingSeenKey = 'has_seen_onboarding_v1';

/// Provider for whether the user has completed or skipped the onboarding tutorial.
final onboardingCompletedProvider =
    NotifierProvider<OnboardingNotifier, bool>(OnboardingNotifier.new);

/// Manages onboarding completion state backed by local storage.
class OnboardingNotifier extends Notifier<bool> {
  @override
  bool build() {
    final storage = ref.watch(localStorageProvider);
    if (storage == null) return false;
    return storage.getBool(_onboardingSeenKey) ?? false;
  }

  /// Marks onboarding as completed.
  Future<void> completeOnboarding() async {
    state = true;
    final storage = ref.read(localStorageProvider);
    if (storage != null) {
      await storage.setBool(_onboardingSeenKey, value: true);
    }
  }

  /// Resets onboarding status so the user can re-watch the tutorial.
  Future<void> resetOnboarding() async {
    state = false;
    final storage = ref.read(localStorageProvider);
    if (storage != null) {
      await storage.setBool(_onboardingSeenKey, value: false);
    }
  }
}
