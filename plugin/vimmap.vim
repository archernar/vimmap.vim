" *****************************************************************************************************
                                  " Utility Functions
                                  " *******************************************************************
function! s:Pad(s,amt)
        return a:s . repeat(' ',a:amt - len(a:s))
endfunction
function! s:Trim(s1)
     return substitute( substitute(a:s1, "^ *", "", "")        , " *$", "", "")
endfunction

                                  " *******************************************************************
                                  " END: Utility Functions
" *****************************************************************************************************
" *****************************************************************************************************
                                  " MyKeyMapper 
                                  " *******************************************************************
function! g:SetMyKeyMapperMode(...)
     let g:MyKeyMapperMode = s:Trim(a:1)
endfunction
function! g:GetMyKeyMapperMode(...)
     if ( g:MyKeyMapperMode == "")
          call g:SetMyKeyMapperMode("STD")
     endif
    return s:Trim(g:MyKeyMapperMode) . " "
endfunction

function! g:MyCommandItemMapper(...)
     let l:szKey = "ITEM" . g:MyCommandItemCT 
     let g:MyCommandItemDict[ l:szKey ] = a:1
     let g:MyCommandItemCT = g:MyCommandItemCT +1
endfunction

function! g:MyCommandItemMapperReset()
    let g:MyCommandItemDict = {} 
    let g:MyCommandItemCT = 1000 
endfunction

function! g:MyKeyMapper(...)
     let l:szKey = substitute(a:1,     "<silent> ", "", "")
     let l:szKey = substitute(l:szKey, "nnoremap ", "", "")
     let l:szKey = substitute(l:szKey, "vnoremap ", "", "")
     let l:szKey = substitute(l:szKey, "inoremap ", "", "")
     let l:szKey = substitute(l:szKey, " .*$", "", "g")

     let g:MyKeyDict[ g:GetMyKeyMapperMode() . l:szKey ] = a:2
     let g:MyKeyDictCT = g:MyKeyDictCT +1
     execute a:1
endfunction

" MYCOMMANDMAPPER
function! g:MyCommandMapper(...)
     let l:szCommand = substitute(a:1, "command! ", "", "")
     let l:szCommand = substitute(l:szCommand, '^[A-Z,0-9]*[ ]*',"", "")
     let l:szKey     = substitute(a:1, "command! ", "", "")
     let l:szKey     = substitute(l:szKey, " .*$", "", "g")
     let g:MyKeyDict[g:GetMyKeyMapperMode() . l:szKey] = l:szCommand 
     let g:MyKeyDictCT = g:MyKeyDictCT + 1
     execute a:1
endfunction
function! g:MyCommandNoMap(...)
     let l:szCommand = substitute(a:1, "command! ", "", "")
     let l:szCommand = substitute(l:szCommand, '^[A-Z,0-9]*[ ]*',"", "")
     let l:szKey     = substitute(a:1, "command! ", "", "")
     let l:szKey     = substitute(l:szKey, " .*$", "", "g")
     let g:MyKeyDict[g:GetMyKeyMapperMode() . l:szKey] = l:szCommand 
     let g:MyKeyDictCT = g:MyKeyDictCT + 1
endfunction
function! g:MyStaticMapper(...)
     let g:MyKeyDict[g:GetMyKeyMapperMode() . a:1] = a:2
     let g:MyKeyDictCT         = g:MyKeyDictCT +1
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
     let l:nnl=0
     let l:break=0
     while ( (l:nn < l:There) && (wuc ==  expand("<cword>")) && (l:break==0)  )
          execute "normal j"
          let l:nn= l:nn + 1


          if (1 > 12) 
          let l:nnl= l:nnl + 1
          if (l:nnl > 12) 
             let l:break=1
             call cursor(l:nn, 1)
             normal! zt 
          endif
          endif

          if (l:nn >= l:There) 
               let l:nn=1
               call cursor(1, 1)
          endif
     endwhile
     normal! zt 
endfunction

function! MKDE()
          let l:currentLine   = getline(".")
          let l:list = split(l:currentLine)
          let l:sz = join(l:list[2:32], ' ')
          echom join(l:list[2:32], ' ')
          silent execute "q"
          silent execute l:sz
endfunction

" MYKEYMAPPERDUMP
function! KeyMapperEnterAction()
     let l:currentLine   = getline(".")
     echom currentLine
     if (empty(matchstr(currentLine,'\v^SNIP') . matchstr(currentLine,'\v^COLOR')   . matchstr(currentLine,'\v^DOIT') . matchstr(currentLine,'\v^FILE')     ))
         let l:currentLine = l:currentLine
     else
"          let l:currentLine = substitute(l:currentLine, '^[A-Z,0-9]*[ ]*',"", "")
"          let l:currentLine = substitute(l:currentLine, '^[A-Z,0-9]*[ ]*',"", "")
"          let l:currentLine = substitute(l:currentLine, '^[ ]*',"", "")
         let l:currentLine = substitute(l:currentLine, '\v^.*:',":", "")
         let l:currentLine = substitute(l:currentLine, '^:',"", "")
         if (strlen(l:currentLine) > 0)
             silent execute "q"
             silent execute l:currentLine
         endif
         " execute "redraw!"
     endif
endfunction

function! MyKeyMapperEmpty(...)
    for l:key in keys(g:MyKeyDict)
        let l:removed = remove(g:MyKeyDict, l:key)
    endfor
endfunction

"          nnoremap <silent><buffer> p :r !ps -ef<cr>
let g:gOtate = -1 
function! g:Otate()
     let g:gOtate = g:gOtate + 1
     if (g:gOtate > 4)
         let g:gOtate = 0
     endif
     if (g:gOtate == 0)
         call g:setupsniplocal("./*.obj")
     endif
     if (g:gOtate == 1)
         call g:setupsniplocal("./*.java")
     endif
     if (g:gOtate == 2)
         call g:setupsniplocal("./*.txt")
     endif
     if (g:gOtate == 3)
         call g:setupsniplocal("./*.csv")
     endif
     if (g:gOtate == 4)
         call g:setupsniplocal("./*.py")
     endif
     call MyDictionaryDump(g:MyCommandItemDict)
endfunction


function! MyDictionaryDump(...)
        call LeftWindowBuffer(":call KeyMapperEnterAction()<cr>")
        nnoremap <silent><buffer> o :call g:Otate()<cr>
        setlocal cursorline
        nnoremap <silent> <buffer> q :close<cr>
        let l:nn=1
        call setline(l:nn, "BEGIN!")
        let l:nn= l:nn + 1
	for key in sort(keys(a:1))
          let l:sz      = a:1[key]
          call setline(l:nn, l:sz . "")
          let l:nn= l:nn + 1
	endfor
        wincmd H
        vertical resize 100 
        set nowrap
        echom ""
endfunction

function! MyKeyMapperDump(...)
        
        call LeftWindowBuffer(":call KeyMapperEnterAction()<cr>")
        setlocal cursorline
        nnoremap <silent> <buffer> q :close<cr>
        nnoremap <silent> <buffer> ? :close<cr>
        nnoremap <silent> <buffer> <F8>  :call MyKeyMapperDumpSeek()<cr>
        nnoremap <silent> <buffer> <leader><F8>  :close<cr>
        nnoremap <silent> <buffer> s  :call MyKeyMapperDumpSeek()<cr>
        " nnoremap <silent> <buffer> C :1<cr>/\v^COLOR<cr>
        let l:nn=1
        let l:ntemp=0
        let l:ntemp2=0
	" a:1 is g:MyKeyDict
	for key in keys(a:1)
          let l:list = split(key)
          let l:n = strlen(join(l:list[0:0], ''))
          if (l:n > l:ntemp)
              let l:ntemp = l:n
          endif
          let l:n = strlen(join(l:list[1:1], ''))
          if (l:n > l:ntemp2)
              let l:ntemp2 = l:n
          endif
	endfor

                    call setline(l:nn, "BEGIN!")
                    let l:nn= l:nn + 1
        let l:ntemp = l:ntemp + 1
        let l:ntemp2 = l:ntemp2 + 1
	for key in sort(keys(a:1))
          let l:list = split(key)
          let l:sz      = Pad(join(l:list[0:0],''), l:ntemp) .  Pad(join(l:list[1:1],''),l:ntemp2) . a:1[key]

          if ( a:0 == 2)
               if ( l:list[0:0] == a:2)
                    call setline(l:nn, l:line . "")
                    let l:nn= l:nn + 1
          endif
          else
               call setline(l:nn, l:sz . "")
               let l:nn= l:nn + 1
          endif
	endfor
        wincmd H
        vertical resize 100 
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
        nnoremap <silent> <buffer> h :call BottomWindowBuffer("(q)uit/close, (h)elp", "Moe")<cr>
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
    if ( a:0 > 1)
         execute a:2
    endif
    call cursor(1, 1)
endfunction

" *****************************************************************************************************
                                  " Bottom Window-Buffer Functions
                                  " *******************************************************************
function! BWB(...) 
call  BottomWindowBuffer()
endfunction
function! BottomWindowBuffer(...)
        belowright new
        let s:buf_nr = bufnr('%')
        setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
        nnoremap <silent> <buffer> q :close<cr>
        nnoremap <silent> <buffer> h :close<cr>
        resize 4
        set nonumber
        if (a:0  > 0)
            let l:nn = 1
            while (l:nn <= a:0 )
                 call setline(l:nn, get(a:000,l:nn-1) )
                 let l:nn= l:nn + 1
            endwhile
        endif
endfunction
