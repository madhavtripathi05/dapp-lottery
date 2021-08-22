import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:lottery_flutter/app/modules/home/views/lottery_view.dart';
import 'package:lottery_flutter/app/modules/home/views/my_paint.dart';
import 'package:lottery_flutter/app/modules/home/views/svg_wrapper.dart';
import 'package:lottery_flutter/utils/constants.dart';
import 'package:lottery_flutter/utils/font_styles.dart';
import 'package:lottery_flutter/utils/input_decorations.dart';
import 'package:lottery_flutter/utils/remove_scroll_glow.dart';
import 'package:lottery_flutter/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: const Text('Select or Add Account', style: bodySemiBoldBig),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.github),
          onPressed: () async {
            const url = 'https://github.com/madhavtripathi05/dapp-lottery';
            await canLaunch(url)
                ? await launch(url)
                : throw 'Could not launch $url';
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.bottomSheet(
                  Container(
                    decoration: BoxDecoration(
                      color: Get.theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Obx(
                      () => ScrollConfiguration(
                        behavior: RemoveScrollGlow(),
                        child: ListView(
                          children: [
                            ListTile(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(FontAwesomeIcons.user)
                                      .paddingOnly(right: 16),
                                  const Text(
                                    'Accounts',
                                    style: bodySemiBoldBig,
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Get.changeThemeMode(
                                            Get.theme.brightness ==
                                                    Brightness.dark
                                                ? ThemeMode.light
                                                : ThemeMode.dark);
                                        Get.back();
                                      },
                                      icon: Icon(Get.theme.brightness ==
                                              Brightness.dark
                                          ? Icons.light_mode
                                          : Icons.dark_mode)),
                                  IconButton(
                                      onPressed: Get.back,
                                      icon: const Icon(Icons.clear)),
                                ],
                              ),
                            ),
                            if (homeController.users.isEmpty)
                              Column(
                                children: [
                                  FutureBuilder<DrawableRoot?>(
                                      future: SvgWrapper(accountsSvgCode)
                                          .generateLogo(),
                                      builder: (ctx, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          );
                                        }
                                        return Row(
                                          children: [
                                            SizedBox(
                                              height: avatarSize * 2,
                                              width: Get.width,
                                              child: CustomPaint(
                                                painter: MyPainter(
                                                    snapshot.data!,
                                                    Size(
                                                      Get.width,
                                                      avatarSize * 2,
                                                    )),
                                                child: Container(),
                                              ),
                                            ),
                                          ],
                                        ).paddingOnly(top: 32);
                                      }),
                                  const ListTile(
                                    title: Text(
                                      'Your saved Accounts will appear here',
                                      textAlign: TextAlign.center,
                                      style: bodySemiBold,
                                    ),
                                  ).paddingOnly(top: 8),
                                ],
                              ),
                            ...homeController.users.map(
                              (u) => FutureBuilder<DrawableRoot?>(
                                  future: SvgWrapper(u.avatar).generateLogo(),
                                  builder: (ctx, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      );
                                    }
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      elevation: 2,
                                      child: Dismissible(
                                        key: UniqueKey(),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) =>
                                            homeController.removeAccount(u),
                                        background: Container(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          alignment: Alignment.centerRight,
                                          decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 32.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: ListTile(
                                          onTap: () =>
                                              homeController.selectAccount(u),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          isThreeLine: true,
                                          trailing: const Icon(
                                                  Icons.arrow_forward_ios)
                                              .paddingSymmetric(vertical: 16),
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
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(FontAwesomeIcons.user))
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: ScrollConfiguration(
            behavior: RemoveScrollGlow(),
            child: RefreshIndicator(
              onRefresh: homeController.reloadContract,
              color: primaryColor,
              child: ListView(
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      'Enter your private key',
                      style: bodySemiBold,
                    ),
                  ).paddingOnly(top: 16),
                  TextField(
                    controller: homeController.keyController,
                    decoration: borderedInputDecoration(
                      fillColor: primaryColor,
                      hint: 'Copy private key from Metamask and paste here',
                      icon: const Icon(
                        FontAwesomeIcons.userLock,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: homeController.keyController.clear,
                        icon: const Icon(
                          Icons.clear,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: homeController.initWallet,
                    splashColor: splashColor,
                    child: Text(
                      'Fetch account details',
                      style: bodySemiBoldSmall.copyWith(color: primaryColor),
                    ),
                  ).paddingSymmetric(vertical: 2),
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
                            leading: const Icon(
                              FontAwesomeIcons.ethereum,
                              color: primaryColor,
                            ),
                            title: const Text(
                              'Account Balance',
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
                            !homeController.loading.value
                        ? const ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              'Enter Account Name',
                              style: bodySemiBold,
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
                                hint: 'Enter name of account to save',
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
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: homeController.check.value
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.spaceAround,
                              children: [
                                if (!homeController.check.value)
                                  IconButton(
                                      onPressed: () => homeController
                                          .generateSvg(force: true),
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
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          title: const Text(
                                            'Address',
                                            style: bodySemiBold,
                                          ),
                                          subtitle: Text(
                                            homeController.userAddress.value,
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          title: const Text(
                                            'Balance',
                                            style: bodySemiBold,
                                          ),
                                          subtitle: Text(
                                            homeController.userBalance.value,
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
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
                          onPressed: () => Get.to(() => LotteryView()),
                          color: Colors.green,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          child: const Text(
                            'Proceed to Lottery',
                            style: bodySemiBold,
                          ).paddingAll(12),
                        ).paddingSymmetric(vertical: 4, horizontal: 8)
                      : const SizedBox.shrink()),
                  ListTile(
                    title: Text(
                      homeController.message.value,
                      style: bodySemiBold,
                    ),
                  )
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }
}
