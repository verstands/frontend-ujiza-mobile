import 'dart:io' show Platform;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class AdService {
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  static const int maxFailedLoadAttempts = 3;

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int _numRewardedLoadAttempts = 0;
  int _numRewardedInterstitialLoadAttempts = 0;

  void initialize() {
    print("Initializing MobileAds...");
    MobileAds.instance.initialize().then((InitializationStatus status) {
      print("AdMob initialization complete: $status");
      _createInterstitialAd();
      _createRewardedAd();
      _createRewardedInterstitialAd();
    }).catchError((error) {
      print("AdMob initialization failed: $error");
    });
  }

  // Création de l'Interstitial Ad
  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-7094258963536106~7368150948'
          : 'ca-app-pub-7094258963536106/8915605716',
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts++;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  // Afficher l'Interstitial Ad
  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // Création du Rewarded Ad
  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-7319269804560504/6645907620'
          : 'ca-app-pub-7319269804560504/2207757133',
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          _numRewardedLoadAttempts++;
          if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
            _createRewardedAd();
          }
        },
      ),
    );
  }

  // Afficher le Rewarded Ad
  void showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('Rewarded Ad showed. Reward: ${reward.amount} ${reward.type}');
      },
    );
    _rewardedAd = null;
  }

  // Création du Rewarded Interstitial Ad
  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5354046379'
          : 'ca-app-pub-3940256099942544/6978759866',
      request: request,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          _rewardedInterstitialAd = ad;
          _numRewardedInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedInterstitialAd = null;
          _numRewardedInterstitialLoadAttempts++;
          if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createRewardedInterstitialAd();
          }
        },
      ),
    );
  }

  // Afficher le Rewarded Interstitial Ad
  void showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print(
            'Rewarded Interstitial Ad showed. Reward: ${reward.amount} ${reward.type}');
      },
    );
    _rewardedInterstitialAd = null;
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
  }
}
