function! s:NotSupportLang(lang)
    let msg = printf("Does not support current language type:[%s].",
                \toupper(a:lang))
    call run#util#RunEchoWarn(msg)
endfunction

function! s:Run(...)
    let winid = winnr()
    if g:Run#AutoSave > 0
        call run#util#AutoSave()
    endif
    
    let runnerType = run#util#GetFileType()
    if run#util#HasMakefile()
        let runnerType = "make"
    endif
    let runner = run#factory#GetRuner(runnerType)
    if empty(runner)
        call s:NotSupportLang(runnerType)
    else
        call runner.Run(a:000)
    endif
    if g:Run#FouceCurrentWin > 0
        execute winid . "wincmd w"
    endif
endfunction

function! s:RunTest(...)
    let winid = winnr()
    if g:Run#AutoSave > 0
        call run#util#AutoSave()
    endif
    
    let runnerType = run#util#GetFileType()
    if run#util#HasMakefile()
        let runnerType = "make"
    endif
    let runner = run#factory#GetRuner(runnerType)
    if empty(runner)
        call s:NotSupportLang(runnerType)
    else
        call runner.Test(a:000)
    endif
    if g:Run#FouceCurrentWin > 0
        execute winid . "wincmd w"
    endif
endfunction

function! s:RunFile(...)
    let winid = winnr()
    if g:Run#AutoSave > 0
        call run#util#AutoSave()
    endif
    
    let runner = run#factory#GetRuner(run#util#GetFileType())
    if empty(runner)
        call s:NotSupportLang(runnerType)
    else
        call runner.Run(a:000)
    endif
    if g:Run#FouceCurrentWin > 0
        execute winid . "wincmd w"
    endif
endfunction

function! s:RunDebug(...)
    if g:Run#AutoSave > 0
        call run#util#AutoSave()
    endif
    
    let runner = run#factory#GetRuner(run#util#GetFileType())
    if empty(runner)
        call s:NotSupportLang(run#util#GetFileType())
    else
        call runner.Debug(a:000)
    endif
endfunction

function! s:RunBuild(...)
    if g:Run#AutoSave > 0
        call run#util#AutoSave()
    endif
    let runnerType = run#util#GetFileType()
    if run#util#HasMakefile()
        let runnerType = "make"
    endif
    let runner = run#factory#GetRuner(runnerType)
    if empty(runner)
        call s:NotSupportLang(runnerType)
    else
        call runner.Build(a:000)
    endif
endfunction

function! s:RunClean(...)
    let runnerType = run#util#GetFileType()
    if run#util#HasMakefile()
        let runnerType = "make"
    endif
    let runner = run#factory#GetRuner(runnerType)
    if empty(runner)
        call s:NotSupportLang(runnerType)
    else
        call runner.Clean(a:000)
    endif
endfunction



command! -nargs=? Run call s:Run(<f-args>)
command! -nargs=? RunFile call s:RunFile(<f-args>)
command! -nargs=? RunDebug call s:RunDebug(<f-args>)
command! -nargs=? RunBuild call s:RunBuild(<f-args>)
command! -nargs=? RunClean call s:RunClean(<f-args>)
command! -nargs=? RunTest call s:RunTest(<f-args>)
command! -nargs=0 RunStop call run#util#RunStop()

command! -nargs=? R Run <f-args>
command! -nargs=? RF RunFile <f-args>
command! -nargs=? D RunDebug <f-args>
command! -nargs=? B RunBuild <f-args>
command! -nargs=? C RunClean <f-args>
command! -nargs=? T RunTest <f-args>
