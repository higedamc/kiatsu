import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PaywallWidget extends StatefulWidget {
  const PaywallWidget({
    Key? key,
    required this.termsOfUse,
    required this.privacyPolicy,
    required this.description,
    required this.packages,
    required this.onClickedPackage,
  }) : super(key: key);

  final String termsOfUse;
  final String privacyPolicy;
  final String description;
  
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;

  @override
  _PaywallWidgetState createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                text: TextSpan(
                  text: widget.termsOfUse,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await launch(
                        dotenv.env['KIATSU_TERMS_OF_USE'].toString(),
                      );
                    },
                ),
              ),
              RichText(
                text: const TextSpan(
                  text: '・',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                 
                ),
              ),
              
              RichText(
                text: TextSpan(
                  text: widget.privacyPolicy,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await launch(
                        dotenv.env['KIATSU_PRIVACY_POLICY'].toString(),
                      );
                    },
                ),
              ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              buildPackages(),
            ],
          ),
        ),
      );

  Widget buildPackages() => ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: widget.packages.length,
        itemBuilder: (context, index) {
          final package = widget.packages[index];

          return buildPackage(context, package);
        },
      );

  Widget buildPackage(BuildContext context, Package package) {
    final product = package.product;

    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData.light(),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          title: Text(
            product.title,
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: Text(product.description),
          trailing: Text(
            product.priceString,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () => widget.onClickedPackage(package),
        ),
      ),
    );
  }
}
