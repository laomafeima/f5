let s:Make = {}

function! run#make#GetRuner()
    return s:Make
endfunction

function! s:Make.Run(args) dict
    let execStr = run#util#strTrim("make " . join(a:args, " "))
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Make.Build(args) dict
    let execStr = run#util#strTrim("make build " . join(a:args, " "))
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Make.Clean(args) dict
    let execStr = run#util#strTrim("make clean " . join(a:args, " "))
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Make.Debug(args) dict
    let project = split(getcwd(), '/')[-1]
    let buildStr = "!echo \"Please wait while compiling.\";make debug " .
                \project . ";echo \"Compiled.\""
    call run#util#RunEcho(buildStr)
    execute buildStr
    execute ":packadd termdebug"
    execute run#util#strTrim(":Termdebug " . project . " " . join(a:args, " "))
endfunction

function! s:Make.Test(args) dict
    let execStr = run#util#strTrim("make test " . join(a:args, " "))
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction
