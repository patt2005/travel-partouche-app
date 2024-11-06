import 'package:flutter/cupertino.dart';
import 'package:travel_partouche_app/model/note.dart';
import 'package:travel_partouche_app/model/text.main.info.dart';
import 'package:travel_partouche_app/model/user.dart';

class AppProvider extends ChangeNotifier {
  int _coins = 100;
  int get coins => _coins;

  final List<Map<TextMainInfo, int>> _shopCartItems = [];
  List<Map<TextMainInfo, int>> get shopCartItems => _shopCartItems;

  final List<Note> _notes = [];
  List<Note> get notes => _notes;

  User? _userInfo;
  User? get userInfo => _userInfo;

  // void setUserInfo(User user) {
  //   _userInfo
  // }

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void addCoins(int amount) {
    _coins += amount;
    notifyListeners();
  }

  double calculateTotalAmount() {
    double total = 0.0;
    for (var cartItem in _shopCartItems) {
      final item = cartItem.keys.first;
      final quantity = cartItem[item]!;
      total += item.price * quantity;
    }
    return total;
  }

  void addToCart(TextMainInfo item) {
    final existingItem =
        _shopCartItems.indexWhere((cartItem) => cartItem.keys.first == item);
    if (existingItem != -1) {
      _shopCartItems[existingItem][item] =
          _shopCartItems[existingItem][item]! + 1;
    } else {
      _shopCartItems.add({item: 1});
    }
    notifyListeners();
  }

  void removeFromCart(TextMainInfo item) {
    _shopCartItems.removeWhere((cartItem) => cartItem.keys.first == item);
    notifyListeners();
  }

  void increaseQuantity(TextMainInfo item) {
    final existingItem =
        _shopCartItems.indexWhere((cartItem) => cartItem.keys.first == item);
    if (existingItem != -1) {
      _shopCartItems[existingItem][item] =
          _shopCartItems[existingItem][item]! + 1;
      notifyListeners();
    }
  }

  double calculateTotalCost() {
    return _shopCartItems.fold(0, (sum, itemMap) {
      final item = itemMap.keys.first;
      final quantity = itemMap.values.first;
      return sum + (item.price * quantity);
    });
  }

  void decreaseQuantity(TextMainInfo item) {
    final existingItem =
        _shopCartItems.indexWhere((cartItem) => cartItem.keys.first == item);
    if (existingItem != -1) {
      final currentQuantity = _shopCartItems[existingItem][item]!;
      if (currentQuantity > 1) {
        _shopCartItems[existingItem][item] = currentQuantity - 1;
      } else {
        _shopCartItems.removeAt(existingItem);
      }
      notifyListeners();
    }
  }
}
