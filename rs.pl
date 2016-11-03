use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

use Module::Refresh;
$VERSION = '1.01';
%IRSSI = (
    authors         => 'Alan Drees',
    contact         => 'alandrees@theselves.com',
    name            => 'russian swearing',
    description     => 'Randomly swear in russian',
    license         => 'GPLv2',
    );

sub _rus_trigger{
    my ($server, $msg, $nick, $address, $target) = @_;
    my ($selfnick);

    if(lc($arguments[0]) eq '!rus'){
    
	@russian_array = ('дурак',
			  'дура',
			  'Дурачок',
			  'дурочка',
			  'Гондон',
			  'Обгондонился',
			  'Кончать',
			  'Дрочер',
			  'дрочить',
			  'говно',
			  'Хуёвый',
			  'Говёный',
			  'Срать',
			  'Обосрался',
			  'Срач',
			  'Скотина',
			  'Козёл',
			  'коза',
			  'Сучара',
			  'Корова',
			  'Курица',
			  'Баран',
			  'овца',
			  'Подонок',
			  'Мудоёб',
			  'Сволочь',
			  'Ублюдок',
			  'Ублюдочный',
			  'Педик',
			  'пидарас',
			  'Говномес',
			  'Распидорасило',
			  'Гопник',
			  'Гопница',
			  'Без пизды',
			  'Блядемудинный пиздопроёб',
			  'В рот ебись',
			  'Ебать тя в рот',
			  'В пизду',
			  'В жопу',
			  'Пиздец',
			  'Нам пиздец',
			  'Да ебал я это',
			  'Насрать',
			  'Ебальник закрой',
			  'Ёбаный насос',
			  'Ёб твою мать',
			  'Не еби мозги');

	my $index = int( rand( scalar(@russian_array) - 1 ) );

	$server->command('MSG '.$target.' '.$russian_array[$index]);
    }
}

signal_add("message public", "_text_trigger");

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
