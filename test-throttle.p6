use v6;

# Standard output is now unbuffered
$*OUT.out-buffer = False;

# Constants
constant COUNT = 100;
constant THROTTLE-LIMIT = 8;

say "Number of PDF files = {COUNT}";
say "Throttle limit      = {THROTTLE-LIMIT}";

# Make sure output folder is there
"output".IO.mkdir;

# Generate PDFs with throttling
my $t0 = now;
my @results;
my $supply = Supply.from-list(^COUNT);
my $t      = $supply.throttle(THROTTLE-LIMIT, {
	my $output-filename = "output/test-$_.pdf";
	$output-filename.IO.unlink;

	run-wkhtmltopdf('input.html', $output-filename);
	my $blob = $output-filename.IO.slurp(:bin);
	my %result = :name($output-filename), :blob($blob);
	@results.push(%result);
});
$t.wait;
say "It took ", (now - $t0), " to generate {COUNT} PDF files (throttling: {THROTTLE-LIMIT})";
say @results.elems;

sub run-wkhtmltopdf($html-file, $output-file) {
	my $proc = Proc::Async.new('wkhtmltopdf', '--quiet', $html-file, $output-file);
	
	# subscribe to new output from out and err handles: 
	$proc.stdout.tap(
		-> $v { say "Output: $v" },
		quit => { say 'caught exception ' ~ .^name }
	);
	#$proc.stderr.tap(
	#	-> $v { print "Error:  $v" }
	#);
	 
	my $promise = $proc.start;
	 
	# wait for the external program to terminate 
	await $promise;	
}

