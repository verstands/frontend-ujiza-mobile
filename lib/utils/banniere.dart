import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Banniere extends StatefulWidget {
  const Banniere({Key? key}) : super(key: key);

  @override
  _BanniereState createState() => _BanniereState();
}

class _BanniereState extends State<Banniere> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: 'ca-app-pub-7094258963536106/8915605716',
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: ${error.message}');
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isBannerAdReady
        ? Container(
            alignment: Alignment.center,
            child: AdWidget(ad: _bannerAd),
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
          )
        : const SizedBox.shrink();
  }
}
