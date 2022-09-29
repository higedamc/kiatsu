import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/controller/user_state.dart';
import 'package:kiatsu/subscription_holder_mixin.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../logger.dart';

final userProvider = StateNotifierProvider<UserController, UserState>(
  (ref) => UserController(),
);

class UserController extends StateNotifier<UserState>
    with SubscriptionHolderMixin {
  UserController() : super(UserState()) {
    // リスナーも提供されている
    Purchases.addCustomerInfoUpdateListener(
      (customerInfo) {
        logger.info('customerInfo: $customerInfo');
        state = state.copyWith(
          customerInfo: customerInfo,
        );
      },
    );

    subscriptionHolder.add(
      _auth.authStateChanges().listen(
        (user) async {
          if (user == null) {
            logger.info('logout');
            state = UserState();
            return;
          }
          // RevenueCatのAppUserIDをセット
          final loginResult = await Purchases.logIn(user.uid);
          state = state.copyWith(
            user: user,
            customerInfo: loginResult.customerInfo,
          );
        },
      ),
    );
  }

  final _auth = FirebaseAuth.instance;
}
