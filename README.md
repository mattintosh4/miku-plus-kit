MikuInstaller+ Kit @VERSION@
================================================================================

このドキュメントは『MikuInstaller+ Kit』（ミクインストーラー・プラス・キット）のマニュアルです



概要
--------------------------------------------------------------------------------

MikuInstaller+ Kit は MikuInstaller-20080803.dmg から新しいバージョンの Wine を内蔵した MikuInstaller.app を作成するキットです。

-   Wine バージョン<br />@WINE\_VERSION@

-   MikuInstaller 公式ページ<br /><http://sourceforge.jp/projects/mikuinstaller/>



システム要件
--------------------------------------------------------------------------------

-   Intel CPU を搭載した Mac OS X 10.6 以上 <sup>＊1</sup>
-   XQuartz 2.7.4 以上 <sup>＊2</sup>
-   MikuInstaller 20080803

<p style="font-size: smaller">
＊1：10.7 以降については動作環境が無いため詳細確認はしていません。<br />
＊2：XQuartz は X11 のグラッフィクスドライバを使用する場合または glu32.dll を必要とする Windows アプリケーションを実行する場合に必要です。</p>



/!\\ 注意事項
--------------------------------------------------------------------------------

-   __いかなる損害においても当方は一切責任を負いません。作業は全て自己責任で行なってください。__

-   __既存の WINEPREFIX を破壊する可能性があります。事前に WINEPREFIX のバックアップを行うことをおすすめします。__

-   このキットは MikuInstaller-20080803.dmg 以外には使用できません。



使用方法
--------------------------------------------------------------------------------

1.  「MikuInstaller-20080803.dmg」を用意してください。（マウントする必要はありません）

2.  「@DISTFILE\_NAME@」をマウントし、ターミナル.app などから `update.sh` を実行します。実行の際に「MikuInstaller-20080803.dmg」のパスを引数に指定してください。

3.  カレントディレクトリに新しい MikuInstaller.app と保存用のディスクイメージが作成されたら完了です。（※既にファイルが存在する場合は上書きされます）

4.  古い MikuInstaller.app が呼び出される可能性があるため新しいアプリケーションを使用する前に古い MikuInstaller.app を削除するか新しいもので上書きしてください。



### 実行例

以下は「MikuInstaller-20080803.dmg」がユーザーのホームディレクトリにある場合の例です。

    /Volumes/@DISTFILE_VOLUME_NAME@/update.sh ~/MikuInstaller-20080803.dmg



変更点について
--------------------------------------------------------------------------------

-   MikuInstaller.app から X11.app が実行されないようにしてあります。

-   `WINEDEBUG` で fixme の出力を抑制してあります。

-   Stream.exe 用の設定が追加されています。不要であれば winecfg から削除してください。

-   `MikuInstaller.app/Contents/Resources/Wine.bundle/Contents` 以下にある `SharedFrameworks` は `_SharedFrameworks` に名前が変更され、`SharedSupport` については一部のファイルが新しいもので上書きされます。



### 備考

-   Gecko と Mono はキットに含まれていません。WINEPREFIX 初期化時にダウンロードを促すダイアログが表示されますのでインストールしておくことをおすすめします。

-   アプリケーションのバンドル化機能については修正していないためエラーになります。MikuInstaller の環境設定から無効にしてください。

-   一部の Windows アプリケーションが glu32.dll を必要とするため、いくつかのモジュールが XQuartz のライブラリを使用するようになっています。必要に応じて XQuartz をインストールしてください。

-   「プロセスの状況」ウィンドウの［強制終了］ボタンが動作しないようです。Wine を強制終了する場合は アクティビティモニタ.app から「wine」と「wineserver」を終了するか、ターミナルなどで `killall wine wineserver` を実行してください。

-   現在の Wine は OS X のグラフィックスドライバを使用するため一部のアプリケーションで描画が正しく行われないことがあります。レジストリを変更することにより以前の X11 グラフィックスドライバに切り替えが可能です。X11 のグラフィックスドライバを使用する場合は XQuartz が必要です。

-   稀に Wine のウィンドウを補足できなくなることがあります。Wine を強制終了してください。



ヘルプ
--------------------------------------------------------------------------------

### MikuInstaller+ Kit 関連

#### Q：MikuInstaller+ の状態からさらに Wine を更新することはできますか？

不可能ではありませんが非常に困難です。

#### Q：今後も Wine の更新に合わせて新しい MikuInstaller+ Kit を配信する予定はありますか？

今のところありません。

#### Q：Wine.bundle はディスクイメージのどこにありますか？

誤操作を避けるため不可視ディレクトリ `.rsrc` に収録してあります。

#### Q：致命的なバグを発見しました！

各自で修正してください。本当に致命的なものであればプルリクエストを送っていだければ修正するかもしれません。

### MikuInstaller 関連

#### Q：MikuInstaller.app を以前のバージョンに戻すにはどうしたらいいですか？

MiuInstaller+ から元に戻すことはできません。MikuInstaller のディスクイメージからインストールし直してください。

#### Q：MikuInstaller.app からレジストリエディタを呼び出すにはどうすればいいですか？

環境設定の［WINEPREFIX］タブで［C:ドライブをFinderで開く］を選択し、`windows` フォルダにある `regedit.exe` を MikuInstaller.app で実行します。

環境変数 `WINEPREFIX` を指定することでターミナルでも呼び出しができます。

    WINEPREFIX="$HOME/Library/Application Support/MikuInstaller/prefix/default" \
    /Applications/MikuInstaller.app/Contents/Resources/Wine.bundle/Contents/SharedSupport/bin/wine regedit



その他
--------------------------------------------------------------------------------

### Wine のバイナリについて

Wine.bundle に含まれる Wine は2013年10月現在の Nihonshu バイナリと同等のものです。依存ライブラリの種類は MikuInstaller に合わせてあります。

<p style="font-size: smaller">
Nihonshu バイナリは Wine のソースに若干手を加えたもので MacPorts や Homebrew でインストールした Wine とは一部動作が異なります。詳しくは <a href="http://matome.naver.jp/odai/2138009369610432001">http://matome.naver.jp/odai/2138009369610432001</a> を参照してください。</p>

### Wine.bundle 内のソフトウェアについて

Wine.bundle には以下のソフトウェアが含まれています。

-   [Wine](http://www.winehq.org/)
-   [freetype](http://freetype.sourceforge.net/)
-   [libjpeg-turbo](http://www.libjpeg-turbo.org/)
-   [libpng](http://www.libpng.org/pub/png/libpng.html)
-   [libtiff](http://www.remotesensing.org/libtiff/)
-   [Little-CMS](http://www.littlecms.com/)
-   [xz](http://tukaani.org/xz/)



あとがき
--------------------------------------------------------------------------------

当ソフトウェアは予告なしに仕様を変更することがあります。また、MikuInstaller+ Kit は mattintosh4 が個人で制作したもので MikuInstaller Project とは何の関係もありません。

- GitHub<br /><https://github.com/mattintosh4/miku-plus-kit>
- Twitter<br /><https://twitter.com/mattintosh4>
