import 'package:equatable/equatable.dart';

/// Βοηθητική κλάση για περιεχόμενο που υπάρχει σε δύο γλώσσες.
/// Κάθε πεδίο όπως τίτλος και περιγραφή αποθηκεύεται ως `LocalizedText`.
class LocalizedText extends Equatable {
  final String el;
  final String en;

  const LocalizedText({required this.el, required this.en});

  /// Επιστρέφει το κείμενο στη ζητούμενη γλώσσα.
  /// Αν λείπει, κάνει fallback στην άλλη.
  String value(String languageCode) {
    if (languageCode == 'el') {
      return el.isNotEmpty ? el : en;
    }
    return en.isNotEmpty ? en : el;
  }

  Map<String, dynamic> toMap() => {'el': el, 'en': en};

  factory LocalizedText.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const LocalizedText(el: '', en: '');
    return LocalizedText(
      el: map['el']?.toString() ?? '',
      en: map['en']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [el, en];
}
