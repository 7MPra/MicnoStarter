# MicnoStarter
これはMicnoLinux用の初回起動時に実行されるウィザード形式のパッケージインストーラーです。
# 動作環境
ネットワークに接続済みのdebianでのみ動作可能
# 依存関係
`curl, wget, gdebi, bash, python3, python3-gi, xfce4-terminal`
# How to build
```
git clone https://github.com/TMP-tenpura/MicnoStarter.git
cd MicnoStarter
dpkg -b MicnoStarter
sudo apt install ./MicnoStarter.deb
