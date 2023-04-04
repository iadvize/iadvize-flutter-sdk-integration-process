import 'package:flutter/material.dart';
import 'package:iadvize_flutter_sdk/iadvize_flutter_sdk.dart';

void main() {
  runApp(const IntegrationDemoApp());
}

class IntegrationDemoApp extends StatelessWidget {
  const IntegrationDemoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iAvize SDK Flutter Plugin Integration',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(title: 'Home'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, dynamic> idzConfig = {
    'logLevel': LogLevel.verbose,

    // TODO Replace with your project id
    'projectId': -1,

    // TODO Replace with relevant user id
    'authOption': AuthenticationOption.simple(userId: 'user-unique-identifier'),

    // TODO Replace with your own GDPR URL
    'gdprOption': GDPROption.url(url: "http://replace.with.your.gdpr.url/"),

    // TODO Replace with relevant targeting rule id
    'targetingRuleId': "targeting-rule-uuid",

    // TODO Replace with relevant targeting rule language
    'targetingLanguage': 'en',

    // TODO Replace with relevant targeting rule channel
    'targetingRuleChannel': ConversationChannel.chat
  };

  bool _isSDKActivated = false;

  @override
  void initState() {
    super.initState();

    // Set iAdvize SDK log level to verbose
    IAdvizeSdk.setLogLevel(idzConfig['logLevel']);

    if (!_isSDKActivated) {
      // Activate iAdvize SDK
      IAdvizeSdk.activate(
        projectId: idzConfig['projectId'],
        authenticationOption: idzConfig['authOption'],
        gdprOption: idzConfig['gdprOption'],
      ).then((bool activated) => setState(() {
            _isSDKActivated = activated;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSDKActivated) {
      // When activated, trigger an engagement
      IAdvizeSdk.setLanguage(idzConfig['targetingLanguage']);
      IAdvizeSdk.activateTargetingRule(
        TargetingRule(
          uuid: idzConfig['targetingRuleId'],
          channel: idzConfig['targetingRuleChannel'],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'iAdvize SDK is ${_isSDKActivated ? 'activated!' : 'disabled.'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
