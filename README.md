# SAF
This is the Sets and Fields (SAF, pronounced "safe") project.

This project was part of the
[Accelerated Strategic Computing Initiative's](https://www.ncbi.nlm.nih.gov/books/NBK44974/)
Data Models and Formats (ASCI-DMF) effort. Work on ASCI-DMF ceased in 2005.
Nonetheless, we are hosting the software and the documentation here for posterity's
sake. The software does indeed still build and run with current compilers and
versions of HDF5 (as of November, 2017). There are several example applications
to demonstrate the use of SAF as well.

The Sets and Fields library was and still is unique among scientific data libraries
in that it combines the aims of scalable, parallel I/O with mathematically rigorous
scientific data modeling principles. It aimes to be highly performant and highly general
in its ability to describe and store a variety of scientific data. In addition,
the implementation of SAF developed here employs a number of features of
[Smart Libraries](https://github.com/markcmiller86/SAF/blob/master/src/safapi/docs/necdc_2004_paper_30Nov04.pdf).

An introductory paper on the SAF data model can be found [here](src/safapi/docs/miller001.pdf)

[![Documentation Status](https://readthedocs.org/projects/sets-and-fields/badge/?version=latest)](http://sets-and-fields.readthedocs.io)

[**Full documentation**](http://sets-and-fields.readthedocs.io)
