# Vim setup (C++ friendly)

This repository provides a simple, append-only Vim setup tailored for C++ work. It populates your `~/.vimrc` and `~/.vim/*.vim` helper files without overwriting any existing content.

## How to install

1. Run in your terminal:
   
   ```bash
   bash -c "$(curl https://raw.githubusercontent.com/danieljs-dev/basic-setup-vim-for-cpp/refs/heads/main/setup.sh)"
   ```
   or cloning this repository and exec the shell script
   ```
   git clone https://github.com/danieljs-dev/basic-setup-vim-for-cpp.git
   cd basic-setup-vim-for-cpp
   chmod +x setup.sh
   ./setup.sh
   ```
   
2. What the script does:
   - Ensures `~/.vimrc` and the directory `~/.vim/` exist.
   - Appends the following blocks if they are not already present (idempotent):
     - `~/.vimrc`
     - `~/.vim/key_mapping.vim`
     - `~/.vim/vim_compile_config.vim`
   - Adds a tip about enabling Ctrl+S in terminal Vim.

3. After running it, restart your terminal or reload your shell profile:
   
   ```bash
   source ~/.bashrc
   ```

## Key mappings

These are added to `~/.vim/key_mapping.vim`:

- q — Quit current window (command mode mapping)
- Ctrl+Q — Force quit current window (discard changes)
- Ctrl+S — Save current buffer
- Ctrl+F — Start a forward search (equivalent to typing `/`)
- Ctrl+A — Select all (go to top, visual select to bottom)
- Ctrl+C (insert mode) — Escape to normal mode
- Ctrl+X — Trigger the C++ compile helper (`:Comp`)

Note: For Ctrl+S to work in terminal Vim, add this to your `~/.bashrc` and reload:

```bash
stty -ixon
```

This disables terminal flow control so Vim can capture Ctrl+S.

## .vimrc settings (summary)

The script appends the following basic options to `~/.vimrc`:

- set tabstop=4 — Tabs display as 4 spaces
- set shiftwidth=4 — Indent width used by >>, <<, =, and autoindent
- set number — Show line numbers
- set autoindent — Preserve indent from previous line
- set incsearch — Show live matches while typing a search
- set wildmenu — Enhanced command-line completion menu
- set laststatus=2 — Always show the statusline
- set confirm — Confirm before closing modified buffers
- set title — Set terminal/window title to current file
- source ~/.vim/key_mapping.vim — Load the key mappings above
- source ~/.vim/theme_configs.vim — Optional; load your theme settings if you have this file
- source ~/.vim/vim_compile_config.vim — Load the C++ compile helper

You can safely add your own settings above or below these blocks in `~/.vimrc`.

## C++ compilation helper

The helper lives in `~/.vim/vim_compile_config.vim` and provides a simple flow:

- :Comp or Ctrl+X
  - If a `Makefile` exists in the current directory: runs `make` and opens a terminal window inside Vim.
  - If no `Makefile` is present: opens a terminal inside Vim and pre-types the C++ compile flags so you can complete the command.

Flags that are pre-typed (you complete the rest):

```
c++ -Wall -Wextra -Werror -std=c++98 
```

Typical usage examples once the terminal opens:

```bash
# Single file
c++ -Wall -Wextra -Werror -std=c++98 main.cpp -o app && ./app

# Multiple files
c++ -Wall -Wextra -Werror -std=c++98 *.cpp -o app && ./app

# Project with Makefile (automatic)
make
```

Tips:
- You can edit the flags in `~/.vim/vim_compile_config.vim` to match your project.
- For projects that always use Makefiles, just rely on `make` and ignore the pre-typed command.

## Troubleshooting

- Ctrl+S doesn’t save in terminal Vim
  - Add `stty -ixon` to your `~/.bashrc` and reload the shell.
- Duplicate blocks appeared
  - The script uses clear BEGIN/END markers to avoid duplicates. If you manually edited these markers, remove or restore them and re-run the script.
- Neovim users
  - Most of these settings work in Neovim, but the terminal commands and some mappings may behave slightly differently.

## Where things go

- `~/.vimrc` — Loads key mappings, theme config (optional), and compile helper
- `~/.vim/key_mapping.vim` — Key mappings listed above
- `~/.vim/vim_compile_config.vim` — C++ compile helper (Ctrl+X / :Comp)

Happy coding!
