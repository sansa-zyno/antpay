import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSticker extends StatelessWidget {
  const CustomSticker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return appProvider.customStickers != null
        ? appProvider.customStickers!.isNotEmpty
            ? Scaffold(
                backgroundColor: appColor,
                appBar: AppBar(
                  backgroundColor: appColor,
                  title: Text(
                    "Undefined Stickers",
                  ),
                  centerTitle: true,
                  leading: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                ),
                body: GridView.builder(
                    controller: ScrollController(),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    shrinkWrap: true,
                    itemCount: appProvider.customStickers!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) => InkWell(
                        onTap: () async {
                          appProvider.setCustomSticker(
                              appProvider.customStickers![index]);
                          Navigator.pop(context);
                        },
                        child: Stack(
                          children: [
                            Image.network(
                              appProvider.customStickers![index],
                            ),
                          ],
                        )),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, childAspectRatio: 1)),
              )
            : Center(child: Text("No stickers to show"))
        : Center(child: Text("Loading stickers..."));
  }
}
