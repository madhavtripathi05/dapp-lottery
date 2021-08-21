import 'dart:convert';

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import '../../utils/constants.dart';

final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0xAF3fc85741e2BD214C9C2e4500b77F0979ed129E');

final client = Web3Client(url, Client(), socketConnector: () {
  return IOWebSocketChannel.connect(ws).cast<String>();
});
final contract = DeployedContract(
    ContractAbi.fromJson(jsonEncode(abi), 'Lottery'), contractAddr);

class Web3Service {
  final getPlayersFunction = contract.function('getPlayers');
  final getCurrentWinnerFunction = contract.function('getCurrentWinner');
  final enterFunction = contract.function('enter');
  final managerFunction = contract.function('manager');
  final pickWinnerFunction = contract.function('pickWinner');
}
