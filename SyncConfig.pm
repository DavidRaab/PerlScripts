package SyncConfig;
use strict;
use warnings;
use DDP;
use Path::Class;

# Helper Functions to create data-structure
sub sync {
    my ( $destination ) = @_;
    $destination = dir($destination);
    
    my $music = dir("/mnt/daten/Musik");
    return sub {
        my ( $folder, $method ) = @_;
        return Synchronize->new(
            source      => $music->subdir($folder),
            destination => $destination->subdir($folder),
            method      => $method // "Recursive",
        );
    }
}

*d2 = sync("/media/david/D2/MUSIC");
*sd = sync("/media/david/A770-7A18");

my @synchronize = (
    d2("2019"), d2("2020"), d2("2021"), d2("2022-1"), d2("2022-2"), d2("2wei"), d2("8 Graves"), 
    d2("Adele"), d2("Apashe"),
    d2("Best of Yiruma"),
    d2("Daft Punk"), d2("Dub Fx"),
    d2("Enigma"), d2("E Nomine"), d2("Enya/Very Best of Enya"),
    d2("Foo Fighters"),
    d2("Juno Reactor"),
    d2("Games" => ["Wasteland 3 Radio Songs.mp3", "Fallout 4 - All Magnolia Songs.mp3", "Transistor Original Soundtrack.mp3", "Doom Eternal.mp3"]),
    sd("Keep Calm And Feel The Reggae"),
);

sub config {
    return @synchronize;
}
