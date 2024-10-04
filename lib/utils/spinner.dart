import 'package:flutter_easyloading/flutter_easyloading.dart';

class Spinner {
  // Fonction pour afficher le spinner avec un message
  static void showLoading({String message = 'Patienter SVP...'}) {
    EasyLoading.show(
      status: message,
      maskType: EasyLoadingMaskType.black, // Utilisation d'un fond noir
    );
  }

  // Fonction pour masquer le spinner
  static void dismissLoading() {
    EasyLoading.dismiss();
  }

  // Fonction pour activer ou désactiver le spinner selon un flag
  static void actf(bool value) {
    if (value) {
      showLoading(message: 'Chargement en cours...');
    } else {
      dismissLoading();
    }
  }

  // Fonction pour simuler un délai et afficher un message de chargement pendant ce temps
  static void startTimer(
      {required Function callback, int durationInSeconds = 3}) {
    EasyLoading.show(
      status: 'Chargement...',
      maskType: EasyLoadingMaskType.custom,
    );
    Future.delayed(Duration(seconds: durationInSeconds), () {
      callback();
      dismissLoading();
    });
  }
}
