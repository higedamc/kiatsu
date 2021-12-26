import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:kiatsu/providers/providers.dart';

//TODO: https://gpalma.pt/blog/riverpod-feature-switcher/

class FeatureSwitcher extends ConsumerWidget {
  final Entitlement entitlement;
  final Widget child;

  const FeatureSwitcher({
    required this.entitlement, 
    required this.child, 
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final features = ref.watch<List<Entitlement>>(entitlementProvider);
    if (features.contains(entitlement)) {
      return child;
    }
    return const SizedBox(height: 32);
  }
}

class FeatureBuilder extends ConsumerWidget {
  final Widget Function(BuildContext, List<Entitlement>) builder;

  const FeatureBuilder({required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final features = ref.watch<List<Entitlement>>(entitlementProvider);
    return builder.call(context, features);
  }
}

class PurchasePage extends StatelessWidget {
  const PurchasePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          //...
          FeatureSwitcher(
            entitlement: Entitlement.free,
            child: Text('💰', style: TextStyle(fontSize: 24.0),),
          ),
          //...
        ],
      ),
    );
  }
}