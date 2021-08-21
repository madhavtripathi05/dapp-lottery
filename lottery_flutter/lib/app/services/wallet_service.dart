import 'dart:math'; //used for the random number generator

import 'package:web3dart/web3dart.dart';

class WalletService {
  Credentials? credentials;

  WalletService(String privateKey) {
    if (privateKey.isNotEmpty) {
      // create Credentials from private keys
      credentials = EthPrivateKey.fromHex(privateKey);
    }
    // Or generate a new key randomly
    // else {
    //   credentials = EthPrivateKey.createRandom(Random.secure());
    // }
  }
}
