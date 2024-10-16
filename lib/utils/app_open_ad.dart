import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3442888419736051/4458501282',
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          print('App Open Ad failed to load: $error');
        },
      ),
    );
  }

  void dispose() {
    _appOpenAd?.dispose();
  }
}
