package SyncConfig;
use v5.36;
#use DDP;
use Path::Class;

# Helper Functions to create data-structure
sub sync ($destination) {
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
    d2("2020"), d2("2021"), d2("2022-1"), d2("2022-2"), d2("2023"), d2("2wei"), d2("8 Graves"),
    d2("Adele"), d2("Apashe"), sd("Audiomachine"),
    d2("Best of Yiruma"),
    d2("Daft Punk"), d2("Dub Fx"),
    d2("Enigma"), d2("E Nomine"), d2("Enya/Very Best of Enya"),
    d2("Foo Fighters"), d2("Gorillaz"), d2("Hidden Citizens"), d2("Infected Mushroom"), d2("INZO"),
    sd("Juno Reactor"), d2("Justice"),
    d2("Linkin Park"),
    d2("Massive Attack"), d2("Milow"), d2("Moby"), d2("Nintendo"),
    d2("Games" => ["Wasteland 3 Radio Songs.mp3", "Fallout 4 - All Magnolia Songs.mp3", "Transistor Original Soundtrack.mp3", "Doom Eternal.mp3"]),
#    d2("Games/Bastion Original Soundtrack"),  TODO: Correct Handling
    sd("MS MR"),
    sd("Secession Studios"),
    sd("The Heavy Horses"),
    sd("The Teskey Brothers"),
    sd("Various artists/Dark Country 4"),
    sd("Various artists/Dark Rock and Blues"),
    sd("Various artists/Dark Rock Songs"),
    sd("Various artists/Keep Calm And Feel The Reggae"),
    sd("Various artists/Vintage Reggae 80s Cafe 2"),
    sd("Stick Figure"),
);

sub config {
    return @synchronize;
}
