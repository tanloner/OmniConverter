import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unit_converter/helpers/ad_helper.dart';
import 'dart:io';

class AdService {
  static bool _isInitialized = false;
  static bool _isHomeBannerReady = false;
  late BannerAd _homeBannerAd;
  late InterstitialAd? _interstitialAd;
  static bool _isInterstitialReady = false;

  static Future<void> initialize() async {
    if (!_isInitialized && !kIsWeb && Platform.isAndroid) {
      MobileAds.instance.initialize();
      _isInitialized = true;
    } else {
      return;
    }
  }

  bool get isInterstitialReady {
    return _isInterstitialReady;
  }

  SizedBox? bannerAd() {
    _homeBannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdHelper.bannerOneAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          _isHomeBannerReady = true;
        }, onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            print("failed to load the ad banner. ${error.message}");
          }
          _isHomeBannerReady = false;
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();
    if (!_isHomeBannerReady) {
      return null;
    }

    return SizedBox(
      height: _homeBannerAd.size.height.toDouble(),
      width: _homeBannerAd.size.width.toDouble(),
      child: AdWidget(ad: _homeBannerAd),
    );
  }

  Future<void> loadInterstitialAd() async {
    InterstitialAd.load(
        adUnitId: AdHelper.intersticialOneAdUnitId,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          if (kDebugMode) {
            print("Interstitial Ad Loaded");
          }
        }, onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialReady = false;
          if (kDebugMode) {
            print("Failed to load interstitial ad: ${error.message}");
          }
        }));
  }

  bool showInterstitialAd() {
    if (_isInterstitialReady && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          loadInterstitialAd(); // Preload a new ad after the previous one is shown
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          if (kDebugMode) {
            print("Failed to show interstitial ad: ${error.message}");
          }
          ad.dispose();
        },
      );
      _isInterstitialReady = false;
      return true;
    } else {
      if (kDebugMode) {
        print("Interstitial Ad not ready yet.");
      }
      return false;
    }
  }
}
