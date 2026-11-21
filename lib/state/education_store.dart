import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/models/education.dart';

/// In-memory list of education entries shared between screens.
///
/// Screens listen to it (e.g. with `ListenableBuilder`) and rebuild whenever
/// an entry is added or removed. Persistence comes later with the REST API.
class EducationStore extends ChangeNotifier {
  final List<Education> _items = [];

  List<Education> get items => List.unmodifiable(_items);

  void add(Education education) {
    _items.add(education);
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// App-wide instance used by the education screens.
final EducationStore educationStore = EducationStore();
