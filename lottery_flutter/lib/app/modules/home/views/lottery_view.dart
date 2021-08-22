import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottery_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:lottery_flutter/utils/font_styles.dart';
import 'package:lottery_flutter/utils/input_decorations.dart';
import 'package:lottery_flutter/utils/remove_scroll_glow.dart';
import 'package:lottery_flutter/utils/theme.dart';

class LotteryView extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  LotteryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Lottery Contract',
          style: bodySemiBoldBig,
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: RefreshIndicator(
            onRefresh: homeController.reloadContract,
            child: ScrollConfiguration(
              behavior: RemoveScrollGlow(),
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.yinYang,
                      color: primaryColor,
                    ),
                    title: const Text(
                      'Manager',
                      style: bodySemiBold,
                    ),
                    subtitle: Obx(
                      () => Text(
                        homeController.managerAddress.value,
                      ),
                    ),
                  ).paddingOnly(top: 16),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.box,
                      color: primaryColor,
                    ),
                    title: const Text(
                      'Prize Pool',
                      style: bodySemiBold,
                    ),
                    subtitle: Obx(
                      () => Text(
                        homeController.contractBalance.value,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.users,
                      color: primaryColor,
                    ),
                    title: const Text(
                      'Players Entered',
                      style: bodySemiBold,
                    ),
                    subtitle: Obx(
                      () => Text(
                        '${homeController.players.length}',
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.gift,
                      color: primaryColor,
                    ),
                    title: const Text(
                      'Last Winner',
                      style: bodySemiBold,
                    ),
                    subtitle: Obx(
                      () => Text(
                        '${homeController.lastWinner.value} ',
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.userAlt,
                      color: primaryColor,
                    ),
                    title: const Text(
                      'Account Address',
                      style: bodySemiBold,
                    ),
                    subtitle: Text(
                      homeController.userAddress.value,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.wallet,
                      color: primaryColor,
                    ),
                    title: const Text(
                      'Account Balance',
                      style: bodySemiBold,
                    ),
                    subtitle: Obx(
                      () => Text(
                        homeController.userBalance.value,
                      ),
                    ),
                  ),
                  const ListTile(
                    title: Text(
                      'Enter Amount in ETH',
                      style: bodySemiBold,
                    ),
                    subtitle: Text(
                      'Min value: 0.002 ETH',
                    ),
                  ),
                  TextField(
                    controller: homeController.amountController,
                    keyboardType: TextInputType.number,
                    decoration: borderedInputDecoration(
                      fillColor: primaryColor,
                      hint: 'Enter amount in ether e.g. 1',
                      icon: const Icon(
                        FontAwesomeIcons.ethereum,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: homeController.amountController.clear,
                        icon: const Icon(
                          Icons.clear,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ).paddingAll(16),
                  Obx(
                    () => homeController.loading.value
                        ? Center(
                            child: CircularProgressIndicator.adaptive(
                              valueColor:
                                  homeController.animationController.drive(
                                ColorTween(
                                  begin: primaryColor,
                                  end: Colors.green,
                                ),
                              ),
                            ),
                          )
                        : MaterialButton(
                            onPressed: homeController.submitLottery,
                            color: primaryColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                            child: const Text(
                              'Submit',
                              style: bodySemiBold,
                            ).paddingAll(12),
                          ).paddingSymmetric(vertical: 4, horizontal: 16),
                  ),
                  Obx(
                    () => !homeController.loading.value &&
                            homeController.userAddress.value ==
                                homeController.managerAddress.value
                        ? MaterialButton(
                            onPressed: homeController.pickWinner,
                            color: secondaryColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                            child: const Text(
                              'Pick Winner',
                              style: bodySemiBold,
                            ).paddingAll(12),
                          ).paddingSymmetric(vertical: 16, horizontal: 16)
                        : Container(),
                  ),
                  ListTile(
                    title: Obx(
                      () => Text(
                        homeController.message.value,
                        textAlign: TextAlign.center,
                        style: bodySemiBold.copyWith(
                            color:
                                homeController.message.value.contains('error')
                                    ? Colors.red
                                    : Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
