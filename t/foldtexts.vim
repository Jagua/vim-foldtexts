if !empty($PROFILE_LOG)
  profile start $PROFILE_LOG
  profile! file autoload/*.vim
  profile! file plugin/*.vim
  " runtime! autoload/ctrlp/*.vim
  " runtime! autoload/ku/*.vim
  " runtime! autoload/unite/*/*.vim
endif


runtime! plugin/foldtexts.vim


describe 'vim-foldtexts'
  it 'is available when compiled with the +folding feature'
    Expect has('folding') to_be_true
  end

  it 'defines a command for CtrlP'
    Expect exists(':CtrlPFoldtexts') == 2
  end
end

describe 'foldtexts#get()'
  before
    new
    put = [
          \ '\"',
          \ 'function s:greeting() \"{{{',
          \ '  echo \"Hello, world!\"',
          \ 'endfunction \"}}}',
          \ '',
          \ '',
          \ '\"{{{',
          \ '\" Main routine',
          \ '\"{{{',
          \ '  call s:greeting()',
          \ '\"}}}',
          \ '\"}}}',
          \ '',
          \]
    1 delete _
    setfiletype vim
    setlocal foldmethod=marker
    normal! zM
  end

  after
    close!
  end

  it 'returns an empty list when all foldings are open'
    normal! zR
    let items = foldtexts#get()
    Expect len(items) == 0
  end

  it 'returns list of dictionary which has three keys when foldings exist'
    let items = foldtexts#get()
    Expect empty(items) to_be_false
    Expect type(items) == v:t_list
    Expect len(items) > 0
    Expect type(items[0]) == v:t_dict
    Expect has_key(items[0], 'lnum') to_be_true
    Expect has_key(items[0], 'foldtextresult') to_be_true
    Expect has_key(items[0], 'word') to_be_true
  end

  it 'returns proper result when foldings exist'
    let items = foldtexts#get()
    Expect len(items) == 2
    Expect items[0].lnum == 2
    Expect items[0].foldtextresult ==# foldtextresult(items[0].lnum)
    Expect items[0].foldtextresult ==# '+--  3 lines: function s:greeting() "'
    Expect items[1].lnum == 7
    Expect items[1].foldtextresult ==# foldtextresult(items[1].lnum)
    Expect items[1].foldtextresult ==# '+--  6 lines: "'
  end

  it 'returns proper result when taking arguments'
    let items = foldtexts#get(1, 5)
    Expect len(items) == 1
    Expect items[0].lnum == 2
    Expect items[0].foldtextresult ==# '+--  3 lines: function s:greeting() "'
  end

  it 'returns proper result when foldings nested'
    normal! 7Gzo
    let items = foldtexts#get()
    Expect len(items) == 2
    Expect items[1].lnum == 9
    Expect items[1].foldtextresult ==# '+---  3 lines: "'
  end
end
