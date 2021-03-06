# Author: Robb Matzke <matzke@llnl.gov>
#
# Purpose:
#     Mkdoc::Texi is a specialization of Mkdoc::Format for generating GNU TexInfo output.
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

package Mkdoc::Texi;
@ISA = qw/Mkdoc::Format/;

use strict;
use Carp;
use Mkdoc::Format;

# Make a new texi output context where $name is the name of the primary file.
sub new {
  my($pkg,$name,%init) = @_;
  $name .= ".texi" unless $name =~ /\.texi?$/;
  my($self) = bless {name=>$name}, $pkg;
  return $self->init(%init);
}

# Generate prologue
sub prologue {
  my($self,$mkdoc_url) = @_;
  local($_);

  my($title) = join ":  ", @{$self->{title}};
  $title ||= "Reference Manual";

  $_ .= "\\input texinfo\n";
  $_ .= "\@c %**start of header\n";
  $_ .= "\@setfilename refman.info\n";
  $_ .= "\@settitle $title\n";
  $_ .= "\@setchapternewpage odd\n";
  $_ .= "\@c %**end of header\n\n";

  $_ .= "\@titlepage\n";
  $_ .= "\@title " . (join "\n\@subtitle ", @{$self->{title}}) . "\n\n";
  $_ .= join "\n", map {"\@author $_"} @{$self->{author}};

  $_ .= "\n\n\@vskip 0pt plus 1filll\n";
  $_ .= "This document was generated from library source code by ";
  $_ .= $self->url($mkdoc_url,$self->code("mkdoc")) . ".\@*\n";
  $_ .= "DO NOT EDIT THIS FILE!\n";
  $_ .= "\@page\n";

  my($copyright);
  foreach $copyright (@{$self->{copyright}}) {
    my($year,$owner,$rights) = split /\000/, $copyright;
    $rights ||= "All rights reserved.";
    $rights =~ s/^[ \t]*//gm;
    $_ .= "\@table \@b\n";
    $_ .= "\@item Copyright \@copyright{} $year. $owner.\n";
    $_ .= $rights . "\n";
    $_ .= "\@end table\n";
  }

  if ($self->{disclaimer}) {
    $_ .= "\@table \@b\n";
    $_ .= "\@item Disclaimer\n";
    my($disclaimer);
    foreach $disclaimer (@{$self->{disclaimer}}) {
      $_ .= $self->context(undef,$disclaimer);
    }
    $_ .= "\n\@end table\n\n";
  }

  $_ .= "\@table \@b\n";
  $_ .= "\@item Warning\n";
  $_ .= "This document was generated from source code by ";
  $_ .= $self->url($mkdoc_url, $self->code("mkdoc")) . ". DO NOT EDIT THIS FILE!\n";
  $_ .= "\@end table\n\n";

  $_ .= "\@end titlepage\n";
  return $_;
}
    
# Generate a cross reference to some target.  Arguments are similar to `target' method.
sub xref {
  my($self,$tag,$text) = @_;
  return "\@xref{$tag}.";
}

# Generate a cross reference to some target, embedded in prose.  We turn this off for texinfo
# because it makes the examples too cluttered.
sub xref2 {
  my($self,$tag,$text) = @_;
  return $text || $tag;
}

# Quote all typesetting special characters so they appear in the documentation.
sub escape {
  my($self,$tokref,$string) = @_;
  $string =~ s/([@\{\}])/Mkdoc::Format::_toksave($tokref,"\@$1")/eg;
  return $string;
}

# Typeset the string as code.
sub code {
  my($self,$string) = @_;
  return "\@code{$string}";
}

# Typeset a word as a variable (formal argument)
sub var {
  my($self,$name) = @_;
  return "\@var{$name}";
}

# Typeset a string as italic.
sub italic {
  my($self,$string) = @_;
  return "\@i{$string}";
}

# Typeset with emphasis
sub emph {
  my($self,$string) = @_;
  return "\@b{$string}";
}

# Typeset as a file name
sub file {
  my($self,$name) = @_;
  return "\@file{$name}";
}

# Join paragraphs together. If a paragraph begins with white space then typeset it verbatim as
# code.
sub para_join {
  my($self,@para) = @_;
  my(@fixed_paragraph,$paragraph);
  foreach $paragraph (@para) {
    if ($paragraph =~ /^[ \t]/) {
      $paragraph = "\@example\n$paragraph\n\@end example";
    }
    push @fixed_paragraph, $paragraph;
  }
  return join "\n\n", grep /\S/, @para;
}

# Make a table
sub table {
  my($self,$format,@items) = @_;
  my(@fixed);

  my($beg,$end); #table delimiters
  if ($format eq 'bullet') {
    $beg = "\@itemize \@bullet";
    $end = "\@end itemize";
  } elsif ($format eq 'b') {
    $beg = "\@table \@b";
    $end = "\@end table";
  } elsif ($format eq 'var') {
    $beg = "\@table \@var";
    $end = "\@end table";
  } elsif ($format eq 'code') {
    $beg = "\@table \@code";
    $end = "\@end table";
  } elsif ($format eq 'xref') {
    $beg = "\@table \@code";
    $end = "\@end table";
  } elsif ($format eq 'table') {
    $beg = "\@table \@asis";
    $end = "\@end table";
  } else {
    croak "unknown table format: $format";
  }

  #table items
  while (@items) {
    my($head,$body) = (shift @items, shift @items);
    if ($format eq 'bullet') {
      push @fixed, "\@item $head";
    } else {
      push @fixed, "\@item $head\n$body";
    }
  }

  return join "\n", $beg, @fixed, $end;
}

# Wrap items into a chapter. We output just the chapter contents if we're talking about a table
# of contents.
sub chapter {
  my($self,$chapter,$title,@items) = @_;
  my($objid,$prev,$next,$up);
  my($level) = split(/\./, $chapter->secnum) || 1;
  local($_);

  $_ .= "\@c " . "#" x 95 . "\n";
  $_ .= "\@c " . "#" x 95 . "\n";

  if ($chapter->name eq 'Table of Contents') {
    $objid = "Top";
    $up = "(dir)";
  } else {
    $objid = $chapter->objid;
    $prev = $chapter->prev;
    $next = $chapter->next;
    $up   = $level==1 ? "Top" : $chapter->up->objid;
  }

  $_ .= "\@node ";
  $_ .= join(", ", $objid, $next?$next->objid:"", $prev?$prev->objid:"", $up) . "\n";
  $_ .= "\@" . (qw/chapter section subsection/)[$level-1] . " " . $chapter->name . "\n\n"
    unless $objid eq "Top";
  $_ .= join "\n\n", @items;
  return $_;
}

# Function prototype
sub proto {
  my($self,$function) = @_;
  my(@formals,$i) = $function->formals;
  my($class) = $function->class;
  local($_);

  $_ .= "\@deftypefn \u$class {" . $function->rettype . "} " . $function->name;
  $_ .= "(\@*" unless $class eq 'symbol';

  for ($i=0; $i<@formals; $i++) {
    my($formal) = $formals[$i];
    if (ref $formal) {
      $_ .= " " . $formal->{type} . $self->var($formal->{name}) . $formal->{array};
    } else {
      $_ .= " " . $formal; # wasn't parsed
    }
    $_ .= "\@*";
  }
  unless ($class eq 'symbol') {
    $_ .= "void\@*" unless @formals;
    $_ .= ")";
  }
  $_ .= "\n\@end deftypefn";
  return $_;
}

# Insert a table of contents entry. Actually, a TOC is generated automatically in Texinfo files, so
# we use this to generate the @menu in the `Top' node and each chapter.
sub do_toc_item {
  my($self,$object,$title,$class,$desc,$xref) = @_; #all required
  return sprintf ("* %-35s %s [%s]%s%s", $object->objid."::", $title, $class,
		  ($desc=~/^\S/?" ":""), $desc);
}

# Wrap some table of contents (menu) items in a table of contents (menu).  Since Texinfo doesn't
# support (or need) multi-level menus we remove all embedded menus.
sub toc {
  my($self,@entries) = @_;
  @entries = grep /\S/, @entries;       #remove empty items
  @entries = grep !/^\@menu/, @entries; #remove embedded menus
  return join "\n", "\@menu", @entries, "\@end menu" if @entries;
  return "";
}

1;
