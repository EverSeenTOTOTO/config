" 自动添加标题头
fun! AutoSetFileHead()
    let filetype_name = strpart(expand("%"), stridx(expand("%"), "."))
    " .sh "
    if filetype_name == '.sh'
        call setline(1, "\#!/bin/bash")
    endif

    " python "
    if filetype_name == '.py'
        call setline(1, "\#!/usr/bin/env python")
        call append(1, "\# encoding: utf-8")
    endif

    " zx "
    if filetype_name == '.mjs'
        call setline(1, "\#!/usr/bin/env zx")
    endif

    normal G
    normal o
    normal o
endfunc
