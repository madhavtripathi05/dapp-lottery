import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:lottery_flutter/app/modules/home/views/lottery_view.dart';
import 'package:lottery_flutter/app/modules/home/views/my_paint.dart';
import 'package:lottery_flutter/app/modules/home/views/svg_wrapper.dart';
import 'package:lottery_flutter/utils/font_styles.dart';
import 'package:lottery_flutter/utils/input_decorations.dart';
import 'package:lottery_flutter/utils/theme.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final homeController = Get.put(HomeController(), permanent: true);
  final avatarSize = 100.0;

  Widget _avatarPreview() {
    return GetBuilder<HomeController>(
      builder: (_) => Container(
        height: avatarSize,
        width: avatarSize,
        child: _.svgRoot == null
            ? const SizedBox.shrink()
            : Material(
                elevation: 8,
                shape: const CircleBorder(),
                child: CustomPaint(
                  painter: MyPainter(_.svgRoot!, Size(avatarSize, avatarSize)),
                  child: Container(),
                ),
              ),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Account'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.bottomSheet(Container(
                  color: Colors.white,
                  height: Get.height * 0.9,
                  child: ListView(
                    children: [
                      const ListTile(
                        title: Text(
                          'Users',
                          style: bodySemiBoldBig,
                        ),
                      ),
                      ...homeController.users.map(
                        (u) => FutureBuilder<DrawableRoot?>(
                            future: SvgWrapper(u.avatar).generateLogo(),
                            builder: (ctx, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator
                                    .adaptive();
                              }
                              return Card(
                                child: ListTile(
                                  onTap: () => homeController.selectAccount(u),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  leading: Container(
                                    height: avatarSize / 2,
                                    width: avatarSize / 2,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Material(
                                      elevation: 8,
                                      shape: const CircleBorder(),
                                      child: CustomPaint(
                                        painter: MyPainter(
                                            snapshot.data!,
                                            Size(avatarSize / 2,
                                                avatarSize / 2)),
                                        child: Container(),
                                      ),
                                    ),
                                  ),
                                  title: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                      u.name,
                                      style: bodySemiBold,
                                    ),
                                    subtitle: Text(u.address),
                                  ),
                                ),
                              ).paddingAll(8);
                            }),
                      )
                    ],
                  ),
                ));
              },
              icon: const Icon(Icons.verified_user))
        ],
      ),
      body: ListView(
        children: [
          const ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              'Enter your private key',
              style: bodySemiBoldBig,
            ),
          ).paddingOnly(top: 16),
          TextField(
            controller: homeController.addressController,
            decoration: borderedInputDecoration(
                fillColor: primaryColor,
                icon: const Icon(
                  FontAwesomeIcons.userLock,
                  color: primaryColor,
                ),
                suffixIcon: IconButton(
                    onPressed: homeController.addressController.clear,
                    icon: const Icon(
                      Icons.clear,
                      color: primaryColor,
                    ))),
          ),
          TextButton(
              onPressed: homeController.initWallet,
              child: const Text('Fetch account details')),
          Obx(
            () => homeController.loading.value &&
                    homeController.userAddress.isEmpty
                ? const ListTileShimmer(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.symmetric(vertical: 8),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => homeController.userAddress.value.isNotEmpty
                ? ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text(
                      'Address',
                      style: bodySemiBold,
                    ),
                    subtitle: Text(
                      homeController.userAddress.value,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => homeController.loading.value &&
                    homeController.userBalance.isEmpty
                ? const ListTileShimmer(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.symmetric(vertical: 8),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => homeController.userBalance.value.isNotEmpty
                ? ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text(
                      'Balance',
                      style: bodySemiBold,
                    ),
                    subtitle: Text(
                      homeController.userBalance.value,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => homeController.loading.value
                ? const ListTileShimmer(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.symmetric(vertical: 8),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => homeController.userBalance.value.isNotEmpty &&
                    homeController.name.value.isNotEmpty &&
                    !homeController.loading.value
                ? const ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      'Enter Account Name',
                      style: bodySemiBoldBig,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => homeController.userBalance.value.isNotEmpty &&
                    !homeController.loading.value
                ? TextField(
                    controller: homeController.nameController,
                    decoration: borderedInputDecoration(
                        fillColor: primaryColor,
                        icon: const Icon(
                          FontAwesomeIcons.userAstronaut,
                          color: primaryColor,
                        )),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => homeController.loading.value
                ? const ProfileShimmer(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.symmetric(vertical: 8),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => homeController.userAddress.value.isNotEmpty &&
                    homeController.userBalance.value.isNotEmpty &&
                    !homeController.loading.value
                ? Card(
                    child: Row(
                      mainAxisAlignment: homeController.check.value
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.spaceAround,
                      children: [
                        if (!homeController.check.value)
                          IconButton(
                              onPressed: homeController.generateSvg,
                              icon: const Icon(Icons.refresh)),
                        GestureDetector(
                            onTap: homeController.check.toggle,
                            child: _avatarPreview()),
                        if (!homeController.check.value)
                          IconButton(
                              onPressed: () {
                                homeController.check.value = true;
                              },
                              icon: const Icon(Icons.check)),
                        if (homeController.check.value)
                          const SizedBox(
                            width: 32,
                          ),
                        if (homeController.check.value)
                          Expanded(
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: const Text(
                                    'Address',
                                    style: bodySemiBold,
                                  ),
                                  subtitle: Text(
                                    homeController.userAddress.value,
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: const Text(
                                    'Balance',
                                    style: bodySemiBold,
                                  ),
                                  subtitle: Text(
                                    homeController.userBalance.value,
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: const Text(
                                    'Account Name',
                                    style: bodySemiBold,
                                  ),
                                  subtitle: Text(
                                    homeController.name.value,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ).paddingAll(16),
                  )
                : const SizedBox.shrink(),
          ).paddingOnly(top: 16),
          Obx(() => (!homeController.loading.value &&
                  homeController.userAddress.value.isNotEmpty &&
                  !homeController.loading.value)
              ? MaterialButton(
                  onPressed: homeController.saveAccount,
                  color: primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: const Text(
                    'Save Account',
                    style: bodySemiBold,
                  ).paddingAll(12),
                ).paddingSymmetric(vertical: 16, horizontal: 8)
              : const SizedBox.shrink()),
          Obx(() => (!homeController.loading.value &&
                  homeController.userAddress.value.isNotEmpty &&
                  !homeController.loading.value)
              ? MaterialButton(
                  onPressed: () => Get.off(() => LotteryView()),
                  color: primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: const Text(
                    'Proceed to Lottery',
                    style: bodySemiBold,
                  ).paddingAll(12),
                ).paddingSymmetric(vertical: 16, horizontal: 8)
              : const SizedBox.shrink()),
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
