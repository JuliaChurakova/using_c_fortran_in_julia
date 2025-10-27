macro C(str_expr)

    str = eval(str_expr) 
    file = tempname() * ".c" 

    lib  = tempname() * ".so"

    open(file, "w") do f  
        write(f, str)
    end

    run(`gcc -shared -fPIC -o $lib $file -lgmp`) 
    return :(ccall((:main, $lib), Cint, ()))
end

