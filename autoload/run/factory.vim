function! run#factory#GetRuner(langType)
    if a:langType == "python"
        return run#python#GetRuner()
    elseif a:langType == "cargo"
        return run#cargo#GetRuner()
    elseif a:langType == "make"
        return run#make#GetRuner()
    elseif a:langType == "go"
        return run#go#GetRuner()
    elseif has_key(g:Run#ScriptRunner, a:langType)
        return run#script#GetRuner()
    else
        return {}
    endif
endfunction
