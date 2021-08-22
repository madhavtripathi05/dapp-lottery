import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottery_flutter/app/models/user.dart';

import 'package:lottery_flutter/app/modules/home/views/svg_wrapper.dart';
import 'package:lottery_flutter/app/services/wallet_service.dart';
import 'package:lottery_flutter/app/services/web3service.dart';
import 'package:lottery_flutter/utils/constants.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:web3dart/web3dart.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  DrawableRoot? svgRoot;
  late AnimationController animationController;
  late WalletService walletService;
  String? svgCode;
  final web3Service = Web3Service();
  final keyController = TextEditingController();
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  final managerAddress = ''.obs;
  final userAddress = ''.obs;
  final privateKey = ''.obs;
  final contractBalance = ''.obs;
  final userBalance = ''.obs;
  final lastWinner = ''.obs;
  final name = ''.obs;
  final message = ''.obs;
  final loading = false.obs;
  final check = true.obs;
  final players = [].obs;
  final users = <User>[].obs;

  Future<void> getManager() async {
    loading.value = true;
    final manager = await client.call(
        contract: contract, function: web3Service.managerFunction, params: []);
    managerAddress.value = '${manager.first}';
    loading.value = false;
  }

  Future<void> getLastWinner() async {
    loading.value = true;
    final winner = await client.call(
        contract: contract,
        function: web3Service.getCurrentWinnerFunction,
        params: []);
    lastWinner.value = '${winner.first}';
    loading.value = false;
  }

  Future<void> getLotteryBalance() async {
    loading.value = true;
    final balance = await client.getBalance(contract.address);
    contractBalance.value = '${balance.getValueInUnit(EtherUnit.ether)} ETH';
    loading.value = false;
  }

  Future<void> getPlayers() async {
    loading.value = true;
    final currentPlayers = await client.call(
        contract: contract,
        function: web3Service.getPlayersFunction,
        params: []);
    if (currentPlayers.isNotEmpty) {
      players.assignAll(currentPlayers.first);
    }
    loading.value = false;
  }

  Future<void> initWallet() async {
    if (keyController.text.length == 64 || privateKey.value.length == 64) {
      loading.value = true;
      walletService = WalletService(privateKey.value);
      final address = await walletService.credentials?.extractAddress();
      userAddress.value = '$address';
      final balance = await client.getBalance(address!);
      userBalance.value = '${balance.getValueInUnit(EtherUnit.ether)} ETH';
      loading.value = false;
    } else {
      Get.rawSnackbar(message: 'Enter a valid Key');
    }
  }

  Future<void> saveAccount() async {
    loading.value = true;
    final user = User(
        address: userAddress.value,
        avatar: svgCode!,
        privateKey: privateKey.value,
        name: nameController.text);
    final existingUser = users.firstWhere((u) => u.address == userAddress.value,
        orElse: () => User(address: '', avatar: '', privateKey: '', name: ''));
    if (existingUser.address == '') {
      users.add(user);
      Get.rawSnackbar(message: 'Account Added');
    } else {
      int i = users.indexOf(existingUser);
      users[i] = User(
          address: existingUser.address,
          avatar: svgCode!,
          privateKey: existingUser.privateKey,
          name: nameController.text);
      Get.rawSnackbar(message: 'Account Updated');
    }

    await box.write('users', users.map((u) => u.toJson()).toList());
    loading.value = false;
  }

  void removeAccount(User u) {
    users.remove(u);
    box.write('users', users.map((u) => u.toJson()).toList());
  }

  Future<void> submitLottery() async {
    if (GetUtils.isNum(amountController.text) &&
        num.parse(amountController.text) > 0.001) {
      final amountInWei = pow(10, 18) * num.parse(amountController.text);

      loading.value = true;
      try {
        message.value = 'Processing transaction, please wait...';
        await client.sendTransaction(
            walletService.credentials!,
            Transaction.callContract(
              contract: contract,
              from: EthereumAddress.fromHex(userAddress.value),
              function: web3Service.enterFunction,
              parameters: [],
              value: EtherAmount.inWei(BigInt.from(amountInWei)),
            ),
            chainId: 4);
        message.value =
            "You've been entered, updating values may take sometime";
        await Future.delayed(const Duration(seconds: 5));
        await reloadContract();
        amountController.clear();
      } catch (e) {
        message.value = 'An error occurred: $e';
        Get.rawSnackbar(message: 'Error: $e');
      }
      loading.value = false;
      await Future.delayed(const Duration(seconds: 5), () {
        reloadContract();
        message.value = '';
      });
    } else {
      Get.rawSnackbar(message: 'Enter a valid value');
    }
  }

  Future<void> pickWinner() async {
    loading.value = true;
    message.value = 'Picking winner, please wait!';
    try {
      await client.sendTransaction(
          walletService.credentials!,
          Transaction.callContract(
            contract: contract,
            from: EthereumAddress.fromHex(userAddress.value),
            function: web3Service.pickWinnerFunction,
            parameters: [],
          ),
          chainId: 4);
      await getLastWinner();
      message.value = 'Winner: ${lastWinner.value} ';
    } catch (e) {
      message.value = 'An error occurred: $e';
      Get.rawSnackbar(message: 'Error: $e');
    }
    loading.value = false;
    await Future.delayed(const Duration(seconds: 10), () => message.value = '');
  }

  void selectAccount(User u) {
    privateKey.value = u.privateKey;
    nameController.text = u.name;
    name.value = u.name;
    keyController.text = u.privateKey;
    svgCode = u.avatar;
    update();
    generateSvg();
    initWallet();
    Get.back();
  }

  Future<void> reloadContract() async {
    await getLotteryBalance();
    await getPlayers();
    await getLastWinner();
    await initWallet();
  }

  Future<void> loadUsers() async {
    final localUsers = box.read('users');
    if (localUsers != null && localUsers.isNotEmpty) {
      users.assignAll(
        List<User>.from(
          localUsers.map(
            (u) => User(
              address: u['address'],
              name: u['name'],
              avatar: u['avatar'],
              privateKey: u['privateKey'],
            ),
          ),
        ),
      );
      selectAccount(users.first);
    }
  }

  Future<void> generateSvg({bool force = false}) async {
    loading.value = true;
    if (svgCode == null || force) {
      svgCode = multiavatar(DateTime.now().millisecondsSinceEpoch.toString());
    }
    svgRoot = await SvgWrapper(svgCode!).generateLogo();
    update();
    loading.value = false;
  }

  @override
  Future<void> onInit() async {
    await loadUsers();
    await generateSvg();
    await getManager();
    await getPlayers();
    await getLotteryBalance();
    await getLastWinner();
    nameController.addListener(() {
      name.value = nameController.text;
    });
    keyController.addListener(() {
      privateKey.value = keyController.text;
    });
    super.onInit();
  }

  @override
  void onReady() {
    animationController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    animationController.repeat();
    super.onReady();
  }
}
