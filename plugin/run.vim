if !exists("Run#AutoSave")
    let Run#AutoSave = 1 " 运行时候是否自动保存
endif

if !exists("Run#AutoCloseQF")
    let Run#AutoCloseQF = 1 " 当只剩下 QuickFix 的时候自动退出
endif

if !exists("Run#FouceCurrentWin")
    let Run#FouceCurrentWin = 1 " 运行的时候焦点依然在当前文件
endif

if !exists("Run#AlwaysBottom")
    let Run#AlwaysBottom = 1 " 运行的时候输出窗口出现在底部
endif


let Run#Type2EnvBase = {
    \'python': '/usr/bin/env python3',
    \'lua': '/usr/bin/env lua',
    \'ruby': '/usr/bin/env ruby',
    \'php': '/usr/bin/env php',
    \'go': '/usr/bin/env go run',
    \'sh': '/usr/bin/env bash', 
    \'javascript': '/usr/bin/env node',
    \'rust': 'cargo run'
    \}
" 添加或者覆盖脚本运行环境
if !exists("Run#Type2Env")
    let Run#Type2Env = g:Run#Type2EnvBase
else
    let Run#Type2Env = extend(g:Run#Type2EnvBase, g:Run#Type2Env)
endif

let Run#Makefiles = [
            \'Makefile',
            \'makefile',
            \'GNUmakefile'
            \] " 指定工程化运行文件


function! s:RunEcho(msg)
    redraw
    echomsg "Run: " . a:msg
endfunction

function! s:RunEchoErr(msg)
    redraw
    echoerr "Run Error: " . a:msg
endfunction


function! s:AutoSave()
    if bufname("%") != ""
        execute "w"
    endif
endfunction

function! s:HasMakefile()
    for i in g:Run#Makefiles
        if filereadable(getcwd() . '/' . i)
            return 1
        endif
    endfor
    return 0
endfunction


function! s:GetFileType()
    let current_filetype = tolower(&filetype)
    return current_filetype
endfunction


function! s:HasFileType(typeName)
    if has_key(g:Run#Type2Env, a:typeName)
        return 1
    else
        return 0
    endif
endfunction


function! s:GetSheBang(filename)
    if a:filename == "%"
        let lines = [getline(1)]
    else
        let lines = readfile(a:filename)
    endif

    if len(lines) > 0 && match(lines[0], "^#!") > -1
        let shebang = strpart(lines[0], 2)
        return shebang
    endif
    return ""
endfunction

function! s:GetExecStr(typeName, filename)
    let shebang = s:GetSheBang(a:filename)
    if shebang == ""
        let execStr = get(g:Run#Type2Env, a:typeName)
    else
        let execStr = shebang
    endif
    return execStr . " " . a:filename
endfunction


function! s:RunSelf(filename)
    let winid = winnr()
    if g:Run#AutoSave > 0
        call s:AutoSave()
    endif
    let typeName = s:GetFileType()
    if s:HasFileType(typeName)
        let execStr = s:GetExecStr(typeName, a:filename)
        call s:ExecFile(execStr)
        if g:Run#FouceCurrentWin > 0
            execute winid . "wincmd w"
        endif
    else
        call s:RunEcho("Unknow file type: " . toupper(typeName))
    endif
endfunction

function! s:Run(...)
    let winid = winnr()
    if g:Run#AutoSave > 0
        call s:AutoSave()
    endif
    if s:HasMakefile()
        call s:ExecFile("make " . join(a:000))
        if g:Run#FouceCurrentWin > 0
            execute winid . "wincmd w"
        endif
    else
        call s:RunSelf("%")
    endif
endfunction

function! s:ExecFile(execStr)
    call s:RunStop()
    execute "AsyncRun " . a:execStr
    execute "copen"
    call s:RunEcho(a:execStr)
endfunction

function! s:RunStop()
    if g:asyncrun_status == "running"
        execute "AsyncStop"
        call s:RunEcho("Stoped")
    else
        execute "cclose"
    endif
endfunction


function! s:AutoCloseQF()
  if &buftype=="quickfix"
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

if g:Run#AutoCloseQF > 0
    au BufEnter * call s:AutoCloseQF()
endif

if g:Run#AlwaysBottom > 0
    autocmd FileType qf wincmd J " QuickFix 出现在最底部
endif

command! -nargs=? Run call s:Run(<f-args>)
command! -nargs=0 RunSelf call s:RunSelf("%")
command! -nargs=0 RunStop call s:RunStop()
