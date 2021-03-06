# Author: Robb Matzke <matzke@llnl.gov>
#
# Purpose:
#     Mkdoc::Note is a specialization of Mkdoc::Docbase for dealing with "post-it" notes in the
#     documentation.
#
# Copyright(C) 1999 The Regents of the University of California.
#     This work  was produced, in  part, at the  University of California, Lawrence Livermore National
#     Laboratory    (UC LLNL)  under    contract number   W-7405-ENG-48 (Contract    48)   between the
#     U.S. Department of Energy (DOE) and The Regents of the University of California (University) for
#     the  operation of UC LLNL.  Copyright  is reserved to  the University for purposes of controlled
#     dissemination, commercialization  through formal licensing, or other  disposition under terms of
#     Contract 48; DOE policies, regulations and orders; and U.S. statutes.  The rights of the Federal
#     Government  are reserved under  Contract 48 subject  to the restrictions agreed  upon by DOE and
#     University.
# 
# Copyright(C) 1999 Sandia Corporation.
#     Under terms of Contract DE-AC04-94AL85000, there is a non-exclusive license for use of this work
#     on behalf of the U.S. Government.  Export  of this program may require a license from the United
#     States Government.
# 
# Disclaimer:
#     This document was  prepared as an account of  work sponsored by an agency  of  the United States
#     Government. Neither the United States  Government nor the United States Department of Energy nor 
#     the  University  of  California  nor  Sandia  Corporation nor any  of their employees  makes any 
#     warranty, expressed  or  implied, or  assumes   any  legal liability  or responsibility  for the 
#     accuracy,  completeness,  or  usefulness  of  any  information, apparatus,  product,  or process 
#     disclosed,  or  represents that its  use would   not infringe  privately owned rights. Reference 
#     herein  to any  specific commercial  product,  process,  or  service by  trade  name, trademark, 
#     manufacturer,  or  otherwise,  does  not   necessarily  constitute  or  imply  its  endorsement, 
#     recommendation, or favoring by the  United States Government   or the University of  California.  
#     The views and opinions of authors expressed herein do not necessarily state  or reflect those of
#     the  United  States Government or  the   University of California   and shall  not be  used  for
#     advertising or product endorsement purposes.
# 
# Acknowledgements:
#     Robb P. Matzke              LLNL - Author of various tools
#     Mark C. Miller              LLNL - Alpha/Beta user; minor debugging/enhancements 
#     Matthew J. O'Brien          LLNL - Author of various tools
#     James F. Reus               LLNL - Alpha/Beta user
package Mkdoc::Section;
@ISA = qw/Mkdoc::Docbase/;

use strict;
use Carp;
use Mkdoc::Docbase;

sub new {
  my($pkg,%args) = @_;
  croak "no section name specified" unless exists $args{name};
  my($self) = bless \%args, $pkg;
  return $self->exists;
}

# Typeset a section
sub render {
  my($self,$output,$exrefs,@omit) = @_;
  my(@items);

  # Description
  my($desc) = $self->prologue->{Description} || "No description available.";
  push @items, $output->paragraph($output->context($self,$desc,undef,undef,$exrefs));

  # Complete chapter
  my($all) = $output->chapter($self,undef,@items);
  return $output->multi_output($self,$all);
}

1;
