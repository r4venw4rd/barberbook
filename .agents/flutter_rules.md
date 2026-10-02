# 📐 Flutter Architectural Blueprint — rules.md
# Bu dosya projenin kalıcı context'idir. Her task'ta açık olmalı.

**Core Philosophy:** Services fetch. Repositories enforce. Notifiers serve. UI only renders.

---

## 1. Stack (Non-Negotiable)

| Concern | Package |
|---|---|
| Global State | `hooks_riverpod` v2.0+ — `Notifier` & `AsyncNotifier` only |
| Local State | `flutter_hooks` — replaces `StatefulWidget` entirely |
| Routing | `go_router` + `go_router_builder` — type-safe, zero magic strings |
| Immutability | `freezed` + `freezed_annotation` |
| Serialization | `json_serializable` — DTOs only |
| Functional Core | `fpdart` — `Either<Failure, T>` in all repository returns |
| Assets | `flutter_gen` — zero raw string asset paths |
| Localization | `flutter_localizations` — zero hardcoded UI strings |
| Linting | `very_good_analysis` |
| Testing | `mocktail` + `golden_toolkit` |

---

## 2. Directory Structure

```
lib/src/
├── core/
│   ├── errors/        # Base Failure classes
│   ├── router/        # App router
│   └── theme/         # Design tokens, ThemeData
└── features/<feature>/
    ├── domain/
    │   ├── entities/  # @freezed domain models
    │   └── failures/  # @freezed Failure union
    ├── infrastructure/
    │   ├── services/      # Raw I/O only (dio, websocket)
    │   ├── dtos/          # fromJson/toJson + toDomain()
    │   └── repositories/  # Either wrapping + error detection
    ├── application/
    │   └── notifiers/     # AsyncNotifier / Notifier providers
    └── presentation/
        ├── pages/         # Scaffold + layout only, <100 lines
        └── components/    # Every extracted widget
```

---

## 3. Layer Rules

### Domain — depends on NOTHING
- Only `dart:core`, `fpdart`, `freezed`. Zero Flutter imports.
- Entities: `@freezed` with `const factory` + `._()` for methods.
- Failures: one `@freezed` union per feature.
- **No** `fromJson`, **no** serialization.

```dart
@freezed
class Device with _$Device {
  const Device._();
  const factory Device({ required String id, required double temperature }) = _Device;
  bool get isOverheating => temperature > 85.0;
}

@freezed
class DeviceFailure with _$DeviceFailure {
  const factory DeviceFailure.notFound() = _NotFound;
  const factory DeviceFailure.networkError(String msg) = _NetworkError;
  const factory DeviceFailure.unauthorized() = _Unauthorized;
}
```

---

### Service — raw I/O ONLY
- Connects to REST (`dio`) or WebSocket. Returns raw `Map` or `Stream<String>`.
- **No** error detection. **No** `Either`. **No** caught exceptions — let them propagate.

```dart
class DeviceApiService {
  Future<Map<String, dynamic>> fetchDevice(String id) async {
    final res = await _dio.get('/devices/$id'); // throws on error — intentional
    return res.data as Map<String, dynamic>;
  }
}
```

---

### DTO — translation only
- `fromJson` / `toJson` + `toDomain()` + `fromDomain()`.
- **No** business logic, **no** validation, **no** `Either`.

```dart
@freezed
class DeviceDto with _$DeviceDto {
  const DeviceDto._();
  const factory DeviceDto({ required String id, required double temperature }) = _DeviceDto;
  factory DeviceDto.fromJson(Map<String, dynamic> json) => _$DeviceDtoFromJson(json);
  Device toDomain() => Device(id: id, temperature: temperature);
}
```

---

### Repository — the ONLY place for exceptions and detection logic
- Calls Service → parses DTO → runs checks → returns `Either<Failure, T>`.
- **All** exceptions caught here. **All** threshold/validity checks here.
- High-frequency streams: buffer with `rxdart` `bufferTime(100ms)`.

```dart
Future<Either<DeviceFailure, Device>> getDevice(String id) async {
  try {
    final raw = await _service.fetchDevice(id);
    final device = DeviceDto.fromJson(raw).toDomain();
    if (device.temperature < 0) return left(DeviceFailure.networkError('Invalid reading'));
    return right(device);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) return left(const DeviceFailure.notFound());
    if (e.response?.statusCode == 401) return left(const DeviceFailure.unauthorized());
    return left(DeviceFailure.networkError(e.message ?? 'Unknown'));
  } catch (e) {
    return left(DeviceFailure.networkError(e.toString()));
  }
}
```

---

### Notifier — reactive state holder only
- Calls Repository, handles `Either` via `.fold()`, updates `AsyncValue`.
- **No** error detection. **No** threshold checks. **No** `dio` imports.

```dart
@riverpod
class DeviceNotifier extends _$DeviceNotifier {
  @override
  FutureOr<Device> build(String deviceId) async {
    final result = await ref.read(deviceRepositoryProvider).getDevice(deviceId);
    return result.fold((f) => throw f, (d) => d);
  }
}
```

---

### Presentation — renders state, dispatches events, nothing else

**Base class selection — use the minimum necessary:**

| Needs | Extend |
|---|---|
| Hooks + Riverpod | `HookConsumerWidget` |
| Riverpod only | `ConsumerWidget` |
| Neither (pure UI) | `StatelessWidget` |

`StatefulWidget` and `setState` are **FORBIDDEN** regardless.

**Widget extraction rule:** Prefer extracting logical UI blocks as standalone widget classes over `_buildXxx()` methods that return `Widget`. Use a method only when the block is trivially small (1–3 widgets, no parameters, no state) and extracting it as a class would add zero value. When in doubt, extract as a class.

```dart
// ❌ AVOID — _build method for any non-trivial UI block
Widget _buildList(List<TelemetryPoint> batch) {
  return ListView.builder(...);
}

// ✅ CORRECT — extract as a standalone widget class
class TelemetryPointList extends StatelessWidget {
  const TelemetryPointList({super.key, required this.batch});
  final List<TelemetryPoint> batch;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: batch.length,
      itemBuilder: (context, index) => TelemetryPointTile(point: batch[index]),
    );
  }
}
```

| Local State Need | Hook |
|---|---|
| Text input | `useTextEditingController()` |
| Boolean toggle | `useState(false)` |
| Animation | `useAnimationController()` |
| Init/dispose | `useEffect()` |
| Focus | `useFocusNode()` |
| Scroll | `useScrollController()` |

```dart
class DeviceDetailPage extends HookConsumerWidget {
  const DeviceDetailPage({super.key, required this.deviceId});
  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = useState(false);
    final deviceAsync = ref.watch(deviceNotifierProvider(deviceId));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.deviceDetail)),
      body: deviceAsync.when(
        data: (device) => DeviceDetailBody(device: device, isExpanded: isExpanded),
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorStateWidget(failure: e),
      ),
    );
  }
}
```

---

## 4. Responsive & Platform Strategy (Web + Mobile + Tablet)

### 4.1 Breakpoints — Single Source of Truth

**Tanım `core/theme/breakpoints.dart`'ta yapılır. Başka hiçbir yerde sayı yazılmaz.**

```dart
abstract class Breakpoints {
  // Width thresholds
  static const double mobileMax  = 599;
  static const double tabletMin  = 600;
  static const double tabletMax  = 1023;
  static const double desktopMin = 1024;
  static const double desktopMax = 1439;
  static const double wideMin    = 1440;

  // Max content width (web'de içerik ortalanır, sonsuza yayılmaz)
  static const double contentMaxWidth = 1200;

  // Spacing scale
  static const double spacingMobile  = 16;
  static const double spacingTablet  = 24;
  static const double spacingDesktop = 32;
}

// Helper extension — widget içinde doğrudan kullanılır
extension BreakpointContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isMobile  => screenWidth <= Breakpoints.mobileMax;
  bool get isTablet  => screenWidth >= Breakpoints.tabletMin && screenWidth <= Breakpoints.tabletMax;
  bool get isDesktop => screenWidth >= Breakpoints.desktopMin;
  bool get isWeb     => kIsWeb;

  double get horizontalPadding => isMobile
      ? Breakpoints.spacingMobile
      : isTablet
          ? Breakpoints.spacingTablet
          : Breakpoints.spacingDesktop;
}
```

**Forbidden:**
```dart
if (MediaQuery.sizeOf(context).width > 800)  // ❌ magic number
if (MediaQuery.sizeOf(context).width > Breakpoints.tabletMin) // ✅
```

---

### 4.2 Layout Shell — Navigation Pattern

**Platform ve ekran boyutuna göre navigation yapısı değişir. Bu mantık her page'de tekrarlanmaz — merkezi `AppShell` widget'ında yaşar.**

| Ekran | Navigation Pattern |
|---|---|
| Mobile (≤599) | `BottomNavigationBar` veya `NavigationBar` |
| Tablet (600–1023) | `NavigationRail` (collapsed, ikonsuz label) |
| Desktop / Web (≥1024) | `NavigationDrawer` (expanded, label görünür) |

```dart
// core/presentation/components/app_shell.dart
class AppShell extends HookConsumerWidget {
  const AppShell({super.key, required this.child, required this.currentIndex});
  final Widget child;
  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (context.isMobile) {
      return _MobileShell(child: child, currentIndex: currentIndex);
    }
    if (context.isTablet) {
      return _TabletShell(child: child, currentIndex: currentIndex);
    }
    return _DesktopShell(child: child, currentIndex: currentIndex);
  }
}
```

**Rule:** `BottomNavigationBar`, `NavigationRail`, `NavigationDrawer` doğrudan page'lerde **FORBIDDEN**. Sadece `AppShell` içinde kullanılır.

---

### 4.3 Content Width Constraint — Web Zorunluluğu

Web'de içerik sonsuza yayılmaz. Tüm sayfa içerikleri `ContentConstraint` wrapper'ından geçer.

```dart
// core/presentation/components/content_constraint.dart
class ContentConstraint extends StatelessWidget {
  const ContentConstraint({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Breakpoints.contentMaxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
          child: child,
        ),
      ),
    );
  }
}
```

**Rule:** Her `Page`'in body'si `ContentConstraint` ile sarılır. Sarılmamış page **REJECTED**.

---

### 4.4 Adaptive Layout — ResponsiveLayout Widget

Mobil ve desktop için tamamen farklı layout gerektiğinde `LayoutBuilder` ile ayrı widget'lar render edilir. Aynı widget içinde `if (isMobile)` ile UI logic dallanması **FORBIDDEN**.

```dart
// ✅ CORRECT — farklı layout tamamen ayrı component'a çıkarılır
class DeviceDashboardPage extends HookConsumerWidget {
  const DeviceDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContentConstraint(
      child: context.isMobile
          ? const DeviceDashboardMobileLayout()
          : const DeviceDashboardDesktopLayout(),
    );
  }
}

// presentation/components/device_dashboard_mobile_layout.dart  (<100 lines)
// presentation/components/device_dashboard_desktop_layout.dart (<100 lines)
```

---

### 4.5 Adaptive Grid

```dart
// ✅ CORRECT
SliverGrid(
  delegate: SliverChildBuilderDelegate(
    (context, index) => DeviceCard(device: devices[index]),
    childCount: devices.length,
  ),
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: context.isMobile ? 400 : 300,
    mainAxisSpacing: context.horizontalPadding,
    crossAxisSpacing: context.horizontalPadding,
    childAspectRatio: context.isDesktop ? 1.4 : 1.2,
  ),
)
```

---

### 4.6 Platform-Aware Widgets

Flutter'ın `.adaptive()` constructor'ları ve platform-specific widget'lar için doğrudan `Platform.isIOS` / `kIsWeb` kontrolü **FORBIDDEN**. Bunlar `PlatformService` üzerinden alınır ya da `AdaptiveWidget` wrapper'ları kullanılır.

```dart
// ✅ CORRECT — adaptive constructors
Switch.adaptive(value: val, onChanged: onChanged);
CircularProgressIndicator.adaptive();
AlertDialog.adaptive(title: Text(context.l10n.confirm), ...);

// ✅ CORRECT — web'e özgü cursor
MouseRegion(
  cursor: SystemMouseCursors.click,
  child: GestureDetector(onTap: onTap, child: card),
)

// ❌ FORBIDDEN — doğrudan platform check in widget
if (Platform.isIOS) CupertinoSwitch(...) else Switch(...)
```

---

### 4.7 Typography & Spacing Scale

Font boyutları hardcode edilmez. `Theme.of(context).textTheme` kullanılır. Web'de büyük ekran için `TextTheme` scale up yapılır.

```dart
// core/theme/app_theme.dart
TextTheme _buildTextTheme(bool isDesktop) {
  final base = GoogleFonts.interTextTheme();
  return isDesktop
      ? base.copyWith(
          headlineLarge: base.headlineLarge?.copyWith(fontSize: 40),
          bodyLarge: base.bodyLarge?.copyWith(fontSize: 18),
        )
      : base;
}
```

**Rule:** `Text('...', style: TextStyle(fontSize: 24))` → **FORBIDDEN**. `Theme.of(context).textTheme.headlineMedium` kullan.

---

### 4.8 Scroll Behavior — Web Mouse Drag

Web'de liste/scroll alanları mouse ile sürüklenebilir olmalı. Default Flutter web scroll behavior bunu engeller.

```dart
// core/presentation/app.dart — MaterialApp seviyesinde tanımlanır
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  };
}

// MaterialApp(scrollBehavior: AppScrollBehavior(), ...)
```

**Rule:** `AppScrollBehavior` app root'unda tanımlanır. Her scroll widget'ında ayrıca belirtilmez.

---

### 4.9 Responsive PR Rejection Criteria

| Violation | Fix |
|---|---|
| Hardcoded pixel değeri (`width > 800`) | `Breakpoints` sabiti kullan |
| `BottomNavigationBar` doğrudan page'de | `AppShell`'e taşı |
| Web page'i `ContentConstraint` olmadan | Wrapper ekle |
| `if (isMobile)` ile aynı widget'ta 2 farklı layout | Ayrı `MobileLayout` / `DesktopLayout` component'ı çıkar |
| `Platform.isIOS` doğrudan widget'ta | `.adaptive()` veya `PlatformService` kullan |
| `TextStyle(fontSize: x)` hardcode | `textTheme.*` kullan |
| Mouse drag çalışmıyor web'de | `AppScrollBehavior` tanımlı mı kontrol et |

---

## 5. Performance Rules

```dart
// Smart rebuild — single field
final status = ref.watch(deviceProvider.select((d) => d.status));

// High-frequency widget isolation
RepaintBoundary(child: LiveTemperatureChart(...));

// Responsive layout — no hardcoded dimensions
LayoutBuilder(builder: (ctx, constraints) {
  final cols = constraints.maxWidth >= Breakpoints.tablet ? 3 : 1;
  return GridView.count(crossAxisCount: cols, ...);
})
```

---

## 5. Routing / Assets / Strings / Colors

```dart
// Routing
const DeviceDetailRoute(deviceId: id).push(context); // ✅
context.push('/device/$id');                          // ❌ FORBIDDEN

// Assets
Assets.images.logo.image();    // ✅
Image.asset('assets/...');     // ❌ FORBIDDEN

// Strings
Text(context.l10n.deviceDetail); // ✅
Text('Device Detail');           // ❌ FORBIDDEN

// Colors
Theme.of(context).colorScheme.error; // ✅
Colors.red                           // ❌ FORBIDDEN

// BuildContext after await
if (!context.mounted) return; // ✅ always guard
```

---

## 6. Testing

**Coverage:** 100% branch on `domain/` and `application/`. Golden tests on all pages + complex components.

```dart
// ✅ Test the sequence, not just the end state
container.listen(deviceNotifierProvider('id'), (_, next) => emissions.add(next), fireImmediately: true);
await container.read(deviceNotifierProvider('id').future);
expect(emissions, [const AsyncLoading<Device>(), isA<AsyncData<Device>>()]);

// ✅ mocktail strict verification
verify(() => mockRepo.getDevice('device-1')).called(1);
verifyNoMoreInteractions(mockRepo);
```

**Test naming — BDD mandatory:**
```
'Given <state>, When <action>, Then <outcome>'
✅ 'Given device offline, When fetchDevice called, Then emit [loading, error(networkError)]'
❌ 'test fetch device'
```

---

## 7. PR Rejection Criteria

| Violation | Fix |
|---|---|
| `setState` or `StatefulWidget` | `HookConsumerWidget` + hooks |
| `_buildXxx()` method for non-trivial UI block | Extract as standalone widget class in `components/` |
| Presentation file > ~100 lines | Extract to `components/` |
| Threshold/detection logic in Notifier or Page | Move to Repository |
| Exception caught in Service | Let it propagate to Repository |
| Magic string route or raw asset path | Use generated type-safe alternatives |
| Hardcoded color | `colorScheme` or design token |
| Hardcoded UI string | `context.l10n.*` |
| `BuildContext` after `await` without `mounted` check | Add guard |
| `ref.watch(provider)` when only one field needed | Use `.select()` |
| Test name not GWT format | Rename |
| Hardcoded pixel breakpoint | Use `Breakpoints.*` constants |
| Navigation widget directly in a Page | Move to `AppShell` |
| Web Page without `ContentConstraint` | Add wrapper |
| `if (isMobile)` dual-layout in same widget | Extract separate layout components |
| `TextStyle(fontSize: x)` hardcoded | Use `textTheme.*` |
