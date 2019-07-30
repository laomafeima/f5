function! run#factory#GetRuner(langType)
    if a:langType == "python"
        return run#python#GetRuner()
    elseif a:langType == "make"
        return run#make#GetRuner()
    elseif a:langType == "go"
        return run#go#GetRuner()
    else
        return {}
endfunction
