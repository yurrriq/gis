LoadPackage( "AutoDoc" );
AutoDoc(rec(
    gapdoc := rec(
        LaTeXOptions := rec(
            LateExtraPreamble := """
            \usepackage{amsmath}
            \usepackage[T1]{fontenc}
            """
        ),
    ),
    autodoc := true,
    dir := "docs",
    scaffold := true
));

QUIT;
