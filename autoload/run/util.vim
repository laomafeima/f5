function! run#util#RunEcho(msg)
    redraw
    echomsg "Run: " . a:msg
endfunction

function! run#util#RunEchoErr(msg)
    redraw
    echoerr "Run Error: " . a:msg
endfunction


function! run#util#AutoSave()
    if bufname("%") != ""
        execute "w"
    endif
endfunction

function! run#util#HasMakefile()
    for i in g:Run#Makefiles
        if filereadable(getcwd() . '/' . i)
            return 1
        endif
    endfor
    return 0
endfunction

function! run#util#GetFileType()
    let current_filetype = tolower(&filetype)
    return current_filetype
endfunction


function! run#util#HasFileType(typeName)
    if has_key(g:Run#Type2Env, a:typeName)
        return 1
    else
        return 0
    endif
endfunction

function! run#util#GetEnv(typeName)
    return get(g:Run#Type2Env, a:typeName)
endfunction

function! run#util#GetSheBang(filename)
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

function! run#util#AutoCloseQF()
  if &buftype=="quickfix"
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

function! run#util#ExecFile(execStr)
    call run#util#RunStop()
    execute "AsyncRun " . a:execStr
    execute "copen"
    call run#util#RunEcho(a:execStr)
endfunction

function! run#util#RunStop()
    if g:asyncrun_status == "running"
        execute "AsyncStop"
        call run#util#RunEcho("Stoped")
    else
        execute "cclose"
    endif
endfunction
