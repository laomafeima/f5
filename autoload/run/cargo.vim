let s:Cargo = {
            \"cargo": "cargo",
            \}

function! run#cargo#GetRuner()
    return s:Cargo
endfunction

function! s:Cargo.Run(args) dict
    let execStr = self.cargo. " run " . join(a:args, " ")
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Cargo.Build(args) dict
    let execStr = self.cargo. " build " . join(a:args, " ")
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Cargo.Clean(args) dict
    let execStr = self.cargo. " clean " . join(a:args, " ")
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction

function! s:Cargo.Debug(args) dict
    let project = split(getcwd(), '/')[-1]
    let buildStr = "!echo \"Please wait while compiling.\";" .
                \self.cargo. " build;echo \"Compiled.\""
    call run#util#RunEcho(buildStr)
    execute buildStr
    execute ":cclose"
    execute ":packadd termdebug"
    execute ":Termdebug target/debug/" . project
endfunction

function! s:Cargo.Test(args) dict
    let execStr = self.cargo. " test " . join(a:args, " ")
    call run#util#RunEcho(execStr)
    call run#util#ExecFile(execStr)
endfunction
