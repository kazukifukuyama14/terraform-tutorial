# Terraform チュートリアル

![Terraform](/docs/first/img/terraform_banner.png)

## Infrastructure as Code

**Terraform** は Infrastructure as Code のアプローチを行うためのツール。

**Infrastructure as Code** はその名前の通り、「インフラのコード化」のためのアプローチ。  
構成を **宣言的** に記述することによって **コードベースでインフラの管理** を行うとができ、属人化を防ぐことができる。  
また、コードベースで管理することにより **インフラのバージョン管理** が可能かつ、そのコードを読むことで現在の構成を一覧することも可能。

## AWS と Terraform

![AWS](/docs/first/img/aws.png)

Terraform は Infrastructure as Code のためのツール。  
例えば、上の図のような VPC・ALB・ECS・etc...のような復数のサービスと、その依存関係をコードで記述し、AWS 上へ展開することが可能。

## IaC ツールの選択肢

![iac](/docs/first/img/iac-logos.png)

他にも Infrastructure as Code を実現するためのツールとして Ansible, Chef, CloudFormation など様々なツールが存在する。  
それぞれのツールは実現したいことや得意なユースケースが異なるので、それらを把握して使い分けるとよし。

### Terraform

Hashicorp 社（Vagrant や Vault などが代表的。）が開発した OSS の Infrastructure as Code ツール。  
Ruby ライクな HCL という DSL でコードを記述する。

また、Terraform は AWS 専用のツールではない。  
AWS 以外のクラウドである GCP や Azure でも使用でき、他にも Datadog や Heroku などの管理を行うことが可能。

[Providers - Terraform by HashiCorp](https://www.terraform.io/docs/providers/)

### Ansible

Terraform と CloudFormation は「AWS の構成管理」を責務としていますが、Ansible その 2 つとは毛色が違い「OS より上の構成管理」を主に責務としています。  
例えば、「どのミドルウェアやコードをインストールして、どのマシンへプロビジョニングする」といったこと行います。

そのためクラウドと Docker を使うと使用する機会が少ないです。  
Infrastructure as Code と一概に言っても様々な責務があるということを伝えたかったため、Ansible の紹介をしました。

```txt
"で、何を使えば良いわけ？"
インフラの構成管理は AWS の場合であれば Terraform と CloudFormation、どちらを使用しても問題ない。
AWS 以外に GCP・Azure・Datadog・PagerDuty などの様々なプロバイダーをコード化したいという要求がある/予想できるのであれば AWS 専用の CloudFormation ではなく Terraform が選択される。
また、Ansible のような OS より上の構成管理のモチベーションがある場合は、そもそも Docker とコンテナオーケストレーションツールを使用し、Ansible(や Chef)のような Infrastructure as Code を使用する余地を与えないことが望ましい。
もちろん、ベアメタルや VM でないと実現できないケースも存在するのでその場合は Ansible のようなツールを使用した方がいい。
結論、「クラウドは Terraform、アプリは Docker」を使用することをオススメする。
```
