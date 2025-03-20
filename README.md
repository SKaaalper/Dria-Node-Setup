## One-click run command:
```
curl -L https://raw.githubusercontent.com/SKaaalper/Dria-Node-Setup/main/install_dria.sh -o install_dria.sh && chmod +x install_dria.sh && ./install_dria.sh
```
▶️ Follow prompts to enter:
➖ **EVM Private Key**: Your Own Private Key, Always use burner Wallet.
➖ **models**: I choose 2 model for my VPS 3 server `gemini 1.5- flash` and `gemini2.0-flash`.
➖ **API keys**: Get your API Keys [Here](https://aistudio.google.com/app/apikey) ▶️ Register Account ▶️ Click **Create API Key** ▶️ Copy your key and save it.

![image](https://github.com/user-attachments/assets/50768b54-aca9-4008-835b-79f3e05db524)

➖ Skip Jina & Serper API key by pressing Enter
- Ctrl + C to skip logs

## Check logs:
```
tail -f /root/dria-node/dkn.log
```
![image](https://github.com/user-attachments/assets/5d27f223-d343-446e-84d9-7aae81d1eaee)
