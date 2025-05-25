 note the $ symbols in f and s commands are 'esc'!
 
    ^ = first line
    . = curr line
    * = last line
    esc = print prev, exit insert mode if inside
    ctrl-j = print next
    pln1:ln2 = print lines in range
    iln1 = insert mode at ln1
    cln1,ln2:ln3 = copy range to ln1
    tln1,ln2:ln3 = move range to ln1
    rln1:ln2 = delete range and insert at ln1
    fstring$ln1:ln2 = find string in range
    sstring1$string2$ln1:ln2 = substitute string in range
    nx = renumber lines using step x
    w = save
    e = save and exit
    es = save without line numbers
    eq = exit without save
    g = save and exit and rerun
    ctrl-u = retype current line, any mode 

