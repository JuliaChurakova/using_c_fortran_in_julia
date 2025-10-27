macro F(str_expr)

    str = eval(str_expr)  
    file = tempname() * ".f90" 

    lib  = tempname() * ".so"

    open(file, "w") do f  
        write(f, str)
    end

    run(`gfortran -shared -fPIC -o $lib $file`)
    return :(ccall((:main_, $lib), Cvoid, ()))
end

