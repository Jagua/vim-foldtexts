let s:save_cpo = &cpo
set cpo&vim


function! ku#foldtexts#available_sources() abort
  return ['foldtexts']
endfunction


function! ku#foldtexts#on_source_enter(source_name_ext) abort
  let bufnr = bufwinnr(bufnr('%'))
  noautocmd wincmd p
  let s:items = foldtexts#get_foldtexts()
  noautocmd execute bufnr . 'wincmd w'
endfunction


function! ku#foldtexts#action_table(source_name_ext) abort
  return {
        \ 'default' : 'ku#foldtexts#action_goto_line',
        \}
endfunction


function! ku#foldtexts#key_table(source_name_ext) abort
  return {
        \ "\<CR>" : 'goto_line',
        \}
endfunction


function! ku#foldtexts#gather_items(source_name_ext, pattern) abort
  return s:items
endfunction


"
" action:
"


function! ku#foldtexts#action_goto_line(item) abort
  execute a:item.lnum
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
