import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ujiza/screens/SearchPharcmacieAll.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/1033173712', // Remplace avec ton ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
          });

          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _navigateToSearchPharmacie(); // Navigue après la fermeture de la pub
              _loadInterstitialAd(); // Recharge une nouvelle pub
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              ad.dispose();
              print('Interstitial Ad failed to show: $error');
              _navigateToSearchPharmacie(); // Navigue même si la pub échoue
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial Ad failed to load: $error');
        },
      ),
    );
  }

  void _navigateToSearchPharmacie() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPharmacieAll(id: 'qid')),
    );
  }

  void _handleButtonClick() {
    if (_isInterstitialAdReady) {
      _interstitialAd?.show();
    } else {
      _navigateToSearchPharmacie();
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interstitiel Example'),
        actions: [
          IconButton(
            onPressed:
                _handleButtonClick, // Appelle la méthode qui gère la pub et la navigation
            icon: const Icon(Icons.shop_two),
            iconSize: 40,
            color: Colors.white,
          ),
        ],
      ),
      body: Center(child: Text('My Page')),
    );
  }
}
