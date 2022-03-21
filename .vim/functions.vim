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

    norm Go
    norm o
endfunc

fun! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --hidden --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunc
