title: Splatoon コラ画像ジェネレータ
abstract: Splatoonのフェスのコラ画像を生成するWebアプリ
technologies: JavaScript
---

- [ソースコード](https://github.com/genya0407/fes_generator)
- [動いているもの](https://kuminecraft.xyz/fes)
	- SSL鍵の更新を忘れたため、ブラウザで警告が出ます

任天堂から発売されたゲーム Splatoonの、[フェス](https://www.nintendo.co.jp/wiiu/agmj/festival/)のコラ画像を生成するWebアプリ。
すべてのロジックを生JSで書き、addEventListener地獄になった。

当時は以下のような理由から、公開は見送った。

- 公開場所を持っていなかった
- 著作権法的にまずそう
- 作成した画像をTwitterに投稿させるには、サーバーサイドの働きも必要だと判明したが、そこまでやる気力がなかった

![](/assets/image/fes-generator.png)