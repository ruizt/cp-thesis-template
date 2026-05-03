%% cpthesis.cls -- Cal Poly thesis class
%%
%% A LaTeX2e document class implementing the formatting requirements for
%% theses submitted to the Cal Poly Office of Graduate Education
%% (per the 2022-2023 guidelines, the most recent at time of writing).
%%
%% Streamlines what was historically a Frankenstein of UC's ucthesis.cls
%% (Munson 1988; Frederick port to LaTeX2e 1994; Whelan UCSB patches 1996;
%%  Cal Poly patches by Mark Barry 2007 and Andrew Tsui 2009; caption fix
%%  by Singhal 2000) into a single small class layered on top of the
%%  standard `report' class.
%%
%% Released into the public domain. No warranty, etc. Always run a final
%% draft past the Cal Poly thesis editor before submission, since the
%% formatting requirements may change.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cpthesis}[2026/05/02 v1.0 Cal Poly thesis class]

%% ---------------------------------------------------------------------
%%  Class options
%% ---------------------------------------------------------------------
%
% Pass any options through to `report'. Defaults below are what Cal Poly
% submissions need: 12pt, letterpaper, single-sided, single column.

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass[12pt,letterpaper,oneside]{report}

%% ---------------------------------------------------------------------
%%  Required packages
%% ---------------------------------------------------------------------

\RequirePackage[letterpaper,
                tmargin=1in, bmargin=1in,
                lmargin=1.5in, rmargin=1in,
                nohead]{geometry}
\RequirePackage{setspace}
\RequirePackage{titlesec}
\RequirePackage{ifthen}
\RequirePackage{array}      % >{...} column specifiers

%% ---------------------------------------------------------------------
%%  Spacing
%% ---------------------------------------------------------------------
%
% Cal Poly requires double-spaced body text. We use setspace's true
% \doublespacing rather than the 1.37x "pseudo double spacing" the
% original ucthesis class inherited from the typewriter era.

\doublespacing

% Paragraph indent and skip. The legacy template put these in the user
% preamble; they are formatting requirements and belong in the class.
\setlength{\parindent}{0.25in}
\setlength{\parskip}{6pt}

% Cal Poly footnote rule: footnotes are single-spaced internally with
% one blank line between successive footnotes. The default \footnotesep
% is too tight for that. Widen it to one full body baselineskip (minus
% the strut depth) so a blank line separates footnotes regardless of
% the body line spacing.
\AtBeginDocument{%
    \newlength{\cp@footnotesep}%
    \setlength{\cp@footnotesep}{\baselineskip}%
    \addtolength{\cp@footnotesep}{-\footnotesep}%
    \setlength{\footnotesep}{\cp@footnotesep}%
}

%% ---------------------------------------------------------------------
%%  Sectioning
%% ---------------------------------------------------------------------

\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}

% Number equations, figures, and tables by chapter.
\@addtoreset{equation}{chapter}
\renewcommand{\theequation}{\thechapter.\arabic{equation}}

% Cal Poly: chapter and section headings should be the same font size
% as body text (no \Huge/\LARGE/\bfseries chapter banners). Render
% chapter titles as "CHAPTER N" centered above the title in normal size,
% and prepend a one-shot "APPENDICES" header above the first appendix
% (which the appendix package numbers as A).
\titleformat{\chapter}[display]
    {\normalfont\normalsize\centering}
    {\ifthenelse{\equal{\thechapter}{A}}{APPENDICES\\[4.3ex]}{}%
     \chaptertitlename\ \thechapter}
    {0pt}{\normalsize\uppercase}
\titlespacing*{\chapter}{0pt}{-20pt}{4.3ex plus .2ex}
\titleformat*{\section}{\normalsize\bfseries}
\titleformat*{\subsection}{\small\bfseries}
\titleformat*{\subsubsection}{\small\bfseries}
\titleformat*{\paragraph}{\small\bfseries}
\titleformat*{\subparagraph}{\small\bfseries}

% Rename the front matter headings to match Cal Poly conventions.
\renewcommand{\contentsname}{TABLE OF CONTENTS}
\renewcommand{\listfigurename}{LIST OF FIGURES}
\renewcommand{\listtablename}{LIST OF TABLES}
\renewcommand{\bibname}{BIBLIOGRAPHY}

%% ---------------------------------------------------------------------
%%  Front matter declarations
%% ---------------------------------------------------------------------
%
% \title{...} and \author{...} come from standard LaTeX. The macros
% below cover everything else needed by the title, copyright, and
% committee membership pages.

% Month and year the degree will be conferred.
\newcommand{\@graduationmonth}{}
\newcommand{\@graduationyear}{}
\newcommand{\graduationmonth}[1]{\renewcommand{\@graduationmonth}{#1}}
\newcommand{\graduationyear}[1]{\renewcommand{\@graduationyear}{#1}}

% Full unabbreviated name of the degree (e.g. "Master of Science").
\newcommand{\@degree}{}
\newcommand{\degree}[1]{\renewcommand{\@degree}{#1}}

% Field/program of study (e.g. "Statistics").
\newcommand{\@program}{}
\newcommand{\program}[1]{\renewcommand{\@program}{#1}}

% Cal Poly campus name. Defaults to San Luis Obispo.
\newcommand{\@campus}{San Luis Obispo}
\newcommand{\campus}[1]{\renewcommand{\@campus}{#1}}

% Committee. \committeechair sets the chair (one only). \committeemember
% can be called any number of times to add additional members in the
% order they will appear on the committee membership page.
\newcommand{\@committeechair}{}
\newcommand{\cp@committeerows}{}
\newcommand{\committeechair}[1]{\renewcommand{\@committeechair}{#1}}
\newcommand{\committeemember}[1]{%
    \g@addto@macro\cp@committeerows{COMMITTEE MEMBER: & #1 \\[1.5ex]}%
}

%% ---------------------------------------------------------------------
%%  Title page
%% ---------------------------------------------------------------------

\renewcommand{\maketitle}{%
    \begin{titlepage}
        \thispagestyle{empty}
        \setcounter{page}{1}
        \begin{singlespace}
        \begin{center}
            {\setstretch{2}\MakeUppercase{\@title}\par}
            \vspace{1in}

            A Thesis \\
            presented to \\
            the Faculty of California Polytechnic State University, \\
            \@campus

            \vspace{1.2in}

            In Partial Fulfillment \\
            of the Requirements for the Degree \\
            \@degree~in~\@program

            \vspace{0.65in}

            by \\
            \@author \\
            \@graduationmonth~\@graduationyear
        \end{center}
        \end{singlespace}
    \end{titlepage}
    \setcounter{footnote}{0}
}

%% ---------------------------------------------------------------------
%%  Copyright page
%% ---------------------------------------------------------------------

\newcommand{\copyrightpage}{%
    \clearpage
    \thispagestyle{empty}
    \begin{singlespace}
    \vspace*{7in}
    \begin{center}
        \copyright~\@graduationyear\\
        \@author\\
        ALL RIGHTS RESERVED
    \end{center}
    \end{singlespace}
}

%% ---------------------------------------------------------------------
%%  Committee membership page
%% ---------------------------------------------------------------------

\newcommand{\committeemembershippage}{%
    \clearpage
    \thispagestyle{empty}
    \begin{singlespace}
    \begin{center}
        COMMITTEE MEMBERSHIP
    \end{center}
    \vspace*{0.5in}
    \begin{tabular}{r >{\raggedright\arraybackslash}p{3.01in}}
        TITLE:           & \@title                                     \\[1.5ex]
        AUTHOR:          & \@author                                    \\[1.5ex]
        DATE SUBMITTED:  & \@graduationmonth~\@graduationyear          \\[3ex]
        COMMITTEE CHAIR: & \@committeechair                            \\[1.5ex]
        \cp@committeerows
    \end{tabular}
    \end{singlespace}
}

%% ---------------------------------------------------------------------
%%  Abstract environment
%% ---------------------------------------------------------------------
%
% Renders an "ABSTRACT / <title> / <author>" header centered, then sets
% the abstract body. \keywords{...} can be used at the end of the
% abstract to attach the required keyword list.

\renewenvironment{abstract}{%
    \clearpage
    \thispagestyle{plain}
    \begin{center}
        ABSTRACT \par
        \@title \par
        \vspace{0.1in}
        \@author
    \end{center}
    \par
}{%
    \par
}

\providecommand{\keywords}[1]{\par\noindent\textbf{\textit{Keywords:}}~#1}

%% ---------------------------------------------------------------------
%%  Acknowledgements environment
%% ---------------------------------------------------------------------

\newenvironment{acknowledgements}{%
    \clearpage
    \thispagestyle{plain}
    \begin{center}
        ACKNOWLEDGEMENTS
    \end{center}
    \par
}{%
    \par
}

%% ---------------------------------------------------------------------
%%  Front matter wrapper
%% ---------------------------------------------------------------------
%
% Use \begin{frontmatter} ... \end{frontmatter} to wrap everything
% between the title page and the body of the thesis. The environment
% switches page numbering to lowercase roman starting at ii (the title
% page is the unnumbered i) and reverts to arabic numerals starting at
% 1 when it ends.

\newenvironment{frontmatter}{%
    \pagenumbering{roman}%
    \setcounter{page}{2}%
    \pagestyle{plain}%
}{%
    \clearpage
    \pagenumbering{arabic}%
    \setcounter{page}{1}%
    \pagestyle{plain}%
}

%% ---------------------------------------------------------------------
%%  TOC, LOF, LOT
%% ---------------------------------------------------------------------
%
% The standard \tableofcontents does not list itself. We mirror the
% legacy ucthesis behavior of having \listoffigures and \listoftables
% appear in the table of contents, and of including the bibliography
% chapter in the TOC.

\let\cp@orig@listoffigures\listoffigures
\renewcommand{\listoffigures}{%
    \cp@orig@listoffigures
    \addcontentsline{toc}{chapter}{\listfigurename}%
    \addtocontents{lof}{\protect\hbox to \linewidth{\hspace*{1.5em}Figure\hfill Page}}%
}

\let\cp@orig@listoftables\listoftables
\renewcommand{\listoftables}{%
    \cp@orig@listoftables
    \addcontentsline{toc}{chapter}{\listtablename}%
    \addtocontents{lot}{\protect\hbox to \linewidth{\hspace*{1.5em}Table\hfill Page}}%
}

% Add a "Page" header to the right side of the TOC. We have to inject
% it on first \tableofcontents call, since the .toc file is being
% written at that moment.
\let\cp@orig@tableofcontents\tableofcontents
\renewcommand{\tableofcontents}{%
    \cp@orig@tableofcontents
    \addtocontents{toc}{\protect\hbox to \linewidth{\hfill Page}}%
}

% (Single-spacing of the TOC/LOF/LOT entries themselves is left to the
%  body line spacing. Cal Poly accepts double-spaced front matter
%  lists. If single-spaced lists are desired, the cleanest approach is
%  to switch \singlespacing on around the \tableofcontents call in the
%  document, since wrapping the TOC call in a list-bearing environment
%  here breaks any \addtocontents{toc}{...} text the user inserts.)

% \tocsubheading{TEXT} writes a flush-left, unnumbered heading line
% into the table of contents. This is the recommended way to insert
% the "CHAPTERS" and "APPENDICES" group headings the Cal Poly editor
% expects between the LOF/LOT and the body chapters, and again before
% the appendices.
%
% The wrapper exists because the obvious construction
%   \addtocontents{toc}{\noindent TEXT}
% leaves LaTeX in horizontal mode and trips up the next \contentsline,
% which calls \vskip in \l@chapter.
\newcommand{\tocsubheading}[1]{%
    \addtocontents{toc}{\protect\par\protect\noindent #1\protect\par}%
}

% \appendixtocformat switches the TOC formatter so that any \chapter
% entries written after this point are rendered with a section-level
% indent. This is the style Cal Poly typically wants for appendices
% that live below an "APPENDICES" group heading. Call once between the
% bibliography and the appendices, and (if you also want the appendix
% chapters dotted with section indentation) call \tocsubheading after.
\newcommand{\appendixtocformat}{%
    \addtocontents{toc}{\protect\let\protect\l@chapter\protect\l@section}%
}

\endinput
