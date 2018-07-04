let s:save_cpo = &cpo
set cpo&vim


"
" sync:
"


let s:source = {
      \ 'name' : 'foldtexts',
      \ 'description' : 'goto folding line',
      \ 'default_kind' : 'foldtexts',
      \ 'hooks' : {},
      \}


function! s:source.hooks.on_init(args, context) abort
  let a:context._items = foldtexts#get_foldtexts()
endfunction


function! s:source.gather_candidates(args, context) abort
  return a:context._items
endfunction


"
" async:
"


let s:source_async = {
      \ 'name' : 'foldtexts/async',
      \ 'description' : 'goto folding line (async)',
      \ 'default_kind' : 'foldtexts',
      \ 'hooks' : {},
      \}


function! s:source_async.hooks.on_init(args, context) abort
  let a:context._lnum = 1
  let a:context._last_lnum = line('$')
  let a:context._bufnr = bufnr('%')
  let a:context._lnum_step = 1000
endfunction


function! s:source_async.async_gather_candidates(args, context) abort
  let lnum = a:context._lnum
  let bufnr = bufnr('%')

  if lnum >= a:context._last_lnum
    let a:context.is_async = 0
    return []
  else
    noautocmd execute bufwinnr(a:context._bufnr) . 'wincmd w'
    let a:context._lnum = lnum + a:context._lnum_step
    let items = foldtexts#get_foldtexts(lnum, a:context._lnum)
    noautocmd execute bufwinnr(bufnr) . 'wincmd w'
    return items
  endif
endfunction


"
" define:
"


function! unite#sources#foldtexts#define() abort
  return [s:source, s:source_async]
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
