" F5 快速运行

if !exists("F5#AutoSave")
    let F5#AutoSave = 1 " 运行时候是否自动保存
endif

if !exists("F5#AutoCloseQF")
    let F5#AutoCloseQF = 1 " 当直升生 QuickFix 的时候自动推出
endif

if !exists("F5#Type2Env")
    let F5#Type2Env = {} " 添加或者覆盖脚本运行环境
endif
let F5#Type2EnvBase = {
    \'python': '/usr/bin/env python',
    \'lua': '/usr/bin/env lua',
    \'ruby': '/usr/bin/env ruby',
    \'php': '/usr/bin/env php',
    \'go': '/usr/bin/env go run',
    \'sh': '/usr/bin/env bash', 
    \'javascript': '/usr/bin/env node'
    \}
if !exists("F5#RunFile")
    let F5#RunFile = [] " 指定工程化运行文件
endif
let F5#RunFileBase = [
            \'run.sh',
            \'dev.sh',
            \'dev_run.sh'
            \]

function! s:F5Run(...)
    if a:0 > 0
        let returnFouce = a:1
    else
        let returnFouce = 1
    endif
    if g:F5#AutoSave > 0
        execute "w"
    endif

    let winid = winnr()
    let filename = ""
    let runfile = g:F5#RunFile + g:F5#RunFileBase
    let type2env = extend(g:F5#Type2EnvBase, g:F5#Type2Env)
    for i in runfile
        if filereadable(getcwd() . '/' . i)
            let filename = getcwd() . '/' . i
            break
        endif
    endfor
    if filename != ""
        call s:F5ExecFile(filename, "sh")
    else
        let current_filetype = tolower(&filetype)
        if has_key(type2env, current_filetype)
            call s:F5ExecFile("%", current_filetype)
        else
            call s:F5Echo("Unknow file type: " . toupper(current_filetype))
        endif
    endif
    if returnFouce > 0
        execute winid . "wincmd w"
    endif
endfunction

function! s:F5ExecFile(filename, fileType)
    let type2env = extend(g:F5#Type2EnvBase, g:F5#Type2Env)
    if a:filename == "%"
        let lines = [getline(1)]
    else
        let lines = readfile(a:filename)
    endif

    if len(lines) < 1
        call s:F5Echo(a:filename . " is empty.")
    else
        call s:F5Stop()
        if match(lines[0], "^#!") > -1
            let shebang = strpart(lines[0], 2)
            let execStr =  shebang . " ". a:filename
            execute "AsyncRun " . execStr
            execute "copen"
        else
            let execStr = get(type2env, a:fileType, "/usr/bin/env bash") . " " . a:filename
            execute "AsyncRun " . execStr
            execute "copen"
        endif
        call s:F5Echo(execStr)
    endif
endfunction

function! s:F5Stop()
    if g:asyncrun_status == "running"
        execute "AsyncStop"
        call s:F5Echo("Stoped")
    else
        execute "cclose"
    endif
endfunction

function! s:F5AutoCloseQF()
  if &buftype=="quickfix"
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

if g:F5#AutoCloseQF > 0
    au BufEnter * call s:F5AutoCloseQF()
endif

function! s:F5Echo(msg)
    redraw
    echomsg "F5: " . a:msg
endfunction

command! -nargs=? F5run call s:F5Run(<args>)
command! -nargs=0 F5stop call s:F5Stop()
nnoremap <silent> <F5> :F5run 1<CR>; " F5 运行
nnoremap <silent> <S-F5> :F5run 0<CR>; " F5 运行
autocmd FileType qf nmap <silent> <C-C> :F5stop<CR>; " QuickFix 框 Ctrl C 停止异步运行，非运行时会关闭 QuickFix
autocmd FileType qf wincmd J " QuickFix 出现在最底部
