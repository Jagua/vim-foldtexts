if exists('g:loaded_ctrlp_foldtexts')
  finish
endif
let g:loaded_ctrlp_foldtexts = 1


let s:save_cpo = &cpo
set cpo&vim


let s:var = {
      \ 'init' : 'ctrlp#foldtexts#init(s:crbufnr)',
      \ 'exit' : 'ctrlp#foldtexts#exit()',
      \ 'accept' : 'ctrlp#foldtexts#accept',
      \ 'lname' : 'foldtexts',
      \ 'sname' : 'foldtexts',
      \ 'type' : 'foldtexts',
      \ 'sort' : 0,
      \}


if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:var)
else
  let g:ctrlp_ext_vars = [s:var]
endif


let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)


function! ctrlp#foldtexts#init(crbufnr) abort
  let bufnr = bufwinnr(bufnr('%'))
  noautocmd execute bufwinnr(a:crbufnr) . 'wincmd w'
  let s:items = foldtexts#get_words()
  noautocmd execute bufnr . 'wincmd w'
  return s:items
endfunction


function! ctrlp#foldtexts#accept(mode, str) abort
  call ctrlp#exit()
  execute foldtexts#get_lnum_from_word(a:str)
endfunction


function! ctrlp#foldtexts#exit() abort
  unlet! s:items
endfunction


function! ctrlp#foldtexts#id() abort
  return s:id
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
