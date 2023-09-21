<img width="1074" alt="README_image" src="https://github.com/kan0109/tirtumo/assets/114494047/4bc2607e-1c44-48ca-8225-8f18f9947363">


## サービスURL　https://tiritumo-setuyaku.fly.dev/

## サービス概要
・節約を継続できるサービスです。
・ユーザー同士の節約術を共有できます。

## ユーザーが抱える課題
・節約が長続きしない
・単純に節約は楽しくない

## 課題に対する仮説
・具体的にどれくらい節約できているのかわからないので、成果が見えづらい
・モチベーション維持が難しい

## 解決方法
・1日の中で節約したものを金額で集計し、一ヶ月単位で結果を出す。
  (例)家から水筒を持って出かける、金額100円
  1ヶ月計20,000円、ユーザーステータス：達人など

・あらかじめこちらから節約項目を提示することで、ユーザーが何をすれば節約できるのかをわかりやすくし、ユーザーは項目欄にチェックし記録するだけで良い。
また。ユーザー独自の節約項目を儲ける。

## メインのターゲットユーザー
・このサービスを使いちりつもで集まった金額で、何か購入したい人
例)再来月に欲しい技術書が出るので、その費用を捻出したい人など

・節約を始めようと考えている人

## 実装機能

  - ログイン
    - LINEを使用したログイン

  - 投稿機能
    - ユーザーの節約術を投稿します。
    - 投稿の作成、編集、削除
    - 節約のタグづけ
    - いいね、コメント
    - 検索（キーワード、タグ、ソート順で検索できます）

  - 記録機能
    - デフォルトで節約リストがあり、こちらをチェックします。
    　チェックすると節約金額に反映されます。
    - ユーザー独自の節約項目を作成、編集
    　こちらは節約の内容と金額を設定します。
    　作成した項目をチェックすると節約金額に反映されます。
    - 記録は1日に一回までで、記録をしたユーザは次の日まで節約リストが非表示になります。
    - 節約金額に応じてカテゴリー分けします。
      金額に対して、カテゴリー名と画像が変化します。

  - 目標機能
    - ユーザーは節約の目標と金額を設定できます。
    　例（新しいスニーカーが欲しい　金額：15,000円）
    　編集もできます。

  - ランキング
    - 各ユーザーの節約金額のランキングを表示
    - ランキングから各ユーザーの詳細が表示されます。

  - LINE公式アカウント友達追加
    - リッチメニューを導入しており、メニューからホームページ、記録、投稿一覧に移動できます。


  - 管理者機能
    - ユーザーの編集、削除ができます。
    - 投稿の編集、削除ができます。

## なぜこのサービスを作りたいのか？
自分自身お金を貯めるのが苦手で、ついコンビニで無駄遣いをしたりして、そういった無駄遣いがなくなったら、どれくらいのお金が貯められるのかが気になりました。
また節約しても長続きしないで終わってしまうことが多く継続性がないため、そういった人たちを少しでも楽しみながら節約できたらいいなと思いこのサービスを作りました。

## スケジュール

企画〜技術調査：6/9〆切
README〜ER図作成：6/15 〆切
メイン機能実装：6/16 - 7/20
β版をRUNTEQ内リリース（MVP）：8/1〆切
本番リリース：9月3日

## 技術選定
・Rails7
・PostgreSQL
・Bootstrap
・fly.io
・AWS S3
・LINEログイン

## Figma(設計)
https://www.figma.com/file/U6lkf1LEtS81iuJ2HhO4vz/%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?type=design&node-id=0-1&t=4p0uecCgC9Zcnsxs-0


## ER図
<img width="1074" alt="ER図(ポートフォリオ改訂版)" src="https://github.com/kan0109/tirtumo/assets/114494047/0ba7d5f3-d13e-4271-91c2-342ad7eb0c9b">
