import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/api/api_state.dart';
import 'package:kiatsu/providers/revenuecat.dart';
import 'package:kiatsu/providers/weather_notifier.dart';
import 'package:kiatsu/repository/weather_repository.dart';
import 'package:http/http.dart' as http;

final weatherClientProvider = Provider.autoDispose<WeatherRepository>(
    (ref) => WeatherRepositoryImpl(http.Client()));

// 依存ソース
final weatherStateNotifierProvider =
    StateNotifierProvider.autoDispose<WeatherStateNotifer, WeatherClassState>(
        (ref) => WeatherStateNotifer(ref.watch(weatherClientProvider)));

//backup use for textEditingController
final cityNameProvider = StateProvider.autoDispose<String>((ref) => '');

final revenueCatProvider =
    ChangeNotifierProvider.autoDispose((ref) => RevenueCat());

///参考URL: https://gist.github.com/elvan/24356a02d4faa8b8946a62806e947df4

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final collectionStreamProvider = StreamProvider.autoDispose((ref) {
  final stream = FirebaseFirestore.instance
      .collectionGroup('comments')
      .orderBy('createdAt', descending: true)
      .snapshots();
  return stream
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});

// final AutoDisposeFutureProvider<String?> documentIdProvider = FutureProvider.autoDispose((ref) async {
//   final docId = FirebaseFirestore.instance.doc('comments').snapshots().map((snapshot) => snapshot.id);
//   return docId.toString();
// });

final documentStreamProvider = StreamProvider.autoDispose((ref) {
  final stream =
      FirebaseFirestore.instance.collection('comments').doc().get().asStream();
  return stream.map((snapshot) => snapshot.data());
});
