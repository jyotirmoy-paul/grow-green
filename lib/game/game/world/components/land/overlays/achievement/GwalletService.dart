import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../../services/log/log.dart';
import 'models/challenges_model.dart';

enum GwalletClaimStatus {
  success,
  failed,
}

class GwalletService {
  static const tag = 'GwalletService';
  static const _baseUrl = 'http://52.172.30.83:3000';
  static Future<void> launchUrl(String urlString) async {
    Log.d("url to launch: $urlString");
    try {
      // Check if the URL can be launched
      await launchUrlString(urlString);
    } catch (e) {
      throw 'Could not launch $urlString'; // throw could be used to handle erroneous situations
    }
  }

  static Future<GwalletClaimStatus> claimGwalletFromChallenge(ChallengeModel challenge) async {
    try {
      final url = await getWalletAddUrlFromChallenge(challenge);
      if (url != null) {
        await launchUrl(url);
        return GwalletClaimStatus.success;
      } else {
        return GwalletClaimStatus.failed;
      }
    } catch (e) {
      Log.e('$tag Failed to claim Gwallet');
      return GwalletClaimStatus.failed;
    }
  }

  static Future<GwalletClaimStatus> claimGwalletFromFarmView(String farmLink) async {
    try {
      final url = await getFarmViewToken(farmLink);
      if (url != null) {
        await launchUrl(url);
        return GwalletClaimStatus.success;
      } else {
        return GwalletClaimStatus.failed;
      }
    } catch (e) {
      Log.e('$tag Failed to claim Gwallet');
      return GwalletClaimStatus.failed;
    }
  }

  static Future<String?> getFarmViewToken(String farmLink) async {
    final dio = Dio();

    final url = '$_baseUrl/viewFarmToken/?farmlink=$farmLink';
    const bodyUrl = '$_baseUrl/viewFarmToken/';
    final body = {
      'farmlink': farmLink,
    };
    final response = await dio.post(
      bodyUrl,
      data: body,
    );

    if (response.statusCode == 200) {
      Log.i('$tag Gwallet claimed');
      return response.data.toString();
    } else {
      Log.e('$tag Failed to claim Gwallet');
      return null;
    }
  }

  static Future<String?> getWalletAddUrlFromChallenge(ChallengeModel challenge) async {
    final dio = Dio();
    final amount = challenge.offer.value.value;
    final code = challenge.offer.code;

    final url = '$_baseUrl/token/?amount=$amount&code=$code';
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      Log.i('$tag Gwallet claimed');
      return response.data.toString();
    } else {
      Log.e('$tag Failed to claim Gwallet');
      return null;
    }
  }
}
