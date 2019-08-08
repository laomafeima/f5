if !exists("Run#AutoSave")
    let Run#AutoSave = 1 " 运行时候是否自动保存
endif

if !exists("Run#AutoCloseQF")
    let Run#AutoCloseQF = 1 " 当只剩下 QuickFix 的时候自动退出
endif

if !exists("Run#FouceCurrentWin")
    let Run#FouceCurrentWin = 1 " 运行的时候焦点依然在当前文件
endif

if !exists("Run#DebugMakeFrist")
    let Run#DebugMakeFrist = 0 " Debug 的时候是否 Makefile 优先
endif

if !exists("Run#AlwaysBottom")
    let Run#AlwaysBottom = 1 " 运行的时候输出窗口出现在底部
endif

if !exists("Run#CargoRootFile")
    let Run#CargoRootFile = ["Cargo.toml"] " Cargo 项目的根目录标记
endif

if !exists("Run#GoRootFile")
    let Run#GoRootFile = ["go.mod", "go.sum"] " Golang 项目的根目录标记
endif

if !exists("Run#PythonRunner")
    let Run#PythonRunner =  "/usr/bin/env python3" " Python 脚本执行
endif

if !exists("Run#PythonTestRunner")
    let Run#PythonTestRunner =  "pytest" " Python  测试脚本执行
endif

if !exists("Run#MakeRootFile")
    let Run#MakeRootFile = [
                \'Makefile',
                \'makefile',
                \'GNUmakefile'
                \] " 指定 Makefile 工程化运行文件
endif

let Run#ScriptRunnerBase = {
    \'lua': '/usr/bin/env lua',
    \'ruby': '/usr/bin/env ruby',
    \'php': '/usr/bin/env php',
    \'sh': '/usr/bin/env bash', 
    \'javascript': '/usr/bin/env node',
    \}
" 添加或者覆盖脚本运行环境
if !exists("Run#ScriptRunner")
    let Run#ScriptRunner = g:Run#ScriptRunnerBase
else
    let Run#ScriptRunner = extend(g:Run#ScriptRunnerBase, g:Run#ScriptRunner)
endif


if g:Run#AutoCloseQF > 0
    au BufEnter * call run#util#AutoCloseQF()
endif

if g:Run#AlwaysBottom > 0
    autocmd FileType qf wincmd J " QuickFix 出现在最底部
endif
