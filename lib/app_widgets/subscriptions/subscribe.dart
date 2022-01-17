// Monthly and Yearly Auto Renewing Subscriptions for Optamize: $9.99/month and $99.99/year

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'package:prasso_app/app_widgets/subscriptions/sub_listitem.dart';
import 'package:prasso_app/common_widgets/custom_buttons.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/services/prasso_api_repository.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class SubscribePage extends StatefulWidget {
  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  Map<String, QPermission> _permissions;
  Map<String, QProduct> _products;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  Future<void> _closeNReturn() async {
    Navigator.of(context).pop(); //close the subscription page
    await PrassoApiRepository.instance.cupertinoHomeScaffoldVM
        .goToDashboard(context);
  }

  Future<void> _subscribeMonthly(BuildContext context) async {
    try {
      final QOfferings offerings = await Qonversion.offerings();
      final List<QProduct> products = offerings.main.products;
      if (products.isNotEmpty) {
        final monthlySub = products[0];

        final permissions = await Qonversion.purchaseProduct(monthlySub);
        final permission = permissions.values.firstWhere(
            (element) => element.productId == monthlySub.qonversionId,
            orElse: () => null);

        if (permission != null && permission.isActive) {
          showSuccessToast('Subscribed to Monthly Subscription');
          final returnval = await PrassoApiRepository.instance
              .processNewSubscription(monthlySub);
          showSuccessToast('Updated Views');

          if (returnval) {
            unawaited(_closeNReturn());
          }
        }
      }
    } on Exception catch (e) {
      showErrorToast(e.toString());
    }
  }

  Future<void> _subscribeYearly(BuildContext context) async {
    try {
      final QOfferings offerings = await Qonversion.offerings();
      final List<QProduct> products = offerings.main.products;
      if (products.isNotEmpty) {
        final yearlySub = products[1];
        final permissions = await Qonversion.purchaseProduct(yearlySub);
        final permission = permissions.values.firstWhere(
            (element) => element.productId == yearlySub.qonversionId,
            orElse: () => null);

        if (permission != null && permission.isActive) {
          showSuccessToast('Subscribed to Yearly Subscription');
          final prassoapi = PrassoApiRepository.instance;
          final returnval = await prassoapi.processNewSubscription(yearlySub);
          showSuccessToast('Updated Views');

          if (returnval) {
            unawaited(_closeNReturn());
          }
        }
      }
    } on Exception catch (e) {
      showErrorToast(e.toString());
    }
  }

  Future<void> onNext(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Become a Coach',
            style: TextStyle(color: PrassoColors.lightGray)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _products == null && _permissions == null
            ? const CircularProgressIndicator()
            : Center(
                child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    'Optamize Your Health App for Coaches',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'One-to-One or Group Communications',
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Tools for managing clients',
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                  const SubListItem(
                      title: 'Enhance client relationships',
                      icon: 'add_circle'),
                  const SubListItem(
                      title: 'Personal private messaging', icon: 'add_circle'),
                  const SubListItem(title: 'Email reports', icon: 'add_circle'),
                  const SubListItem(
                      title: 'Mobile and web', icon: 'add_circle'),
                  const SubListItem(
                      title: 'Tools for managing clients', icon: 'add_circle'),
                  const SubListItem(
                      title: 'Personal home page.', icon: 'add_circle'),
                  const SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CustomRaisedButton(
                                onPressed: () {
                                  _subscribeMonthly(context);
                                },
                                color: Colors.white,
                                borderRadius: 15,
                                height: 50,
                                child: Text(
                                  '\$9.99/mn',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(color: PrassoColors.primary),
                                ),
                              ),
                            )
                          ])),
                      Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: CustomRaisedButton(
                                  onPressed: () {
                                    _subscribeYearly(context);
                                  },
                                  color: Theme.of(context).secondaryHeaderColor,
                                  borderRadius: 15,
                                  height: 50,
                                  child: Text(
                                    '\$99.99/yr',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(width: 16.0),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: CustomRaisedButton(
                                  onPressed: () {
                                    _closeNReturn();
                                  },
                                  color: Theme.of(context).secondaryHeaderColor,
                                  borderRadius: 15,
                                  height: 50,
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(width: 16.0),
                    ],
                  )
                ],
              )),
      ),
    );
  }

  Future<void> _initPlatformState() async {
    if (kDebugMode) {
      await Qonversion.setDebugMode();
    }

    await Qonversion.launch(
      Strings.qonversionId,
      isObserveMode: false,
    );

    await Qonversion.setAppleSearchAdsAttributionEnabled(true);

    await _loadQonversionObjects();
  }

  Future<void> _loadQonversionObjects() async {
    try {
      _products = await Qonversion.products();
      _permissions = await Qonversion.checkPermissions();
    } catch (e) {
      print(e);
      _products = {};
      _permissions = {};
    }

    setState(() {});
  }
}
