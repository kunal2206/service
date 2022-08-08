import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/settings.dart';
import '../exceptions.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  // ignore: prefer_final_fields
  Rx<String?> _token = Rx<String?>(null);

  ///checks if there is token and the token expiry date has not passed
  ///and finally returns a token
  String? get token {
    return _token.value;
  }

  DateTime? _expiryDate;

  DateTime? get expiryDate => _expiryDate;

  ///the email,name and the phone number needs to be stored
  /// in the shared preferences so that it
  ///can be shown when the user has logged in
  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;

  ///this is used to create a timer every time we loggin and ends when the time
  ///of token expiry ends
  Timer? _authTimer;

  ///whenever this is called it checks whether we are logged in or not
  Rx<bool> get isAuth {
    return Rx((token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())));
  }

  //Endpoint to receive otp and token
  Future<String?> sendPhoneNumberForVerification(String phoneNumber) async {
    final url = Uri.parse(LOGIN);

    try {
      int? integerPhoneNumber = int.tryParse(phoneNumber);
      if (integerPhoneNumber == null) {
        throw AuthException(message: "The phone number you entered is invalid");
      }
      final data = {
        "phonenumber": phoneNumber,
      };
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body);

      if (responseData["error"] == "Invalid value") {
        throw AuthException(
            message:
                "The phone number entered by you is not correct. Kindly check your number");
      }
      if (responseData.containsKey("token")) {
        _token.value = responseData["token"];
        _phoneNumber = phoneNumber;
        return "PHONE_REGISTERED";
      }
    } catch (error) {
      throw AuthException(
          message:
              "The phone number entered by you is not correct. Kindly check your number");
    }
    return Future.value(null);
  }

  //Endpoint to verify OTP
  Future<String?> otpVerification(String otp) async {
    const uri = VALIDATE_OTP;

    final url = Uri.parse(uri);

    final data = {
      "otp": otp,
      "token": token,
    };
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(data),
      );

      final responseData = json.decode(response.body);
      if (responseData["msg"] == "Please provide otp") {
        throw AuthException(
            message:
                "The otp entered by you has either expired or is invalid.");
      }

      if (responseData["message"] == "Your Otp has expired!") {
        throw AuthException(
            message:
                "The otp entered by you has either expired or is invalid.");
      }
      if (responseData.containsKey("token") && responseData["token"] != null) {
        _token.value = responseData["token"];
        _expiryDate = DateTime.now().add(const Duration(days: 29));
        autoLogout();
        final prefs = await SharedPreferences.getInstance();
        final userData = {
          "token": _token.value,
          "phonenumber": _phoneNumber,
          "expiryDate": _expiryDate!.toIso8601String()
        };
        prefs.setString('userData', json.encode(userData));
        return "OTP_VERIFIED";
      }
    } catch (error) {
      throw AuthException(
          message:
              "The otp entered by you has either expired or is invalid. Kindly check your number");
    }
    return Future.value(null);
  }

  ///this  resets every variable so that the isAuth returns false which can
  ///be used to check whether logged in or not
  Future<void> logout() async {
    _token.value = null;
    _expiryDate = null;
    _phoneNumber = null;

    ///no need to nullify all other variables as they will not be seen or used if
    ///isAuth returns false  because of this two variables
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");

    //SETTINGS["corrections"] = "unabled";
  }

  ///whenever we move out of the app we logout automatically
  ///this only run if the user contnuosly use the app for more than a day
  ///without closing the app
  void autoLogout() {
    ///with every new login it will first remove the old timer
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    ///this provides a fixed time until which the timer runs if the
    ///app is not shut down
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () {
      logout();
    });
  }

  ///check whether is data is stored in shared reference or not
  ///this is used to automatically log using the token saved in the
  ///shared preferences
  Future<bool> tryAutoLogging() async {
    final prefs = await SharedPreferences.getInstance();

    ///contains the userData having token
    if (!prefs.containsKey("userData")) {
      return false;
    }

    ///getting userData stored in the shared preferences
    final extractedUserData = json.decode(prefs.getString("userData")!);
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]!);

    ///token has expired ie. is it after a day

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    ///as the data stored is valid and can be used to login again
    _token.value = extractedUserData["token"];
    _phoneNumber = extractedUserData["phonenumber"];
    _expiryDate = DateTime.parse(extractedUserData["expiryDate"]);

    autoLogout();
    return true;
  }
}
