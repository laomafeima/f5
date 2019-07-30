if !exists("Run#AutoSave")
    let Run#AutoSave = 1 " 运行时候是否自动保存
endif

if !exists("Run#AutoCloseQF")
    let Run#AutoCloseQF = 1 " 当只剩下 QuickFix 的时候自动退出
endif

if !exists("Run#FouceCurrentWin")
    let Run#FouceCurrentWin = 1 " 运行的时候焦点依然在当前文件
endif

if !exists("Run#AlwaysBottom")
    let Run#AlwaysBottom = 1 " 运行的时候输出窗口出现在底部
endif


let Run#Type2EnvBase = {
    \'python': '/usr/bin/env python3',
    \'python_test': '/usr/bin/env pytest',
    \'go': '/usr/bin/env go',
    \'lua': '/usr/bin/env lua',
    \'ruby': '/usr/bin/env ruby',
    \'php': '/usr/bin/env php',
    \'sh': '/usr/bin/env bash', 
    \'javascript': '/usr/bin/env node',
    \}
" 添加或者覆盖脚本运行环境
if !exists("Run#Type2Env")
    let Run#Type2Env = g:Run#Type2EnvBase
else
    let Run#Type2Env = extend(g:Run#Type2EnvBase, g:Run#Type2Env)
endif

let Run#Makefiles = [
            \'Makefile',
            \'makefile',
            \'GNUmakefile'
            \] " 指定工程化运行文件

if g:Run#AutoCloseQF > 0
    au BufEnter * call run#util#AutoCloseQF()
endif

if g:Run#AlwaysBottom > 0
    autocmd FileType qf wincmd J " QuickFix 出现在最底部
endif
