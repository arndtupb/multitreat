## Extend the TRR 266 Template for Reproducible Empirical Accounting Research to Multiple Coding Languages 

This repository extends trr266/treat to multiple coding languages. In particular, code/stata contains .do-files for conducting reproducible accounting research with Stata. It is showcased how to download data from Compustat via WRDS (using Stata 17 under Windows) & how to implement a causal research design when facing an (hypothetical) staggered adoption of a treatment among (randomly selected) firms. doc contains a Quarto Markdown file (stata_paper.qmd) that ties the output from Stata to a scientific paper. You can use the .qmd-file for any of your upcoming paper projects.

This all comes on top from what you already know from trr266/treat. Please refer to this repository for further details! However, please note that this repository is work in progress. A Stata-specific MAKE file is in need of being written & therefore, you will have to run the .do-files manually (you could also consider the fake make part in 01_setup.do). Additionally, you will once need to copy your working directory into 01_setup.do. 

### Licensing

This repository is licensed to you under the MIT license, essentially meaning that you can do whatever you want with it as long as you give credit to us when you use substantial portions of it. What 'substantial' means is not trivial for a template. Here is our understanding. If you 'only' use the workflow, the structure and let's say parts of the Makefile and/or the README sections that describe these aspects, we do not consider this as 'substantial' and you do not need to credit us. If, however, you decide to reuse a significant part of the example code, for example the code pulling data from WRDS, we think that giving credit would be appropriate.

In any case, we would love to see you spreading the word by adding a statement like 

```
This repository was built based on the ['treat' template for reproducible research](https://github.com/trr266/treat).
```

to your README file. But this is not a legal requirement but a favor that we ask.


### References

These are some very helpful texts discussing collaborative workflows for scientific computing:

- Christensen, Freese and Miguel (2019): Transparent and Reproducible Social Science Research, Chapter 11: https://www.ucpress.edu/book/9780520296954/transparent-and-reproducible-social-science-research
- Gentzkow and Shapiro (2014): Code and data for the social sciences:
a practitioner’s guide, https://web.stanford.edu/~gentzkow/research/CodeAndData.pdf
- Wilson, Bryan, Cranston, Kitzes, Nederbragt and Teal (2017): Good enough practices in scientific computing, PLOS Computational Biology 13(6): 1-20, https://doi.org/10.1371/journal.pcbi.1005510


