let s:Script = {}

function! run#script#GetRuner()
    return s:Script
endfunction

function! s:Script.Run(args) dict
    if len(a:args) == 0
        let args = ["%"]
    else
        let args = a:args
    endif
    let shebang = run#util#GetSheBang(args[0])
    if shebang == ""
        let execStr = run#util#GetScriptRunner(run#util#GetFileType()) . " " .
                    \join(args, " ")
    else
        let execStr = shebang . " " . join(args, " ")
    endif
    let execStr = run#util#strTrim(execStr)
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Script.Build(args) dict
endfunction

function! s:Script.Clean(args) dict
endfunction

function! s:Script.Debug(args) dict
endfunction

function! s:Script.Test(args) dict
endfunction
