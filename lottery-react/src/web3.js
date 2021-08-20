import Web3 from 'web3';
let web3;
// Modern DApp Browsers
if (typeof window !== 'undefined' && typeof window.ethereum !== 'undefined') {
  // We are in the browser and metamask is running.
  window.ethereum.request({ method: 'eth_requestAccounts' });
  web3 = new Web3(window.ethereum);
  console.log(web3.eth.accounts);
}
// Legacy DApp Browsers
else if (window.web3) {
  web3 = new Web3(window.web3.currentProvider);
  console.log(web3.eth.accounts);
}
// Non-DApp Browsers
else {
  alert('You have to install MetaMask !');
}

export default web3;
