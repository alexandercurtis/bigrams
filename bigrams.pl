#!/usr/bin/perl -w
# Alex Curtis
# 2nd December 2011

use strict;

print "Reads text from stdin and extracts the letter bigrams. Uses these to generate sentence-like output.\n";
print "Enter lots of prose and press Ctrl-D when finished.\n";

my %h;
my $nchars = 0;
while(my $line = <> )
{
  my $prev = "\n";
  $line =~ s/\s+$//;
  my @a = split(//,$line);
  foreach my $x (@a)
  {
    if( length $line > 0 )
    {
      if( !exists $h{$prev} )
      {
        $h{$prev} = {};
      }
      if( !exists $h{$prev}{$x} )
      {
        $h{$prev}{$x} = 0;
      }
      ++$h{$prev}{$x};
      ++$nchars;
      $prev = $x;
    }
  }
}

my %counts;
foreach my $u (sort keys %h)
{
  my $m = 0;
  foreach my $v (sort keys %{$h{$u}})
  {
    print "$u => $v : " . $h{$u}{$v} . "\n";
    $m += $h{$u}{$v};
  }
  $counts{$u} = $m;
  print "$m counts\n";
}


my $ochars = 2560; # num chars to generate
my $prev = "a"; # First char to start with

print $prev;
my $seendot = 0;
while( $ochars-- )
{
  my $count = 0;
  if( exists $counts{$prev} )
  {
    $count = $counts{$prev};
  }
  if( $count == 0 )
  {
    die "Oops! Somehow reached a letter from which I can't continue!\n";
  }
  my $l = int(rand($count));
  foreach my $v (sort keys %{$h{$prev}})
  {
    $l -= $h{$prev}{$v};
    if( $l < 0 )
    {
      if( $seendot and $v =~ /\w/ )
      {
        $seendot = 0;
        print uc $v;
      }
      else
      {
        print $v;
      }
      if( $v eq "." )
      {
        $seendot = 1;
      }

      $prev = $v;
      last;
    }
  }
}
print ".\n";
