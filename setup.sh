#!/bin/bash

# Purpose: Append (never overwrite) your Vim setup files using the content you provided
#          for .vimrc, key mappings, and C++ compile helpers.
# Behavior: If the target files don't exist, they will be created. If they exist, the
#           content blocks are appended at the end, guarded by markers to avoid duplicates.

set -euo pipefail

# Paths for the configuration files
VIMRC_PATH="$HOME/.vimrc"
VIM_DIR="$HOME/.vim"
KEYMAP_PATH="$VIM_DIR/key_mapping.vim"
COMPILE_CFG_PATH="$VIM_DIR/vim_compile_config.vim"

# Ensure ~/.vim exists
mkdir -p "$VIM_DIR"

# Ensure the target files exist so we can append safely
touch "$VIMRC_PATH" "$KEYMAP_PATH" "$COMPILE_CFG_PATH"

# Helper: Append a Vimscript block to a file if a marker is not found.
# Usage: append_block <file> <begin_marker> <end_marker> <<'EOF' ... EOF
append_block() {
  local file="$1"
  local begin_marker="$2"   # unique identifier comment to detect duplicates
  local end_marker="$3"

  if grep -Fq "$begin_marker" "$file"; then
    echo "Skip: Block already present in $file ($begin_marker)"
  else
    echo "Append: Adding block to $file ($begin_marker)"
    {
      echo
      echo "\" $begin_marker"
      cat
      echo "\" $end_marker"
    } >> "$file"
  fi
}

echo "Configuring Vim files..."

# 1) .vimrc content
VIMRC_BEGIN_MARK='>>> BEGIN VIMRC_BASE_SETTINGS_V1'
VIMRC_END_MARK='<<< END VIMRC_BASE_SETTINGS_V1'
append_block "$VIMRC_PATH" "$VIMRC_BEGIN_MARK" "$VIMRC_END_MARK" <<'VIMRC_EOF'
set tabstop=4
set shiftwidth=4
set number
set autoindent
set incsearch
set wildmenu
set laststatus=2
set confirm
set title
"set mouse=a

source ~/.vim/key_mapping.vim

source ~/.vim/theme_configs.vim

source ~/.vim/vim_compile_config.vim
VIMRC_EOF

# 2) key_mapping.vim content
KEYMAP_BEGIN_MARK='>>> BEGIN KEY_MAPPINGS_V1'
KEYMAP_END_MARK='<<< END KEY_MAPPINGS_V1'
append_block "$KEYMAP_PATH" "$KEYMAP_BEGIN_MARK" "$KEYMAP_END_MARK" <<'KEYMAP_EOF'
map q :quit<CR>

map <C-q> :quit!<CR>

nnoremap <C-S> :w<CR>

nnoremap <C-f> /

nnoremap <C-a> ggVG

inoremap <C-c> <Esc>
KEYMAP_EOF

# 3) vim_compile_config.vim content
COMPILE_BEGIN_MARK='>>> BEGIN CPP_COMPILE_CONFIG_V1'
COMPILE_END_MARK='<<< END CPP_COMPILE_CONFIG_V1'
append_block "$COMPILE_CFG_PATH" "$COMPILE_BEGIN_MARK" "$COMPILE_END_MARK" <<'COMPILE_EOF'
function! OpenCppTerminal()	
  let cmd = 'c++ -Wall -Wextra -Werror -std=c++98 '

  terminal
  sleep 1
  call feedkeys(cmd, 't')
endfunction

function! CompileOnSave()
  if filereadable('Makefile')
    execute '!make'
    terminal
  elseif argc() == 1
    call OpenCppTerminal()
  elseif argc() > 1
    call OpenCppTerminal()
  endif
endfunction

command! Compile call CompileOnSave()
command! Comp call CompileOnSave()

nnoremap <C-X> :Comp<CR>
COMPILE_EOF

echo "Done: Vim files configured."

# Terminal tip for Ctrl+S in Vim inside terminal emulators
echo
echo "Tip: To allow Ctrl+S to save in Vim, add the following line to your ~/.bashrc:"
echo "  stty -ixon"
echo "This disables terminal flow control so Vim can capture Ctrl+S."
echo
echo "Restart your terminal or run: source ~/.bashrc"
echo "Vim setup completed successfully."

