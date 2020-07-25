#!/usr/bin/env python3
 
import gi, sys, subprocess
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

def mktemp():
	return subprocess.run('mktemp', shell=True, stdout=subprocess.PIPE, check=True).stdout.decode().strip('\n')

class Win(Gtk.Window):
	def __init__(self):
		Gtk.Window.__init__(self, title="Micno Starter")
		self.set_border_width(10)
		vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
		self.install_applications = []
		self.install_button = Gtk.Button(label='インストール', sensitive=False)
		self.install_button.connect('clicked', self.on_install_clicked)
		browser_list = ['ブラウザー(必須)', 'Chrome', 'Firefox', 'Vivaldi', 'Brave', 'Opera', 'Chromium']
		softwere_list = [['コミュニケーション', 'Discord', 'Slack', 'Skype', 'Teams', 'Zoom'], ['クラウドサービス', 'MEGA', 'Dropbox', 'GnomeOnlineAccounts']]
		vbox.pack_start(Gtk.Label(label=browser_list.pop(0), visible=True), False, False, 0)
		self.browser_buttons = []
		hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
		for i, s in enumerate(browser_list):
			self.browser_buttons.append(Gtk.ToggleButton(label=s))
			self.browser_buttons[i].connect('toggled', self.on_browser_button_togled, i, s)
			hbox.pack_start(self.browser_buttons[i], False, False, 0)
		vbox.pack_start(hbox, False, False, 0)
		for i, r in enumerate(softwere_list):
			hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
			vbox.pack_start(Gtk.Label(label=r.pop(0), visible=True), False, False, 0)
			for s in r:
				button = Gtk.ToggleButton(label=s)
				hbox.pack_start(button, False, False, 0)
				button.connect('toggled', self.on_softwere_button_togled, s)
			vbox.pack_start(hbox, False, False, 0)
		vbox.pack_start(self.install_button, False, False, 0)
		self.add(vbox)
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
		print(self.install_applications)
		for i, b in enumerate(self.browser_buttons):
			if i != number and button.get_active():
				b.set_active(False)
	def on_softwere_button_togled(self, button, name):
		if button.get_active():
			self.install_applications.append(name)
		else:
			self.install_applications.remove(name)
		print(self.install_applications)
	def on_install_clicked(self, button):
		temp=mktemp()
		with open(temp,'w') as f:
			for s in self.install_applications:
				f.write('curl -so- https://repo.micno.xyz/scripts/starter/{} | sudo bash \n'.format(s))
		subprocess.Popen('pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY xfce4-terminal --zoom=-2 --hide-borders -x bash {0} && rm {0}'.format(temp), shell=True, stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
Win()
Gtk.main()