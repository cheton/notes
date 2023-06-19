set tabstop=2
set shiftwidth=2
set expandtab

" No end of line
set noeol

set viminfo='100,<1000,s100,h
" '100 Marks will be remembered for the last 100 edited files.
" <1000 Limits the number of lines saved for each register to 1000 lines; if a register contains more than 1000 lines, only the first 1000 lines are saved.
" s100 Registers with more than 100 KB of text are skipped.
" h Disables search highlighting when Vim starts.

" Plugins will be downloaded under the specified directory.
call plug#begin()
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'dikiaap/minimalist'
call plug#end()

" https://github.com/MaxMEllon/vim-jsx-pretty
" JSX syntax pretty highlighting for vim.
let g:vim_jsx_pretty_template_tags = ['html', 'raw']
let g:vim_jsx_pretty_highlight_close_tag = 0
let g:vim_jsx_pretty_colorful_config = 1 " default 0

" https://github.com/dikiaap/minimalist
" A Material Color Scheme Darker for Vim.
set t_Co=256
syntax on
colorscheme minimalist

let g:copilot_filetypes = {
  \ '*': v:true,
  \ }
