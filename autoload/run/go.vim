let s:Go = {
            \"env": run#util#GetEnv("go"),
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
    let execStr = self.env . " run " . join(args, " ")
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Go.Build(args) dict
    let execStr = self.env . " build " . join(a:args, " ")
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Go.Clean(args) dict
    let execStr = self.env . " clean " . join(a:args, " ")
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Go.Debug(args) dict
    let project = split(getcwd(), '/')[-1]
    execute "!" . self.env . " build -gcflags \"-N -l\" -o " . project . "&echo build finish"
    execute ":cclose"
    execute ":packadd termdebug"
    execute ":Termdebug " . project
endfunction

function! s:Go.Test(args) dict
    let execStr = self.env . " test " . join(a:args, " ")
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction
