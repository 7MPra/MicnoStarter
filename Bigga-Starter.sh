#!/usr/bin/env bash
if [ ! "$UID" -eq 0 ];then
  pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY ./Bigga-Starter.sh
  exit
fi
zenity --info --width=400 --title MicnoLinuxへようこそ！ --text これから簡単な初期設定を行います。OKを押すかこのダイアログを消して次に進んでください。 
browser=`zenity --list --text=インストールするブラウザを選択してください。 --radiolist --column="" --column="ブラウザ名" "" "Chrome" "" "Vivaldi" "" "Firefox(ESR)" "" "Chromium"`
if [[ $browser = 'Firefox(ESR)' ]]; then
  (
  echo "10" ; apt-get install -y firefox-esr
  echo "# apt-get install firefox-esr-l10n-jaを実行中..."
  echo "50" ; apt-get install -y firefox-esr-l10n-ja
  echo "100"
  ) |
  zenity --progress \
    --title="Firefoxをインストール中..."\
    --width=400\
    --text="apt-get install firefox-esrを実行中..."\
    --percentage=0\
    --auto-close
elif [[ $browser = 'Chromium' ]]; then
  (
  echo "10" ; apt-get install -y chromium
  echo "# apt-get install chromium-browser-l10nを実行中..."
  echo "50" ; apt-get install -y chromium-browser-l10n
  echo "100"
  ) |
  zenity --progress \
    --title="Chromiumをインストール中..."\
    --width=400\
    --text="apt-get install chromiumを実行中..."\
    --percentage=0\
    --auto-close
elif [[ $browser = 'Chrome' ]]; then
  (
  echo "10" ; wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  echo "# apt-get installでdebファイルをインストール中..."
  echo "50" ; apt-get install -y ./google-chrome-stable_current_amd64.deb
  echo "# debファイルを削除中..."
  echo "90" ; rm google-chrome-stable_current_amd64.deb
  echo "100"
  ) |
  zenity --progress \
    --width=400\
    --title="Chromeをインストール中..."\
    --text="ネットワークからdebファイルをダウンロード中..."\
    --percentage=0\
    --auto-close
elif [[ $browser = 'Vivaldi' ]]; then
  (
  echo "10" ; wget https://downloads.vivaldi.com/stable/vivaldi-stable_2.11.1811.49-1_amd64.deb
  echo "# apt-get installでdebファイルをインストール中..."
  echo "50" ; apt-get install -y ./vivaldi-stable_2.11.1811.49-1_amd64.deb
  echo "# debファイルを削除中..."
  echo "90" ; rm vivaldi-stable_2.11.1811.49-1_amd64.deb
  echo "100"
  ) |
  zenity --progress \
    --title="ViValdiをインストール中..."\
    --width=400\
    --text="ネットワークからdebファイルをダウンロード中..."\
    --percentage=0\
    --auto-close
fi
zenity --question --title="インストール確認" --text="コミュニケーションツール(Skypeなど)をインストールしますか？" 2>/dev/null
EXITCODE=$?
if [[ $EXITCODE = 0 ]]; then
  if [[ $browser = 'Firefox(ESR)' ]]; then
    tool=`zenity --list --width=400 --height=200 --text=インストールするコミュニケーションツールを選択してください。 --checklist --column="" --column="ツール名" "" "Skype" "" "Discord" "" "Slack" "" "Hangouts"`
  else
    tool=`zenity --list --width=400 --height=200 --text=インストールするコミュニケーションツールを選択してください。 --checklist --column="" --column="ツール名" "" "Skype" "" "Discord" "" "Slack" "" "LINE" "" "Hangouts"`
  fi
  if [[ `echo $tool | grep Skype` ]];then
    (
    echo "10" ; wget https://repo.skype.com/latest/skypeforlinux-64.deb
    echo "# apt-get installでdebファイルをインストール中..."
    echo "50" ; apt-get install -y ./skypeforlinux-64.deb
    echo "# debファイルを削除中..."
    echo "90" ; rm skypeforlinux-64.deb
    echo "100"
    ) |
    zenity --progress \
      --title="Skypeをインストール中..."\
      --width=400\
      --text="ネットワークからdebファイルをダウンロード中..."\
      --percentage=0\
      --auto-close
  fi
  if [[ `echo $tool | grep Discord` ]];then
    (
    echo "10" ; wget --trust-server-names "https://discordapp.com/api/download?platform=linux&format=deb" ; filename=`find discord*.deb`
    echo "# apt-get installでdebファイルをインストール中..."
    echo "50" ; apt-get install -y ./$filename
    echo "# debファイルを削除中..."
    echo "90" ; rm $filename
    echo "100"
    ) |
    zenity --progress \
      --title="Discordをインストール中..."\
      --width=400\
      --text="ネットワークからdebファイルをダウンロード中..."\
      --percentage=0\
      --auto-close
  fi
  if [[ `echo $tool | grep Slack` ]];then
    (
    echo "10" ; wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.4.0-amd64.deb
    echo "# apt-get installでdebファイルをインストール中..."
    echo "50" ; apt-get install -y ./slack-desktop-4.4.0-amd64.deb
    echo "# debファイルを削除中..."
    echo "90" ; rm slack-desktop-4.4.0-amd64.deb
    echo "100"
    ) |
    zenity --progress \
      --title="Slackをインストール中..."\
      --width=400\
      --text="ネットワークからdebファイルをダウンロード中..."\
      --percentage=0\
      --auto-close
  fi
  if [[ `echo $tool | grep Hangouts` ]];then
     echo "Hangouts"
    if [[ $browser = 'Firefox(ESR)' ]]; then
      cat <<EOF > /usr/share/applications/Hangouts-Firefox.desktop
[Desktop Entry]
Name=Hangouts
Comment=Googleの無料メッセンジャー
Exec=/usr/lib/firefox-esr/firefox-esr https://hangouts.google.com/
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/usr/share/icons/hicolor/512x512/apps/hangouts.png
Categories=Network
StartupNotify=true
EOF
    elif [[ $browser = 'Chromium' ]]; then
      cat <<EOF > /usr/share/applications/Hangouts-Chromium.desktop
[Desktop Entry]
Name=Hangouts
Comment=Googleの無料メッセンジャー
Exec=/usr/bin/chromium https://hangouts.google.com/
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/usr/share/icons/hicolor/512x512/apps/hangouts.png
Categories=Network
StartupNotify=true
EOF
    elif [[ $browser = 'Chrome' ]]; then
      cat <<EOF > /usr/share/applications/Hangouts-Chrome.desktop
[Desktop Entry]
Name=Hangouts
Comment=Googleの無料メッセンジャー
Exec=/usr/bin/google-chrome-stable https://hangouts.google.com/
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/usr/share/icons/hicolor/512x512/apps/hangouts.png
Categories=Network
StartupNotify=true
EOF
    elif [[ $browser = 'Vivaldi' ]]; then
      cat <<EOF > /usr/share/applications/Hangouts-Vivladi.desktop
[Desktop Entry]
Name=Hangouts
Comment=Googleの無料メッセンジャー
Exec=/usr/bin/vivaldi-stable https://hangouts.google.com/
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/usr/share/icons/hicolor/512x512/apps/hangouts.png
Categories=Network
StartupNotify=true
EOF
    fi
  fi
  if [[ `echo $tool | grep LINE` ]];then
     zenity --info --width=400 --title=LINEのインストール --text=LINEのインストールは手動で行ってもらいます。これから開かれるページにあるChromeに追加を押してChromeの拡張機能版のLINEをインストールしてください。
    if [[ $browser = 'Chromium' ]]; then
      /usr/bin/google-chrome-stable %U &
      /usr/bin/chromium https://chrome.google.com/webstore/detail/line/ophjlpahpchlmihnnnihgmmeilfjmjjc
    elif [[ $browser = 'Chrome' ]]; then
      /usr/bin/google-chrome-stable %U &
      /usr/bin/google-chrome-stable https://chrome.google.com/webstore/detail/line/ophjlpahpchlmihnnnihgmmeilfjmjjc
    elif [[ $browser = 'Vivaldi' ]]; then
      /usr/bin/vivaldi-stable %U &
      /usr/bin/vivaldi-stable https://chrome.google.com/webstore/detail/line/ophjlpahpchlmihnnnihgmmeilfjmjjc
    fi
  fi
fi
zenity --question --title="インストール確認" --text="クラウドストレージサービス(DropBoxなど)をインストールしますか？" 2>/dev/null
EXITCODE=$?
if [[ $EXITCODE = 0 ]]; then
  storage=`zenity --list --text=インストールするコミュニケーションツールを選択してください。 --checklist --column="" --column="ツール名" "" "Dropbox" "" "MEGA"`
  if [[ `echo $storage | grep Dropbox` ]];then
    (
    echo "10" ; wget --trust-server-names "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb"  ; filename=`find dropbox*.deb`
    echo "# apt-get installでdebファイルをインストール中..."
    echo "50" ; apt-get install -y ./$filename
    echo "# debファイルを削除中..."
    echo "90" ; rm $filename
    echo "100"
    ) |
    zenity --progress \
      --title="Dropboxをインストール中..."\
      --width=400\
      --text="ネットワークからdebファイルをダウンロード中..."\
      --percentage=0\
      --auto-close
  fi
  if [[ `echo $storage | grep MEGA` ]];then
    (
    echo "10" ; wget https://mega.nz/linux/MEGAsync/Debian_10.0/amd64/megasync-Debian_10.0_amd64.deb
    echo "# apt-get installでdebファイルをインストール中..."
    echo "50" ; apt-get install -y ./megasync-Debian_10.0_amd64.deb
    echo "# debファイルを削除中..."
    echo "90" ; rm megasync-Debian_10.0_amd64.deb
    echo "100"
    ) |
    zenity --progress \
      --title="MEGAをインストール中..."\
      --width=400\
      --text="ネットワークからdebファイルをダウンロード中..."\
      --percentage=0\
      --auto-close
  fi
fi