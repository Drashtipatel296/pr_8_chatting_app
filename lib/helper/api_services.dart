import 'dart:convert';
import 'dart:developer';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class ApiServices{
  static ApiServices apiServices = ApiServices._();
  ApiServices._();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static const String baseUrl = "https://fcm.googleapis.com/v1/projects/pr-8-firebase-miner/messages:send";

  Future<String> getServerToken() async {
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final privateKey = jsonEncode(jsonKey);
    final client = ServiceAccountCredentials.fromJson(privateKey);

    final serviceClient = await clientViaServiceAccount(client, scopes);

    final serverToken = serviceClient.credentials.accessToken.data;
    return serverToken;
  }

  Future<void> sendMessage(String title, String body, String token) async {
    print("\n\n-------------------------------------------\n\n");
    log(title);
    log(body);
    log(token);
    print("\n\n-------------------------------------------\n\n");
    Map notification = {
      "message" : {
        "token" : token,
        "notification" : {
          "title" : title,
          "body" : body,
        },
        "data" : {
          "response" : "Message Done !!",
        }
      },
    };

    final jsonNotification = jsonEncode(notification);

    try{
      String? serverToken = "ya29.a0AcM612zeVU5L4l3kkJtFyB1q7a7QBf0vH8x-Usm8gxCpPr4GjaKF4u4vJmNDzYpchp5pi_W3XmuXoFCp99hRfEL9W3JHfB2YMJbqUlyWEe6AwIEgeKXCHckBG1z1oJ56LfKHFuzHUOxEDpQajEc6qoCrQ3O_cBX6F3MCuFHfaCgYKAWQSAQ8SFQHGX2MiClunpcX6rNbDLv_ORBc1Pg0175";

      var response = await http.post(Uri.parse(baseUrl),
        body: jsonNotification,
        headers: <String, String>{
          'Authorization' : 'Bearer $serverToken',
          'Content-Type' : 'application/json',
        }
      );

      if(response.statusCode == 200){
        log('Successfully sent message: ${response.body}');
      }
      else{
        log('Error sending message: ${response.body}');
      }
    }catch(e){
      log("Api error: ${e.toString()}");
    }
  }
}

final jsonKey = {
  "type": "service_account",
  "project_id": "pr-8-firebase-miner",
  "private_key_id": "63585703fa0d7b5ae7dcdf30bc9a03a9c9444352",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2y+ww/aghtZYe\nmalL6ZR7KbzA1ZuING/B2qpozYQ8cKXMjz0n0j9hYNdp7hgOfgQgHyvkycpOudq7\n7LCBY9PYf9k+6Y3oOMqXl2gEAAcgifJctj6iJXS27pGEX7N/MjSL5EBK2xhmWpvO\nr9WTNYaW5YcUlC/wqglvJPtcP/b0iK9fvyn8ek2lr2ROwGBpZFDCbbXPMP3lhL8A\nZLFHrF8sjwCx7icG7k00Y9npXqtgsyC/Hyl0hWVSpGg2IMWS1CpJg2wSyfxF+ZRB\nV+D2lvOxaWQRW3w0La9lSIXbEAf6BXw6jW7ZVl/vkGoDBNV5rPbuFemm/mu6HXUl\nf7aTI2uFAgMBAAECggEATUbJK27YeKO0+mu4g9STxjt/RcAn171fL4Ma/mI/kHOI\nzAET9/UsgSS4/FnAxsOkR9YVrstV4NE2NLLbbV+/66sksrF2oeD8WHiT6vj+ClX2\n5RXQRajy/fC+CMmSbufRCgCs41hbKM4ORyLTdb+vjbQr1lnNKH8hrOBj+Pw7kOVO\n4o6AFL3Vwb6GSSgZ3UkxXhDaOQH2c+CS2qvZutERz8QitmbA7Kjk9+FexeAWFRpE\nnzb8Ww7OA4+1wkLmnOZ+S+5jqu4RToUY9VG1tQ/XIHoEHP7nrjFMYVk9fXDEhPDg\nrXFELKrKGkhzwHFAwbT1Uv0KdFm09UBCswLnAvMNowKBgQDZnkL4epu/pmLLbWiZ\n3ItTWwRPiMeDHKv4VutMM7+ZXgxQBoYmlEjVT7zzXMmURVg3tzKgZH8Osi4hakYU\nXPN8acJgatqP8cJI/i5nm11r0qNz14o9ITZ2z5pI27JgshORCz/DyllDrPeka/t7\nknvTg3K0lPqLvRtK4nvUtAIPlwKBgQDXCWt//p60vEPEnvV2GlEXLArbe04QlepZ\nM8NufL29W7G43XlHEf4Y/tI9VX/JqOGxVQbJJFLawYs+bgGcyYTI/7azTL0Mg3dA\n9xBn01JdwXse9Q6zRXZ12qNQO86kHBoZEWAbCgut8B/PY9i9+k2Qpx/Eqo/nqsw7\nPhIgKPxBQwKBgQDJ1DwslBpLPxe1r/0pZiBZ6LowwZy4fykHpCWKgRwcM9ubhNF6\nimCaZd/Kna3fNAlDc0ci9tHYYWzjVNs2G5c/Nh8uqSuYARK9+/Ax6yhTzgIGeEsf\nsuP+gUCIfioMAFyhUxuKjOsJFyx+dB/DVfI+E1WZIerVG0hqxW8vsNuQdQKBgQC1\nS/XcZfm8e3XPUg21Ux7HIJTO0zjP9vUr296LSpRWD/bY27EiYGMRA9aRa4JfrQkL\nj5o2/27zjHYvXmPxol1XcXDB3pMM99IVbbfhMWOiNDvvr8CDGK91Ua6bOLFR33eJ\nZwLWCTQro+XN3mqgUWYP7Td1gi/trCygTgbOIn/7LQKBgEaG8ZZ/S6PRS0w1h+Y1\nbyw5AOhVrumuVbcYgzLOkKAG3X8MTdyq3b0b4zkreqaL7buAsPKS8NavzzukEEXq\n883o80jzJl6OtOSAw68miegSJiCH8h5z/Dt/1lepi2mXiBgHvEkaP7ZxgP5Xm2ms\neEymjXoZqjVU9/0R8W1Bo+ZI\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-jca51@pr-8-firebase-miner.iam.gserviceaccount.com",
  "client_id": "100218067371428214835",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-jca51%40pr-8-firebase-miner.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};
