#!/usr/bin/perl
use strict;
use warnings;
use POSIX qw(floor ceil);
use Astro::Sunrise;
use DateTime;
use Test::More;

my @data = load_data();
plan(tests => 5 + 2 * @data); # I prefer having Perl counting my tests than myself

use vars qw($long $lat $offset);

my $test_year  = '2003';
my $test_month = '6';
my $test_day   = '21';


for (@data) {
/(\w+),\s+(\w+)\s+(\d+)\s+(\d+)\s+(\w)\s+(\d+)\s+(\d+)\s+(\w)\s+sunrise:\s+(\d+:\d+)\s+sunset:\s+(\d+:\d+)/;
    if ( $5 eq 'N' ) {
        $lat = sprintf( "%.3f", ( $3 + ( $4 / 60 ) ) );

    }
    elsif ( $5 eq 'S' ) {
        $lat = sprintf( "%.3f", -( $3 + ( $4 / 60 ) ) );

    }

    if ( $8 eq 'E' ) {
        $long = sprintf( "%.3f", $6 + ( $7 / 60 ) );

    }
    elsif ( $8 eq 'W' ) {
        $long = sprintf( "%.3f", -( $6 + ( $7 / 60 ) ) );

    }

    if ($long < 0 )   {
      $offset = ceil( $long / 15 );
    }elsif ($long > 0 )   {
      $offset = floor( $long /15 );
    }

    my ( $sunrise, $sunset ) =
      sunrise( $test_year, $test_month, $test_day, $long, $lat, $offset, 0 );


    is ($sunrise, $9, "Sunrise for $1, $2");
    is ($sunset , $10, "Sunset for $1, $2");

}


my $sunrise_1 = sun_rise( -118, 33  );
my $sunrise_2 = sun_rise( -118, 33, -.833 );
my $sunrise_3 = sun_rise( -118, 33, -.833, 0 );
my $sunrise_4 = sun_rise( -118, 33, undef, 0 );

ok( $sunrise_1 eq $sunrise_2 , "Test W/O Alt");
ok( $sunrise_2 eq $sunrise_3 , "Test W/O offset");
ok( $sunrise_3 eq $sunrise_4 , "Test setting Alt to undef");


my $then = DateTime->new (
                    year => 2000,
		    month => 6,
		    day => 20,
		    time_zone =>'America/Los_Angeles',
		    );
my $offset = ( ($then->offset) /60 /60);

my ($sunrise, $sunset) = sunrise($then->year, $then->mon, $then->mday,
                              -118, 33, $offset, 0);
is ($sunrise, '05:42', "Test DateTime sunrise interface");
is ($sunset,  '20:05', "Test DateTime sunset interface");



sub load_data {
    return split "\n", <<'EOD';
Aberdeen, Scotland 57 9 N 2 9 W sunrise: 03:09 sunset: 21:11
Adelaide, Australia 34 55 S 138 36 E sunrise: 06:52 sunset: 16:43
Algiers, Algeria 36 50 N 3 0 E sunrise: 04:28 sunset: 19:12
Amsterdam, Netherlands 52 22 N 4 53 E sunrise: 03:16 sunset: 20:09
Ankara, Turkey 39 55 N 32 55 E sunrise: 04:18 sunset: 19:22
Asuncion, Paraguay 25 15 S 57 40 W sunrise: 07:34 sunset: 18:11
Athens, Greece 37 58 N 23 43 E sunrise: 04:01 sunset: 18:52
Auckland, New_Zealand 36 52 S 174 45 E sunrise: 06:32 sunset: 16:13
Bangkok, Thailand 13 45 N 100 30 E sunrise: 04:50 sunset: 17:49
Barcelona, Spain 41 23 N 2 9 E sunrise: 04:16 sunset: 19:30
Beijing, China 39 55 N 116 25 E sunrise: 03:44 sunset: 18:48
Belem, Brazil 1 28 S 48 29 W sunrise: 06:13 sunset: 18:18
Belfast, Northern_Ireland 54 37 N 5 56 W sunrise: 03:44 sunset: 21:07
Belgrade, Yugoslavia 44 52 N 20 32 E sunrise: 03:50 sunset: 19:29
Berlin, Germany 52 30 N 13 25 E sunrise: 02:41 sunset: 19:35
Birmingham, England 52 25 N 1 55 W sunrise: 03:43 sunset: 20:36
Bogota, Colombia 4 32 N 74 15 W sunrise: 06:46 sunset: 19:11
Bombay, India 19 0 N 72 48 E sunrise: 04:31 sunset: 17:50
Bordeaux, France 44 50 N 0 31 W sunrise: 04:14 sunset: 19:53
Bremen, Germany 53 5 N 8 49 E sunrise: 02:56 sunset: 19:57
Brisbane, Australia 27 29 S 153 8 E sunrise: 06:36 sunset: 17:02
Bristol, England 51 28 N 2 35 W sunrise: 03:51 sunset: 20:33
Brussels, Belgium 50 52 N 4 22 E sunrise: 03:26 sunset: 20:02
Bucharest, Romania 44 25 N 26 7 E sunrise: 03:29 sunset: 19:05
Budapest, Hungary 47 30 N 19 5 E sunrise: 03:44 sunset: 19:46
Buenos_Aires, Argentina 34 35 S 58 22 W sunrise: 07:59 sunset: 17:52
Cairo, Egypt 30 2 N 31 21 E sunrise: 04:52 sunset: 19:00
Calcutta, India 22 34 N 88 24 E sunrise: 04:21 sunset: 17:55
Canton, China 23 7 N 113 15 E sunrise: 04:41 sunset: 18:17
Cape_Town, South_Africa 33 55 S 18 22 E sunrise: 06:50 sunset: 16:46
Caracas, Venezuela 10 28 N 67 2 W sunrise: 06:07 sunset: 18:53
Cayenne, French_Guiana 4 49 N 52 18 W sunrise: 06:18 sunset: 18:44
Chihuahua, Mexico 28 37 N 106 5 W sunrise: 05:06 sunset: 19:06
Chongqing, China 29 46 N 106 34 E sunrise: 04:52 sunset: 18:58
Copenhagen, Denmark 55 40 N 12 34 E sunrise: 02:23 sunset: 20:00
Cordoba, Argentina 31 28 S 64 10 W sunrise: 07:14 sunset: 17:23
Dakar, Senegal 14 40 N 17 28 W sunrise: 05:41 sunset: 18:43
Darwin, Australia 12 28 S 130 51 E sunrise: 05:35 sunset: 17:01
Djibouti, Djibouti 11 30 N 43 3 E sunrise: 04:44 sunset: 17:35
Dublin, Ireland 53 20 N 6 15 W sunrise: 03:54 sunset: 20:59
Durban, South_Africa 29 53 S 30 53 E sunrise: 06:50 sunset: 17:06
Edinburgh, Scotland 55 55 N 3 10 W sunrise: 03:24 sunset: 21:05
Frankfurt, Germany 50 7 N 8 41 E sunrise: 03:13 sunset: 19:41
Georgetown, Guyana 6 45 N 58 15 W sunrise: 06:38 sunset: 19:11
Glasgow, Scotland 55 50 N 4 15 W sunrise: 03:29 sunset: 21:09
Guatemala_City, Guatemala 14 37 N 90 31 W sunrise: 05:33 sunset: 18:35
Guayaquil, Ecuador 2 10 S 79 56 W sunrise: 06:20 sunset: 18:22
Hamburg, Germany 53 33 N 10 2 E sunrise: 02:48 sunset: 19:55
Havana, Cuba 23 8 N 82 23 W sunrise: 05:43 sunset: 19:19
Helsinki, Finland 60 10 N 25 0 E sunrise: 01:50 sunset: 20:53
Hobart, Tasmania 42 52 S 147 19 E sunrise: 06:40 sunset: 15:44
Iquique, Chile 20 10 S 70 7 W sunrise: 07:14 sunset: 18:11
Irkutsk, Russia 52 30 N 104 20 E sunrise: 02:37 sunset: 19:32
Jakarta, Indonesia 6 16 S 106 48 E sunrise: 06:01 sunset: 17:48
Johannesburg, South_Africa 26 12 S 28 4 E sunrise: 05:53 sunset: 16:26
Kingston, Jamaica 17 59 N 76 49 W sunrise: 05:32 sunset: 18:46
Kinshasa, Congo 4 18 S 15 17 E sunrise: 06:03 sunset: 17:58
La_Paz, Bolivia 16 27 S 68 22 W sunrise: 07:00 sunset: 18:11
Leeds, England 53 45 N 1 30 W sunrise: 03:33 sunset: 20:43
Lima, Peru 12 0 S 77 2 W sunrise: 06:26 sunset: 17:54
Lisbon, Portugal 38 44 N 9 9 W sunrise: 05:10 sunset: 20:06
Liverpool, England 53 25 N 3 0 W sunrise: 03:41 sunset: 20:47
London, England 51 32 N 0 5 W sunrise: 03:40 sunset: 20:24
Lyons, France 45 45 N 4 50 E sunrise: 03:49 sunset: 19:36
Madrid, Spain 40 26 N 3 42 W sunrise: 04:43 sunset: 19:50
Manchester, England 53 30 N 2 15 W sunrise: 03:37 sunset: 20:44
Manila, Philippines 14 35 N 120 57 E sunrise: 05:27 sunset: 18:29
Marseilles, France 43 20 N 5 20 E sunrise: 03:57 sunset: 19:24
Mazatlan, Mexico 23 12 N 106 25 W sunrise: 05:19 sunset: 18:56
Mecca, Saudi_Arabia 21 29 N 39 45 E sunrise: 04:38 sunset: 18:07
Melbourne, Australia 37 47 S 144 58 E sunrise: 06:34 sunset: 16:10
Mexico_City, Mexico 19 26 N 99 7 W sunrise: 05:58 sunset: 19:19
Milan, Italy 45 27 N 9 10 E sunrise: 03:33 sunset: 19:17
Montevideo, Uruguay 34 53 S 56 10 W sunrise: 07:51 sunset: 17:42
Moscow, Russia 55 45 N 37 36 E sunrise: 02:42 sunset: 20:21
Munich, Germany 48 8 N 11 35 E sunrise: 03:11 sunset: 19:19
Nagasaki, Japan 32 48 N 129 57 E sunrise: 04:11 sunset: 18:33
Nagoya, Japan 35 7 N 136 56 E sunrise: 04:37 sunset: 19:11
Nairobi, Kenya 1 25 S 36 55 E sunrise: 05:32 sunset: 17:36
Nanjing_Nanking, China 32 3 N 118 53 E sunrise: 03:57 sunset: 18:15
Naples, Italy 40 50 N 14 15 E sunrise: 03:30 sunset: 18:40
Newcastle-on-Tyne, England 54 58 N 1 37 W sunrise: 03:25 sunset: 20:52
Odessa, Ukraine 46 27 N 30 48 E sunrise: 04:02 sunset: 19:55
Osaka, Japan 34 32 N 135 30 E sunrise: 04:44 sunset: 19:15
Oslo, Norway 59 57 N 10 42 E sunrise: 01:50 sunset: 20:48
Panama_City, Panama 8 58 N 79 32 W sunrise: 05:59 sunset: 18:40
Paramaribo, Suriname 5 45 N 55 15 W sunrise: 06:28 sunset: 18:58
Paris, France 48 48 N 2 20 E sunrise: 03:45 sunset: 20:00
Perth, Australia 31 57 S 115 52 E sunrise: 06:15 sunset: 16:21
Plymouth, England 50 25 N 4 5 W sunrise: 04:03 sunset: 20:33
Port_Moresby, Papua_New_Guinea 9 25 S 147 8 E sunrise: 05:25 sunset: 17:01
Prague, Czech_Republic 50 5 N 14 26 E sunrise: 02:50 sunset: 19:18
Rangoon, Myanmar 16 50 N 96 0 E sunrise: 05:02 sunset: 18:13
Reykjavik, Iceland 64 4 N 21 58 W sunrise: 01:50 sunset: 23:09
Rio_de_Janeiro, Brazil 22 57 S 43 12 W sunrise: 07:32 sunset: 18:17
Rome, Italy 41 54 N 12 27 E sunrise: 03:33 sunset: 18:50
Salvador, Brazil 12 56 S 38 27 W sunrise: 06:53 sunset: 18:18
Santiago, Chile 33 28 S 70 45 W sunrise: 07:45 sunset: 17:44
St_Petersburg, Russia 59 56 N 30 18 E sunrise: 02:32 sunset: 21:29
Sao_Paulo, Brazil 23 31 S 46 31 W sunrise: 06:46 sunset: 17:30
Shanghai, China 31 10 N 121 28 E sunrise: 04:49 sunset: 19:02
Singapore, Singapore 1 14 N 103 55 E sunrise: 04:59 sunset: 17:13
Sofia, Bulgaria 42 40 N 23 20 E sunrise: 03:47 sunset: 19:10
Stockholm, Sweden 59 17 N 18 3 E sunrise: 02:28 sunset: 21:11
Sydney, Australia 34 0 S 151 0 E sunrise: 07:00 sunset: 16:56
Tananarive, Madagascar 18 50 S 47 33 E sunrise: 06:20 sunset: 17:23
Teheran, Iran 35 45 N 51 45 E sunrise: 04:16 sunset: 18:54
Tokyo, Japan 35 40 N 139 45 E sunrise: 04:24 sunset: 19:01
Tripoli, Libya 32 57 N 13 12 E sunrise: 03:58 sunset: 18:20
Venice, Italy 45 26 N 12 20 E sunrise: 03:20 sunset: 19:04
Veracruz, Mexico 19 10 N 96 10 W sunrise: 05:47 sunset: 19:06
Vienna, Austria 48 14 N 16 20 E sunrise: 03:52 sunset: 20:01
Vladivostok, Russia 43 10 N 132 0 E sunrise: 03:30 sunset: 18:57
Warsaw, Poland 52 14 N 21 0 E sunrise: 03:12 sunset: 20:03
Wellington, New_Zealand 41 17 S 174 47 E sunrise: 06:45 sunset: 16:00
Zurich, Switzerland 47 21 N 8 31 E sunrise: 03:27 sunset: 19:28
EOD
}
