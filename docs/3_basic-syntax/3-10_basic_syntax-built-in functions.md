## 5-7.組み込み関数

### 5-7-1.組み込み関数の種類

組み込み関数は以下の通り。

| 種類             | 説明                                                      |
| ---------------- | --------------------------------------------------------- |
| numeric          | 数値演算。絶対値、切り上げ、切り捨て、最大、最小…など。   |
| string           | 文字列操作。フォーマット、抜き出し、結合…など。           |
| collection       | 配列操作。結合、分割、ソート…など。                       |
| encoding         | エンコード。Base64、CSV、json、YAML などの変換。          |
| filesystem       | ファイル操作。ディレクトリ名取得、ファイル読み取り…など。 |
| data & time      | 日付操作。現在時刻取得、データのフォーマット指定…など。   |
| Hashi & Crypt    | ハッシュおよび暗号化。Bcrypt、MD5、SHA-256…など。         |
| IP Network       | CIDR 表記の演算。ホスト名取得、サブネット名取得…など。    |
| Type Cosnversion | 型変換。bool、string、number…など。                       |

### 5-7-2.組み込み関数のリファレンス

Terraform 公式ドキュメントから、組み込み関数の参照できるページがある。  
以下、参照先になる。

[Terraform 公式ドキュメント：組み込み関数リファレンス](https://developer.hashicorp.com/terraform/language/functions)

### 5-7-3.組み込み関数の試し方

指定された設定で関数を実行する。

```bash
terraform console
    [-var <KEY>=<VALUE>]
    [-var-file <VAR_FILE>]
```

引数:

- -var <KEY>=<VALUE> : 変数の指定
- -var-file <VAR_FILE> : 変数ファイルの指定

**変数を指定したい場合、変数定義された .tf ファイルがあるディレクトリで実行すること。**

### 5-7-3.実践

以下、実際に組み込み関数を試してみる。

1.Terraform のリファレンスを参照
2.terraform console にて動作確認

- [Numeric Function] - [floor]
- [String Function] - [substr]

[Terraform 公式ドキュメント：組み込み関数リファレンス(Numeric Function floor)](https://developer.hashicorp.com/terraform/language/functions/floor)  
[Terraform 公式ドキュメント：組み込み関数リファレンス(String Function substr)](https://developer.hashicorp.com/terraform/language/functions/substr)

試し方としては、エディタ内でコンソールを開き、以下コマンドを入力する。

```bash
terraform console
```

Numeric Function リファレンスに記載されている以下を入力していく。

```bash
> floor(5)
5
> floor(4.9)
4
>
```

なぜこのように出力されるのかを解説していく。

`floor` は数学用語で「床関数」と呼ばれる関数である。  
与えられた数値以下の最大の整数を返す。

**なぜ floor(4.9)が 4 になるのか？**  
floor 関数は常に下方向に丸めるから:

```txt
# 4.9は4と5の間にある小数
# floorは「4.9以下の最大の整数」を探す
# 4.9以下の整数は: ...2, 3, 4
# この中で最大は4
floor(4.9) = 4

# 他の例で理解を深める
floor(4.1) = 4  # 4.1以下の最大の整数は4
floor(4.5) = 4  # 4.5以下の最大の整数は4
floor(4.99) = 4 # 4.99以下の最大の整数は4
```

同じように、リファレンスの `String Function substr` も実行してみる。

```bash
> substr("hello world", 1, 4)
"ello"
```

substr 関数で書かれた上記については、**文字列から 1 文字目を飛ばして残りの 4 文字を出力する**というものになる。
