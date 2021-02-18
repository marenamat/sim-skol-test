#!/usr/bin/perl

use common::sense;

my $sens = 0.9;
my $spec = 0.995;
my $class = 25;
my $real_pos = 0.025;
my $absenteers = 0.04;

my $total_people = 1500000;

my $total_rounds = 10;

my @quarantines = (0)x2;

my $quarantines_ok = 0;
my $quarantines_bad = 0;
my $quarantines_unseen = 0;
my $in_school = 0;

foreach my $round (0 .. $total_rounds) {
  my $total_quarantines = 0;
  foreach my $q (@quarantines) {
    $total_quarantines += $q;
  }

  my ($cnt, $abs, $pos, $neg, $fpos, $fneg) = (0)x6;
  my $qu_this_round;

  foreach my $person (0 .. ($total_people - $total_quarantines*$class)) {
    # Is not present anyway.
    if ($absenteers > rand) {
      $abs++;
    }

    # Positive or negative?
    elsif ($real_pos > rand) {
      # Get positive result according to sensitivity
      if ($sens > rand) {
	$pos++;
      }
      else {
	$fpos++;
      }
    }
    else {
      # Get negative result according to specificity
      if ($spec > rand) {
	$neg++;
      }
      else {
	$fneg++;
      }
    }

    next if ++$cnt < 25;

#    say "$abs $pos $fpos $neg $fneg";

    # If positive, quarantine is OK
    if ($pos > 0) {
      $quarantines_ok++;
      $qu_this_round++;
    }
    # If a false positive test is matched by a false negative
    # quarantine is OK
    elsif (($fpos > 0) and ($fneg > 0)) {
      $quarantines_ok++;
      $qu_this_round++;
    }
    # Only false positives and true negatives
    elsif ($fpos > 0) {
      $quarantines_bad++;
      $qu_this_round++;
    }
    # Only false negatives and true negatives
    elsif ($fneg > 0) {
      $quarantines_unseen++;
    }
    # Consistency check
    elsif ($neg + $abs == 25) {
      $in_school++;
    }
    else {
      die "Strange numbers: $pos, $fpos, $neg, $fneg, $abs";
    }

    ($cnt, $abs, $pos, $neg, $fpos, $fneg) = (0)x6;
  }

  push @quarantines, $qu_this_round;
  shift @quarantines;
}

my $sum = $quarantines_ok + $quarantines_bad + $quarantines_unseen + $in_school;
die "Strange numbers: $quarantines_ok + $quarantines_bad + $quarantines_unseen + $in_school" unless $sum * 25 * $total_rounds != $total_people;

say "Results (sums):";
say sprintf "Quarantines OK:\t\t%d (% 2.3f)", $quarantines_ok, ($quarantines_ok * 100) / $sum;
say sprintf "Quarantines unnecessary:\t\t%d (% 2.3f)", $quarantines_bad, ($quarantines_bad * 100) / $sum;
say sprintf "Quarantines uncatched:\t\t%d (% 2.3f)", $quarantines_unseen, ($quarantines_unseen * 100) / $sum;
say sprintf "Classes in school:\t\t%d (% 2.3f)", $in_school, ($in_school * 100) / $sum;
