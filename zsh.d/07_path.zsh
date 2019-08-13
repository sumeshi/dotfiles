#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Name			: path settings
# Licence		: MIT
# Author		: S.Nakano(https://github.com/sumeshi)
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
export PATH="$PATH":/usr/local/sbin
export PATH="$PATH":/Library/TeX/texbin
export PATH="$PATH":$HOME/.nodebrew/current/bin

#export NODE_PATH="$PATH:"/usr/local/share/npm/bin
export PATH=/home/linuxbrew/.linuxbrew/var/nodebrew/current/bin:$PATH
export NODEBREW_HOME=/home/linuxbrew/.linuxbrew/var/nodebrew/current
export NODEBREW_ROOT=/home/linuxbrew/.linuxbrew/var/nodebrew

export PYENV_ROOT=/home/linuxbrew/.linuxbrew/
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

export PATH=/home/linuxbrew/.linuxbrew/opt/python/libexec/bin:$PATH
