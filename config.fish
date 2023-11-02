# fuck you fish
set fish_greeting

# override keybind settings.
fish_vi_key_bindings

# functions
function git_branch
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
end

# override prompt
function fish_mode_prompt
end
function fish_prompt
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        switch $fish_bind_mode
            case default
                set_color red white
				echo -n "| " 
            case insert
                set_color cyan white
				echo -n "= " 
            case replace-one
                set_color cyan white
				echo -n "= " 
            case visual
                set_color magenta white
				echo -n "+ " 
            end
        echo (set_color white)(echo $USER) (set_color white)(date "+%H:%M:%S")"> "
    end
end

function fish_right_prompt
    echo (set_color blue)"["(prompt_pwd)"]"(set_color brblack)(git_branch)
end

# aliases
alias ls='exa'
alias ll='exa -l'
alias la='exa -la'
alias llg='exa -l --git'
alias llt='exa -l --tree'

