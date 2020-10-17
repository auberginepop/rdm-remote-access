#!/usr/bin/perl
use CGI ':standard';
use warnings;

sub print_prompt {
   print start_form;
   print textfield('ip');
   print " IP address to whitelist (x.x.x.x)";
   print "<br>";
   print textfield('description');
   print " Reason for whitelist (e.g. name of support engineer)";
   print "<p>";
   print submit('Action','Submit');
   print end_form;
   print "<hr>\n";
}

sub print_tail {
   print <<END;
<hr>
END
}

print header;
print start_html(-title=>"RDM Remote Access");
print "<style>
    * {
      font-family: arial, sans-serif;
      color: green;
    }
    table {
	font-family: arial, sans-serif;
	font-size: 12px;
	border-collapse: collapse;
	width: 100%;
    }
    
</style>";

print "<img src='encompass.png' style='float:right'>";
print "<h1>Remote Desktop Manager Remote Access</h1>\n";
print_prompt();
$ip          = param('ip');
$description = param('description');
$ip //= "";          # default to empty string if not defined
$description //= ""; # default to empty string if not defined
$date = `date +%F`;
chomp $date; # remove trailing newline
$description = "${date}_$description";
$description =~ s/ /_/g; # spaces are not allowed
if ( ( $ip =~ /^\d+\.\d+\.\d+\.\d+$/ ) && ( $description =~ /\w+/ ) ) {
    $return = `/opt/encompass/rdm-remote-access/aws_commands/rule_add.sh "$ip" "$description" 2>&1`;
    print "<pre>$return</pre>";
}
print "Current Rules<p>";
$current_rules = `/opt/encompass/rdm-remote-access/aws_commands/rule_getall.sh`;
print "<pre>$current_rules</pre>";
print_tail();
print end_html;
