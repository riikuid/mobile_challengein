import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/model/topup_model.dart';
import 'package:mobile_challengein/pages/dashboard/dashboard.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/sweet_alert.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TopUpPage extends StatefulWidget {
  final TopUpModel topUpModel;
  const TopUpPage({super.key, required this.topUpModel});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  String errorText = "";
  SavingModel getSelectedSaving(String idSaving) {
    SavingModel selectedSaving = context
        .read<SavingProvider>()
        .savings
        .where(
          (element) => element.id == idSaving,
        )
        .first;
    return selectedSaving;
  }

  bool _isLoading = false;

  Future<bool> handleCheckStatus() async {
    setState(() {
      _isLoading = true;
    });
    await context
        .read<SavingProvider>()
        .checkQrExpired(
          errorCallback: (p0) => setState(() {
            errorText = p0.toString();
          }),
        )
        .then(
      (value) {
        if (value) {
          ThrowSnackbar()
              .showError(context, "Transaction is still in progress");
        } else {
          showDialog<void>(
            context: context,
            barrierDismissible: true, // user must tap button!

            builder: (BuildContext context) {
              return SweetAlert(
                title: errorText == "404"
                    ? "Transaction is Complete"
                    : errorText == "407"
                        ? "QR Code Expired"
                        : "Something went wrong",
                description: errorText == "404"
                    ? "Check your transaction history for more details."
                    : "Create a new transaction to get a new QR code",
                buttonText: "Back To Home",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
    setState(() {
      _isLoading = false;
    });
    return true;
  }

  Future<int> _androidVersion() async {
    var version = 0;
    try {
      var versionRelease = await Platform.version;
      version = int.parse(versionRelease.split('.')[0]);
    } catch (e) {
      print('Failed to get Android version: $e');
    }
    return version;
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  Future<void> _saveImageFromUrl() async {
    bool status = await Permission.storage.shouldShowRequestRationale;
    log(status.toString());

    if (Platform.isAndroid && (await _androidVersion() <= 32)) {
      // Request storage permissions for Android 12 and below
      if (!(await _requestPermission(Permission.storage))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to save the image'),
          ),
        );
        return;
      }
    }

    // Fetch the image from the URL
    final response = await http.get(Uri.parse(widget.topUpModel.qrUrl!));
    if (response.statusCode == 200) {
      // Convert the response body into bytes
      Uint8List imageData = response.bodyBytes;

      // Save the image to the gallery
      final result = await ImageGallerySaver.saveImage(imageData);
      print(result);

      Fluttertoast.showToast(msg: "Image Saved to Gallery");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Image Saved to Gallery')),
      // );
    } else {
      Fluttertoast.showToast(msg: "Failed to download image");
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData device = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          "Top Up",
          style: primaryTextStyle.copyWith(
            fontWeight: semibold,
            fontSize: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 25,
                  bottom: 30,
                  right: 30,
                  left: 30,
                ),
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image:
                        AssetImage("assets/image/image_background_topup.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  boxShadow: [
                    defaultShadow,
                  ],
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/image/icon_logo_white.svg",
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ExtendedImage.network(
                      widget.topUpModel.qrUrl!,
                      width: device.size.width - 160,
                      height: device.size.width - 160,
                      fit: BoxFit.fill,
                      cache: true,
                      color: whiteColor,
                      // border: Border.all(color: Colors.red, width: 1.0),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      printError: true,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.loading) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: device.size.width - 160,
                              height: device.size.width - 160,
                              decoration: BoxDecoration(
                                color: blackColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                          );
                        }
                        if (state.extendedImageLoadState == LoadState.failed) {
                          return GestureDetector(
                            onTap: () => state.reLoadImage(),
                            child: Container(
                              alignment: Alignment.center,
                              width: device.size.width - 160,
                              height: device.size.width - 160,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Text(
                                "Failed to load QR Code\nTap to reload",
                                textAlign: TextAlign.center,
                                style: primaryTextStyle.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            child: ExtendedRawImage(
                              width: device.size.width - 160,
                              height: device.size.width - 160,
                              image: state.extendedImageInfo?.image,
                            ),
                          );
                        }
                      },
                      //cancelToken: cancellationToken,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      getSelectedSaving(widget.topUpModel.idSavings!).goalName,
                      style: primaryTextStyle.copyWith(
                        color: whiteColor,
                        fontSize: 12,
                      ),
                    ),
                    // const SizedBox(
                    //   height: 3,
                    // ),
                    Text(
                      AppHelper.formatCurrency(widget.topUpModel.topupAmount!),
                      style: primaryTextStyle.copyWith(
                        color: whiteColor,
                        fontSize: 24,
                        fontWeight: semibold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            "This QR is valid for one-time use only",
                            style: primaryTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 12,
                              fontWeight: semibold,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Valid until ${AppHelper.formatDateTimeWithWIB(widget.topUpModel.qrExpired!)}",
                            style: primaryTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 12,
                              // fontWeight: semibold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        height: 50,
                        onPressed: handleCheckStatus,
                        isLoading: _isLoading,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.autorenew,
                              color: whiteColor,
                              size: 26,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Check\nStatus",
                              style: headingSmallTextStyle.copyWith(
                                color: whiteColor,
                                fontSize: 12,
                                fontWeight: semibold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: PrimaryButton(
                        height: 50,
                        onPressed: _saveImageFromUrl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icon/icon_save.svg",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Save QR",
                              style: headingSmallTextStyle.copyWith(
                                color: whiteColor,
                                fontWeight: semibold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
