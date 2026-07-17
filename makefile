.PHONY: format tlp

format:
	stylua .

tlp:
	sudo install -Dm 0644 tlp/tlp.d/99-battery.conf /etc/tlp.d/99-battery.conf
	sudo tlp start

