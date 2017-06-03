title: 熊野寮内部ページ
abstract: 熊野寮で使われるWebアプリ
technologies: Django | Python | Bootstrap
---

- [kumano-dormitory/kumanodocs](https://github.com/kumano-dormitory/kumanodocs)

PythonのWebフレームワーク[Django](http://djangoproject.jp/)で作成した。

私が居住している京都大学熊野寮の寮生用ページ。

寮には、月に二回開かれるホームルームのようなものがある。
このWebアプリは、そこで読む資料を出力するWebアプリである。
大まかには、記事を投稿・閲覧する機能と、それらの記事を一つのPDFファイルにまとめて出力する機能の二つからなっている。

突貫で作成したということもあり、汚く長すぎるコードが散見される。現在リファクタリング／テスト作成中である。
また、一から新しく作り直すというプロジェクトも進行中である。

投稿された記事は寮外秘ということになっているので、アクセスできません。ご容赦ください。

