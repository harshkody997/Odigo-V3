import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';

/// Riverpod provider to access StoreMappingController via dependency injection
final storeMappingController = ChangeNotifierProvider((ref) => getIt<StoreMappingController>());

@injectable
class StoreMappingController extends ChangeNotifier {
  /// Dispose controller and optionally notify listeners
  void disposeController({bool isNotify = false}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }

  /// Key to access and validate the form
  GlobalKey<FormState> storeMappingFormKey = GlobalKey();

  /// Text editing controllers for the dropdown fields
  final TextEditingController selectStoreController = TextEditingController();
  final TextEditingController selectFloorController = TextEditingController();

  /// Available store and floor options
  final List<String> storeList = ['H&M', 'Zara', 'Puma'];
  final List<String> floorList = ['0', '1', '2'];
  final List<int> floorOptions = [0, 1, 2];

  /// Currently selected store and floor
  String? selectedStore;
  int? selectedFloor;

  /// List of assigned stores (store + floor)
  final List<AssignedStore> assignedStores = [];

  /// Update the selected store and notify listeners
  void updateSelectedStore(String? store) {
    selectedStore = store;
    notifyListeners();
  }

  /// Update the selected floor and notify listeners
  void updateSelectedFloor(int? floor) {
    selectedFloor = floor;
    notifyListeners();
  }

  /// Add store-floor assignment to the list if not already added
  void addStore() {
    if (selectedStore != null && selectedFloor != null) {
      bool alreadyAdded = assignedStores.any((e) => e.store == selectedStore && e.floor == selectedFloor);
      if (!alreadyAdded) {
        assignedStores.add(AssignedStore(store: selectedStore!, floor: selectedFloor!));

        // Clear the selected values after adding
        selectedStore = null;
        selectedFloor = null;
        notifyListeners();
      }
    }
  }

  /// Remove an assigned store entry by index
  void removeStore(int index) {
    assignedStores.removeAt(index);
    notifyListeners();
  }

  /// Clear the dropdown controllers and selected values
  void clearDropdownsData() {
    selectStoreController.clear();
    selectFloorController.clear();
    updateSelectedStore(null);
    updateSelectedFloor(null);
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  /// Show/hide loading indicator (used for future API integration)
  bool isLoading = false;

  /// Update loading status and notify listeners
  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }
}

/// Model class to hold assigned store data (store name + floor)
class AssignedStore {
  final String store;
  final int floor;

  AssignedStore({required this.store, required this.floor});
}
