[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

# export PATH=/usr/local/bin:(...)
export PATH=/usr/local/bin:$PATH 	    # Postgres installed via homebrew on os x lion fix
export PGDATA=/usr/local/var/postgres # Postgresql cluster variables
export CI_TSDIR=$PGDATA               # Postgresql cluster variables

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

export PATH=$PATH:~/Documents/ci_git/git_support/bin
export CC=gcc-4.2
export cc=gcc-4.2
export EDITOR='sublime -w'

function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " "${ref#refs/heads/}" "
}

function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " "${ref#refs/heads/}" "
}

function rvm_version {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"
  local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
  [ "$version" != "" ] && version="$version"
  local full="$version$gemset"
  [ "$full" != "" ] && echo " $full"
}

function parse_git_dirty {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "• "
}

BLACK='\[\033[0;30m\]'
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[0;33m\]'
BLUE='\[\033[0;34m\]'
PURPLE='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
WHITE='\[\033[0;37m\]'
NORMAL="\[\033[0m\]"
WHITE="\[\033[0;37;40m\]"
MAGENTA="\[\033[0;43;40m\]"
BRIGHTBLUE="\[\033[0;31;40m\]"
BRIGHTWHITE="\[\033[1;37;40m\]"
BRIGHTMAGENTA="\[\033[0;33;40m\]"

export DYLD_LIBRARY_PATH="/usr/local/mysql/lib"
export PS1="$WHITE\w$YELLOW\$(rvm_version)$PURPLE\$(parse_git_branch)$RED\$(parse_git_dirty)$BLUE\$ "

function ssh-setup {
  cat ~/.ssh/id_rsa.pub | ssh $1 'cat - >> ~/.ssh/authorized_keys'
}

# alias pg-start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'

dotfiles.open(){
  eval "sublime ~/.$1"
}

alias dotfiles.push='cd ~/ && git commit -am "updating dot files" && git push origin master'
alias reload='source ~/.bash_profile'

alias pg.start='pg_ctl -D /usr/local/var/postgres -l logfile start'
alias pg.running='ps aux | grep postgres'
alias pg.stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

alias mysql.stop='killall -9 mysqld'

# sublime
alias sublime.packages="cd ~/Library/Application\ Support/Sublime\ Text\ 2/Packages"
alias sublime.bundles="cd ~/Library/Application\ Support/Sublime\ Text\ 2/Packages"
alias sublime.snippets.edit='sublime ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User/sublime-snippets'
alias sublime.snippets.push='cd ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User/sublime-snippets && git add -A && git commit -am "updating snippets" && git push origin master'

alias chrome.customize="sublime ~/Library/Application Support/Google/Chrome/Default/User StyleSheets"
# textmate
alias tm.bundles='cd ~/Library/Application\ Support/TextMate/Pristine\ Copy/Bundles/'
alias tm.2.bundles='open ~/Library/Application\ Support/Avian/Pristine Copy/Bundles/'

# git
alias git.stash_pull="git stash && git pull --rebase && git stash pop"
alias git.fetch_upstream="git pull --rebase origin master"

git.branch.destroy.remote(){
  eval "git push origin --delete $1"
}

git.branch.destroy.local(){
  eval "git branch -d $1"
}

git.branch.create(){
  eval "git branch $1 && git checkout $1"
}

git.branch.push(){
  eval "git push origin $1"
}

# rails
alias rails.stop='killall -9 rails'
alias rails.zapdb='rake db:drop db:create db:migrate db:seed'

# new relic aliases
alias rpm.dir="cd ~/newrelic/rpm_site"
alias rpm.debug_layout="rpm.dir &&
echo '/
  controller:
  =params[:controller]' >> app/views/layouts/application.html.haml &&
  echo '  action:
  =params[:action]' >> app/views/layouts/application.html.haml"

alias rpm.mate="rpm.dir && mate ."
alias rpm.clear_assets="rpm.dir && find public/assets -type f -exec rm {} \;"


test.controller(){
  eval "ruby -Itest:lib test/functional/$1_controller_test.rb"
}

test.model(){
  eval "ruby -Itest:lib test/unit/$1_test.rb"
}

rpm.server.start(){
  eval "./script/server thin -e $1"
  # eval "script/server thin -e $1"
}
rpm.console.start(){
  eval "RAILS_ENV=$1 ruby ./script/console"
  # eval "RAILS_ENV=$1 ruby script/console"
}
rpm.console.model_methods(){
  eval "ap ($1.first.methods - Object.methods).sort"
}
rpm.console.find_account(){
  eval "account = load_account($1)"
}

alias edit-bash="dotfiles.open bash_profile"

# test
alias test.autotest="autotest -f -c"

bash-commands(){
  echo "dotfiles"
  echo "|__ dotfiles.open [file] ................. edit a dotfile"
  echo "|__ dotfiles.push ........................ push dotfiles to github"
  echo ""
  echo "ssh-setup ................................ cat your ssh file"
  echo ""
  echo "Postgres"
  echo "|__ pg.start ............................. start postrgres"
  echo "|__ pg.running ........................... is postgres running?"
  echo "|__ pg.stop .............................. kill postgres processes"
  echo ""
  echo "MySql"
  echo "|__ mysql.stop ........................... kill mysql processes"
  echo ""
  echo "Git"
  echo "|__ git.fetch_upstream ................... pull from master into your branch"
  echo "|__ git.stash_pull ....................... stash, pull with rebase, and pop"
  echo "|__ git.branch.create [name] ............. create a branch, and check it out"
  echo "|__ git.branch.push [name] ............... push a local branch to remote"
  echo "|__ git.branch.destroy.local [name] ...... destroy a local branch"
  echo "|__ git.branch.destroy.remote [name] ..... destroy a remote branch"
  echo ""
  echo "Ruby On Rails"
  echo "|__ rails.zapdb .......................... drop, create, migrate, seed"
  echo "|__ rails.stop ........................... kill rails processes"
  echo ""
  echo "reload ................................... reload the bash profile after changes"
  echo "edit-bash ................................ edit the bash profile file in sublime"
  echo ""
  echo "Sublime"
  echo "|__ sublime.packages ..................... cd into sublime packages"
  echo "|__ sublime.bundles ...................... cd into sublime bundles folder"
  echo "|__ sublime.snippets.edit ................ open snippets in editor"
  echo "|__ sublime.snippets.push ................ push snippets to github"
  echo ""
  echo "Textmate"
  echo "|__ tm.bundles ........................... Edit textmate bundles"
  echo "|__ tm.2.Bundles ......................... Edit textmate 2 bundles"
  echo ""
  echo "RPM"
  echo "|__ rpm.server.start [environment] ....... start the RPM app with specified environment"
  echo "|__ rpm.console.start [environment] ...... start the RPM console with specified environment"
  echo "|__ rpm.console.model_methods [model] .... get the sorted methods for a model"
  echo "|__ rpm.debug_layout ..................... find the controller/action for a page"
  echo "|__ rpm.console.find_account [id] ........ find the account on whatever shard its on"
  echo ""
  echo "Testing"
  echo "|__ test.controller ...................... test.controller [controller]"
  echo "|__ test.model ........................... test.model [model]"
  echo "|__ test.autotest ........................ start autotest -f -c"
}



# rm /usr/local/var/postgres/postmaster.pid
# alias pg_ctl start
