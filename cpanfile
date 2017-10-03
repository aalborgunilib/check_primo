requires 'File::Basename';
requires 'File::RandomLine';
requires 'LWP::Simple';
requires 'Monitoring::Plugin';
requires 'Time::HiRes'
requires 'URI::Escape';

feature 'debug', 'XML debugging support' => sub {
	recommends 'XML::LibXML';
	recommends 'XML::LibXML::PrettyPrint';
}
