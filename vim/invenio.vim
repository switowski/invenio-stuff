"FIXME: it doesn't work as it should
function IvenioKwalitee()
    if !executable("invenio-check-kwalitee")
        echoerr "invenio-check-kwalitee not found. Please install it first."
        return
    endif

    " store old grep settings (to restore later)
    let l:old_gfm=&grepformat
    let l:old_gp=&grepprg

    " write any changes before continuing
    if &readonly == 0
        update
    endif

    " perform the grep itself
    let &grepformat="%f:%l:%m,%-G%.%#"
    let &grepprg="invenio-check-kwalitee"
    silent! grep! %

    " restore grep settings
    let &grepformat=l:old_gfm
    let &grepprg=l:old_gp

    " open cwindow
    let has_results=getqflist() != []
    if has_results
        execute 'belowright copen'
        setlocal wrap
        nnoremap <buffer> <silent> c :cclose<CR>
        nnoremap <buffer> <silent> q :cclose<CR>
    endif

    set nolazyredraw
    redraw!
    if has_results == 0
        " Show OK status
        hi Green ctermfg=green
        echohl Green
        echon "Invenio kwaletee check OK"
        echohl
    endif
endfunction

function InvenioMakeInstall()
     if !executable("invenio-make-install")
        echoerr "invenio-make-install not found. Please install it first."
        return
    endif

    let l:old_make=&makeprg

    let &makeprg="invenio-make-install"
    silent! !make %

endfunction

noremap <buffer> <leader>kw :call IvenioKwalitee()<CR>
noremap <buffer> <leader>mi :call InvenioMakeInstall()<CR>

