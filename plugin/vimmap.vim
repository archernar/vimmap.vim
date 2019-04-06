" *****************************************************************************************************
                                  " Utility Functions
                                  " *******************************************************************
function! Pad(s,amt)
        return a:s . repeat(' ',a:amt - len(a:s))
endfunction

                                  " *******************************************************************
                                  " END: Utility Functions
" *****************************************************************************************************
" *****************************************************************************************************
                                  " MyKeyMapper 
                                  " *******************************************************************
let g:MyKeyDict = {} 
let g:MyKeyDictCT = 1000 
let g:MyKeyMapperMode = "" 
function! g:SetMyKeyMapperMode(...)
     let g:MyKeyMapperMode = substitute(a:1, " .*$", "", "g") . " "
endfunction
function! g:GetMyKeyMapperMode(...)
     if ( g:MyKeyMapperMode == "")
          call g:SetMyKeyMapperMode("STD")
     endif
    return g:MyKeyMapperMode
endfunction
function! MyTest()
     let l:szKey = "abcd-no"
     let l:szKey = substitute(l:szKey, "^[cga]", "X", "")
     echom l:szKey
endfunction
function! g:MyKeyMapper(...)
     let l:szKey = substitute(a:1,     "<silent> ", "", "")
     let l:szKey = substitute(l:szKey, "nnoremap ", "", "")
     let l:szKey = substitute(l:szKey, "vnoremap ", "", "")
     let l:szKey = substitute(l:szKey, "inoremap ", "", "")
     let l:szKey = substitute(l:szKey, " .*$", "", "g")
     " let l:prefix= g:MyKeyMapperMode . " " . g:MyKeyDictCT 
     let l:prefix= g:GetMyKeyMapperMode() . " " . g:MyKeyDictCT 

     let g:MyKeyDictCT = g:MyKeyDictCT +1
     let g:MyKeyDict[l:prefix . " " . l:szKey] = a:2
     execute a:1
endfunction

" MYCOMMANDMAPPER
function! g:MyCommandMapper(...)
     let l:szCommand = substitute(a:1, "command! ", "", "")
     let l:szCommand = substitute(l:szCommand, '^[A-Z,0-9]*[ ]*',"", "")
     let l:szKey     = substitute(a:1, "command! ", "", "")
     let l:szKey     = substitute(l:szKey, " .*$", "", "g")

     let l:prefix = g:GetMyKeyMapperMode() . " " . g:MyKeyDictCT 
     let g:MyKeyDictCT = g:MyKeyDictCT + 1

     let g:MyKeyDict[l:prefix . " " . l:szKey] = l:szCommand 

     execute a:1
endfunction
function! g:MyStaticMapper(...)
     let l:prefix = g:GetMyKeyMapperMode() . " " . g:MyKeyDictCT 
     let g:MyKeyDictCT = g:MyKeyDictCT +1
     let g:MyKeyDict[l:prefix . " " . a:1] = a:2
endfunction
function! MyKeyMapperDumpSeek()
"    zt puts current line to top of screen
"    z. or zz puts current line to center of screen
"    zb puts current line to bottom of screen
     let wuc = expand("<cword>") 
     let currentLine   = getline(".")
     let l:nn=0
     let l:Here = line(".")
     normal! G
     let l:There = line(".")
     call cursor(l:Here, 1)
     while ( (l:nn < l:There) && (wuc ==  expand("<cword>")) )
          execute "normal j"
          let l:nn= l:nn + 1
          if (l:nn >= l:There) 
               let l:nn=1
               call cursor(1, 1)
          endif
     endwhile
     normal! zt 
endfunction

" MYKEYMAPPERDUMP
function! MyKeyMapperDump(...)
        call LeftWindowBuffer()
        setlocal cursorline
        nnoremap <silent> <buffer> q :close<cr>
        nnoremap <silent> <buffer> ? :close<cr>
        nnoremap <silent> <buffer> <F8>  :call MyKeyMapperDumpSeek()<cr>
        nnoremap <silent> <buffer> <leader><F8>  :close<cr>
        nnoremap <silent> <buffer> s  :call MyKeyMapperDumpSeek()<cr>
        let l:nn=1
        echo "MPMMP"
"  	for key in sort(keys(g:MyKeyDict))
"                      call setline(l:nn, g:MyKeyDict[key] . "    [[    |" .  key)
"                      let l:nn= l:nn + 1
"  	endfor
        let l:ntemp=0
        let l:ntemp2=0
	"for key in sort(keys(g:MyKeyDict))
	for key in keys(g:MyKeyDict)
          let l:list = split(key)

          let l:n = strlen(join(l:list[0:0], ''))   " section
          if (l:n > l:ntemp)
              let l:ntemp = l:n
          endif
          let l:n = strlen(join(l:list[2:2], ''))   " punch
          if (l:n > l:ntemp2)
              let l:ntemp2 = l:n
          endif
	endfor
        let l:ntemp = l:ntemp + 1
        let l:ntemp2 = l:ntemp2 + 1
	for key in sort(keys(g:MyKeyDict))
          let l:list = split(key)
          let l:section = l:list[0:0]
          let l:number = l:list[1:1]
          let l:punch = l:list[2:2]
          let l:linemod = g:MyKeyDict[key]
          let l:sz = Pad(join(l:section, ''), l:ntemp) .  Pad(join(l:punch, ''),l:ntemp2) . l:linemod

          if ( a:0 == 1)
               if ( l:section == a:1)
                    call setline(l:nn, l:line . "")
                    let l:nn= l:nn + 1
          endif
          else
               call setline(l:nn, l:sz . "")
               let l:nn= l:nn + 1
          endif
	endfor
        wincmd H
        vertical resize 80 
        set nowrap
"         setlocal readonly nomodifiable
        echom ""
endfunction

" *****************************************************************************************************
                                  " Left Window-Buffer Functions
                                  " *******************************************************************
function! LeftWindowBuffer(...)
    " a:1    Enter Action
    " a:2    Content Action
    " *******************************************************************
    " Reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        vnew
        wincmd H
        let s:buf_nr = bufnr('%')
        setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
        nnoremap <silent> <buffer> q :close<cr>
    elseif bufwinnr(s:buf_nr) == -1
        vnew
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif
    " *******************************************************************
    if ( a:0 > 0)
         execute "nnoremap <silent> <buffer> <Enter> " . a:1
    endif
    " let w:scratch = 1
    vertical resize 80 
    call cursor(1, 1)
    execute "normal! gg"
    execute "normal! dG"
    if ( a:0 > 0)
         execute a:2
    endif
    call cursor(1, 1)
endfunction

