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
\ProvidesClass{cpthesis}[2026/05/03 v1.1 Cal Poly thesis class]

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
    % Cal Poly Bibliography rule: "Links to sources are not underlined
    % (remove hyperlinks)." If the user loaded hyperref, suppress all
    % link-box decorations so URLs and cross-references render as plain
    % text in the printed PDF.
    \@ifpackageloaded{hyperref}{%
        \hypersetup{
            linkbordercolor={1 1 1},
            urlbordercolor={1 1 1},
            citebordercolor={1 1 1},
            pdfborder={0 0 0}
        }%
    }{}%
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
%%  Preliminary-page heading helper
%% ---------------------------------------------------------------------
%
% Cal Poly requires every preliminary-page heading (COMMITTEE
% MEMBERSHIP, ABSTRACT, ACKNOWLEDGMENTS, TABLE OF CONTENTS, LIST OF
% TABLES, LIST OF FIGURES) to be centered "two inches from the top of
% the page" (Guidelines, Preliminaries section). Top margin is 1", so
% we add an additional 1" of vertical space before the heading.
% Headings render in normal size, no bold/italic/underline.

% Cal Poly Preliminaries rule (Guidelines, p. 9):
%   "Page headings should appear in all capital letters and be of the
%    same size font. They should be centered at the top of the page,
%    two inches from the top of the page."
% We render the heading in singlespace so multi-line headings
% (e.g. ABSTRACT / Title / Author on the abstract page) sit tight, and
% size the leading vspace so the top of the glyphs lands very near 2".
\newcommand{\cp@prelimheading}[1]{%
    \begin{singlespace}%
    \vspace*{0.6in}%
    \begin{center}#1\end{center}%
    \end{singlespace}%
    \vspace{1ex}%
}

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
    \g@addto@macro\cp@committeerows{COMMITTEE MEMBER: & #1 \\[3ex]}%
}

%% ---------------------------------------------------------------------
%%  Title page  (page i, counted but NOT numbered)
%% ---------------------------------------------------------------------
%
% Pagination starts here in lower-case roman. The titlepage env sets
% \thispagestyle{empty} so the i is never printed; the page is still
% counted. Subsequent prelim pages then naturally appear as ii, iii,
% iv, etc. without us touching the counter.

\renewcommand{\maketitle}{%
    \pagenumbering{roman}%
    \begin{titlepage}
        \thispagestyle{empty}
        \begin{singlespace}
        \begin{center}
            {\setstretch{2}\MakeUppercase{\@title}\par}
            \vspace{1.5in}

            A Thesis \\
            presented to \\
            the Faculty of California Polytechnic State University, \\
            \@campus

            \vspace{1.5in}

            In Partial Fulfillment \\
            of the Requirements for the Degree \\
            \@degree~in~\@program

            \vspace{1.5in}

            by \\
            \@author \\
            \@graduationmonth~\@graduationyear
        \end{center}
        \end{singlespace}
    \end{titlepage}
    \setcounter{footnote}{0}%
    % titlepage env resets the counter to 1 on its way out (oneside);
    % undo that so the next prelim page starts at ii.
    \setcounter{page}{2}%
}

%% ---------------------------------------------------------------------
%%  Copyright page  (page ii, numbered)
%% ---------------------------------------------------------------------
%
% Note: \thispagestyle{plain} (not empty) so the bottom-center page
% number ii prints, per Cal Poly Preliminary Page Numbering rule.

\newcommand{\copyrightpage}{%
    \clearpage
    \thispagestyle{plain}%
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
%%  Committee membership page  (page iii, numbered)
%% ---------------------------------------------------------------------

\newcommand{\committeemembershippage}{%
    \clearpage
    \thispagestyle{plain}%
    \begin{singlespace}
    \cp@prelimheading{COMMITTEE MEMBERSHIP}
    \vspace{0.4in}
    \begin{tabular}{r >{\raggedright\arraybackslash}p{3.01in}}
        TITLE:           & \@title                                     \\[3ex]
        AUTHOR:          & \@author                                    \\[3ex]
        DATE SUBMITTED:  & \@graduationmonth~\@graduationyear          \\[6ex]
        COMMITTEE CHAIR: & \@committeechair                            \\[3ex]
        \cp@committeerows
    \end{tabular}
    \end{singlespace}
}

%% ---------------------------------------------------------------------
%%  Abstract environment  (page iv, numbered)
%% ---------------------------------------------------------------------
%
% Renders an "ABSTRACT / <title> / <author>" header centered, then sets
% the abstract body. \keywords{...} can be used at the end of the
% abstract to attach the required keyword list. Title and author render
% in title case (NOT all caps) per Cal Poly checklist.

\renewenvironment{abstract}{%
    \clearpage
    \thispagestyle{plain}%
    \cp@prelimheading{ABSTRACT \\ \@title \\ \@author}
    \par
}{%
    \par
}

% "Keywords:" line. Plain text (no bold/italic) per the rule that
% preliminary pages cannot use bold-face, italic, or underlined font.
\providecommand{\keywords}[1]{\par\noindent Keywords:~#1}

%% ---------------------------------------------------------------------
%%  Acknowledgments environment  (page v, numbered, optional)
%% ---------------------------------------------------------------------
%
% Cal Poly spelling: ACKNOWLEDGMENTS (no first 'E'). Both the
% environment name and the alias remain `acknowledgements' for legacy
% compatibility, but the rendered heading uses the Cal Poly spelling.

\newenvironment{acknowledgements}{%
    \clearpage
    \thispagestyle{plain}%
    \cp@prelimheading{ACKNOWLEDGMENTS}
    \par
}{%
    \par
}
\let\acknowledgments\acknowledgements
\let\endacknowledgments\endacknowledgements

%% ---------------------------------------------------------------------
%%  Front matter wrapper
%% ---------------------------------------------------------------------
%
% Use \begin{frontmatter} ... \end{frontmatter} to wrap everything
% between the title page and the body. Pagination state was already
% switched to roman by \maketitle; this env just enables the plain
% page style (so numbers print) and reverts to arabic numerals at the
% end so chapter 1 starts on arabic page 1.

\newenvironment{frontmatter}{%
    \pagestyle{plain}%
}{%
    \clearpage
    \pagenumbering{arabic}%
    \pagestyle{plain}%
}

%% ---------------------------------------------------------------------
%%  TOC, LOF, LOT
%% ---------------------------------------------------------------------
%
% We provide our own implementations rather than calling
% \cp@orig@tableofcontents because the standard implementation routes
% through \chapter*, which then uses titlesec's chapter spacing and
% can't be coaxed into the "two inches from top" rule without
% wholesale state-juggling. Building the heading directly via
% \cp@prelimheading is cleaner.

\renewcommand{\tableofcontents}{%
    \clearpage
    \thispagestyle{plain}%
    \cp@prelimheading{\contentsname}%
    \@starttoc{toc}%
    \addtocontents{toc}{\protect\hbox to \linewidth{\hfill Page}}%
}

\renewcommand{\listoftables}{%
    \clearpage
    \thispagestyle{plain}%
    \cp@prelimheading{\listtablename}%
    \addcontentsline{toc}{chapter}{\listtablename}%
    \@starttoc{lot}%
    \addtocontents{lot}{\protect\hbox to \linewidth{Table\hfill Page}}%
}

\renewcommand{\listoffigures}{%
    \clearpage
    \thispagestyle{plain}%
    \cp@prelimheading{\listfigurename}%
    \addcontentsline{toc}{chapter}{\listfigurename}%
    \@starttoc{lof}%
    \addtocontents{lof}{\protect\hbox to \linewidth{Figure\hfill Page}}%
}

% Chapter entries in the TOC. Cal Poly forbids bold-face on prelim
% pages, so we strip the \bfseries from the standard \l@chapter and
% add dotted leaders so entries read "1. INTRODUCTION ........ 1" as
% in Sample F of the guidelines.
\renewcommand*{\l@chapter}[2]{%
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip 1.0em \@plus\p@
        \begingroup
            \renewcommand*{\numberline}[1]{##1.\hspace{0.75em}}%
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode
            #1\nobreak
            \leaders\hbox{$\m@th
                \mkern \@dotsep mu\hbox{.}\mkern \@dotsep mu$}\hfill
            \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}

% \tocsubheading{TEXT} writes a flush-left, unnumbered heading line
% into the table of contents. Used to insert "CHAPTER" and "APPENDICES"
% group dividers between the LOF/LOT and the body chapters, and again
% before the appendices.
\newcommand{\tocsubheading}[1]{%
    \addtocontents{toc}{\protect\par\protect\noindent #1\protect\par}%
}

% \appendixtocformat switches the TOC formatter so that any \chapter
% entries written after this point are rendered with section-level
% indent (Cal Poly Sample F shows "A. Cover Letter" indented under the
% APPENDICES heading). Call once between the bibliography and the
% appendices.
\newcommand{\appendixtocformat}{%
    \addtocontents{toc}{\protect\let\protect\l@chapter\protect\l@section}%
}

\endinput
