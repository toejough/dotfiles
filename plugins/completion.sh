#  bash completion, cd completion, etc

#  programmable completion is enabled
shopt -s progcomp
#  use bash completion!
if [ -f ~/.bash_completion ]; then
    source  ~/.bash_completion
fi
#  allow cd to autocorrect small errors
shopt -s cdspell
#  allow dir names to be autocorrected for small erors
shopt -s dirspell
#  complete @<text> with hostnames if possible
shopt -s hostcomplete

