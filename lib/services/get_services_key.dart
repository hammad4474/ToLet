import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class NotificationService {
  static const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  /// Sends an FCM notification for an audio call
  Future<void> sendCallNotification(String deviceToken, String callID) async {
    final accessToken = await _getAccessToken();

    final notificationData = {
      "to": deviceToken,
      "notification": {
        "title": "Incoming Call",
        "body": "You have a new audio call.",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "data": {
        "callID": callID,
        "type": "audio_call",
      },
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(notificationData),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to send notification: ${response.body}");
    }
  }

  /// Retrieves the access token using the service account credentials
  Future<String> _getAccessToken() async {
    final scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    final credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "tolet-b666d",
      "private_key_id": "22a62343f54785ce1261bc193098fe21d0b6a395",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC1C6IU1KRkKpnm\nssbMrTrvlV+1DxpakJwkJMerA7HsQKBi8UMZy+7ynv4Y7hiKBepMXYbcRGtDMmNB\n+klK+JC+Zs8uYp0q2AFcVQhn+uH/5wSSxLqqzi0dCU86Y0ygoYAeQsquGirSZ97r\nlfiaEAQRLMrV/euAPSqgk8uKghVPQoAs83IlVAEey8PdyQrU4l2+nydZYmAbttFG\nSsIXwX4pdmplLsdmPA0ZpcGFSTOmg3YCobcVafTsOcvVPQJlEognAELJSVmzbeAG\nd0f9pogcwB6tqheE9OG/+9zc9gKffJhur9uXi+DRzgnjFUmvkC37lbwPleZnSjE7\nPdi1dq/TAgMBAAECggEAMsCkGzrRKtNWeXm8iTw2vVsejV9CgAjx/J/i6WoLwrML\nQzFnIiAtSA6SJOL6Nhcaa3X8jFsRxrClaqWDTmUIDpg7lEFI1e3f08ZyqNOH73kP\nqyVDPwa1VuJ5N2EG5jDf/ZuzvcLQJlPABkLwgh/jQ/1Oj1azYivDe2hzMszstF7z\nV5eYw+YaizoSw8vmA2UfoOz04wYz4pAbDpNYKmo/eAZ6joo1IyPIphKEwnNej0LK\nb2SLoGRlKcwQnoBZSm+Yatnzj9n24nQraULxjECOZxk4zauBgiQYxRvedg/DlxOX\nHd45LVV7i3MV3x13lJXv/f8DU4vIj0iGKATu2A1b4QKBgQDdWgq65sBGRO0M56RL\nS/EvzleAWJUwFleKMGaevFpDsNKfqy1RpjCxqygKnt37oyF8xGYPpL9GLzhe0iU0\nGTHM23qYyuiVvzWjO1/dzjHkLQApnI2liDDL9Nio/+lxQWu2hIdPjy9z2H6nv+JG\nTvWxTn9t5FvbkyD/88a0SNm+lQKBgQDRYnJTUKbQSo/Da6ffQlXao5PgE/zbn+AQ\nM/SnX5sJnS0XhJlZBt+NAvxrwMtoIiF2V5uJDOWvtgV2AXaPxsP8wHsm4AkqHTMV\nbE5GzbgoF/9GoCC/myXrMZK9AVvNhhi1+T6TkDX0dR78ODipKpK7RQo/aythyp1i\nUfTmmSTixwKBgDDXlniJRDH9MYVgc6s9tZmD4WDrqveyZlySs4IhM5WuJbufrN9Q\nWXxKtQoq5faJl3ENcSvQgXg+ISUjH5xwVsHKSDIAy/OG/pHnHw81WWLs3xVPex3k\ngEfw3gHkfiFEez0J30WZ5bGdOs1PFOHIuIQIOywHcJFx1J1FsDnFvW5FAoGBALTB\nR/Ckr10hAPqy9TjHC1az3/SRTLhMTCGwuIPFBRJHnaWv0rIIPPR+n2pmBTLgRALl\nnl+xwpbti8lTegakkIyhna7xuPeiPXdBCFIXReNW1AkkMyE1zoY7RXHkuluyZ6Kw\niFTbKbjfYuBZqJBhMEp6T15wJgNF5pf6KHDpw+4BAoGBAJhCS2o1xUbHwUZ5WscA\nhR9RKvo5gJqIYkdV/cv1AfLHDz2/kYikEHHjGGbsz5i4JpoPx65c/xl2N2aSTDUt\n9wePBJBLV5eUqP7GQP24IaLFioXNrnXOdZGBNSpj0lglxTjVAaAlywWbxf7Huvvw\nrR+9+O/imheQCqc85hjijK80\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-mpl0o@tolet-b666d.iam.gserviceaccount.com",
      "client_id": "116788562657141996403",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-mpl0o%40tolet-b666d.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });

    final client = await clientViaServiceAccount(credentials, scopes);
    return client.credentials.accessToken.data;
  }
}
