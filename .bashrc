# ~/.bashrc

# Только для интерактивной оболочки
[[ $- != *i* ]] && return

# PROMPT: > вместо $
PS1='\u@\h:\w> '

# Алиасы
alias l='ls -CF'
alias ll='ls -l'
alias la='ls -A'

# Навигация
alias ..='cd ..'
alias ...='cd ../..'

# Минимум нагрузки
unset MAILCHECK
unset PROMPT_COMMAND
