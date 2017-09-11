---
title: Rakyll
abstract: 静的サイトジェネレータ
technologies: Ruby
---

## What's This?

- [genya0407/rakyll](https://github.com/genya0407/rakyll)

このページを作成するために作成したRuby gem。
[Hakyll](https://jaspervdj.be/hakyll/)というHaskellの静的サイトジェネレータDSLに大きく影響を受けている。
というかほとんどHakyllのRuby cloneである。

## 使い方

以下に、このサイトを生成するスクリプトの一部を抜粋する。

```ruby
Rakyll.dsl do
  match 'products/*' do
    apply 'default.html.erb'
  end

  copy 'assets/*/*'

  create 'index.html' do
    @products = load_all 'products/*'
    @qiita_items = get_qiita_items
    @title = "About: Yusuke Sangenya"
    apply 'index.html.erb'
    apply 'default.html.erb'
  end
end
```

このようなDSLを書いておき、Markdownで書いた記事や、ERBで書いたHtmlテンプレート、CSSやJavaScripや画像ファイルを指定のディレクトリに配置すれば、このページが生成される。

## 何故作ったのか

既存の静的サイトジェネレータに不満があったからである。

### Jekyllへの不満

Rubyの静的サイトジェネレータは存在する。Jekyllである。
しかし、Jekyllは自由度が低い。

例えば、「CSVからイベントの日付を読み込んで、それをもとに`events/${event-title}.html`みたいなページを自動で生成し、さらにそれらのページへのリンクを埋め込んだ`events.html`というページも作る」というようなことはできない。

これは、そもそもJekyllがそういう用途のためには作られていないからである。

### Hakyllへの不満

そこで[Hakyll](https://jaspervdj.be/hakyll/)の出番である。

Hakyllは、Haskellの静的サイトジェネレータ **DSL** である。
`site.hs`というファイルにサイトの構造を書くことで、かなり高い自由度でサイトを生成できる。
しかし、問題が３つある。Haskellを書くのが難しいということと、コンパイルが遅いということ、その他のライブラリが充実していない（ことがある）ことである。

#### Haskellが難しい

Haskellは良い言語だと思うし、動的言語よりも書きやすいという人がいるのも知っているが、少なくとも私にとってHaskellを書くのは難しい。
しかも、単なる静的サイトジェネレータであるから、Haskellの売りである堅牢性であるとか、強力な型システムの優位性といったものは、それほど必要とされない。

#### コンパイルが遅い

コンパイル時間が発生するのも良くない。
「`site.hs`を書き換えてコンパイルし、さらにHTMLファイルとディレクトリを生成し直す」までの待ち時間はストレスである。
これはHaskellやHakyllが悪いというよりは、コンパイルが必要な言語でやるのが間違っているのだと思う。

#### ライブラリの不足

少なくともRubyに比べてHaskellは、ライブラリの数や「なんのライブラリでもある感」という観点からは劣っているように思える。

例えば、このWebサイトのトップには、私がQiitaで書いた記事の一覧を表示しているが、これをHaskellで実現するのは面倒だった。
というのもHaskellにはQiitaのAPIを叩くクライアントライブラリは存在しないため、自前でHTTP Requestを投げ、JSONをパースする必要があったからである。
もちろんHTTP Requestを投げるライブラリやJSONをパースするライブラリはあるが、APIを利用する処理を自前で書くのは面倒だった。

### こんな静的サイトジェネレータDSLが欲しい

以上の不満から、

- サイトの構造が自由である
- （私にとって）簡単な言語で書ける
- DSLファイルをコンパイルしなくて良い
- 周辺ライブラリが充実している

という条件を満たすフレームワークが欲しいという結論に至った。
そして、そういうものは存在していないようだったので、Rakyllというgemを作成した。

これが、Rakyllを作った経緯である。
