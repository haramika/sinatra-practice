# **メモアプリの開発**
## 概要
RubyのSinatraを用いてメモアプリを作成しました。(DBにデータを保存)

## 立ち上げ手順
- リポジトリを`git clone`する　※開発ブランチのmemoをクローン

    git clone https://github.com/haramika/sinatra-practice.git -b db

- ディレクトリに移動する
  
    cd sinatra-practice

- データ保存先のデータベースを作成する

  - postgreSQLへログイン

      psql -Upostgres

  - データベースを作成

      CREATE DATABASE memo;

- テーブルを作成する

    CREATE TABLE memos
    (id TEXT not null,
    title TEXT,
    body TEXT,
    PRIMARY KEY(id));

- 必要なGemをインストールする

    bundle install

- アプリケーションを起動する

    ruby sinatra_memo.rb
  
- ブラウザで下記にアクセスする

    http://localhost:4567/memos
