// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

extension StringExtension on String {
  Iterable<String> iterable() sync* {
    for (var i = 0; i < length; i++) {
      yield this[i];
    }
  }
}

const List<String> alphabetsEng = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
];

const List<String> alphabetsGeo = [
  'ა',
  'ბ',
  'გ',
  'დ',
  'ე',
  'ვ',
  'ზ',
  'თ',
  'ი',
  'კ',
  'ლ',
  'მ',
  'ნ',
  'ო',
  'პ',
  'ჟ',
  'რ',
  'ს',
  'ტ',
  'უ',
  'ფ',
  'ქ',
  'ღ',
  'ყ',
  'შ',
  'ჩ',
  'ც',
  'ძ',
  'წ',
  'ჭ',
  'ხ',
  'ჯ',
  'ჰ',
];

class Alphabet {
  final String countrySymbols;
  final List<String> alphabetList;

  Alphabet(this.countrySymbols, this.alphabetList);

  Alphabet.ka()
      : countrySymbols = 'ka',
        alphabetList = alphabetsGeo;

  Alphabet.en()
      : countrySymbols = 'en',
        alphabetList = alphabetsEng;

  Alphabet copyWith({
    String? countrySymbols,
    List<String>? alphabetList,
  }) =>
      Alphabet(
        countrySymbols ?? this.countrySymbols,
        alphabetList ?? this.alphabetList,
      );

  static List<Alphabet> alphabets = [
    Alphabet.en(),
    Alphabet.ka(),
  ];

  // ignore: prefer_constructors_over_static_methods
  static Alphabet findMyAlphabet(String countrySymbols) {
    return alphabets
            .firstWhereOrNull((alp) => alp.countrySymbols == countrySymbols) ??
        Alphabet.en();
  }

  /// var relation = 'Dart'.compareTo('Go');
  /// print(relation); // < 0
  /// relation = 'Go'.compareTo('Forward');
  /// print(relation); // > 0
  /// relation = 'Forward'.compareTo('Forward');
  /// print(relation); // 0

  // widget.list
  //     .sort((x, y) => x.key.toLowerCase().compareTo(y.key.toLowerCase()));

  int compareTo(String firstString, String secondString) {
    const List<String> alphabetList = alphabetsGeo;
    final aString = firstString.replaceAll(' ', '').replaceAll('\\', '');
    final bString = secondString.replaceAll(' ', '').replaceAll('\\', '');
    int index = 0;
    for (var a in aString.iterable()) {
      final aNum = getAlphabetIndex(alphabetList, a);
      final b = bString[index];
      final bNum = getAlphabetIndex(alphabetList, b);
      final getComp = aNum.compareTo(bNum);
      if (getComp < 0) {
        return 1;
      } else if (getComp > 0) {
        return -1;
      } else {
        index += 1;
      }
    }
    return 0;
  }

  static String getBetter(String firstString, String secondString) {
    const List<String> alphabetList = alphabetsGeo;
    final aString = firstString.replaceAll(' ', '').replaceAll('\\', '');
    final bString = secondString.replaceAll(' ', '').replaceAll('\\', '');
    int index = 0;
    for (var a in aString.iterable()) {
      final aNum = getAlphabetIndex(alphabetList, a);
      final b = bString[index];
      final bNum = getAlphabetIndex(alphabetList, b);
      final getComp = aNum.compareTo(bNum);
      if (getComp < 0) {
        return firstString;
      } else if (getComp > 0) {
        return secondString;
      } else {
        index += 1;
      }
    }
    return firstString;
  }

  static int getAlphabetIndex(List<String> alphabetList, String c) =>
      alphabetList.indexWhere((e) => e == c);
}
