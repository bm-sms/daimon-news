site1 = Site.find_by!(name: "site1")
site1.posts.create!(
  title: "Rubyist Magazine（るびま）0053号に須藤へのインタビューが掲載",
  body: <<-EOS.strip_heredoc,
    # Rubyist Magazine（るびま）0053号に須藤へのインタビューが掲載

    Rubyist Magazine（るびま）にはRubyist HotlinksというRubyistへインタビューする企画があります。0053号の[Rubyist Hotlinks 【第 36 回】](http://magazine.rubyist.net/?0053-Hotlinks)はクリアコードの社長である須藤へのインタビューです。クリアコードのビジネスについてやOSS Gateの話題もあるのでご覧ください。それらの話題にそんなに興味のない方でもぜひご覧ください。聞き手・野次馬のみなさんのおかげで読み物としておもしろいものになっています。

    須藤は2016年5月28日開催の[東京Ruby会議11](http://regional.rubykaigi.org/tokyo11/)で話すのですが、発表者の自己紹介欄をRubyist Hotlinksへのリンクにするだけでよいので大変便利です。

    [るびま0053号](http://magazine.rubyist.net/?0053)はHotlinks以外にもおもしろい記事が揃っているので読んでみてください。過去の記事にもおもしろい記事はたくさんあります。バックナンバーもぜひお楽しみください。
  EOS
  thumbnail: open(Rails.root.join("db/data/thumbnail.jpg")),
  published_at: Time.current,
  category: site1.categories.find_by!(slug: "category1"),
)

published_at = 3.minutes.from_now

site1.posts.create!(
  title: "This post will appear at #{published_at}",
  body: <<-EOS.strip_heredoc,
    # Hello
    hi !

    This post will appear at #{published_at}
  EOS
  thumbnail: open(Rails.root.join("db/data/thumbnail.jpg")),
  published_at: published_at,
  category: site1.categories.find_by!(slug: "category2"),
)

size = (ARGV[0] || 100).to_i
size.times do |i|
  i += 1

  site1.posts.create!(
    title: "Post #{i}",
    body: <<~EOS,
      # OSDNのファイルリリース機能をAPI経由で使うには

      ## はじめに

      「オープンソース・ソフトウェア開発/公開のために様々な機能を提供する無料サービス」の1つに、[OSDN](https://osdn.jp)があります。
      かつてSourceForge.JPとして運営されていたので、そちらのほうに馴染みがあるかたも多いことでしょう。

      * [Slashdot JapanならびにSourceForge.JP、サイト名称変更のお知らせ](http://osdn.co.jp/press/2015/04/%E3%82%B5%E3%82%A4%E3%83%88%E5%90%8D%E7%A7%B0%E5%A4%89%E6%9B%B4%E3%81%AE%E3%81%8A%E7%9F%A5%E3%82%89%E3%81%9B)

      OSDNへとブランド名称が変更されたのが2015年5月のことですから、新ブランドへ移行して、まもなく1年ということになりますね。
      今年に入ってからのOSDNのトピックとしては、ファイルリリースのミラーの増強が行われたようです。そして、2016年2月からはAPIの提供がはじまりました。

      * [API (β)の提供を開始します](https://osdn.jp/projects/sourceforge/news/25232)

      今回は提供されているAPIのうち、リリースに関連した部分を以下の流れで紹介します。

      * OSDNのファイルリリース機能について
      * APIとクライアントライブラリについて
      * osdn-cliとは
      * クライアントライブラリの使い方

      ## OSDNのファイルリリース機能について

      OSDNでのリリースは、[ファイルリリースガイド](https://osdn.jp/docs/FileRelease_Guide)にあるように基本的に3つの要素から構成されています。

      * パッケージ（デフォルトではプロジェクト名と同じ）
      * リリース（各パッケージにひもづけて作成する。複数リリース可能）
      * ファイル（各リリースにひもづけて作成する。複数アップロード可能）

      ただし、リリースの下に追加できるのは、ファイルのみという制約があります。ディレクトリを追加するようなことはできません。

      類似のサービスであるSourceForge.netと大きく違うのがこの点です。SourceForge.netでは、ファイルリリースのために、frs.sourceforge.netというサイトが用意されています。
      frs.sourceforge.netでは、所定のディレクトリへとアップロードしたディレクトリツリーはそのまま公開されるようになっています。
      OSDNのような制約がないので、rsyncでアップロードできます。

      上記制約で問題にならないケースがほとんどだと思われますが、例外もあります。
      それはプロジェクトがパッケージのリポジトリを提供しようとしている場合です。
      aptやyumを使って簡単にインストールできるようにdebパッケージやrpmパッケージのリポジトリを提供しようとすると、リポジトリのディレクトリツリーがOSDNのこの制約にひっかかります。

      プロジェクトWeb{{fn "プロジェクトWebとはhttps://(プロジェクト名).osdn.jp/としてアクセスされるもののこと"}}配下に置くという裏技がありますが、これはネットワークの帯域的な問題およびファイルシステムリソース的な問題を起こしかねないので、やってはいけないことになっています。
      OSDN側で問題は認識しているものの、下記のチケットをみる限り残念ながらこの制約に関して進展はなさそうです。{{fn ".htaccessでrewriteすることで、ファイルリリースシステム側へマッピングするという手も試してみたのですが、残念ながらエラーになるため使えませんでした。"}}

      * [シェルサーバからリリース公開する手段](https://osdn.jp/ticket/browse.php?group_id=1&tid=35773)

      ## APIとクライアントライブラリについて

      どんなAPIが提供されているかは、[APIエクスプローラ](https://osdn.jp/swagger-ui/)にて確認できます。

      このAPIの提供に合わせて、それらを簡単に扱えるようなクライアントライブラリ``osdn-client``もリリースされています。
      この記事を書いている4月時点で、Ruby/PHP/Pythonの3種類が提供されています。
      OSDN Codeから各種言語向けのアーカイブをダウンロードできます。

      * [OSDN Code](https://osdn.jp/projects/osdn-codes/releases/)

      クライアントライブラリの使い方については後述します。

      ## osdn-cliとは

      前述のクライアントライブラリ``osdn-client``を利用したコマンドラインツールです。
      APIの使用例として参考になることでしょう。Rubyで実装されています。

      * [osdn-cli](https://osdn.jp/projects/osdn-codes/scm/git/osdn-cli/)

      以下のようにして、gemとしてインストールすることができます。

      ```
      % gem install osdn-cli
      ```

      インストールが完了すると、``osdn``コマンドが使えるようになります。
      ``osdn login``を実行すると、ブラウザでアプリケーション連携確認画面が表示されます。

      {{image 0, 'アプリケーション連携確認', nil, [436,288]}}

      許可すると、認証コードが表示されるので、ターミナルにて、認証コードを入力します。

      ```
      % osdn login
      Access following URL to get auth code;

      Type your auth code: (ここで認証コードを入力)
      ```

      クレデンシャル情報については、``~/.config/osdn/credential.yml``として保存されるようになっています。

      ```
      % cat ~/.config/osdn/credential.yml
      ---
      access_token: (ここにアクセストークン)
      expires_in: 86400
      token_type: Bearer
      scope:
      - profile
      - group
      - group_write
      refresh_token: (ここにリフレッシュトークン)
      expires_at: 2016-04-02 15:56:29.336425089 +09:00
      ```

      このあと説明するクライアントライブラリでは、上記のアクセストークンを使います。

      ## クライアントライブラリの使い方

      クライアントライブラリの使い方を次の3つの観点から紹介します。

      * アクセストークンの設定（共通）
      * 参照系のAPIの使い方
      * 更新系のAPIの使い方

      ### アクセストークンの設定

      アクセストークンの設定は次のようにして行います。アクセストークンの値については、``credential.yml``を参照してください。

      ```
      OSDNClient.configure do |config|
        config.access_token = "(ここにアクセストークン)"
      end
      ```

      ### 参照系のAPIの使い方

      次の4点について説明します。

      * プロジェクト情報の取得
      * パッケージ情報の取得
      * リリース情報の取得
      * ファイル情報の取得

      #### プロジェクト情報の取得

      プロジェクト情報の取得には、``get_project``を使います。

      ```
      api = OSDNClient::ProjectApi.new
      proj_info = api.get_project("プロジェクト名")
      p proj_info
      ```

      #### パッケージ情報の取得

      パッケージ情報の取得には、``list_packages``を使います。

      ```
      api = OSDNClient::ProjectApi.new
      packages = api.list_packages("プロジェクト名")
      packages.each do |package|
        p package
      end
      ```

      後述するファイル情報取得では、パッケージ固有のIDを``package.id``として引数に渡します。

      #### リリース情報の取得

      リリース情報の取得には、各パッケージの``releases``を参照します。

      ```
      api = OSDNClient::ProjectApi.new
      packages = api.list_packages("プロジェクト名")
      packages.each do |package|
        package.releases.each do |release|
          p release
        end
      end
      ```

      後述するファイル情報取得では、リリース固有のIDを``release.id``として引数に渡します。

      #### ファイル情報の取得

      ファイル情報の取得には、``get_release``を使い、リリース情報の``files``を参照します。

      ```
      api = OSDNClient::ProjectApi.new
      packages = api.list_packages("プロジェクト名")
      packages.each do |package|
        package.releases.each do |release|
          release_info = api.get_release("プロジェクト名", package.id, release.id)
            p release_info.files
          end
        end
      end
      ```

      ### 更新系のAPIの使い方

      次の3点について説明します。

      * パッケージの作成
      * リリースの作成
      * ファイルの作成

      ### パッケージの作成

      パッケージの作成には、``create_package``を使います。

      ```
      package = api.create_package("プロジェクト名", "パッケージ名")
      ```

      ### リリースの作成

      リリースの作成には、``create_release``を使います。

      ```
      package = api.create_package("プロジェクト名", "パッケージ名")
      release = api.create_release("プロジェクト名", package.id, "リリース名")
      ```

      リリースはパッケージにひもづいているので、パッケージ固有のIDを``package.id``として引数に渡します。

      ### ファイルの作成

      ファイルの作成には、``create_release_file``を使います。

      ```
      package = api.create_package("プロジェクト名", "パッケージ名")
      release = api.create_release("プロジェクト名", package.id, "リリース名")
      open("ファイル") do |file|
        file_info = api.create_release_file("プロジェクト名", package.id, release.id, file)
      end
      ```

      ファイルはパッケージとリリースにひもづいているので、パッケージ固有のIDを``package.id``、リリース固有の値を``release.id``として引数に渡します。

      ## まとめ

      今回は、OSDNのファイルリリース機能をAPI経由で使う方法をパッケージ/リリース/ファイルの参照と作成に焦点をあてて紹介しました。
      もし、リリース時のファイルのアップロードを自動化したいというときには、APIの利用を検討してみるといいかもしれません。


      .
    EOS
    thumbnail: open(Rails.root.join("db/data/thumbnail.jpg")),
    published_at: Time.current,
    category: site1.categories.find_by!(slug: "category1"),
  )
end
