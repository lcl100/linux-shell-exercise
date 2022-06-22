#!/bin/bash

####################################
#
# 功能：编写生成脚本基本格式的脚本，包括作者，联系方式，版本，时间，描述等。
#
# 使用：直接执行，不需要任何参数
#
####################################


# 其实就是将下面这段内容输出到 ~/.vimrc 文件中
cat << EOF > ~/.vimrc
autocmd BufNewFile *.sh exec ":call SetTitle()"
func SetTitle()
  if expand("%:e") == 'sh'
    call setline(1, "#!/bin/bash")
    call setline(2, "Author: ")
    call setline(3, "eMail: ")
    call setline(4, "Time:".strftime("%F %T"))
    call setline(5, "Name: ".expand("%"))
    call setline(6, "Version: V1.0")
    call setline(7, "Description: ")
  endif
endfunc
EOF
