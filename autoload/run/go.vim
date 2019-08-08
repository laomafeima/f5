let s:Go = {
            \"env": "go",
            \}

function! run#go#GetRuner()
    return s:Go
endfunction

function! s:Go.Run(args) dict
    if len(a:args) == 0
        let args = ["%"]
    else
        let args = a:args
    endif
    let execStr = run#util#strTrim(self.env . " run " . join(args, " "))
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Go.Build(args) dict
    let execStr = run#util#strTrim(self.env . " build " . join(a:args, " "))
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Go.Clean(args) dict
    let execStr = run#util#strTrim(self.env . " clean " . join(a:args, " "))
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Go.Debug(args) dict
    let project = split(getcwd(), '/')[-1]
    let buildStr = "!echo \"Please wait while compiling.\";" .
                \self.env . " build -gcflags \"-N -l\" -o " . project .
                \";echo \"Compiled.\""
    call run#util#RunEcho(buildStr)
    execute buildStr
    execute ":packadd termdebug"
    execute run#util#strTrim(":Termdebug " . project . " " . join(a:args, " "))
endfunction

function! s:Go.Test(args) dict
    let execStr = run#util#strTrim(self.env . " test " . join(a:args, " "))
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction
