import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:az_scrolling/alp_scroll/alphabet.dart';
import 'package:az_scrolling/alp_scroll/alphabet_node.dart';
import 'package:az_scrolling/alp_scroll/alpha_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AZScrolling extends StatefulWidget {
  const AZScrolling({
    required this.list,
    required this.itemBuilder,
    required this.alphabetList,
    this.alignment = Alignment.centerRight,
    this.isAlphabetsFiltered = true,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.overlayWidget,
    Key? key,
  }) : super(key: key);

  final Alphabet alphabetList;

  /// List of Items should be non Empty
  /// and you must map your
  /// ```
  ///  List<T> to List<AlphaModel>
  ///  e.g
  ///  List<UserModel> _list;
  ///  _list.map((user)=>AlphaModel(user.name)).toList();
  /// ```
  /// where each item of this ```list``` will be mapped to
  /// each widget returned by ItemBuilder to uniquely identify
  /// that widget.
  final List<AlphaModel> list;

  /// Alignment for the Alphabet List
  /// can be aligned on either left/right side
  /// of the screen
  final Alignment alignment;

  /// defaults to ```true```
  /// if specified as ```false```
  /// all alphabets will be shown regardless of
  /// whether the item in the [list] exists starting with
  /// that alphabet.

  final bool isAlphabetsFiltered;

  /// Widget to show beside the selected alphabet
  /// if not specified it will be hidden.
  /// ```
  /// overlayWidget:(value)=>
  ///    Container(
  ///       height: 50,
  ///       width: 50,
  ///       alignment: Alignment.center,
  ///       color: Theme.of(context).primaryColor,
  ///       child: Text(
  ///                 '$value'.toUpperCase(),
  ///                  style: TextStyle(fontSize: 20, color: Colors.white),
  ///              ),
  ///      )
  /// ```

  final Widget Function(String)? overlayWidget;

  /// Text styling for the selected alphabet by which
  /// we can customize the font color, weight, size etc.
  /// ```
  /// selectedTextStyle:
  ///   TextStyle(
  ///     fontWeight: FontWeight.bold,
  ///     color: Colors.black,
  ///     fontSize: 20
  ///   )
  /// ```

  final TextStyle? selectedTextStyle;

  /// Text styling for the unselected alphabet by which
  /// we can customize the font color, weight, size etc.
  /// ```
  /// unselectedTextStyle:
  ///   TextStyle(
  ///     fontWeight: FontWeight.normal,
  ///     color: Colors.grey,
  ///     fontSize: 18
  ///   )
  /// ```

  final TextStyle? unselectedTextStyle;

  /// The itemBuilder must return a non-null widget and the third paramter id specifies
  /// the string mapped to this widget from the ```[list]``` passed.

  final Widget Function(BuildContext, int, String) itemBuilder;

  @override
  State<AZScrolling> createState() => _AZScrollingState();
}

class _AZScrollingState extends State<AZScrolling> {
  final itemScrollController = ItemScrollController(); //

  late List<String> alphabet = widget.alphabetList.alphabetList;

  ScrollController listController = ScrollController();
  final _selectedIndexNotifier = ValueNotifier<int>(0);
  final positionNotifier = ValueNotifier<Offset>(Offset.zero);
  final Map<String, int> firstIndexPosition = {};
  List<String> _filteredAlphabets = [];
  final letterKey = GlobalKey();
  List<AlphaModel> _list = [];
  bool isLoading = false;
  bool isFocused = false;
  final key = GlobalKey();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    widget.list
        .sort((x, y) => x.key.toLowerCase().compareTo(y.key.toLowerCase()));

    _list = widget.list;
    setState(() {});

    /// filter Out AlphabetList
    if (widget.isAlphabetsFiltered) {
      final List<String> temp = [];
      alphabet.forEach((letter) {
        final AlphaModel? firstAlphabetElement = _list.firstWhereOrNull(
          (item) => item.key.toLowerCase().startsWith(letter.toLowerCase()),
        );
        if (firstAlphabetElement != null) {
          temp.add(letter);
        }
      });
      _filteredAlphabets = temp;
    } else {
      _filteredAlphabets = alphabet;
    }
    calculateFirstIndex();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant AZScrolling oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.list != widget.list ||
        oldWidget.isAlphabetsFiltered != widget.isAlphabetsFiltered) {
      _list.clear();
      firstIndexPosition.clear();
      init();
    }
  }

  int getCurrentIndex(double vPosition) {
    final double kAlphabetHeight = letterKey.currentContext!.size!.height;
    return vPosition ~/ kAlphabetHeight;
  }

  /// calculates and Maintains a map of
  /// [letter:index] of the position of the first Item in list
  /// starting with that letter.
  /// This helps to avoid recomputing the position to scroll to
  /// on each Scroll.
  void calculateFirstIndex() {
    _filteredAlphabets.forEach((letter) {
      final AlphaModel? firstElement = _list.firstWhereOrNull(
          (item) => item.key.toLowerCase().startsWith(letter));
      if (firstElement != null) {
        firstIndexPosition[letter] = _list.indexOf(firstElement);
      }
    });
  }

  Future<void> scrollToIndex(int x) {
    final int index = firstIndexPosition[_filteredAlphabets[x].toLowerCase()]!;
    return itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        alignment: 0,
        opacityAnimationWeights: const [40, 20, 40]);
  }

  void onVerticalDrag(Offset offset) {
    final int index = getCurrentIndex(offset.dy);
    if (index < 0 || index >= _filteredAlphabets.length) return;
    _selectedIndexNotifier.value = index;
    setState(() {
      isFocused = true;
    });
    scrollToIndex(index);
  }

  TextStyle get textStyle =>
      widget.unselectedTextStyle ??
      const TextStyle(
        fontSize: 11,
        height: 14.85 / 11,
        fontWeight: FontWeight.w500,
        color: Color.fromRGBO(130, 203, 232, 1),
      );

  TextStyle get selectedTextStyle =>
      widget.selectedTextStyle ??
      textStyle.copyWith(
        fontWeight: FontWeight.w800,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          padding: EdgeInsets.zero,
          itemCount: _list.length,
          itemBuilder: (_, idx) => widget.itemBuilder(_, idx, _list[idx].key),
        ),
        Align(
          alignment: widget.alignment,
          child: Container(
            key: key,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: SingleChildScrollView(
              child: GestureDetector(
                onVerticalDragStart: (z) => onVerticalDrag(z.localPosition),
                onVerticalDragUpdate: (z) => onVerticalDrag(z.localPosition),
                onVerticalDragEnd: (z) => setState(() {
                  isFocused = false;
                }),
                child: ValueListenableBuilder<int>(
                    valueListenable: _selectedIndexNotifier,
                    builder: (__, int selected, _) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _filteredAlphabets.length,
                            (x) => AlphabetNode(
                                text: _filteredAlphabets[x],
                                selected: x == selected,
                                textStyle: textStyle,
                                selectedTextStyle: selectedTextStyle,
                                letterKey: letterKey,
                                onCallBack: () {
                                  _selectedIndexNotifier.value = x;
                                  scrollToIndex(x);
                                }),
                          ));
                    }),
              ),
            ),
          ),
        ),
        isFocused
            ? ValueListenableBuilder<Offset>(
                valueListenable: positionNotifier,
                builder: (__, Offset position, _) => Positioned(
                      right: widget.alignment.isRight ? 40 : null,
                      left: widget.alignment.isRight ? 40 : null,
                      top: position.dy,
                      child: widget.overlayWidget != null
                          ? widget.overlayWidget!(
                              _filteredAlphabets[_selectedIndexNotifier.value],
                            )
                          : Container(),
                    ))
            : Container()
      ],
    );
  }
}

extension AligmnetExtension on Alignment {
  bool get isRight => this == Alignment.centerRight;
}
