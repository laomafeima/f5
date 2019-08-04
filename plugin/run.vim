let s:runVim = {
            \"currentWinid": 0,
            \}

function! s:runVim.Before() dict
    let self.currentWinid = winnr()
    if g:Run#AutoSave > 0
        call run#util#AutoSave()
    endif
endfunction


function! s:runVim.After() dict
    if g:Run#FouceCurrentWin > 0 && self.currentWinid > 0
        let self.currentWinid = 0
        execute self.currentWinid . "wincmd w"
    endif
endfunction

function! s:runVim.GetRunner(...) dict
    let runnerType = run#util#GetFileType()
    if len(a:000) > 0 " 如果有指定类型就优先选择有类型的
        let runnerType = a:000[0]
    else
        if run#util#HasRootFile(g:Run#GoRootFile)
            let runnerType = "go"
        endif
        if run#util#HasRootFile(g:Run#CargoRootFile)
            let runnerType = "cargo"
        endif
        if run#util#HasRootFile(g:Run#MakeRootFile)
            let runnerType = "make"
        endif
    endif
    let runner = run#factory#GetRuner(runnerType)
    if empty(runner)
        call run#util#NotSupportLang(runnerType)
    endif
    return runner
endfunction



function! s:runVim.Run(...) dict
    call self.Before()
    let runner = self.GetRunner()
    if !empty(runner)
        call runner.Run(a:000)
    endif
    call self.After()
endfunction

function! s:runVim.RunTest(...) dict
    call self.Before()

    let runner = self.GetRunner()
    if !empty(runner)
        call runner.Test(a:000)
    endif
    call self.After()
endfunction

function! s:runVim.RunFile(...) dict
    call self.Before()
    
    let runner = self.GetRunner(run#util#GetFileType())
    if !empty(runner)
        call runner.Run(a:000)
    endif
    call self.After()
endfunction

function! s:runVim.RunDebug(...) dict
    call self.Before()
    let runner = self.GetRunner()
    if !empty(runner)
        call runner.Debug(a:000)
    endif
    call self.After()
endfunction

function! s:runVim.RunBuild(...) dict
    call self.Before()
    let runner = self.GetRunner()
    if !empty(runner)
        call runner.Build(a:000)
    endif
    call self.After()
endfunction

function! s:runVim.RunClean(...) dict
    let runner = self.GetRunner()
    if !empty(runner)
        call runner.Clean(a:000)
    endif
endfunction

command! -nargs=? Run call s:runVim.Run(<f-args>)
command! -nargs=? RunFile call s:runVim.RunFile(<f-args>)
command! -nargs=? RunDebug call s:runVim.RunDebug(<f-args>)
command! -nargs=? RunBuild call s:runVim.RunBuild(<f-args>)
command! -nargs=? RunClean call s:runVim.RunClean(<f-args>)
command! -nargs=? RunTest call s:runVim.RunTest(<f-args>)
command! -nargs=0 RunStop call run#util#RunStop()

command! -nargs=? R Run <f-args>
command! -nargs=? RF RunFile <f-args>
command! -nargs=? D RunDebug <f-args>
command! -nargs=? B RunBuild <f-args>
command! -nargs=? C RunClean <f-args>
command! -nargs=? T RunTest <f-args>
