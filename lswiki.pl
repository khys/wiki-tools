#!/usr/bin/perl -w

use strict;
use warnings;
use utf8;
use Encode;
use Encode::Guess qw/euc-jp shiftjis 7bit-jis/;

my $encording = "Guess";
my $decording = "euc-jp";
$decording = "utf-8" if ($ENV{LANG} =~ /utf-?8/i);
$decording = "sjis" if ($ENV{LANG} =~ /sjis/i);
my $is_short  = 0;
my $is_encording = 0;

my @files;

sub rename {
    my $file = shift;
    my $is_encording = shift;

    if ($is_encording) {
        $file = join "", map sprintf("%s", $_), unpack("H*", $file);
        $file =~ tr/a-z/A-Z/;
    } else {
        $file =~s/([0-9A-F]{2})/chr(hex($1))/ge;
    }
    $file = Encode::decode($encording, $file);
    $file = Encode::encode($decording, $file);

    return $file;
}

while ( $#ARGV >= 0 ) {
    if ( $ARGV[0] =~ /^-([esft])$/ ) {
        my $flag = $1;
        $is_encording = 1 if($flag eq "e" );
        $is_short = 1     if($flag eq "s" );
        if($flag eq "f" ){
            $encording = $ARGV[1]  or die "you should specify character encoding for input data";
            shift @ARGV;
        }
        if($flag eq "t" ){
            $decording = $ARGV[1]  or die "you should specify character encoding for output data";
            shift @ARGV;
        }
        shift @ARGV;
    }
    else {
        my $file =  shift @ARGV;
        if( -d  $file ){
            my $rcd = opendir(DIR, $file) or die;
            push (@files,  sort grep { !/^\.\.?$/ } readdir(DIR));
            closedir(DIR);
        } else {
            push(@files, $file);
        }
    }
}


if ( $#files == -1){
    my $rcd = opendir(DIR, ".") or die;
    @files = sort grep { !/^\.\.?$/ } readdir(DIR);
    closedir(DIR);
}


foreach my $orig ( @files ){
    my $rename = &rename($orig, $is_encording);
    $orig =~ s|^.*/||;
    $rename .= "\t($orig)" unless($is_short);
    print $rename . "\n";
}
