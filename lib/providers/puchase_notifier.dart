import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/model/entitlement.dart';

class PurchaseNotifier extends StateNotifier<List<Entitlement>> {
  PurchaseNotifier() : super([]);
  void addFeature(Entitlement entitlement) => state = [...state, entitlement];
  void removeFeature(Entitlement entitlement) => state = [...state..remove(entitlement)];
}