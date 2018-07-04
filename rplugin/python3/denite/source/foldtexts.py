from .base import Base


class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'foldtexts'
        self.kind = 'file'

        self.__current_path = self.vim.call('expand', '%')

    def on_init(self, context):
        context['__items'] = self.get_foldtexts(1, self.vim.call('line', '$'))

    def gather_candidates(self, context):
        return [{'word': item['word'],
                 'action__path': self.__current_path,
                 'action__line': item['lnum']}
                for item
                in context['__items']]

    def get_foldtexts(self, start, end):
        items = []
        lnum = start
        width = str(len(str(len(self.vim.current.buffer))))
        while (lnum <= end):
            fold_last_lnum = self.vim.call('foldclosedend', lnum)
            if fold_last_lnum == -1:
                lnum += 1
            else:
                text = self.vim.call('foldtextresult', lnum)
                items.append({
                    'lnum': lnum,
                    'foldtextresult': text,
                    'word': ('{0:' + width + 'd} : {1:s}').format(lnum, text),
                })
                lnum = fold_last_lnum + 1
        return items
