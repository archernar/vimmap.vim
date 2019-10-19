func! s:strfind(s,find,start)
            if type(a:find)==1
                    let l:i = a:start
                    while l:i<len(a:s)
                            if strpart(a:s,l:i,len(a:find))==a:find
                                    return l:i
                            endif
                            let l:i+=1
                    endwhile
                    return -1
            elseif type(a:find)==3
                    " a:find is a list
                    let l:i = a:start
                    while l:i<len(a:s)
                            let l:j=0
                            while l:j<len(a:find)
                                    if strpart(a:s,l:i,len(a:find[l:j]))==a:find[l:j]
                                            return [l:i,l:j]
                                    endif
                                    let l:j+=1
                            endwhile
                            let l:i+=1
                    endwhile
                    return [-1,-1]
            endif
    endfunc

    func! g:strreplace(s,find,replace)
            if len(a:find)==0
                    return a:s
            endif
            if type(a:find)==1 && type(a:replace)==1
                    let l:ret = a:s
                    let l:i = s:strfind(l:ret,a:find,0)
                    while l:i!=-1
                            let l:ret = strpart(l:ret,0,l:i).a:replace.strpart(l:ret,l:i+len(a:find))
                            let l:i = s:strfind(l:ret,a:find,l:i+len(a:replace))
                    endwhile
                    return l:ret
            elseif  type(a:find)==3 && type(a:replace)==3 && len(a:find)==len(a:replace)
                    let l:ret = a:s
                    let [l:i,l:j] = s:strfind(l:ret,a:find,0)
                    while l:i!=-1
                            let l:ret = strpart(l:ret,0,l:i).a:replace[l:j].strpart(l:ret,l:i+len(a:find[l:j]))
                            let [l:i,l:j] = s:strfind(l:ret,a:find,l:i+len(a:replace[l:j]))
                    endwhile
                    return l:ret
            endif

    endfunc
