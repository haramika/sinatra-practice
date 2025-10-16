# **メモアプリの開発**
## 概要
RubyのSinatraを用いてメモアプリを作成しました。

## 立ち上げ手順
・リポジトリを`git clone`する　※開発ブランチのmemoをクローン

    git clone https://github.com/haramika/sinatra-practice.git -b memo

・ディレクトリに移動する
  
    cd sinatra-practice

・必要なGemをインストールする

　　bundle install

・アプリケーションを起動する

    ruby sinatra_memo.rb
  
・ブラウザで下記にアクセスする

    http://localhost:4567/memo/top
