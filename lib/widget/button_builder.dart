// import 'package:flutter/material.dart';
// import 'package:kiatsu/model/entitlement.dart';
// import 'package:kiatsu/pages/purchase_page.dart';

// class ButtonBuilder extends StatelessWidget {
//   final Entitlement entitlements;
//   const ButtonBuilder({required this.entitlements, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FeatureBuilder(builder: (context, features) {
//       if (features.contains(Entitlement.pro)){
//         return ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size.fromHeight(50),
//           ),
//           child: const Text(
//             '広告削除済みです',
//             style: TextStyle(fontSize: 20),
//           ),
//           onPressed: null,
//         );
//       }

//       if (features.contains(Entitlement.free)) {
//         return ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size.fromHeight(50),
//           ),
//           child: const Text(
//             'プランを見る',
//             style: TextStyle(fontSize: 20),
//           ),
//           onPressed: isLoading ? null : fetchOffers,
//         );
      
//       }
//       return Container();
//     });
//   }
// }