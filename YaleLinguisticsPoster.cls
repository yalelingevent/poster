\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{YaleLinguisticsPoster}[2026-03-04, v0] % Florence Zhang-Yukun
\LoadClass{standalone}


\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=ylp, prefix=ylp@, setkeys = \kvsetkeys}

\DeclareBoolOption[false]{review}
\DeclareBoolOption[false]{ling}


\DeclareStringOption[30mm]{profileradius}
\DeclareStringOption[0mm]{beforeabstractskip}
\DeclareStringOption[0mm]{lefttitleskip}
\DeclareStringOption[2cm]{qrwidth}


\ProcessKeyvalOptions*



%syntax
\RequirePackage{etoolbox}
\RequirePackage{xparse, xstring}
\RequirePackage{expl3}


%symbols
\RequirePackage{amsmath, amssymb, stmaryrd, textcomp}

%qr code
\RequirePackage{qrcode}

%drawing
\RequirePackage[inkscapepath=./dist/svg-inkscape/]{svg}

\RequirePackage[most]{tcolorbox}
\RequirePackage{calc}
\RequirePackage{tikz}
    \usetikzlibrary{calc, arrows.meta, patterns.meta}
\RequirePackage{graphicx}
\RequirePackage[dvipsnames]{xcolor}
    \definecolor{yaleblue}{HTML}{00356B}



%spacing, formatting and typography
\RequirePackage{relsize}
\RequirePackage{setspace}
\RequirePackage[auto-lang=false]{lipsum}



%font
\RequirePackage{fontspec}
    \setmainfont[SmallCapsFont={NewComputerModern Sans}, SmallCapsFeatures={Letters=SmallCaps},]{Helvetica}



%bibliography
\usepackage[hidelinks]{hyperref}
\usepackage[backend = biber, style = apa]{biblatex}
    \makeatletter\DeclareFieldFormat{bibhyperref}{\iffieldundef{doi}{\iffieldundef{url}{\@firstofone}{\href{\thefield{url}}}}{\href{https://doi.org/\thefield{doi}}}{#1\IfFileExists{assets/magnifier.svg}{\textsuperscript{\includesvg[width=1ex]{assets/magnifier.svg}}}{}}}\makeatother


%linguistics
\makeatletter
    \ifylp@ling\RequirePackage{expex, textglos, leipzig}\fi
\makeatother

%
\makeatletter\ifylp@review
    \newcommand{\insertdraftwatermark}{\node at (105mm,148.5mm)            [text = white, rotate=35, scale=2.5, text opacity=.3, scale = 5] {\textbf{DRAFT}};}
    \newcommand{\colorpatch}[1]{\tikz[outer sep=0pt] {\path[draw=gray, line width = .1pt, fill=#1] (0,0) rectangle (.3cm,.3cm);}}
    \newcommand{\colorpatchentourage}{\colorpatch{cyan}\hspace{-.1pt}\colorpatch{magenta}\hspace{-.1pt}\colorpatch{yellow}\hspace{-.1pt}\colorpatch{black}\colorpatch{white}}
    \newcommand{\insertcolorpatchentourage}{\node at (0mm,0mm) [anchor = south west, align = left, inner sep = 0pt] {\colorpatchentourage};}
\fi\makeatother

% Filling Meta Infromation

\ExplSyntaxOn
    \NewDocumentCommand{\readYAML}{mm}{\sr_readyaml:nn { #1 } { #2 }}
    \seq_new:N \l__sr_readyaml_line_seq\ior_new:N \g_sr_readyaml_stream\cs_generate_variant:Nn \seq_set_split:Nnn { NV }\cs_new_protected:Nn\sr_readyaml:nn{\prop_if_exist:cF { g_sr_readyaml_#1_prop }{\__sr_readyaml_read:n { #1 }}\prop_item:cn { g_sr_readyaml_#1_prop } { #2 }}\cs_new_protected:Nn \__sr_readyaml_read:n{\prop_new:c { g_sr_readyaml_#1_prop }\ior_open:Nn \g_sr_readyaml_stream { #1 }\ior_map_inline:Nn \g_sr_readyaml_stream{\__sr_readyaml_line:nn { #1 } { ##1 }}\ior_close:N \g_sr_readyaml_stream}\cs_new_protected:Nn\__sr_readyaml_line:nn{\tl_if_blank:nF { #2 }{\seq_set_split:NVn\l__sr_readyaml_line_seq\c_colon_str{ #2 }\prop_gput:cxx{ g_sr_readyaml_#1_prop }{ \seq_item:Nn \l__sr_readyaml_line_seq { 1 } }{ \seq_item:Nn \l__sr_readyaml_line_seq { 2 } }}}
    \NewExpandableDocumentCommand{\readYAMLexpand}{mm}{\prop_item:cn { g_sr_readyaml_#1_prop } { #2 }}
\ExplSyntaxOff

    % \- QR
    
    
    \newcommand{\addcalendarlink}[1]{\providecommand{\insertcalendarlink}{#1}}
    

    


    
    % \- Macro


    \newcommand{\insertdepartment}{University Department}
    \newcommand{\inserttype}{Talk Type}
    \newcommand{\insertdate}{00 Zer 0000}
    \newcommand{\inserttime}{00:00 ZM}
    \newcommand{\insertlocation}{00 Ave, Room 00-00}
    
    \newcommand{\addyamlinfo}[1]{%
        \renewcommand{\insertdepartment}{\readYAML{#1}{department}}
        \renewcommand{\inserttype}{\readYAML{#1}{type}}
        \renewcommand{\insertdate}{\readYAML{#1}{date}}
        \renewcommand{\insertlocation}{\readYAML{#1}{location}}
        \renewcommand{\inserttime}{\readYAML{#1}{time}}
        \renewcommand{\insertlocation}{\readYAML{#1}{location}}
    }
    
    % \- information of this talk

    \newcommand{\addprofileresource}[1]{\providecommand{\profilepath}{#1}}
    \newcommand{\addname}[1]{\providecommand{\insertname}{#1}}
    \newcommand{\addtitle}[1]{\providecommand{\inserttitle}{#1}}
    \newcommand{\addabstract}[1]{\providecommand{\insertabstract}{#1}}
    \AtBeginDocument{%
        \ifundef{\profilepath}{\IfFileExists{assets/Default_pfp.svg}{\providecommand{\insertdefaultprofilepic}{\includesvg[width=70mm]{assets/Default_pfp.svg}}\ClassWarning{YaleLinguisticsPoster}{No profile picture}}{}}{}%
        \ifundef{\insertname}{\newcommand{\insertname}{Given Family}\ClassWarning{YaleLinguisticsPoster}{Speaker name set to default}}{}%
        \ifundef{\inserttitle}{\newcommand{\inserttitle}{This is a title: And this is a subtitle}\ClassWarning{YaleLinguisticsPoster}{Title set to default}}{}%
        \ifundef{\insertabstract}{\newcommand{\insertabstract}{\large{\lipsum[1-2]}\par\ex Klingon\\\begingl\gla DaH mojaq-mey-vam DI-vuS-nIS-beʼ ʼeʼ vI-Har.//\glb now suffix-\Pl{}-\Dem{} \Fpl{}>\Tpl{}-limit-need-\Neg{} \Comp{} \Fsg{}>\Tsg{}-believe// \glft`I believe that we do not need to limit these suffixes now.'//\endgl\xe{\lipsum[3]}}\ClassWarning{YaleLinguisticsPoster}{Abstract set to default}}{}%
    }
    
    
    
    
    \newcommand{\addzoomlink}[1]{\providecommand{\insertzoomlink}{#1}}


% Drawing the poster




\newlength{\profileradius}
\newlength{\beforeabstractskip}
\newlength{\lefttitleskip}
\newlength{\qrwidth}

\makeatletter
\setlength{\profileradius}{\ylp@profileradius}
\setlength{\beforeabstractskip}{\ylp@beforeabstractskip}
\setlength{\lefttitleskip}{\ylp@lefttitleskip}
\setlength{\qrwidth}{\ylp@qrwidth}
\makeatother



\newcommand{\makeposter}{%
    \begin{tikzpicture}
        \fill[yaleblue] (0,0) rectangle (210mm,297mm);
        

        \path (5mm, 242mm) coordinate (titleblock) rectangle (205mm, 292mm);


        
        \node[anchor=north west, inner sep=0pt, text=yellow, font=\bfseries\itshape, scale = 4] (dept) at (5mm,292mm) {\insertdepartment};
        
        \node[anchor=north west, inner sep=0pt,  text=yellow, font=\bfseries\itshape, scale = 4] (type) at ([yshift=5mm]dept.south west) {\inserttype};
        
        \node[anchor= north west, inner sep = 0pt, text = white, font=\bfseries, scale = 2, align = left, text width = 100mm] (timeloc) at ([yshift = -2mm]type.south west) {\IfFileExists{assets/date.svg}{\includesvg[width=1em]{assets/date.svg}\ }{}\insertdate, \inserttime \\\IfFileExists{assets/loc.svg}{\includesvg[width=1em]{assets/loc.svg}\ }{}\insertlocation%
        };

        \begin{scope}[shift = {([yshift =-3mm-\profileradius]5mm, 0 |- titleblock.south west)}]
            \node (pic) at (0, 0) {};
            \clip ($(pic)+(\profileradius,0)$) circle (\profileradius);
            \ifundef{\profilepath}{\ifundef{\insertdefaultprofilepic}{}{\node at ($(pic)+(\profileradius,0)$) {\insertdefaultprofilepic};}}{\node at ($(pic)+(\profileradius,0)$) {\includegraphics[width=2\profileradius]{\profilepath}};}
        \end{scope}
        
        
        %\node[anchor=north east, text=white, inner sep = 0pt, font=\bfseries, scale = 2, align = right] (locNdat) at (205mm, 235mm) {\insertdate\\\inserttime\\\insertlocation};
        
        

        \node[anchor = north east, align=justify, inner sep = 0pt, outer sep = 0pt, text width=130mm-\lefttitleskip, text = white,] at (205mm, 225mm) {%
            \begin{tcolorbox}[
                standard jigsaw, boxsep = 0mm, beforeafter skip = 0mm, leftright skip = 0mm, 
                empty,
                attach boxed title to top left, boxed title style={empty,size=minimal}, fonttitle=\bfseries\fontsize{4\dimexpr\fontdimen6\font}{1.2\dimexpr\fontdimen6\font}\selectfont, coltitle = yellow, title = {\insertname},
                overlay={\draw[line width = 2pt,yellow] (title.east) -- (title.east -| frame.north east) --(frame.south east)--(frame.south west);},
                colback = white, opacityback=0, 
                coltext = white, left = 0mm, right = 3mm, bottom = 3mm, 
                ]
                \huge\bfseries\inserttitle\par
            \end{tcolorbox}
        };

        %\node[anchor=north east, text=yellow, inner sep = 0pt, font=\bfseries, scale = 4] (name) at (205mm, 227mm) {\insertname};
        
        %\node[anchor=north east, align = right, inner sep = 0pt, text=white, font=\bfseries, scale = 2] (title) at ([yshift=-.2cm]name.south east) {\inserttitle};
        


        % abstract
        
        \node[anchor = north west, align=justify, text width=200mm, text = white, font=,] at ([yshift = -30mm+\beforeabstractskip]pic.south west) {%
            \begin{tcolorbox}[
                standard jigsaw, boxsep = 0mm, beforeafter skip = 0mm, leftright skip = 0mm, 
                empty, 
                attach boxed title to top left, boxed title style={empty,size=minimal}, fonttitle=\huge\bfseries, coltitle = yellow, title = {Abstract}, 
                overlay={\draw[line width = 2pt,yellow] (title.east) -- (frame.north east |- title.east) -- (frame.south east) --(frame.south west);},
                colback = white, opacityback=0, 
                coltext = white, left = 0mm, right = 2mm, bottom = 2mm
                ]
                \insertabstract\par
            \end{tcolorbox}
        };
        

        % zoom link

        \ifundef{\insertzoomlink}{}{\node[anchor=south east, text=white, inner sep = 0pt, scale = 1, font = \Large] (zoomlink) at (205mm,5mm) {\IfFileExists{assets/Zoom.svg}{\includesvg[height = 1ex]{assets/Zoom.svg}\ }{}\href{\insertzoomlink}{\texttt{\IfBeginWith{\insertzoomlink}{https://}{\StrGobbleLeft{\insertzoomlink}{8}}{\IfBeginWith{\insertzoomlink}{http://}{\StrGobbleLeft{\insertzoomlink}{7}}{\insertzoomlink}}}}};}
        
        
        
        



        % QR code

        \ifundef{\insertcalendarlink}{}{%
            
            %
            %
            \node[anchor = north east, inner sep = 0pt, outer sep = 0pt, align = center, font = \large\bfseries\itshape, text = yellow] (scan) at (205mm, 292mm) {SCAN \& ADD TO CALENDAR};

            \node[anchor = north east, inner sep = 0pt, text = white] (qr) at ([yshift = -2mm]scan.south east) {\qrcode[hyperlink, height = \qrwidth]{\insertcalendarlink}};%
        }




        % draft things

        \ifundef{\insertdraftwatermark}{}{\insertdraftwatermark}


        \ifundef{\insertcolorpatchentourage}{}{\insertcolorpatchentourage}
    \end{tikzpicture}
}