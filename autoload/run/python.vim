let s:Python = {
            \"env": run#util#GetEnv("python"),
            \"test": run#util#GetEnv("python_test"),
            \}

function! run#python#GetRuner()
    return s:Python
endfunction

function! s:Python.Run(args) dict
    if len(a:args) == 0
        let args = ["%"]
    else
        let args = a:args
    endif
    let shebang = run#util#GetSheBang(args[0])
    if shebang == ""
        let execStr = self.env . " " . join(args, " ")
    else
        let execStr = shebang . " " . join(args, " ")
    endif
    let execStr = run#util#strTrim(execStr)
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Python.Build(args) dict
endfunction

function! s:Python.Clean(args) dict
endfunction

function! s:Python.Debug(args) dict
endfunction

function! s:Python.Test(args) dict
    let execStr = run#util#strTrim(self.test. " " . join(a:args, " "))
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction
