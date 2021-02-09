import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart' as oidc;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _response = 'nothing';

  @override
  void initState() {
    super.initState();
  }

  void _clearText() {
    setState(() {
      _response = 'nothing';
    });
  }

  Future<void> _getSignIn() async {
    try {
      var result = await _openID();
      setState(() {
        _response = result;
      });
    } on PlatformException catch (e) {
      print('ERR ${e.message}');
    }
  }

  Future<void> _getInfo() async {
    try {} on PlatformException catch (e) {
      print('ERR ${e.message}');
    }
  }

  Future<void> _getToken() async {
    try {} on PlatformException catch (e) {
      print('ERR ${e.message}');
    }
  }

  Future<void> _signOut() async {
    try {} on PlatformException catch (e) {
      print('ERR ${e.message}');
    }
  }

  var redirectUrl = 'com.kittist.openid.oidc://callback';
  var clientId = 'ba08dd00-484a-0139-b563-06351d701be3184317';
  var issuerUrl = "https://openid-connect.onelogin.com/oidc";

  Future _openID() async {
    var scopes = List<String>.of(['openid', 'profile']);
    var uri = Uri.parse(redirectUrl);
    var issuer = await oidc.Issuer.discover(Uri.parse(issuerUrl));

    var client = new oidc.Client(issuer, clientId);
    var flow = oidc.Flow.authorizationCodeWithPKCE(client);
    // oidc.Flow.authorizationCodeWithPKCE(client)
    flow.redirectUri = uri;

    urlLauncher(String url) async {
      print(url);
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    }

    // open browser
    // handle the custom return url
    // var credentials = await flow.callback(urlParams);
    var authenticator = oidc.Authenticator(
      client,
      urlLancher: urlLauncher,
      redirectUri: uri,
      scopes: scopes,
    );

    var c = await authenticator.authorize();
    closeWebView();
    var token = await c.getTokenResponse();
    print('token $token');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => _getSignIn(),
              child: Text('Sign in'),
            ),
            RaisedButton(
              onPressed: () => _getInfo(),
              child: Text('Show user Info'),
            ),
            RaisedButton(
              onPressed: () => _getToken(),
              child: Text('Check Token'),
            ),
            RaisedButton(
              onPressed: () => _signOut(),
              child: Text('Sign out'),
            ),
            Text(
              'Response:',
            ),
            Text(
              _response,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearText,
        tooltip: 'Clear',
        child: Icon(Icons.reset_tv),
      ),
    );
  }
}
