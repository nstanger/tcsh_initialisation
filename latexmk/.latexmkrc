$force_mode = 1;
$pdf_previewer = "start open -a /Applications/Skim.app %S";
$dvi_previewer = "start open -a /Applications/Skim.app %S";
$make = "gmake";
&set_tex_cmds("-synctex=1 -shell-escape -interaction=nonstopmode -halt-on-error -file-line-error");
