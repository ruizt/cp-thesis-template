# Cal Poly Thesis Template

A LaTeX template for theses submitted to the Cal Poly Office of Graduate
Education, targeting the 2022–2023 Grad Ed M.S. thesis formatting
guidelines. The template is intentionally small: it consists of a
single class file (`cpthesis.cls`) layered on top of LaTeX's standard
`report` class, plus an example driver document (`main.tex`) that
exercises every feature.

## Repository contents

| File | Purpose |
|---|---|
| `cpthesis.cls` | The Cal Poly thesis document class. |
| `main.tex` | Example/starter thesis. Edit in place. |
| `refs.bib` | Example BibTeX database illustrating common entry types. |
| `img/` | Image assets used by the example (replace with your own). |

## Quick start

Local build (TeX Live or MacTeX):

```
pdflatex main
bibtex   main
pdflatex main
pdflatex main
```

Or simply open `main.tex` in Overleaf and compile. The first build
produces front matter, TOC/LOT/LOF, body chapters, bibliography, and
appendices in a single 12pt, single-sided, double-spaced PDF that
matches Cal Poly's submission requirements.

## Front-matter API

The class adds a small set of declaration commands. Call each one in
the document body before `\maketitle`. Order does not matter; values
are stored and emitted later by the page-generating commands.

```latex
\title{Thesis Title in Title Case}
\author{Your Name}
\degree{Master of Science}
\program{Statistics}
\graduationmonth{June}
\graduationyear{2026}
\campus{San Luis Obispo}
\committeechair{Prof. Chair \linebreak Title and department}
\committeemember{Prof. Two   \linebreak Title and department}
\committeemember{Prof. Three \linebreak Title and department}
```

`\committeemember` is repeatable; call it once for each non-chair
committee member, in the order you want them listed. Use `\linebreak`
inside any committee entry to break a line within the right-hand cell.

## Document skeleton

```latex
\documentclass{cpthesis}
% your usepackages here

\begin{document}
% front-matter declarations (see above)

\maketitle                      % title page

\begin{frontmatter}             % roman page numbers, double-spaced
  \copyrightpage
  \committeemembershippage

  \begin{abstract}
    ...
    \keywords{kw1, kw2}
  \end{abstract}

  \begin{acknowledgements}
    ...
  \end{acknowledgements}

  \tableofcontents
  \listoftables
  \listoffigures
  \tocsubheading{CHAPTERS}      % adds the "CHAPTERS" divider in the TOC
\end{frontmatter}

\pagestyle{plain}
\chapter{...}                   % body chapters

\bibliography{refs}
\bibliographystyle{abbrvnat}

\appendixtocformat              % flatten appendix entries in the TOC
\tocsubheading{APPENDICES}
\begin{appendices}
  \chapter{...}                 % first chapter inside `appendices`
                                % gets the "APPENDICES" prefix in the body
\end{appendices}
\end{document}
```

## What the class sets for you

You should not need to set any of these in your preamble; the class
already handles them per Cal Poly's requirements:

- 1.5 in left margin, 1 in top/right/bottom margins, letter paper
- 12pt body font, double-spaced
- 0.25 in first-line paragraph indent, 6pt parskip
- Chapter titles set in normal body size (not display-size), centered
- Equations numbered by chapter (1.1, 1.2, …, 2.1, …)
- Footnote separator widened to satisfy single-spaced-footnote rules
- TOC, LOT, and LOF each get a `Page` (or `Table` / `Figure`) header

If you need to deviate (e.g., different chapter font size, single-sided
vs. two-sided, etc.), edit `cpthesis.cls` directly. The whole class is
short and commented; everything is in one place.

## Customization tips

- Add packages in your `main.tex` preamble as needed (theorem
  environments, `tikz`, `algorithm2e`, `booktabs`, etc.). The class is
  deliberately minimal and does not preload anything you might want to
  swap.
- Use `hyperref` (already loaded in `main.tex`) and `cleveref` for
  cross-references; the class is compatible with both.
- The bibliography is configured in `main.tex` (not in the class), so
  you can change `\bibliographystyle` freely without touching the
  class.

## Drafting tips

A few things that aren't obvious from the LaTeX source alone:

- **Captions.** Figure captions go *below* the figure; table captions
  go *above* the table. The example in `main.tex` shows both.
- **Equation numbering.** Equations are numbered by chapter
  automatically (1.1, 1.2, …, 2.1, …). Number only those equations you
  actually cross-reference, and reach for `equation*` for the rest.
- **Sectioning depth.** The class numbers `\section` /
  `\subsection` / `\subsubsection` (depth 3) but lists only the first
  two in the table of contents. Avoid unnumbered starred sections if
  you intend to cross-reference them.
- **Tables from R.** `xtable::xtable(df)` writes a LaTeX `tabular` for
  any data frame; combined with the `clipr` package it makes table
  generation painless. Inspect the output before pasting—`xtable`
  emits a complete `tabular` block, but you usually want only the
  rows.
- **BibTeX entries.** `refs.bib` contains worked examples of the
  common entry types (article, book, incollection, Manual, misc).
  Google Scholar will generate entries automatically; review them for
  consistent capitalization and missing fields before committing.
- **Final pass.** Always run a final draft past the Cal Poly thesis
  editor before submission. The Grad Ed Office revises the
  formatting requirements periodically and a template that passed
  last year may need small tweaks this year.

## History and attribution

Earlier versions of this repository used a Cal Poly–patched copy of
`ucthesis.cls`. That file had accumulated layered modifications going
back to the late 1980s. Approximate provenance of the predecessor
class:

- **Ethan V. Munson** — original UCTHESIS for UC dissertations
  (LaTeX 2.09, late 1980s; `report.sty`-based)
- **Blaise B. Frederick** (LBL) — direct port of UCTHESIS v2.7 to
  LaTeX2e as `ucthesis.cls` v3.0, October 1994
- **Chris Martin** and **John T. Whelan** — UCSB modifications, 1996
- **Ashish Singhal** — `\makecaption` adjustments, October 2000
- **Mark Barry** (Cal Poly) — Cal Poly title page, copyright page, and
  copyright-year handling, February 2007
- **Andrew Tsui** (Cal Poly) — committee membership page; copyright
  page updates for digital submission, June 2009

The current `cpthesis.cls` is a clean reimplementation written from
scratch on top of the standard `report` class. None of the historical
UC class code is retained verbatim — the rewrite drops UC-specific
front matter, dual-sided handling, and the custom size files
(`uct1[012].clo`) in favor of `report`'s built-in primitives plus
small additions (`geometry`, `setspace`, `titlesec`, `array`) for the
Cal Poly–specific layout. The reimplementation is the work of
**Trevor Ruiz** (Cal Poly Statistics), 2026, with assistance from
Anthropic's Claude. The earlier names are listed because their work
shaped the prior versions of this template that this repository
descends from, and their contributions are gratefully acknowledged.

## License

`cpthesis.cls` (the new class) is released into the public domain by
the author. Do whatever you like with it; no warranty.

The historical attributions above describe the predecessor class that
was previously distributed in this repository. Munson's original
UCTHESIS class did not carry an explicit license; users of any
remaining derivative work should consult the relevant upstream
sources.

## Notes

Always run a final draft past the Cal Poly thesis editor before
submission. Formatting requirements are revised periodically, and a
template that passed last year may need small tweaks this year.
