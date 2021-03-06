################################################################################
#                            myth zsh theme by myth                            #
#                                  2018 edition                                #
#                                                                              #
# With inspiration from:                                                       #
# - zsh docs :>                                                                #
# - github.com/jarretmoses                                                     #
# - steef and bira themes                                                      #
#                                                                              #
################################################################################

#
# Variables and flags
#

MYTH_FMT_PROMPT_SYMBOL=">"
MYTH_FMT_CONTEXT_SEPARATOR="|"
MYTH_FMT_VCS_STAGED_SYMBOL="*"
MYTH_FMT_VCS_UNSTAGED_SYMBOL="*"
MYTH_FMT_VCS_UNTRACKED_SYMBOL="*"

autoload -U add-zsh-hook
autoload -Uz vcs_info

setopt prompt_subst

#
# Colors
#

# Additional definitions

darkestgray="230"
darkergray="235"
darkgray="240"
grayer="245"
gray="250"
lightgray="255"
lightblue="117"
limegreen="118"
orange="202"

# Support functions

# Set the foreground color.
# Calling fgc without an argument resets to terminal default.
# Usage: "fgc blue"
fgc() {
	local fg
	[[ -n $1 ]] && fg="%F{$1}" || fg="%f"
	echo -n "%{$fg%}"
}

# Set the backgroud color.
# Calling bgc without an argument resets to terminal default.
# Usage: "bgc black"
bgc() {
	local bg
	[[ -n $2 ]] && bg="%K{$1}" || bg="%k"
	echo -n "%{$bg%}"
}

# Reset the background and foreground colors
noc() {
	echo -n "%{%k%}%{%f%}"
}

#
# Git config
#
# %b - branchname
# %u - unstagedstr
# %c - stagedstr
# %a - action (i.e interactive rebase)
# %R - repository path
# %S - path in the repositpry

# Flag to enable/disable forced run of vcs_info (used for performance increase)
MYTH_FORCE_RUN_VCS_INFO=1

# Enable git vcs_info and check for repo changes
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:prompt:*' check-for-changes true

# Formatting
MYTH_FMT_GIT_BRANCH="$(fgc $lightblue)%b"
MYTH_FMT_GIT_STAGED="$(fgc $limegreen)$MYTH_FMT_VCS_STAGED_SYMBOL"
MYTH_FMT_GIT_UNSTAGED="$(fgc $orange)$MYTH_FMT_VCS_UNSTAGED_SYMBOL"
MYTH_FMT_GIT_UNTRACKED="$(fgc red)$MYTH_FMT_VCS_UNTRACKED_SYMBOL"
MYTH_FMT_GIT_ACTION="$(fgc $darkgray)($(fgc $limegreen)%a$(fgc $darkgray))"
MYTH_FMT_GIT_FORMATS="$MYTH_FMT_GIT_BRANCH%c%u"
MYTH_FMT_GIT_ACTIONFORMATS="$MYTH_FMT_GIT_FORMATS $MYTH_FMT_GIT_ACTION"

# Set the different format strings for the git prompt
zstyle ':vcs_info:git:prompt:*' stagedstr "$MYTH_FMT_GIT_STAGED"
zstyle ':vcs_info:git:prompt:*' unstagedstr "$MYTH_FMT_GIT_UNSTAGED"
zstyle ':vcs_info:git:prompt:*' nvcsformats ""

# Set force run vcs_info if "git" or "g" has been typed,
# as the state of the repo might have changed and needs updating
git_preexec() {
    case "$1" in
        g*)
            MYTH_FORCE_RUN_VCS_INFO=1
            ;;
    esac
}
add-zsh-hook preexec git_preexec

# Set force run vcs_info everytime user changed directory
git_chpwd() {
    MYTH_FORCE_RUN_VCS_INFO=1
}
add-zsh-hook chpwd git_chpwd

# For every command entered, check if we are going to update vcs_info
git_precmd() {
    if [[ -n "$MYTH_FORCE_RUN_VCS_INFO" ]]; then
        # Check for untracked files or updated submodules, since vcs_info doesn't
        if git ls-files --other --exclude-standard 2> /dev/null | grep -q "."; then
            MYTH_FORCE_RUN_VCS_INFO=1
            # Append the untracked marker to the standard format
            MYTH_FMT_GIT="$MYTH_FMT_GIT_FORMATS$MYTH_FMT_GIT_UNTRACKED"
        else
            MYTH_FMT_GIT="$MYTH_FMT_GIT_FORMATS"
        fi
        
        zstyle ':vcs_info:git:prompt:*' formats         " $MYTH_FMT_GIT"
        zstyle ':vcs_info:git:prompt:*' actionformats   " $MYTH_FMT_GIT $MYTH_FMT_GIT_ACTION"

        vcs_info 'prompt'

        MYTH_FORCE_RUN_VCS_INFO=
    fi
}
add-zsh-hook precmd git_precmd

#
# Prompt Components
#

# A component that displays the current user and host information
pc_context() {
    local user host
    user="$(fgc $orange)%n"
    host="$(fgc $limegreen)%m"
    echo -n "$user$(fgc $darkergray)$MYTH_FMT_CONTEXT_SEPARATOR$host$(fgc)"
}

# A component that displays the current working directory
pc_dir() {
    fgc $grayer
    echo -n "%~"
    fgc
}

# A component that displays the current ref of git repositories,
# as well as colored indicators for the current state of the working directory.
pc_git() {
    echo -n "$vcs_info_msg_0_"
}

# A component that displays current virtual environment name, if active
pc_virtenv() {
    if [[ $VIRTUAL_ENV ]]; then
        echo -n " $(fgc $darkergray)[$(fgc magenta)$(basename $VIRTUAL_ENV)$(fgc $darkergray)]$(fgc)"
    fi
}

# A component that displays the return code of a non-zero command in red text
pc_retcode() {
    echo -n "%(?..%{$(fgc red)%}%? ${fgc})"
}

# A component that pushes the prompt symbol and input to the next line
pc_symbol() {
    if [[ $MYTH_RETCODE -ne 0 ]]; then
        echo -n "\n$(fgc red)$MYTH_FMT_PROMPT_SYMBOL$(fgc) "
    else
        echo -n "\n$(fgc $darkergray)$MYTH_FMT_PROMPT_SYMBOL$(fgc) "
    fi
}

# A component that renders the current timestamp
pc_timestamp() {
    if [[ $MYTH_FMT_DISABLE_CLOCK -ne 1 ]]; then
        echo -n "$(fgc $darkgray)[$(fgc $grayer)%*$(fgc $darkgray)]$(fgc)"
    fi
}

# Build the main prompt
build_prompt() {
    # Cache the last return code so we don't interfere with it
    MYTH_RETCODE=$?

    # Reset bold, foreground and background color
    echo -n "%f%k%b"

    # Assemble components
    pc_context
    echo -n " "
    pc_dir
    pc_git
    pc_virtenv
    pc_symbol
}

# Build the right side prompt
build_rprompt() {
    # Reset bold, foreground and background color
    echo -n "%f%k%b"

    # Assemble components
    pc_retcode
    pc_timestamp
}

# Assign the main and right hand side prompts
PROMPT='$(build_prompt)'
RPROMPT='$(build_rprompt)'
