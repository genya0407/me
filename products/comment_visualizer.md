---
title: Comment Visualizer
abstract: ニコニコ動画のコメントの時間分布を可視化するChrome拡張機能
image-path: assets/image/visualizer.png
technologies: JavaScript
---

- [ソースコード](https://github.com/genya0407/niconico\_comment\_visualiser)
- [Chromeウェブストア](https://chrome.google.com/webstore/detail/niconicocommentvisualizer/lahlfbnopindeiocbcconhmdiodmgagb)

ニコニコ動画のコメントの時間分布を可視化するChrome拡張機能。
画像のように、動画の下部分にグラフが現れ、単位時間あたりのコメント数がわかるようになる。

ニコ動のAPIを複数回叩く必要があるため、ナイーブに書くとコールバック地獄になりそうだが、
この拡張機能ではPromiseをうまく使うことによって、コールバック地獄を回避できたと思う。
私がPromiseの使い方を理解するきっかけになった。
