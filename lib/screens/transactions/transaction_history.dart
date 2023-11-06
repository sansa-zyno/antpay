import 'dart:convert';
import 'dart:developer';
import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class TransactionHistory extends StatefulWidget {
  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List? transactionHistory;
  getTransactionHistory(String token) async {
    Response response = await HttpService.getRequest(Api.transactionHistory,
        bearerToken: true, accessToken: token);
    Map result = jsonDecode(response.body);
    if (result["status"]) {
      transactionHistory = result["data"];
      log(transactionHistory.toString());
      setState(() {});
    } else {
      //transactionHistory = [];
      //setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    getTransactionHistory(appProvider.token);
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Provider.of<UserController>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: appColor,
      body: Stack(
        children: [
          Positioned(
              top: 0, left: 15, child: Image.asset(heart_red_2, width: 70)),
          Column(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: titleBarOffset,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: gd2,
                            size: 20,
                          ),
                        ),
                        Spacer(),
                        CustomText(
                          text: "Transaction History",
                          color: Colors.white,
                          size: 16,
                        ),
                        Spacer(),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(image: AssetImage(stickers)),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [appColor, gd2, gd3, gd4, gd5],
                          stops: [0.02, 0.2, 0.6, 0.8, 1.0]),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        transactionHistory != null
                            ? transactionHistory!.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: transactionHistory!.length,
                                    padding: EdgeInsets.all(0),
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                            onTap: () async {},
                                            title: CustomText(
                                              text: transactionHistory![index]
                                                      ["type"]
                                                  .toString()
                                                  .capitalizeFirst!,
                                              size: 16,
                                              weight: FontWeight.bold,
                                              color: appColor,
                                            ),
                                            trailing: CustomText(
                                              text: transactionHistory![index]
                                                  ["amount"],
                                              size: 16,
                                              weight: FontWeight.bold,
                                              color: appColor,
                                            )),
                                      );
                                    })
                                : Container(
                                    height: MediaQuery.of(context).size.height -
                                        150,
                                    alignment: Alignment.center,
                                    child: CustomText(
                                        text: "No Transaction history to show"))
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height - 150,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator()),
                      ],
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
