$pdf_previewer = 'start "open -a /Applications/Skim.app" %S';
&set_tex_cmds("-synctex=1 -shell-escape -interaction=nonstopmode -halt-on-error -file-line-error");

$clean_ext = "fls nav snm synctex.gz vrb";

# Adapted from https://tex.stackexchange.com/a/69832.
add_cus_dep( 'tex', 'aux', 0, 'makeexternaldocument' );
sub makeexternaldocument {
    # if the dependency isn't one of the files that this latexmk run will consider, process it
    # without this test, we would get an infinite loop!
    if (!($root_filename eq $_[0]))
    {
        if ($pdf_mode == 1)     { system( "latexmk -pdflatex \"$_[0]\"" ); }
        elsif ($pdf_mode == 2)  { system( "latexmk -pdfps \"$_[0]\"" ); }
        elsif ($pdf_mode == 3)  { system( "latexmk -pdfdvi \"$_[0]\"" ); }
        elsif ($pdf_mode == 4)  { system( "latexmk -pdflua \"$_[0]\"" ); }
        elsif ($pdf_mode == 5)  { system( "latexmk -xelatex \"$_[0]\"" ); }
        else                    { system( "latexmk \"$_[0]\"" ); }
    }
}
