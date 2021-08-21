import 'package:get_storage/get_storage.dart';

const url = 'https://rinkeby.infura.io/v3/08113a6a0011405aae30abd9f32bf52f';
const ws = 'wss://rinkeby.infura.io/ws/v3/08113a6a0011405aae30abd9f32bf52f';
const secretPhrase =
    'absorb earth diesel congress inherit page unfold relax team taxi winner keep';
final box = GetStorage();
const abi = [
  {
    'inputs': [],
    'stateMutability': 'nonpayable',
    'type': 'constructor',
  },
  {
    'inputs': [],
    'name': 'currentWinner',
    'outputs': [
      {
        'internalType': 'address',
        'name': '',
        'type': 'address',
      },
    ],
    'stateMutability': 'view',
    'type': 'function',
  },
  {
    'inputs': [],
    'name': 'enter',
    'outputs': [],
    'stateMutability': 'payable',
    'type': 'function',
  },
  {
    'inputs': [],
    'name': 'getCurrentWinner',
    'outputs': [
      {
        'internalType': 'address',
        'name': '',
        'type': 'address',
      },
    ],
    'stateMutability': 'view',
    'type': 'function',
  },
  {
    'inputs': [],
    'name': 'getPlayers',
    'outputs': [
      {
        'internalType': 'address payable[]',
        'name': '',
        'type': 'address[]',
      },
    ],
    'stateMutability': 'view',
    'type': 'function',
  },
  {
    'inputs': [],
    'name': 'manager',
    'outputs': [
      {
        'internalType': 'address',
        'name': '',
        'type': 'address',
      },
    ],
    'stateMutability': 'view',
    'type': 'function',
  },
  {
    'inputs': [],
    'name': 'pickWinner',
    'outputs': [],
    'stateMutability': 'nonpayable',
    'type': 'function',
  },
  {
    'inputs': [
      {
        'internalType': 'uint256',
        'name': '',
        'type': 'uint256',
      },
    ],
    'name': 'players',
    'outputs': [
      {
        'internalType': 'address payable',
        'name': '',
        'type': 'address',
      },
    ],
    'stateMutability': 'view',
    'type': 'function',
  },
];
