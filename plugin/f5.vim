" F5 快速运行
exit

nnoremap <silent> <F5> :call s:F5Run()<CR>; " F5 运行
autocmd FileType qf nmap <silent> <C-C> :call s:F5Stop()<CR>; " QuickFix 框Ctrl C 停止异步运行
autocmd FileType qf wincmd J " QuickFix 出现在最底部
let F5#AutoSave = 1 " 运行时候是否自动保存
let F5#ReturnFouce= 1 " 打开 QuickFix 时候是否返回原来窗口

let F5#Type2Env = {} " 添加或者覆盖脚本运行环境
let F5#Type2EnvBase = {
    \'python': '/usr/bin/env python',
    \'lua': '/usr/bin/env lua',
    \'ruby': '/usr/bin/env ruby',
    \'php': '/usr/bin/env php',
    \'go': '/usr/bin/env go',
    \'sh': '/usr/bin/env bash', 
    \'javascript': '/usr/bin/env node'
    \}

let F5#RunFile = [] " 指定工程化运行文件
let F5#RunFileBase = [
            \'run.sh',
            \'dev.sh',
            \'dev_run.sh'
            \]

function! s:F5Run()
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
    if g:F5#ReturnFouce > 0
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
        return
    else
        if match(lines[0], "^#!") > -1
            let shebang = strpart(lines[0], 2)
            execute "AsyncRun " shebang . " ". a:filename
            execute "copen"
        else
            execute "AsyncRun " .get(type2env, a:fileType, "/usr/bin/env bash")  " " . a:filename
            execute "copen"
        endif
    endif
endfunction

function! s:F5Stop()
    execute "AsyncStop"
endfunction

function! s:F5Echo(msg)
    redraw
    echomsg "F5: " . a:msg
endfunction

command! -nargs=0 F5run call s:F5Run()
command! -nargs=0 F5stop call s:F5Stop()
