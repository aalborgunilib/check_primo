# check_primo
Nagios (and compatibles) plugin to check and monitor the response time of searches performed in the ExLibris Primo library discovery system.

## About
Using the [brief search](https://developers.exlibrisgroup.com/primo/apis/webservices/xservices/search/briefsearch) API endpoint of ExLibris Primo this Nagios compatible plugin can be used as a check and monitoring tool for the search performance.

It can be configured to search for a specific query string or pick a random query from a predefined list of e.g. popular searches thus emulating a more real-life system behavior.

In addition, it can perform the search in local collections only, Primo Central, or in both (blended search).

The API approach was chosen to eliminate the load time of the Primo search page itself and PDS redirects. These should be monitored as well but is as such not within the scope of this plugin (check_http is much better for this job).

## Installation

Copy the check_primo and primo_searches.txt files to your Nagios plugins directory, e.g.:

    git clone https://github.com/aalborgunilib/check_primo
    cd check_primo
    sudo cp plugins/check_primo /usr/lib64/nagios/plugins/
    sudo cp plugins/primo_searches.txt /usr/lib64/nagios/plugins/
    sudo chmod 755 /usr/lib64/nagios/plugins/check_primo

Install Perl dependencies for the plugin via e.g. [cpanm](https://metacpan.org/pod/App::cpanminus). (Please stay within the check_primo directory):

    cpanm --sudo --installdeps .

*Compilation of the Perl dependencies does require the installation of software development tools on the server (gcc).*

Please check that you have set Primo up to recognize your server IP address in the WS and XS IP mapping table. Read the section "Register your IP" in [Getting started - XService API](https://developers.exlibrisgroup.com/primo/apis/webservices/gettingstarted).

Now, check to see if the plugin is working (local search):

    plugins/check_primo --critical=6 --hostname=http://<server>.hosted.exlibrisgroup.com --port=1701 --institution=INST --local

You should get something in the line of:

    PRIMO OK -  search was done in 0.222 second(s): 192 hits | 'Search time'=0.222s;;6

Primo Central (if you are a subscriber) can be checked with the following:

    plugins/check_primo --critical=6 --hostname=http://<server>.hosted.exlibrisgroup.com --port=1701 --institution=INST --primocentral

## Usage

    Usage: check_primo
        [ -c|--critical=<critical threshold> ]
        [ -w|--warning=<warning threshold> ]
        [ -H|--hostname=<Primo server name> ]
        [ -p|--port=<port number> ]
        [ -I|--institution=<Primo institution> ]
        [ -P|--primocentral ]
        [ -L|--local ]
        [ -K|--keywords=<keyword1+keyword2+...> ]
        [ -t|--timeout=<timeout> ]

The `-c|--critical` and `-w|--warning` defines the standard Nagios service check thresholds (in seconds). The warning threshold can be omitted.

`-H|--hostname` is the url to the Primo server (including http:// or https://). `-p|--port` is the port number and defaults to port 1701.

`-I|--institution` is the Primo institution to which the search is scoped to.

`-L|--local` performs the search in the local index. `-P|--primocentral` performs the search in the Primo Central index. You can add both options to perform a blended search.

`-K|--keywords` lets you add your own search string instead of using the provided list of random searches. Separate each keyword by a `+` sign.

`-t|--timeout` is the plugin timeout. If timeout is reached the check will bail out and issue a UNKNOWN state.

`-c|--critical`, `-H|--hostname`, and `-I|--institution` are required.

### Icinga 2 configuration ###

An example configuration for `check_primo` has been provided for the excellent [Icinga 2](https://www.icinga.org/icinga/icinga-2/) in the file `config/primo-icinga2.conf`. You can use it as inpiration on how you can set up the different checks.

## Bugs

* Currently the plugin will issue an UNKNOWN state when it times out (defaults to 15 seconds). I think it would be more correct to issue a CRITICAL state or at least let it be up the user to decide.

## Copyright and license

Copyright (c) 2015 Kasper Løvschall and Aalborg University Library

This software is free software; you can redistribute it and/or modify it under the same terms as Perl itself. See [Perl Licensing](http://dev.perl.org/licenses/).

