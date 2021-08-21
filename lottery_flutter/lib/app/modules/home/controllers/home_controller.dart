import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottery_flutter/app/models/user.dart';
import 'package:lottery_flutter/app/modules/home/views/lottery_view.dart';
import 'package:lottery_flutter/app/modules/home/views/svg_wrapper.dart';
import 'package:lottery_flutter/app/services/wallet_service.dart';
import 'package:lottery_flutter/app/services/web3service.dart';
import 'package:lottery_flutter/utils/constants.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:web3dart/web3dart.dart';

class HomeController extends GetxController {
  DrawableRoot? svgRoot;
  late WalletService walletService;
  String? svgCode;
  final web3Service = Web3Service();
  final addressController = TextEditingController();
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  final managerAddress = ''.obs;
  final userAddress = ''.obs;
  final privateKey = ''.obs;
  final contractBalance = ''.obs;
  final userBalance = ''.obs;
  final lastWinner = ''.obs;
  final name = ''.obs;
  final loading = false.obs;
  final check = false.obs;
  final players = [].obs;
  final users = <User>{}.obs;

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
    loading.value = true;
    walletService = WalletService(privateKey.value);
    final address = await walletService.credentials?.extractAddress();
    userAddress.value = '$address';
    final balance = await client.getBalance(address!);
    userBalance.value = '${balance.getValueInUnit(EtherUnit.ether)} ETH';
    loading.value = false;
  }

  Future<void> saveAccount() async {
    loading.value = true;
    final user = User(
        address: userAddress.value,
        avatar: svgCode!,
        privateKey: privateKey.value,
        name: nameController.text);
    users.add(user);
    await box.write('users', users.map((u) => u.toJson()).toList());
    loading.value = false;
  }

  void selectAccount(User u) {
    privateKey.value = u.privateKey;
    name.value = u.name;
    addressController.text = u.privateKey;
    nameController.text = u.name;
    svgCode = u.avatar;
    update();
    generateSvg();
    initWallet();
    Get.back();
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

  Future<void> generateSvg() async {
    loading.value = true;
    svgCode ??= multiavatar(DateTime.now().millisecondsSinceEpoch.toString());
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
    addressController.addListener(() {
      privateKey.value = addressController.text;
    });
    super.onInit();
  }
}
