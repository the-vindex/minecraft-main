use strict;
use warnings;
use Data::Dumper;
use File::Find qw(find);
use File::Copy;

replace(load('fields.csv'));
replace(load('methods.csv'));

sub load{
	my $source = shift;
	open(F,'<', $source) or die 'Cannot load $source';

	my %fields;

	while(<F>){
		chomp;
		my $line = $_;
		$line =~ m/(.*?),(.*?),/;
		$fields{$1} = $2;
	}
	#print Dumper(%fields);

	close(F);
	
	return \%fields;
}

sub replace{
	my $replacements = shift;
	my $dir     = '.';
	my $pattern = '.java';
	find sub {
		my $fn = $File::Find::name;
		my $openPath = $_;
		if ( $fn =~ /\Q$pattern\E$/) {
			print "<${fn}\n";
			open(F, "<", $openPath) or die "Cannot open $openPath";
			open(DEC, ">${openPath}.out") or die "Cannot open $openPath.out";
			my $contents = do { local $/; <F> }; #slurp file
			
			foreach my $key (keys %{$replacements}){
				$contents =~ s/\Q$key\E/$replacements->{$key}/g;
			}
			print DEC $contents;
			close(F);
			close(DEC);
			
			move("${openPath}.out", $openPath) or die "Can't move to $openPath";
		}
	}, $dir;
}