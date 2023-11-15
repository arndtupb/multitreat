## Extend the TRR 266 Template for Reproducible Empirical Accounting Research to Multiple Coding Languages

This repository extends [**trr266/treat**](https://github.com/trr266/treat) to multiple coding languages. In particular, **code/stata** contains .**do-files** for conducting reproducible accounting research with Stata. It is showcased how to download data from Compustat via WRDS (using Stata 18 under Windows) & how to implement a commonly employed research design when observing an (hypothetical) staggered adoption of a treatment among (randomly selected) firms. **doc** contains a **Quarto Markdown file** (stata_paper.qmd) that ties the output from Stata to a scientific paper. You can use the .qmd-file as template for any of your upcoming paper projects.

### How to Build

-   **Makefile**: The latest update to the code includes a .make-file that executes the analysis and compiles the paper: as this is work in progress, any reports on bugs are greatly appreciated!

-   Build "by hand" using **Stata 18**: The software is developed under **Windows** and requires a Windows environment to run successfully (the minimum requirement of Stata is its version 17).

    -   **Working Directory**: I suggest that you copy the path to the repository ["C:\\....\\multitreat"] on your local drive to **01_setup_build.do**. Otherwise, the code will respectively run in case you opened the .dofile with a double click (Stata neither knows project-files nor where .dofiles are stored).

    -   **Packages**: You will need to install some of the many excellent user written packages for Stata. These packages (and the way of how to install them from ssc) are highlighted at the first lines of **01_setup_build.do** but will not run automatically.

    -   Access to data from **WRDS** requires a user account and a (institutional) subscription to the Compustat database. Enter your **user credentials** to **config.csv**. Note that config.csv is included in .gitignore, so that your confidential data are excluded from being pushed to the repository. Never push credentials to GitHub (there is no way to undo this!). Also, note that WRDS introduced 2FA: you will receive a push notification to permit the code to execute. 

    -   Access to WRDS requires Stata 17/18 & a **JBDC driver**, which you must install separately. Please refer to 02_connect_wrds.do or **01_setup_build.do** for further information.

-   **Quarto**: You can knit the .qmd-file from doc (**paper_stata.qmd**) once you carried out the analyses at code/stata (alternatively, the .make-file does this for you right away). 

### Issues

This all comes on top from what you already know from trr266/treat. Please refer to this repository for further details! However, please note that this repository is work in progress:

-   A Stata-specific MAKE file is in need of being written; current work-around: fake it! running 01_setup_build.do will source all .dofiles (irrespective of changes!).

-   For additional issues, see [Issues](https://github.com/arndtupb/multitreat/issues)!

### Licensing

This repository is licensed to you under the MIT license, essentially meaning that you can do whatever you want with it as long as you give credit to us when you use substantial portions of it. What 'substantial' means is not trivial for a template. Here is our understanding. If you 'only' use the workflow, the structure and let's say parts of the Makefile and/or the README sections that describe these aspects, we do not consider this as 'substantial' and you do not need to credit us. If, however, you decide to reuse a significant part of the example code, for example the code pulling data from WRDS, we think that giving credit would be appropriate.

In any case, we would love to see you spreading the word by adding a statement like

    This repository was built based on the ['treat' template for reproducible research](https://github.com/trr266/treat) and the ['multitreat' extension](https://github.com/arndtupb/multitreat).

to your README file. But this is not a legal requirement but a favor that we ask.

### References

These are some very helpful texts discussing collaborative workflows for scientific computing:

-   Christensen, Freese and Miguel (2019): Transparent and Reproducible Social Science Research, Chapter 11: <https://www.ucpress.edu/book/9780520296954/transparent-and-reproducible-social-science-research>
-   Gentzkow and Shapiro (2014): Code and data for the social sciences: a practitioner’s guide, <https://web.stanford.edu/~gentzkow/research/CodeAndData.pdf>
-   Wilson, Bryan, Cranston, Kitzes, Nederbragt and Teal (2017): Good enough practices in scientific computing, PLOS Computational Biology 13(6): 1-20, <https://doi.org/10.1371/journal.pcbi.1005510>
