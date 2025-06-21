# 環境準備

## Terraform IAM ユーザー作成

まずは AWS の Web コンソールへアクセスして Terraform 実行用の IAM ユーザーを作成し、アクセスキーを取得する。

1.AWS Web コンソールから IAM サービスへアクセス。
![iamserch](/docs/1_first/img/iam-serch.png)

2.IAM サービスのトップページからユーザー一覧へアクセス。
![iamuser](/docs/1_first/img/ima-user.png)

3.ユーザー一覧からユーザーを作成。
![iamusercreate](/docs/1_first/img/iam-user-create.png)

4.ユーザー作成画面でユーザー名を入力し、`AWS マネジメントコンソールへのユーザーアクセスを提供する`にチェック入れて`IAM ユーザーを作成する`を選択。  
パスワードはユーザーがよしなに選択して次へ
![iamusercreate2](/docs/1_first/img/iam-user-create2.png)

5.許可設定については`ポリシーを直接アタッチする`を選択し、許可ポリシーは`AdministratorAccess`を選択。
![iamusercreate3](/docs/1_first/img/iam-user-create3.png)

6.確認画面ではユーザー名を確認し、ユーザーを作成。
![iamusercreate4](/docs/1_first/img/iam-user-create4.png)

7.ユーザーが正常に作成されたことを確認。
![iamusercreate5](/docs/1_first/img/iam-user-create5.png)

## アクセスキー作成

1.作成されたユーザーから`セキュリティ認証情報`タブを選択して、MFA と アクセスキー が未作成であることを確認する。
![iamusercreate6](/docs/1_first/img/iam-user-create6.png)

2.アクセスキーを作成する。ユースケースは`CLI`を選択して、タグは任意の文字列を入力して作成を進める。
![iamusercreate7](/docs/1_first/img/iam-user-create7.png)
![iamusercreate8](/docs/1_first/img/iam-user-create8.png)

3.アクセスキーが取得できたことを確認。スクショの注意書きにもあるが、アクセスキーは**必ず CSV ダウンロード**を実施して手元に保存しておくこと。
![imausercreate9](/docs/1_first/img/iam-user-create9.png)

4.ターミナルを開いて、アクセスキーと AWS CLI Credentials の紐付けを実施する。  
（AWS CLI は手元のローカルマシンにインストール完了している前提）

```bash
$ aws configure
AWS Access Key ID [****************LP4C]:
AWS Secret Access Key [****************XR+e]:
Default region name [None]: ap-northeast-1
Default output format [None]:
```

AWS Access Key ID と AWS Secret Access Key は先ほど取得したものを入力する。  
Default region name Key は、 `ap-northeast-1`を指定する。  
Default output format は特に指定しなくて問題ない。

5.IAM ユーザー画面に戻って、アクセスキーが作成されていることを確認する。
![imausercreate10](/docs/1_first/img/iam-user-create10.png)

## MFA 登録

登録方法はユーザーの任意になるが、私は Authenticator アプリを使用して登録する。

1.MFA device name は任意の文字列を入力し、MFA device は認証アプリケーションを選択して次へ。
![iamusercreate11](/docs/1_first/img/iam-user-create11.png)

2.デバイスの設定で、ユーザーの手元で Authenticator アプリを起動し、QR コードを表示させ登録を進めていく。  
コードは 2 回入力していく。
![iamusercreate12](/docs/1_first/img/iam-user-create12.png)

3.QR コードを読み取ったら、デバイスが正常に登録されたことを確認する。
![iamusercreate13](/docs/1_first/img/iam-user-create13.png)
