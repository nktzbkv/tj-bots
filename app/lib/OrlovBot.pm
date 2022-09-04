package OrlovBot;

use strict;
use warnings;
use utf8;
use base qw/BotBase/;
use experimental qw/signatures/;

my @victim_responses = (
  ["Ты зачем порвался?", "Зачем ты порвался?", "Зачем порвался?"],
  ["Травля", "Травля, жаль", "Травля жаль"],
  ["Порвался жаль", "Порвался, жаль"],
  "Жаль",
  "Разбань",
);

# my @responses = (
#   @victim_responses,
#   ["Двойные стандарты", "Двойные стандарты, жаль"],
#   "Нет ты",
#   "Разбань",
#   "Геюга",
#   "Я ухожу с TJ",
# );

my @text_match_responses = (
  "Жаль",
  "Очень жаль",
  "JAL",
  "Спасибо люблю целую",
  "По факту ☝️",
  "Давай БЕЗ ЭТОГО",
  "Привет БРАТ",
  "Как дела?",
  "Пришел сюда за этим",
  "Хватит писать такие комментарии. Извинись",
);

my @responses = (
  "Может хватит рваться????",
  "Че рвешься?",
  "Че ты рвешься????? Успокойся",
  "Ты зачем порвался?", "Зачем ты порвался?", "Зачем порвался?",
  "Да", "Нет",
  "Двойные стандарты", "Двойные стандарты, жаль",
  "Нет ты",
  "Нет, извини",
  "Травля", "Травля, жаль", "Травля жаль",
  "Порвался жаль",
  "Жаль",
  "Очень жаль",
  # "Плюсаните\nУ меня должно быть под сотню",
  "Это я его порвал??",
  "Нашел твою маму. Что с ней делать???",
  "Разбань",
  "Давай дружить. Разбань",
  "РАЗБАНЬ",
  "Геюга",
  # "Приехал в фонд помощи хохлам",
  "Сразу видно, украинские корни",
  "Добавь в чат",
  "ТВОЯ МАТЬ неШЛЮХА", "Твоя мать хорошая женщина", "Твоя мать мать",
  "Зачем порвался???",
  "Спасибо всем за поддержку!!!",
  "ВЫДВИГАЮ НАРОДНЫЙ УЛЬТИМАТУМ ПРОТИВ ЦЫПЛУХИНА И ВАХТЕРА",
  "СРОЧНО! ПРЯМАЯ ЛИНИЯ С ДМИТРИЕМ ОРЛОВЫМ. ЗВОНИТЕ И ПИШИТЕ",
  "Чечня превыше всего",
  "ДОГОВОРИЛСЯ С ВАХТЕРОМ О МОЕМ РАЗБАНЕ",
  "Почему Дмитрий Орлов забанен несправедливо?",
  # "Помогите мне пожалуйста!",
  "⚡️ТАСС: уход Дмитрия Орлова с TJ оказался фейком",
  "Рубрика: вечер с Дмитрием Орловым",
  "За что меня забанил вахтер???",
  "А правда, что российское государство специально создаёт образ диких агрессивных русских, чтобы оправдать свою власть????",
  # "Что не так с клоунами на дтф?",
  # "Зачем хаким продолжает угрожать каждому встречному в интернете???",
  "Зачем русские рвутся, когда их просят говорить Беларусь?",
  "Сколько часов в неделю работает вахтер?",
  "Что изменилось на тж за эту неделю?¿??",
  "Исследование: коммунистами чаще всего становятся люди с низким IQ",
  "Почему муслимы бухают, но свинину не едят??",
  "Почему мужчины ставят себе женщин на аватарки?",
  # "Тошнит и кружится голова. Что делать?",
  "Чей твинк и почему он не в бане?",
  # "Как кыргызы относятся к акаеву??? Нужен комментарий кыргызов",
  "Почему тж рвется от моих постов, в которых я обличаю всю гниль местной аудитории?",
  "Дмитрий Орлов — лучший пользователь ТЖ?",
  # "Зачем польский бариста Дитковский добавил меня в чс??",
  "Я ухожу с TJ",
  "Что здесь написано???",
  "Что не так с русскими???",
  # "Почему маленькие девочки пишут о себе в мужском лице??",
  "Как перестать удивляться высокомерности глупых людей, которые считают себя умнее всех???",
  # "Что изображено на этой картинке? Что означают эти цифры??? Никак не могу понять",
  "Больше никаких вбросов",
  "Настоящее лицо великих русских революционеров",
  "Вахтер красава",
  "Зачем я занимаюсь всей этой хуйней? Помогите",
  # "Я бойкотирую подсайт Интернет на пять дней!!!!",
  # "Меня забанили!",
  # "Хочу плакать. Что делать??",
  "Рассуждения о тупых животных",
  "Вы победили",
  "Что всё это означает?",
  "Я возвращаюсь на TJ",
  "Древнее зло пробудилось",
  # "Зачем влад Цып нанимал двух вахтеров, если по выходным всё равно никто не работает?????????",
  "Я устал",
  "Хочу в прекрасную Россию будущего",
  "Ладно",
  "Не рВиСь", "Не рвись МРАЗЬ",
  "После этих слов в барнауле начался сущий кошмар",
  "Этой мой последний комментарий на TJ",
  "Очередное доказательство того, что братья хохлы только пиздеть в интернете могут",
  "Правый хуже пидораса",
  "Ведёшь себя как порохбот",
  "Зачем рваться с кремлеботов??",
  "Не пизди",
  "Нужно потерпеть",
  "Посоветуй куда идти с подозрением на сдвг???",
  "Бггг",
  "С чего вдруг я русофоб????",
  "Какая позиция медузы по Крыму????",
  "Почему Навальный не записывает Навальный лайв из колонии???",
  "Ты есть в чате дыни?",
  "[@293191|Шахтёр] ПРЕСЛЕДОВАНИЯ УПОМИНАНИЯМИ!!!!",
  "Когда украинцы вернут Крым????",
  "Разбань. ЗАЧЕМ ОБИЖАЕШЬСЯ???",
  "Че хотел?",
  "Это была провокация, молодец",
  "Спроси у лося зачем он порвался и добавил меня в чс?",
  "Когда в Беларуси протесты?",
  "Я ПОПУТАЛ БЕРЕГА УЖЕ ИЛИ НЕТ????",
  "Мощный удар по Воронежу",
  "Толстой правда открывал пивоварни, чтобы РУСНЯ перестала пить водку?",
  "Давай я тебя забаню, а ты заплачешь???",
  "Путин был в гневе когда получил залупу за воротник",
  "Кринж",
  "НУ И В ЧЕМ ОН НЕ ПРАВ???",
  "Ты сначала вопросы научись задавать, потом в интернете пиши",
  "Я позвонил Вахтёру. Он порвался",
  "Я казахский патриот",
  "Сталин себе такого не позволял",
  "Приезжай в Казахстан угощу кумысом",
  "ВСЁ ЯСНО",
  "Ты прав", "Ты не прав",
  "Я ЭТО УЖЕ СЛЫШАЛ",
  "Когда русские перестанут терпеть?",
  "Порвался?))))))",
  "Беларусь считается зарубежом для России????",
  "НУ КАК СКАЗАТЬ",
  "В чем я не прав??", "Да. В чем я не прав?", "Нет. В чем я не прав?",
  "Это человек из моего чс. Они не могут не рваться",
  "Чет ты меня заебал. Ты по делу что-то скажешь?",
  "Нихуя ты умный братан",
  "КТО ХУЖЕ: СТАЛИН ИЛИ ГИТЛЕР",
  "NE RVIS",
  "JAL",
  "Ne rvis. Я серьезно",
  "Зашейся",
  "Умный дохуя?",
  "Спасибо люблю целую",
  "РУССКИЕ, ВАШИ НАЛОГИ НУЖНЫ КАК НИКОГДА!!!!",
  "Одно другому не мешает",
  "Белорусы могут объяснить, почему они не выходят на митинги?",
  "Жалко ущемленных славян",
  "По факту ☝️",
  "Ты узбек? Давай дружить. Нужно в Ташкент мне",
  "Закончил школу уже?",
  "Почему из-за путинской твари спутник не котируется за рубежом??????? Кто отвечает??????",
  "Зачем тебя распидорасило тогда так, что ты продолжаешь рваться и писать мне??",
  "ЕДУ В КАЗАХСТАН",
  "Звучит справедливо",
  # "Почему злые олигархи не дади сталину построить в СССР демократию??????",
  "Зачем либералы клевещут на сталина??",
  # "Нужно дождаться экспертного мнения курасова о том, как сахаров развалил великую державу",
  # "Почему Лукашенко терпит этих белорусов???",
  "Унижу тебя на глазах у всего тж. Ты этого хочешь????",
  "Да как этот птушник постоянно у меня в чс оказывается",
  "При сталине таких ели",
  "ТЕРПИМ",
  # "Почему представитель народа-жертвы гододмора защищает колониализм??",
  "Высеры шизофреников, которым лишь бы никак все быть",
  "От таких новостей у меня флэшбеки",
  "Ясно",
  "Согласен",
  "БАРНАУЛ ОБЩИЙ СБОР",
  "Задоначу тж, чтобы его признали иноагентом",
  "Барнаул уже выступил против вопиющего феминизма?????",
  "КАК ХОРОШО ЧТО В ВЕЛИКОМ КАЗАХСТАНЕ ТАКОЙ ХУЙНИ НЕТ",
  "Сколько граждане России будут терпеть произвол силовиков???",
  "Хочу чтобы Казахстан стал 51 штатом США",
  # "Страна терпения и страна прощения. Всё по христианским канонам",
  "Что произошло бы с Россией, если бы РУССКИЕ перестали терпеть????",
  "Сейчас забаню за украинизм",
  # "Долбаебы рвутся с рыночных отношений????",
  "При общении с пользователями ТЖ синдром вахтёра встречается?",
  "Извинись передо мной за свои плохие слова",
  "Это правда, что зимой в Украине все собираются раз в день погреться у газовых труб???",
  "Ты привился?",
  "Сообщение удалено",
  "Не рвись пожалуйста давай дружить",
  "Это точно кремлеботы сидят и клепают",
  "Привет",
  "НУ И В ЧЕМ ТЫ НЕ ПРАВ?",
  "Ладно не рвусь",
  "Ne rviS i hvatit menya travIt",
  "Ты уважаешь Навального???",
  "Знаешь кто твоя мать?",
  "Я против троллинга и буллинга",
  "И ведь лайкают даже такие высеры",
  "Ты бы прошел тест на руssкого?",
  # "Откуда взялся миф о капиталистических США???",
  "Ты был в Крыму??",
  "Говоришь как Навальный",
  "Хватит писать такие комментарии. Извинись",
  "Зачем ты насрал в треде??? Убирай",
  "Почему на дтф сидят так много обоссанных коммуняк?",
  "Как правильно ставить запятые???? Я не учил русский",
  # "Почему мартингал перестал рваться? Уехал на своей лодке в закат?",
  "Антисоветчик всегда гомофоб",
  "Нож в спину",
  "Мощная самоирония",

  # "Разбаньте!!!",
  # "Меня забанили!",
  # "Хочу в прекрасную Россию будущего, где меня не банят на ТЖ!!!",
  # "Сколько граждане России будут терпеть произвол Вахтера???",
  # "Я позвонил Вахтёру. Он меня забанил",
  # "Что произошло бы с ТЖ, если бы пользователи перестали терпеть мой бан????",

  "Всё равно хуйню сказал",
  "Хорошо",
  "Иногда я смотрю на своих друзей и думаю, как было бы круто БЫТЬ БОГАТЫМ",
  "Это наброс. Не бери в голову.",
  "А Я БОЯЛСЯ ЧТО Я ОДИН ТАКОЙ",
  "Давай БЕЗ ЭТОГО",
  "А?",
  "Привет БРАТ",
  "Не РВИСЬ брат",
  "Если ты так думаешь, то ЖАЛКО ТЕБЯ",
  "Можешь ЗАВАЛИТЬ ебало?",
  "Не умничай",
  "Как дела?",
  "ГОСПАДИ ПАМАГИ",
  "Зачем советов двигает кремлёвскую повестку про развал запада?",
  "Что не так с этим постом?",
  "(удалено) ЗАБЫТЬ СПРОСИЛИ АХАХАХАХАХА!!!!",
  "Рот закрой",
  "Не пизди",
  "Ты смотрел боку но пико?",
  "Ой бляяяяя",
  "Лучше не стало",
  "Я пил вчера",
  "Слабак",
  "Попробуй не заходить на тж",
  "Ты хочешь, чтобы я опять дал свою оценку твоим умственным способностям????????",
  "За что??????",
  "Я думаю ты запизделся",
  "Жаль бедной Украине это не помогает",
  "Дай админку",
  # "Я в Казахстане живу брат",
  "Прошу не пиздеть",
  "Это мой твинк",
  "Брат, тебе тут круглосуточно разъясняют, почему ты пишешь хуйню",
  "Не пизди пожалуйста умоляю",
  "Пришел сюда за этим",
  "Слишком умно",
  "Почему так мало Навального????",
  "Зачем УКРАИНЦЫ позволили отобрать у себя крым?",
);

my %never_reply = map {$_ => 1} qw/398152 308880 400974 404799/;

sub should_ignore($self, $json) {
  my $cid = $json->{creator}{id};
  return $cid && $never_reply{$cid};
}

sub handle_mention($self, $json) {
  return if $self->should_ignore($json);

  my $text = $json->{text};
  $text =~ s/\s*\[\@(\d+)\|.*?\]\s*//g;
  if ($text =~ /\w/) {
    $self->handle_reply($json);
  } else {
    my $to = $json->{reply_to} ? $json->{reply_to}{id} : undef;
    # $self->like(id => $json->{id}, type => 'comment', sign => 1, delay => 1);
    $self->reply_from_list($json, $to, \@responses);
  }
}

sub handle_reply($self, $json) {
  return if $self->should_ignore($json);
  my $rand = rand(100);
  # $self->like(id => $json->{id}, type => 'comment', sign => 1, delay => 1) if $rand < ($self->{like_probability} || 50);
  $self->reply_from_list($json, $json->{id}, \@responses) if $rand < ($self->{reply_probability} || 10);
}

sub handle_post_reply($self, $json) {
  return if $self->should_ignore($json);
  $self->handle_reply($json);
}

sub handle_victim_mention($self, $json) {
  return if $self->should_ignore($json);
  # return if (rand(100) > ($self->{victim_probability} || 10));
  $self->reply_from_list($json, $json->{id}, \@victim_responses);
}

sub handle_text_match($self, $json) {
  return if $self->should_ignore($json);
  my $rand = rand(100);
  # $self->like(id => $json->{id}, type => 'comment', sign => 1, delay => 1) if $rand < 50;
  $self->reply_from_list($json, $json->{id}, \@text_match_responses) if $rand < 90;
}

1;
