# ビットコイン取引Bot on Docker
仮想通貨の自動取引システムをDocker上で起動させるためのスクリプト集です。

取引システム本体は下記から購入ください。

## BFS-X
ポジションを自炊して高速に売買を行うbitFlyerでの高速botフレームワーク(mmbotと高速スキャルピングbotのサンプルロジック付属)  
https://note.com/kunmosky1/n/n112b73eee4f0

## NeoDuelBot
Cloud9で動作するポジション自炊・ロジック切替・高頻度・バックテスト可能な BitMEX/Bybit/Liquid 対応の BOT フレームワーク NeoDuelBot（ロジック多数付属）  
https://note.com/inagobot/n/n597cdf2a7fe6

## Docker 環境の準備について
導入手順は下記を参考にLinux上でdocker-composeが動作する環境をご用意ください。  
http://docs.docker.jp/compose/install.html

## 使い方

### BFS-X
ソースコードを展開します
```bash
$ unzip BFS-X_VNNN_NNNNNNNN.zip -d ./docker/bfs-x/
```
コンテナのビルドします
```bash
$ docker-compose build bfs-x pos-server
```
ビルドが完了したらコンテナの起動します。  
ソースコードがアップデートされたら同様の手順でソースコードを展開しビルドを行ってください。
```bash
$ docker-compose up -d bfs-x pos-server
```
起動が完了したらコンテナへアタッチします
```bash
$ docker-compose exec -it bfs-x bash
```
コンソールがコンテナ内に移動します
```bash
root@d07bbb68e3bc:/scripts# ls -l
total 108
drwxrwxr-x 2 root root  4096 Jun 15 13:53 documents
drwxrwxr-x 2 root root  4096 Jun 15 13:53 libs
-rw-rw-r-- 1 root root 33362 Jun 15 13:53 pos_server.py
drwxrwxr-x 2 root root  4096 Apr 11 19:22 pybitflyer
drwxrwxr-x 2 root root  4096 Jun 15 13:53 strategy
-rw-rw-r-- 1 root root 52773 Jun 15 13:53 trade.py
-rw-rw-r-- 1 root root  3265 Jul  4 21:16 trade.yaml
```

### Neoduelbot
ソースコードを展開します。  
ユーザ名とパスワードを入力します。  
```bash
$ cd ./docker/neo_duelbot2
$ ./init.sh
```
ビルドが完了したらコンテナの起動します。  
ソースコードがアップデートされたら同様の手順でソースコードを展開しビルドを行ってください。  
```bash
$ cd ../../
$ docker-compose build neo_duelbot2
```
コンテナの起動
```bash
$ docker-compose up -d neo_duelbot2
```
コンテナへのアタッチ
```bash
$ docker-compose exec -it neo_duelbot2 bash
```
コンソールがコンテナ内に移動します
```bash
root@f1958b7a97cb:/scripts# ls -l
total 96
-rw-rw-r-- 1 root root  7770 Jul  4 20:16 backtester.py
-rwxrwxr-x 1 root root  2066 Jul  4 20:16 collector_bybit.py
-rw-rw-r-- 1 root root  2263 Jul  4 20:16 collector_liquid.py
-rwxrwxr-x 1 root root  2002 Jul  4 20:16 collector.py
drwxrwxr-x 2 root root  4096 Jul  4 20:16 config
drwxrwxr-x 4 root root  4096 Jul  4 20:16 documents
-rw-rw-r-- 1 root root  4866 Jul  4 20:16 duelbot.py
drwxrwxr-x 3 root root  4096 Jul  4 20:16 extlibs
-rwxrwxr-x 1 root root  1321 Jul  4 20:16 install.sh
drwxrwxr-x 8 root root  4096 Jul  4 20:16 libs
-rw-rw-r-- 1 root root 16788 Jul  4 20:16 opt_backtester.py
-rw-rw-r-- 1 root root   375 Jul  4 20:16 README.md
-rw-rw-r-- 1 root root 11420 Jul  4 20:16 relay_server.py
-rwxrwxr-x 1 root root   290 Jul  4 20:16 setup_cloud9.sh
-rwxrwxr-x 1 root root   275 Jul  4 20:16 setup_crontab.sh
drwxrwxr-x 5 root root  4096 Jul  4 20:16 strategy
```

## コンテナとホストOS間でのファイル共有

コンテナに保存されたデータは永続化されていません。
`docker-compose down -v`等のコマンドでコンテナを停止すると、
コンテナ内に保存されたデータはすべて削除されます。  
そこで、ホストOS間とコンテナ間で共有しているディレクトリ`/work`にデータをコピーして大事なデータをバックアップしてください。

また、ストラテジファイルについてはホスト側の`./bfsx-strategy`及び`./neo_duelbot2-strategy`に保存しておけば、
コンテナ内のディレクトリ`/my-strategy`からデータにアクセスすることができます。

## APIキーを設定する
`.env`ファイルの`API_KEY`と`SECLET_KEY`の値を修正します。

コンテナを再起動し環境変数の中身を確認します。
```
$ docker-compose up -d bfs-x

root@d07bbb68e3bc:/scripts# env |grep _KEY
ACCESS_KEY=ssssssssssssssssssss
SECLET_KEY=ssssssssssssssssssssssssssssssssssss
```

BFS-Xについてはコンテナのエントリポイント(起動時に最初に実行されるスクリプト)から  
`trade.yaml`の設定を環境変数に設定された値に置き換えています。
```
root@d07bbb68e3bc:/scripts# cat /entrypoint.sh
#!/bin/bash
sed -i -e "s/__ACCESS_KEY__/$ACCESS_KEY/g" trade.yaml
sed -i -e "s/__SECLET_KEY__/$SECLET_KEY/g" trade.yaml
sed -i -e "s|__WEBHOOK_URL__|$WEBHOOK_URL|g" trade.yaml
tail -f /proc/cpuinfo
```
