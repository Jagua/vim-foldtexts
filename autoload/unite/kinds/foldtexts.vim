let s:save_cpo = &cpo
set cpo&vim


let s:kind = {
      \ 'name' : 'foldtexts',
      \ 'parents' : [],
      \ 'default_action' : 'goto_line',
      \ 'action_table' : {
      \   'goto_line' : {
      \     'description' : 'goto folding line',
      \   },
      \ },
      \}


function! s:kind.action_table.goto_line.func(candidate) abort
  execute a:candidate.lnum
endfunction


"
" define:
"


function! unite#kinds#foldtexts#define() abort
  return s:kind
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
