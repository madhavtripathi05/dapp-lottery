##Lottery Smart Contract built with Solidity and React.
###Deploy contract on the ethereum network:
* `npm i` inside root folder and [lottery-react](./lottery-react/package.json) to install dependencies.
* run `node compile.js` to compile the contract.
* run `node deploy.js` to deploy on rinkeby network.

###Deploy web app locally:
* copy the contract deployment address from console to `address` variable and `abi` from [build/Lottery.json](./build/Lottery.json)  inside [lottery-react/src/lottery.js](./lottery-react/src/lottery.js)
* run locally with `yarn start`

###Deploy web app on gh-pages:
* change `homepage` from [lottery-react/package.json](./lottery-react/package.json) to `https://{username}.github.io/{repo-name}`
* run `yarn deploy` to deploy on gh-pages.



