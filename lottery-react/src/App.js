import './App.css';
import { useEffect, useState } from 'react';
import web3 from './web3';
import lottery from './lottery';

function App() {
  const [manager, setManager] = useState('Loading...');
  const [value, setValue] = useState('');
  const [message, setMessage] = useState('');
  const [account, setAccount] = useState('');
  const [players, setPlayers] = useState([]);
  const [balance, setBalance] = useState('');
  const [winner, setWinner] = useState('');
  const [reload, setReload] = useState(false);
  const [loading, setLoading] = useState(false);
  useEffect(() => {
    const init = async () => {
      const accounts = await web3.eth.getAccounts();
      setAccount(accounts[0]);
      setManager(await lottery.methods.manager().call());
      setPlayers(await lottery.methods.getPlayers().call());
      setWinner(await lottery.methods.getCurrentWinner().call());
      setBalance(await web3.eth.getBalance(lottery.options.address));
    };
    init();
  }, [reload]);

  const onSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage('Processing your transaction...');
    console.log(account);
    await lottery.methods.enter().send({
      from: account,
      value: web3.utils.toWei(value, 'ether'),
    });
    setValue('');
    setMessage("You've been entered!");
    setLoading(false);
    setReload(!reload);
  };

  const pickWinner = async () => {
    setLoading(true);
    setMessage('Choosing a winner...');
    await lottery.methods.pickWinner().send({
      from: account,
    });
    const result = await lottery.methods.getCurrentWinner().call();
    console.log('result', result);
    setWinner(result);
    setMessage(`Winner is selected`);
    setLoading(false);
    setReload(!reload);
  };

  return (
    <div className=''>
      <h2>Lottery Smart Contract</h2>
      <p>This contract is managed by {manager}</p>
      <p>
        Currently there are {players.length} players entered with total of{' '}
        {web3.utils.fromWei(balance, 'ether')} ether
      </p>
      {account ? (
        <>
          <p>Your account: {account}</p>
        </>
      ) : (
        <>
          <p>
            Please login to your metamask account to continue, already done?{' '}
            <span>
              <button onClick={() => setReload(!reload)}>reload</button>
            </span>
          </p>
        </>
      )}
      <hr />
      <form onSubmit={onSubmit}>
        <h4>Try your luck!</h4>
        <h3>Minimum amount: 0.002 ether</h3>
        <div className=''>
          <label>
            <h3>Enter amount in ether: </h3>
          </label>
          <input
            type='text'
            value={value}
            onChange={(e) => setValue(e.target.value)}
          />
        </div>
        <br />
        <button>Enter</button>
        <br />
        <br />
        {account === '0xfb2F3A65c7EEA39b9b07D62ae5E3Acd168640689' && (
          <button type='button' onClick={pickWinner}>
            Pick a winner
          </button>
        )}
      </form>

      <h4>{message}</h4>
      {loading && (
        <svg
          className='spinner'
          width='65px'
          height='65px'
          viewBox='0 0 66 66'
          xmlns='http://www.w3.org/2000/svg'
        >
          <circle
            className='path'
            fill='none'
            strokeWidth='6'
            strokeLinecap='round'
            cx='33'
            cy='33'
            r='30'
          ></circle>
        </svg>
      )}

      {winner && <h4>Last winner: {winner}</h4>}
      <span>
        <a href='https://github.com/madhavtripathi05/dapp-lottery'>GitHub</a>
      </span>
    </div>
  );
}

export default App;
