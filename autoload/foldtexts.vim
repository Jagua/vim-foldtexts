let s:save_cpo = &cpo
set cpo&vim


function! foldtexts#get(...) abort
  let start = get(a:, '1', 1)
  let end = get(a:, '2', line('$'))
  return s:get_foldtexts(start, end)
endfunction


" Note: return text adapted to format for |location-list| and |quickfix|
function! foldtexts#qfexpr() abort
  return map(foldtexts#get(),
        \ 'printf("%s:%d: %s", expand("%"), v:val.lnum, v:val.foldtextresult)')
endfunction


function! foldtexts#words() abort
  return map(foldtexts#get(), 'v:val.word')
endfunction


function! foldtexts#lnum_of_word(word) abort
  return str2nr(matchstr(a:word, '^\s*\zs\d\+\ze\s*:'))
endfunction


function! foldtexts#find_lnum(foldtext) abort
  let res = filter(foldtexts#get(), 'v:val.word ==# a:foldtext')
  return empty(res) ? 0 : res[0].lnum
endfunction


function! s:get_foldtexts(start, end) abort
  let items = []
  let lnum = a:start
  let width_str = printf('%d', float2nr(log10(a:end)) + 1)
  while lnum <= a:end
    let fold_last_lnum = foldclosedend(lnum)
    if fold_last_lnum == -1
      let lnum += 1
    else
      let text = foldtextresult(lnum)
      call add(items, {
            \ 'lnum' : lnum,
            \ 'foldtextresult' : text,
            \ 'word' : printf('%' . width_str . 'd : %s', lnum, text),
            \})
      let lnum = fold_last_lnum + 1
    endif
  endwhile
  return items
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
