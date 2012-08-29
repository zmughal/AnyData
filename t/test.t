#!/usr/local/bin/perl -wT
use strict;
use warnings;

#the original tests that came with AnyData 0.10

my @formats = qw(CSV Pipe Tab Fixed Paragraph ARRAY);

use Test::More;
plan tests => (1+$#formats) * 4;

use AnyData;


for my $format( @formats ) {
   printf  "  %10s ... %s\n", $format, test_ad($format);
}

sub test_ad {
    my $file = [];
    my $format = shift;
    my $mode = 'o';
    my $flags = {cols=>'name,country,sex',pattern=>'A5 A8 A3'};
    my $table = adTie( $format,$file, $mode, $flags ); # create a table
    $table->{Sue} = {country=>'fr',sex=>'f'};          # insert rows
    $table->{Tom} = {country=>'fr',sex=>'f'};
    $table->{Bev} = {country=>'en',sex=>'f'};
    $table->{{ name=>'Tom'}} = {sex=>'m'};             # update a row
    delete $table->{Bev};                              # delete a row
    $flags = {pattern=>'A5 A8 A3'};
    ok('f' eq $table->{Sue}->{sex}, "Failed single select");
    my $tstr;
    while ( my $person = each %$table ) {              # select mulitple rows
        $tstr .= $person->{name} if $person->{country} eq 'fr';
    }
    ok('SueTom' eq $tstr, "Failed multiple select");
    ok('namecountrysex' eq join('',adNames($table)), "Failed names");
    ok(2 == adRows($table), "Failed rows");
}


__END__