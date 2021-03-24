if exists('g:loaded_nvim_tetris') | finish | endif " prevent loading file twice

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

if has("nvim")
  command Tetris lua require("nvim-tetris.main").init()
endif

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_nvim_tetris = 1
