// import 'package:velocity_x/velocity_x.dart';

class Api {
  static String get baseUrl {
    return "https://antpay.com.ng/api";
  }

  static const register = "/auth/register";
  static const login = "/auth/login";
  static const wallet = "/user/wallet";
  static const fund = "/fund-deposit";
  static const transactionHistory = "/user/wallet/transactions";
  static const setPin = "/change/pin";
  static const transfer = "/transfer/internal";
  static const countries = "/countries?length=157";
  static const kyc = "/kyc/tier-two";
  static const docVerification = "/kyc/tier-three";
  static const banks = "/banks";
  static const withdraw = "/initiate-withdrawal";
  static const nameEnquiry = "/name-enquiry";
}
