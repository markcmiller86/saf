# Author: Mark C. Miller, 22Nov17
#
# Purpose:
#     Mkdoc::reST is a specialization of Mkdoc::Format for dealing with the generation of reStructured
#     text format.
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


package Mkdoc::reST;
@ISA = qw/Mkdoc::Format/;

use strict;
use Carp;
use Mkdoc::Format;

my($FigureDir) = ".";		# directory to find figures in

# Make a new html output context where $name is the name of the primary file.
sub new {
  my($pkg,$name,%init) = @_;
  $name .= ".rst" unless $name =~ /\.rst?$/;
  my($self) = bless {name=>$name}, $pkg;
  return $self->init(%init);
}

# HTML prologue
sub prologue {
  my($self,$mkdoc_url) = @_;
  local($_);

  my($bodytitle,$headtitle, $acktag);
  if ('ARRAY' eq ref $self->{title}) {
    $bodytitle = join "\n", @{$self->{title}};
    $headtitle = $self->{title}[0];
  }
  $headtitle ||= "Reference Manual\n";
  $bodytitle ||= $headtitle;

  $bodytitle =~ s/\n/ /g;

  if ($bodytitle =~ /Examples/) {
      $acktag = "examples";
  } elsif ($bodytitle =~ /API/) {
      $acktag = "safapi";
  } elsif ($bodytitle =~ /SSlib/) {
      $acktag = "sslib";
  }

  $_ .= "$bodytitle\n################\n";

  $_ .= ":ref:`Acknowledgements <acknowledgements_$acktag>`\n";

  my($ackfile) = $self->outdir . "/acknowledgements.rst";
  open OUTPUT, ">$ackfile" or croak "cannot open file $ackfile";

  print OUTPUT ".. _acknowledgements_$acktag:\n\n";
  print OUTPUT "Acknowledgements\n";
  print OUTPUT "================\n\n";

  print OUTPUT "\n**Developers**:\n\n";
  my($author);
  foreach $author (@{$self->{author}}) {
    print OUTPUT "* $author\n";
  }
  my($oldauthor);
  foreach $oldauthor (@{$self->{oldauthor}}) {
    print OUTPUT "* $oldauthor\n";
  }
  print OUTPUT "\n";

  print OUTPUT "\n**Acknowledgements**:\n\n";
  my($acknow);
  foreach $acknow (@{$self->{acknow}}) {
    print OUTPUT "* $acknow\n";
  }
  print OUTPUT "\n";

  my($copyright);
  foreach $copyright (@{$self->{copyright}}) {
    my($year,$owner,$rights) = split /\000/, $copyright;
    $rights ||= "All rights reserved.";

    print OUTPUT "Copyright $year. $owner.\n\n";
    $rights =~ s/\n\s*/\n/g;
    print OUTPUT $rights . "\n\n";
  }
  print OUTPUT "\n";

  if ($self->{disclaimer}) {
    print OUTPUT "\n**Disclaimer**:\n\n";
    my($disclaimer);
    foreach $disclaimer (@{$self->{disclaimer}}) {
      $disclaimer =~ s/\n\s*/\n/g;
      print OUTPUT "\n" . $self->context(undef,$disclaimer);
    }
  }
  print OUTPUT "\n";
  close OUTPUT;

  return $_;
}

# Special symbols
sub sym_section {""}

# Get/set multipart flag.
sub multipart {
  my($self,$set) = @_;
  $self->{multipart} = $set if @_>1;
  return $self->{multipart};
}

# Generate a target for a cross reference.  The $tag is the name of the target and is an
# object ID that consists of only letters, digits, and underscores.
sub target {
  my($self,$tag) = @_;
  return "\n.. _$tag\:\n";
}

# Generate a cross reference to some target.  Arguments are similar to `target' method.
sub xref {
  my($self,$tag,$text) = @_;
  my($retval);
  $text =~ s/^``(.*)``$/$1/; # strip off the ``code`` styling
  return ":ref:`$text <$tag>`";
}

# Generate a cross reference to some source file.
sub xref3 {
  my($self,$name,$title) = @_;
  $title ||= $self->file($name);
  return ":file:`$title $name`";
}

# Quote all typesetting special characters so they appear in the documentation.
sub escape {
  my($self,$tokref,$string) = @_;
  $string =~ s/([<>])/Mkdoc::Format::_toksave($tokref,$1 eq '<'?'&lt;':'&gt;')/eg;
  return $string;
}

# Typeset the string as code
sub code {
  my($self,$string) = @_;
  return "``$string``";
}

# Typeset a word as a variable (formal argument)
sub var {
  my($self,$name) = @_;
  return "``$name``";
}

# Typeset a string as italic.
sub italic {
  my($self,$string) = @_;
  return "*$string*";
}

# Typeset with emphasis
sub emph {
  my($self,$string) = @_;
  return "**$string**";
}

# Typeset as a file name
sub file {
  my($self,$name) = @_;
  return ":file:`$name`";
}

# Typeset a picture
sub figure {
  my($self,$name) = @_;

  $name =~ s/\s/_/g;

  my($n2home) = ($self->{figdir} || ".") . "/" . $name;
  my($n2here) = $self->outdir            . "/" . $name;

  # copy the image if it isn't already here 
  if (-f $n2home && -r _) {
    unless (-f $n2here) {
      system "cp", $n2home, $n2here;
      chmod 0644, $n2here;
    }
  }

  return ".. figure:: $name"
}

# Typeset a universal resource locator (URL). By default, $text will be the URL sans the leading
# protocol.
sub url {
  my($self,$url,$text) = @_;
  unless (defined $text) {
    $text = $url;
    $text =~ s/^((https|http|file|ftp|mailto):(\/\/)?)//;
  }
  return "`$text <$url>`_";
}

# Typeset an example. The code has to be on one line so that when this return value is indented by various other functions
# it doesn't mess up the indentation inside the code.  What happened before is that lines were emitted like this:
#
#    |<code><pre>    line 1
#    |    line 2</pre></code>
#
# which was later indented, perhaps inside a table body, to be
#
#    |  <code><pre>    line 1
#    |      line 2</pre></code>
#
# and would be rendered in a browser with `line 1' preceded still by four spaces but `line 2' by six spaces.
#
# Secondly, the entire sequence is contained in a 1x1 table in order to make left/right movements much easier -- you just move
# the table and don't worry about the individual lines of code.  Therefore, white space common to every line can be removed for
# more uniform output.
sub example {
  my($self,$curfunc,$s,$see_also,$exrefs,$lnums) = @_;

  # Remove whitespace that's common to every line.  Treat blank lines as an infinite amount of white space so they don't
  # interfere with the other lines' white space.  Tabs should already be expanded by now.
  my $prefix;
  for my $line (split /\n/, $s) {
    if ($line =~ /\S/) {
      my($ws) = $line =~ /^(\s*)/;
      $prefix = $ws if !defined($prefix) || length($ws)<length($prefix);
    }
  }
  $s =~ s/^$prefix//gm if length $prefix;

  # Build the output. All code on one line and in a 1x1 table per above.
  $s =~ s/^(.)/    \1/g;
  $s =~ s/\n/\n    /g;
  $s = "\n.. _SC_" . $curfunc->name .":\n\n.. code-block:: c\n   :linenos:\n\n$s\n";
  return $s;
}

# Switch foreground text color as specified ($color is optional)
sub color {
  my($self,$color,$string) = @_;
  return "*$string*";
}

# Join paragraphs together. Each paragraph except the first begins with `<p>' (we assume the caller is already in
# paragraph context, so the first paragraph will not start with `<p>').
#
# This function used to also surround any paragraph that starts with white space with "<pre><code>" in order to typeset
# it as code, but that functionality has been superseded with Mkdoc::Format::context(). --rpm 2003-08-26
sub para_join {
  my($self,@para) = @_;
  return join "\n\n",@para;
}

# Make a table
sub table {
  my($self,$format,@items) = @_;
  my(@fixed,@heads,@bodies);

  # Split the items into a list of heads and bodies.
  while (@items) {
    push @heads, shift @items;
    push @bodies, shift @items;
  }

  # Do various things to the heads
  if ($format eq 'b') {
    @heads = map {$self->emph($_)} @heads;
  } elsif ($format eq 'var') {
    @heads = map {$self->var($_)} @heads;
  } elsif ($format eq 'code') {
    @heads = map {$self->code($_)} @heads;
  }

  # If the bodies are all empty then the list looks better with less vertical space
  my $vsp = "\n" if grep /\S/, @bodies;

  # The innards of the table
  while (@heads) {
    my($head,$body) = (shift @heads, shift @bodies);
    my($vspace) = @fixed ? $vsp:"";
    if ($format eq 'bullet') {
      push @fixed, "* $head\n";
    } elsif ($format eq 'b') {
      push @fixed, "$vspace$head: $body\n";
    } elsif ($format eq 'var') {
      $body =~ s/\n/\n  /g;
      push @fixed, "* $head: $body\n";
    } elsif ($format eq 'code') {
      push @fixed, "$vspace$head: $body\n";
    } elsif ($format eq 'xref') {
      $head =~ s/``(.*)``/$1/g; # strip off the ``code`` styling
      $head =~ s/\*(.*)\*/$1/g; # strip off the *italics* styling
      $head =~ s/\*\*(.*)\*\*/$1/g; # strip off the **bold** styling
      push @fixed, "* $head: $body\n";
    } elsif ($format eq 'table') {
      push @fixed, "$vspace$head: $body\n";
    } else {
      croak "unknown table format: $format";
    }
  }

  # The table begin and end
  if ($format eq 'bullet') {
    unshift @fixed, "\n";
    push    @fixed, "\n";
  } elsif ($format eq 'table') {
    unshift @fixed, "\n\n";
    push    @fixed, "\n\n";
  } else {
    unshift @fixed, "\n";
    push    @fixed, "\n";
  }
  return join "\n", @fixed;
}

# Send $string to an auxiliary file.
sub multi_output {
  my($self,$object,$string,$basename) = @_;
  return $string unless $self->multipart;

  my($file) = $self->outdir . "/" . ($basename || $object->objid) . ".rst";
  my($title) = $object->name;
  my($class,$next,$prev,$up);

  # Navigation buttons.
  if ($basename =~ /^SC_/) {
    $class = "source";
    $next = $prev = undef;
    $up = $object;
  } else {
    $class = $object->class;
    $next = $object->next;
    $prev = $object->prev;
    $up   = $object->up;
  }

  open OUTPUT, ">$file" or croak "cannot open file: $file";
  print OUTPUT $string;
  close OUTPUT;
  return "";
}

# Wrap items into a chapter
sub chapter {
  my($self,$chapter,$title,@items) = @_;
  $title = $chapter->name unless defined $title;
  #$title = join ".  ", grep {$_ ne ""} $chapter->secnum, $title;
  my($level) = (scalar split /\D/, $chapter->secnum) || 1;
  my(@headers) = (
      "#########################################################################",
      "*************************************************************************",
      "=========================================================================",
      "-------------------------------------------------------------------------",
      "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^",
      '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'); 
  local($_);

  #$_ .= "<hr>\n" unless $self->multipart;
  $_ .= $self->target($chapter->objid) . "\n";
  $_ .= "$title\n$headers[$level]\n";
  if ($title =~ /Table of Contents/) {
      $_ .= "\n.. toctree::\n   :maxdepth: 1\n";
  }
  $_ .= join "\n\n", @items;
  return $_;
}

# Insert a table-of-contents entry.  We ignore the title (which is normally the same as what
# would be rendered by the $xref anyway).
sub do_toc_item {
  my($self,$object,$title,$class,$desc,$xref) = @_; #all required
  my($audience) = $object->prologue->{Audience} if grep {$class eq $_} qw/function macro symbol datatype/;

  $title =~ s/^``(.*)``$/$1/; # strip off the ``code`` styling
  $title =~ s/^\*(.*)\*$/$1/; # strip off the *italics* styling
  $title =~ s/^\*\*(.*)\*\*$/$1/; # strip off the **bold** styling
  $title =~ s/ /_/g if $class =~ /hapter/; # Change any spaces to underscores
  $audience .= " " if length $audience;

  my($xreftarget) = $xref;
  $xreftarget =~ s/:ref:`(.*) <(.*)_([0-9]*)>`$/$2_$3/;
  my($targfile) = $self->outdir . "/" . $xreftarget . ".rst";
  if (-e $targfile) {
      return "$title [$audience$class] <$xreftarget>";
  } else {
      return "$title [$audience$class] <$title>";
  }
}

# Wrap some table of contents items in a table of contents.
sub toc {
  my($self,$title,@entries) = @_;
  local($_);

#  $_ .= $self->emph($title) . "\n" if $title;
#  $_ .= "\n" . $title . "\n=======\n" if $title;
  $_ .= "\n" . $title . "\n=======\n.. toctree::\n   :maxdepth: 2\n" if $title;
  $_ .= "\n";
  $_ .= join "\n", map {my($s)=$_;$s=~s/^/  /mg;$s} @entries;
  return $_;
}

# Function prototype
sub proto {
  my($self,$function) = @_;
  my(@formals,$i) = $function->formals;
  local($_);
  
  $_ .= "\n\n.. c:";
  my($domtype) = $function->class;
  $domtype = "var" if ($domtype eq 'symbol');
  $_ .= $domtype . ":: " . $function->rettype . " " . $function->name;
  $_ .= "(" unless $function->class eq 'symbol';
  my($indent) = length($function->name)+($function->class eq 'symbol' ? 0 : 1);

  for ($i=0; $i<@formals; $i++) {
    my($formal) = $formals[$i];
    $_ .= ", " if $i;
    if (ref $formal) {
      my($type) = $formal->{type};
      $type =~ s/([a-z_A-Z]\w*)/Mkdoc::Type->exists($1) || Mkdoc::Function->exists($1)?$1:$1/eg;
#      $_ .= $type . $self->var($formal->{name}) . $self->{array};
      $_ .= $type . $formal->{name} . $self->{array};
    } else {
      $_ .= $formal; # wasn't parsed
    }
  }
  unless ($function->class eq 'symbol') {
    $_ .= "void" unless @formals;
    $_ .= ")";
  }
  $_ .= "\n";
  return $_;
}

# Create an entry for a permuted index
sub pindex_item {
  my($self,$object,$pre,$post) = @_;
  return "   $pre, $post, " . $self->xref($object->objid,$self->code($object->name)) . "\n";
}

# Wrap a permuted index around some entries
sub pindex {
  my($self,@entries) = @_;
  local($_);

  $_ .= ".. csv-table:: Permuted Index\n";
  $_ .= "   :header: \"Concept\", \"Key\", \"Reference\"\n";
  $_ .= "   :widths: 5, 3, 1\n";
  $_ .= "\n" . join("\n",@entries) . "\n";

  return $_;
}

# Create an entry for a concept index
sub cindex_item {
  my($self,$object,$text) = @_;
  return "   $text, " . $self->xref($object->objid,$self->code($object->name)) . "\n";
}

# Wrap a concept index around some entries
sub cindex {
  my($self,@entries) = @_;
  local($_);

  $_ .= ".. csv-table:: Concept Index\n";
  $_ .= "   :header: \"Concept\", \"Reference\"\n";
  $_ .= "   :widths: 3, 1\n";
  $_ .= "\n" . join("\n",@entries) . "\n";
  
  return $_;
}

1;
