import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/api/api_state.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:kiatsu/providers/location_notifier.dart';
import 'package:kiatsu/providers/puchase_notifier.dart';
import 'package:kiatsu/providers/revenuecat.dart';
import 'package:kiatsu/providers/weather_notifier.dart';
import 'package:kiatsu/repository/location_repository.dart';
import 'package:kiatsu/repository/permission_repository.dart';
import 'package:kiatsu/repository/weather_repository.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/utils/clock_ticker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../pages/timeline.dart';

final weatherClientProvider = Provider.autoDispose<WeatherRepository>(
  (ref) => WeatherRepository(http.Client()),
);
final locationClientProvider =
    Provider.autoDispose<LocationRepository>((ref) => LocationRepositoryImpl());

final permissionGetter = Provider.autoDispose<PermissionRepository>(
  (ref) => PermissionRepositoryImpl(),
);

// 依存ソース
final weatherStateNotifierProvider =
    StateNotifierProvider.autoDispose<WeatherStateNotifer, WeatherClassState>(
  (ref) => WeatherStateNotifer(ref.watch(weatherClientProvider)),
);

final locationStateNotifierProvider =
    StateNotifierProvider.autoDispose<LocationStateNotifer, LocationState>(
  (ref) => LocationStateNotifer(ref.watch(locationClientProvider)),
);

//backup use for textEditingController
final cityNameProvider = StateProvider.autoDispose<String>((ref) => '');

// final revenueCatProvider =
//     ChangeNotifierProvider.autoDispose((ref) => RevenueCat());

///参考URL: https://gist.github.com/elvan/24356a02d4faa8b8946a62806e947df4

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final commentsCollectionStreamProvider = StreamProvider.autoDispose((ref) {
  final stream = FirebaseFirestore.instance
      .collectionGroup('comments')
      .orderBy('createdAt', descending: true)
      .snapshots();
  return stream
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});

// final blockIdCollectionStreamProvider = StreamProvider.autoDispose((ref) {
//   final userId = FirebaseAuth.instance.currentUser?.uid;
//   // String dummy = '';
//   // final zako = ref.watch(commentsCollectionStreamProvider.select((value) => value.asData?.value == 'userId'));

//   final stream = FirebaseFirestore.instance.collectionGroup('users')
//       // .orderBy('isBlocked', descending: false)
//       // .snapshots();
//       // .where(
//       //     'isDeletedUser', isEqualTo: true,)
//           .snapshots();
//   return stream.map((snapshot) =>
//       snapshot.docs.map<dynamic>((doc) => doc.data().containsValue('true')).toList());
// });

// final blockedOrNotProvider = StateProvider.autoDispose<bool>((ref) {
//   final zako = ref.watch(
//     blockIdCollectionStreamProvider.select((value) {
//       if (value.asData?.value == null) {
//         return false;
//       } else {
//         return true;
//       }
//     }),
//   );

//   if (zako == true) {
//     return true;
//   } else {
//     return false;
//   }
// });

// final isCurrentUserBlockedProvider =
//     FutureProvider.autoDispose<bool>((ref) async {
//   final userId = FirebaseAuth.instance.currentUser?.uid;
//   final CollectionReference deletedUsers = firebaseStore.collection('users');
//   final test = await deletedUsers.doc(currentUser?.uid).get();
//   final dynamic deletedUser = await test.get(FieldPath.fromString('isDeletedUser'));
//   if (userId == null) {
//     return false;
//   } 
//   else if (deletedUser == true) {
//     return true;
//   } else {
//     return false;
//   }
// });

// final isCurrentUserblockedOrNotProvider = StateProvider.autoDispose<bool>((ref) {
//   final zako = ref.watch(
//     isCurrentUserBlockedProvider.select((value) {
//       if (value.asData?.value == false) {
//         return false;
//       } else {
//         return true;
//       }
//     }),
//   );

//   if (zako == true) {
//     return true;
//   } else {
//     return false;
//   }
// });

// final blockedOrNotProvider = StateProvider.autoDispose<bool>((ref) {
//   final test = ref.read(blockIdCollectionStreamProvider);
//   final test2 = test.
// });

// final AutoDisposeFutureProvider<String?> documentIdProvider = FutureProvider.autoDispose((ref) async {
//   final docId = FirebaseFirestore.instance.doc('comments').snapshots().map((snapshot) => snapshot.id);
//   return docId.toString();
// });

final documentStreamProvider = StreamProvider.autoDispose((ref) {
  final stream =
      FirebaseFirestore.instance.collection('comments').doc().get().asStream();
  return stream.map((snapshot) => snapshot.data());
});

// final entitlementProvider =
//     StateNotifierProvider.autoDispose<PurchaseNotifier, List<Entitlement>>((ref) {
//   return PurchaseNotifier();
// });

//参考URL: https://codewithandrea.com/articles/flutter-state-management-riverpod/
final clockProvider = StateNotifierProvider<Clock, DateTime>((ref) {
  return Clock();
});

// https://tamappe.com/2021/09/29/flutter-riverpod-textfield/
final textControllerStateProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});
