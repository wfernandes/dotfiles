# dotfiles

## Install Dotfiles

```
./install.sh
```

To just link the dot files run,

```
./install.sh -l
```

To just initialize the vim plugins,

```
./install.sh -p
```

## Tmux and Tmate
The `install.sh` will link the `tmate.conf` file into the home directory by
default.


If you plan to use tmate then you should alias tmux so that it directly points
to the corresponding tmux.conf
```
alias tmux='tmux -f $HOME/workspace/dotfiles/dotfiles/tmux.conf'
```
This is done in order to get tmate and tmux to work along side each
other.

By default, tmate reads both the tmux.conf and the tmate.conf but it seems
that tmate is packaged with an older version of tmux so the
configurations for copy/paste in vi-mode are different when using later
version of tmux (>=v2.7)

So in order to get both tmate and tmux(>=v2.7) working together, `tmate.conf`
is placed in the home directory and `tmux.conf` is used in the alias mentioned
above.

### Resources
- https://robots.thoughtbot.com/tmux-copy-paste-on-os-x-a-better-future
- https://blog.carbonfive.com/2017/08/17/copying-and-pasting-with-tmux-2-4/
