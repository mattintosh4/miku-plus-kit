# MikuInstaller+ Kit @VERSION@



## 概要

MikuInstaller の Wine を @WINE_VERSION@ にアップデートするキットです。Wine は 2013年10月現在の Nihonshu バイナリと同等のものです。

このキットは MikuInstaller-20080803.dmg 以外には使用できません。



## システム要件

- Intel CPU を搭載した Mac OS X 10.6 以上 <sup>*1</sup>
- XQuartz 2.7.4 以上 <sup>*2</sup>
- MikuInstaller 20080803

<div style="font-size: smaller;">
注1：10.7 以降の動作環境が無いため正確な動作確認はしていません。
注2：XQuartz は X11 グラッフィクスドライバを使用する場合、または glu32.dll を必要とする Windows アプリケーションを実行する場合に必要です。
</div>



## 注意事項

- __いかなる損害においても当方は一切責任を負いません。アップデートは自己責任で行なってください。__
- __既存の WINEPREFIX を破壊する可能性がありますので事前に「~/Library/Application Support/MikuInstaller」のバックアップを行うことをおすすめします。__
- Wine @WINE_VERSION@ は開発版ですので不具合が発生する可能性があります。



## 使用方法

1. __MikuInstaller-20080803.dmg__ を用意してください。
2. __MikuPlusKit\_@VERSION@.dmg__ をマウントしてターミナルで「miku-plus-kit.sh」を実行します。実行の際に MikuInstaller-20080803.dmg のパスを引数に指定する必要があります。
3. 新しいディスクイメージがデスクトップ上に作成され、マウントされたら完了です。
4. 新しい MikuInstaller.app を使用する前に古い MikuInstaller.app を新しいもので上書きするか削除してください（古い方が呼び出される可能性があります）。

### スクリプト実行例

MikuInstaller-20080803.dmg がユーザーのホームディレクトリにある場合の例です。

```
/Volumes/MikuPlusKit/miku-plus-kit.sh ~/MikuInstaller-20080803.dmg
```



## 変更点について

- MikuInstaller.app から X11.app が実行されないようにしてあります。
- 一部の Windows アプリケーションが glu32.dll を必要とするため、いくつかのモジュールが XQuartz のライブラリを使用するようになっています。必要に応じて XQuartz をインストールしてください。
- WINEDEBUG で fixme の出力を抑制してあります。デバッグメッセージが必要な場合は解除してください。
- 「MikuInstaller.app/Contents/Resources/Wine.app/Contents」以下にある「SharedFrameworks」は丸ごと変更ですが、「SharedSupport」については新しいもので上書きしています。古いファイルが残るためアプリケーションのファイルサイズが若干増えます。
- Wine.bundle のプロパティリストですが、Bundle version を書き換えると警告が出るため Get Info string のみ変更しています。



## 備考

- 元に戻す場合は MikuInstaller-20080803.dmg から再度 MikuInstaller.app をインストールしてください。
- Gecko と Mono はキットに含まれていません。WINEPREFIX 初期化時にダウンロードを促すダイアログが表示されますのでインストールしておくことをおすすめします。
- アプリケーションのバンドル化機能については修正していないためエラーになります。MikuInstaller の環境設定から無効にしてください。
- 「プロセスの状況」ウィンドウの「強制終了」ボタンが動作しないようです。Wine を強制終了する場合はターミナルから killall wine を実行してください。
- 現在の Wine は OS X のグラフィックスドライバを使用するため一部のアプリケーションで描画が正しく行われないことがありますがレジストリによるグラフィックスドライバの切り替えで対応できることがあります。
- 稀に Wine のウィンドウを補足できなくなることがあります。Wine を強制終了してください。



## その他

### 収録コンテンツについて

Wine.bundle には Wine 以外に以下のリソースが含まれています。詳しくは「Wine.bundle/Contents/SharedSupport/share/doc」内のドキュメントを参照してください。

- freetype
- libjpeg-turbo
- liblzma
- libpng
- libtiff
- Little-CMS

### Nihonshu バイナリについて

Wine のソースに若干手を加えてあるバイナリです。MacPorts や Homebrew でインストールした Wine とは一部動作が異なります。詳しくは http://matome.naver.jp/odai/2138009369610432001 を参照してください。


## あとがき

MikuInstaller+ Kit は mattintosh4 が個人で制作したもので MikuInstaller Project とは一切関係ありません。

- GitHub：@GitHub@
- Twitter：https://twitter.com/mattintosh4
