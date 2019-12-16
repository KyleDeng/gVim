source $VIMRUNTIME/vimrc_example.vim

set diffexpr=MyDiff()
filetype on
"关闭自动备份
set noundofile
set nobackup
set noswapfile

"----------------------------------------------------------------
"编码设置
"----------------------------------------------------------------
"Vim 在与屏幕/键盘交互时使用的编码(取决于实际的终端的设定)        
set encoding=utf-8
set langmenu=zh_CN.UTF-8
" 设置打开文件的编码格式  
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1 
set fileencoding=utf-8
"解决菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"解决consle输出乱码
"set termencoding = cp936  
"设置中文提示
language messages zh_CN.utf-8 
"设置中文帮助
set helplang=cn
"设置为双字宽显示，否则无法完整显示如:☆
set ambiwidth=double

set smartindent   "设置智能缩进
set shortmess=atI "去掉欢迎界面
colorscheme  molokai         "Monokai的配色方案
set guifont=Consolas_for_Powerline_FixedD:h12      "字体与字号
set tabstop=4                " 设置tab键的宽度
set shiftwidth=4             " 换行时行间交错使用4个空格
set autoindent               " 自动对齐
set backspace=2              " 设置退格键可用
set cindent shiftwidth=4     " 自动缩进4空格
set smartindent              " 智能自动缩进
set ai!                      " 设置自动缩进
set nu!                      " 显示行号
set mouse=a                  " 启用鼠标
set ruler                    " 右下角显示光标位置的状态行
set incsearch                " 查找book时，当输入/b时会自动找到
set hlsearch                 " 开启高亮显示结果
set incsearch                " 开启实时搜索功能
set nowrapscan               " 搜索到文件两端时不重新搜索
set nocompatible             " 关闭兼容模式
set vb t_vb=                 " 关闭提示音
au GuiEnter * set t_vb=      " 关闭闪屏
set hidden                   " 允许在有未保存的修改时切换缓冲区
set list                     " 显示Tab符，使用一高亮竖线代替
set listchars=tab:\|\ ,
syntax enable                " 打开语法高亮
syntax on                    " 开启文件类型侦测
filetype indent on           " 针对不同的文件类型采用不同的缩进格式
filetype plugin on           " 针对不同的文件类型加载对应的插件
filetype plugin indent on    " 启用自动补全
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quickly Run
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w" 
    if &filetype == 'c' 
        exec '!gcc % -o %<'
        exec '! %<'
    elseif &filetype == 'go' 
        exec "!go run %" 
    elseif &filetype == 'cpp'
        exec '!g++ -std=c++11 % -o %<'
        exec '! %<'
    elseif &filetype == 'python'
        exec '!python %'
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!java %<"
    elseif &filetype == 'sh'
        :!bash %
    endif                                                                              
endfunc 

"map <C-w> :tabclose<CR>
map <C-s> :w<CR>
map <A-a> ggVG
map <A-c> "+y
map <A-v> "+p
map <A-1> <C-]>
map <A-2> <C-T>
imap <C-CR> <Esc>i<CR><Esc>O

" 绑定F2到NERDTreeToggle
"map <F2> :NERDTreeToggle<CR>

"配置taglist相关
"let   Tlist_Inc_Winwidth=0 "配置打开函数列表的时候不改变窗口大小
"let   Tlist_Use_Right_Window=1 "配置函数列表挂靠在屏幕右手边
let   Tlist_File_Fold_Auto_Close=1 "配置自动关闭非活动的文件
"let   Tlist_Exit_OnlyWindow=1 "配置当前只有函数列表窗口的时候退出vim
"map <F3> :TlistToggle<cr>

" winmanager配置
let g:NERDTree_title='NERD Tree'
let g:winManagerWindowLayout='NERDTree|TagList'
function! NERDTree_Start()
    exec 'NERDTree'
endfunction

function! NERDTree_IsValid()
    return 1
endfunction
" 绑定F2到winmanager
"nmap <silent> <F2> :WMToggle<CR>
" Windows绑定F2到winmanager
nmap <silent> <F2> :if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR>
 
" NERD_commenter配置
let mapleader="," " 把默认的leader从“\”改为“,”
let g:NERDSpaceDelims=1 " 在注释的时候自动添加空格
map <C-k> ,c<space>
map <C-l> ,cA


""""""""""""""""""""""""""""""""""""""""""
""" airline设置
""""""""""""""""""""""""""""""""""""""""""
set t_Co=256
set laststatus=2
set lazyredraw
"let g:airline_theme='molokai'
" 使用powerline打过补丁的字体
let g:airline_powerline_fonts=1
if !exists('g:airline_symbols')
    let g:airline_symbols={}
endif
" 关闭空白符检测
let g:airline#extensions#whitespace#enabled=0
"打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件
 let g:airline#extensions#tabline#enabled = 1
 let g:airline#extensions#tabline#buffer_nr_show = 1
"设置切换Buffer快捷键"
 nnoremap <C-tab> :bn<CR>
 nnoremap <C-s-tab> :bp<CR>
" old vim-powerline symbols
  let g:airline_left_sep = '⮀'
  let g:airline_left_alt_sep = '⮁'
  let g:airline_right_sep = '⮂'
  let g:airline_right_alt_sep = '⮃'
  let g:airline_symbols.branch = '⭠'
  let g:airline_symbols.readonly = '⭤'
  let g:airline_symbols.linenr = '⭡'

