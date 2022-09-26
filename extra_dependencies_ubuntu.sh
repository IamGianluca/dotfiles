# install pyenv and pyenv-virtualenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
exec $SHELL
pyenv install 3.10.6
pyenv global 3.10.6


# install poetry
curl -sSL https://install.python-poetry.org | python3 -
poetry completions zsh > ~/.zfunc/_poetry


# install powerline-shell
apt-get install fonts-powerline
cd git && \
	git clone https://github.com/b-ryan/powerline-shell && \
	cd powerline-shell && \
	python setup.py install


# install oh-my-zsh and plugins
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/joshskidmore/zsh-fzf-history-search ~/.oh-my-zsh/custom/plugins/zsh-fzf-history-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting


# install tmux
apt install tmux


# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
	~/.fzf/install

# install ripgrep, used by telescope.nvim
apt-get install ripgrep

# install rust
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
rustup update
