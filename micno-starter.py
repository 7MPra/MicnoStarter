#!/usr/bin/env python3
 
import gi, sys, subprocess, requests
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

def mktemp():
	return subprocess.run('mktemp', shell=True, stdout=subprocess.PIPE, check=True).stdout.decode().strip('\n')

def check_dialog(title,text):
	dialog = Gtk.MessageDialog(buttons=Gtk.ButtonsType.YES_NO, text=title, secondary_use_markup=True, secondary_text=text)
	dialog.set_default_response(Gtk.ResponseType.YES)
	responce = dialog.run()
	dialog.destroy()
	return responce == Gtk.ResponseType.YES
	del dialog
	del recponce

def dialog(title,text):
	dialog = Gtk.MessageDialog(buttons=Gtk.ButtonsType.OK, text=title, secondary_use_markup=True, secondary_text=text)
	dialog.run()
	dialog.destroy()
	del dialog

def connect_check():
	try:
		requests.get('http://google.com')
	except:
		return False
	else:
		return True

if not check_dialog('ようこそ、MicnoLinuxへ！',
                'これからブラウザのインストール等の初期設定を始めます。続行しますか？'):
	sys.exit(0)
class Win(Gtk.Window):
	def __init__(self):
		Gtk.Window.__init__(self, title="Micno Starter")
		self.set_border_width(10)
		vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
		label=Gtk.Label()
		label.set_markup('<big>インストールするソフトを選択してください。</big>')
		vbox.pack_start(label, False, False, 0)
		del label
		self.install_applications = []
		self.install_button = Gtk.Button(label='インストール', sensitive=False)
		self.install_button.connect('clicked', self.on_install_clicked)
		vbox.pack_end(self.install_button, False, False, 0)
		browser_list = ['ブラウザー(必須)', 'Chrome', 'Firefox', 'Vivaldi', 'Brave', 'Opera', 'Chromium']
		softwere_list = [['コミュニケーション', 'Discord', 'Slack', 'Skype', 'Teams', 'Zoom'], ['クラウドサービス', 'MEGA', 'Dropbox', 'GnomeOnlineAccounts']]
		vbox.pack_start(Gtk.Label(label=browser_list.pop(0), xalign=0), False, False, 0)
		self.browser_buttons = []
		hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
		for i, s in enumerate(browser_list):
			self.browser_buttons.append(Gtk.ToggleButton(label=s))
			self.browser_buttons[i].connect('toggled', self.on_browser_button_togled, i, s)
			hbox.pack_start(self.browser_buttons[i], False, False, 0)
		del browser_list
		vbox.pack_start(hbox, False, False, 0)
		del hbox
		for i, r in enumerate(softwere_list):
			hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
			vbox.pack_start(Gtk.Label(label=r.pop(0), xalign=0), False, False, 0)
			for s in r:
				button = Gtk.ToggleButton(label=s)
				hbox.pack_start(button, False, False, 0)
				button.connect('toggled', self.on_softwere_button_togled, s)
				del button
			vbox.pack_start(hbox, False, False, 0)
			del hbox
		del softwere_list
		self.add(vbox)
		del vbox
		self.connect('delete-event', Gtk.main_quit)
		self.show_all()
	def on_browser_button_togled(self, button, number, name):
		if button.get_active():
			self.install_applications.append(name)
			self.install_button.set_sensitive(True)
		else:
			self.install_applications.remove(name)
			for b in self.browser_buttons:
				if b.get_active():
					self.install_button.set_sensitive(True)
					break
				self.install_button.set_sensitive(False)
		for i, b in enumerate(self.browser_buttons):
			if i != number and button.get_active():
				b.set_active(False)
	def on_softwere_button_togled(self, button, name):
		if button.get_active():
			self.install_applications.append(name)
		else:
			self.install_applications.remove(name)
	def on_install_clicked(self, button):
		while not connect_check():
			dialog('エラー', 'インターネットに接続してください')
		temp=mktemp()
		with open(temp,'w') as f:
			f.write('''
if [[ ! `cat /etc/apt/sources.list` = *"deb http://deb.debian.org/debian stable main"*"deb-src http://deb.debian.org/debian stable main"* ]];then
	cat << EOF >> /etc/apt/sources.list
	deb http://deb.debian.org/debian stable main
	deb-src http://deb.debian.org/debian stable main
EOF
fi\n''')
			f.write('apt update\n')
			for s in self.install_applications:
				f.write('curl -so- https://repo.micno.xyz/scripts/starter/{} | bash \n'.format(s))
		subprocess.run('pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY xfce4-terminal --zoom=-2 --hide-borders -x bash {0} && rm {0}'.format(temp), shell=True, stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
		subprocess.run(['rm', '-f', temp])
		dialog('完了','すべての動作が完了しました。さあ、MicnoLinuxを使い始めましょう!')
		Gtk.main_quit()
Win()
Gtk.main()