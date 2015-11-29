# markdown_ex

仕様

```
■■見出し(markdown)

# 章扉リード文

## 第1レベル見出し

### 第2レベル見出し

#### 第3レベル見出し

##### 第4レベル見出し

または

章扉リード文
===============

第1レベル見出し
---------------

■■相互参照用見出し(kramdown)

# 章扉リード文
{: id="識別子"}

例)

# NoSQLとは
{: id="capter_about-nosql"}

■■斜体(markdown)

_斜体_

■■強調(markdown)

__強調__

■■インラインコード・等幅フォント(markdown)

`等幅フォント`

■■順序付きリスト(markdown)

1. 操作手順1
1. 操作手順2
1. 操作手順3

■■箇条書き(markdown)

* 箇条書き項目
* 箇条書き項目

■■図(kramdown)

![説明文](画像ファイル名){: id="識別子"}

例)

![IoTではまず多数のセンサーからのビッグデータ収集を行う。](bigdata.png){: id="img_bigdata"}


出力)

 -----------
 |         |
 |   図    |
 |         |
 -----------
 図1.1:IoTではまず多数のセンサーからのビッグデータ収集を行う。


■■表(kramdown)

{: title="表の名前" id="識別子" }
markdownの表

※titleは必須。idは参照しなければ省略可能

例)

{: title="金額一覧表" id="table_plice" }
|Right     | Left   | Center|
|---------:| :----- |:-----:|
|Computer  |  $1600 | one   |
|Phone     |    $12 | three |
|Pipe      |     $1 | eleven|



■■コード/リスト(独自拡張)

{: title="タイトル" id="識別子"}
~~~   (チルダ×3)
コード本文
~~~   (チルダ×3)

※titleは必須。idは参照しなければ省略可能

例)

{: title="プログラムのサンプル" id="sample.java"}
~~~   (チルダ×3)
import xxx
public static void main(String argv[]){
    System.out.println("hello world");
}
~~~   (チルダ×3)


■■コラム(独自拡張)

{: title="タイトル" id="識別子"}
<div class="column">
本文
</div>

※titleは必須。idは参照しなければ省略可能

例)

{: title="データレイクとは" id="column_data-lake"}
<div class="column">
データレイクは・・・
</div>


■■ノート(独自拡張)

{: title="タイトル" id="識別子"}
<div class="note">
本文
</div>

※titleは必須。idは参照しなければ省略可能

例)

{: title="JSONとは" id="note_json"}
<div class="note">
JSONとは・・・
</div>

■■フットノート(markdown)

文字列[^1]文字列[^2]

[^1]: 説明文
[^2]: 説明文

例)

JSON[^1]やXML[^2]

[^1]: JSONとは・・・
[^2]: XMLとは・・・

■■相互参照(独自拡張)

[[識別子]]

例)

これに関しては、[[sample.java]]のサンプルプログラムを参照してください。

出力)

これに関しては、リスト1-1のサンプルプログラムを参照してください。



```
