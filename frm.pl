use strict;

use vars qw($VERSION %IRSSI);
$VERSION = "2006092408";
%IRSSI = (
    authors     => "Josh Bressers",
    contact     => "josh\@bress.net",
    name        => "frm",
    description => "Stop typing frm into channels",
    license     => "GPLv2",
    changed     => "$VERSION",
    commands	=> "frm"
);

use Irssi 20020324;

# These commands will be caught if they appear as is at the beginning of
# the line.
my @commands = ("frm", "ls", "s", "minc");

# These commands will be caught if they appear anywhere other than the
# beginning of the line
my @illegal_terms = ("/wg", "/query", "/msg");

sub cmd_remove {
    my ($msg, $server, $witem) = @_;
    my ($command);

    foreach $command (@illegal_terms) {
        if ($msg =~ /$command/ && $msg !~ /^$command/) {
            return unless ($witem);
            $witem->print("DON'T DO THAT!", MSGLEVEL_CLIENTCRAP);
            Irssi::signal_stop();
        }
    }

    foreach $command (@commands) {
        if ($msg =~ /^$command$/) {
            return unless ($witem);
            $witem->print("DON'T DO THAT!", MSGLEVEL_CLIENTCRAP);
            Irssi::signal_stop();
        }
    }
}

Irssi::signal_add('send text', 'cmd_remove');
print "%B>>%n ".$IRSSI{name}." ".$VERSION." loaded";
