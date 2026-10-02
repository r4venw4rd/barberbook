import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Derives and verifies password hashes using PBKDF2-HMAC-SHA256.
///
/// Encoded hashes use the format `scheme$iterations$salt$hash`.
class PasswordHasher {
  /// Creates a hasher using [iterations] PBKDF2 rounds.
  const new({this.iterations = defaultIterations});

  /// PBKDF2 round count applied when creating new hashes.
  static const int defaultIterations = 120000;

  /// The PBKDF2 round count used by this hasher.
  final int iterations;

  static const String _scheme = 'pbkdf2_sha256';
  static const int _hashLength = 32;
  static const int _saltLength = 16;
  static final Random _secureRandom = Random.secure();

  /// Returns an encoded, salted hash for [password].
  String hash(String password) {
    final salt = _randomBytes(_saltLength);
    final derived = _derive(password, salt, iterations, _hashLength);
    return <String>[
      _scheme,
      iterations.toString(),
      base64Encode(salt),
      base64Encode(derived),
    ].join(r'$');
  }

  /// Whether [password] matches the credentials in [encoded].
  ///
  /// Returns false instead of throwing for malformed input.
  bool verify(String password, String encoded) {
    final parts = encoded.split(r'$');
    if (parts.length != 4 || parts[0] != _scheme) return false;
    final rounds = int.tryParse(parts[1]);
    if (rounds == null || rounds < 1) return false;
    final Uint8List salt;
    final Uint8List expected;
    try {
      salt = base64Decode(parts[2]);
      expected = base64Decode(parts[3]);
    } on FormatException {
      return false;
    }
    if (expected.length != _hashLength) return false;
    final actual = _derive(password, salt, rounds, expected.length);
    return _constantTimeEquals(actual, expected);
  }

  Uint8List _randomBytes(int length) {
    return Uint8List.fromList(
      List<int>.generate(length, (_) => _secureRandom.nextInt(256)),
    );
  }

  Uint8List _derive(
    String password,
    Uint8List salt,
    int rounds,
    int keyLength,
  ) {
    final hmac = Hmac(sha256, utf8.encode(password));
    final blockCount = (keyLength / _hashLength).ceil();
    final output = BytesBuilder(copy: false);
    for (var block = 1; block <= blockCount; block++) {
      final seed = <int>[
        ...salt,
        (block >> 24) & 0xff,
        (block >> 16) & 0xff,
        (block >> 8) & 0xff,
        block & 0xff,
      ];
      var u = hmac.convert(seed).bytes;
      final aggregated = List<int>.from(u);
      for (var round = 1; round < rounds; round++) {
        u = hmac.convert(u).bytes;
        for (var i = 0; i < aggregated.length; i++) {
          aggregated[i] ^= u[i];
        }
      }
      output.add(aggregated);
    }
    return output.toBytes();
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var difference = 0;
    for (var i = 0; i < a.length; i++) {
      difference |= a[i] ^ b[i];
    }
    return difference == 0;
  }
}
