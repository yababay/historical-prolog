:- module(утилиты, [
    имена_вне_базы/3,
    частотность/4,
    частотности/3
]).

:- use_module(library(pcre)).
:- use_module(library(lists)).

имена_вне_базы(Текст, Шаблоны, Имена):-
    re_foldl(добавить_слово, "[А-Я][а-я]+", Текст, [], Слова, []),
    list_to_set(Слова, Уникальные),
    уже_в_базе(Шаблоны, Уникальные, [], Имена).

уже_в_базе(_, [], Список, Выход):-
    Выход = Список,!.

уже_в_базе(Шаблоны, [Имя|Имена], Список, Выход):-
    (
        вне_шаблонов(Шаблоны, Имя) ->
        уже_в_базе(Шаблоны, Имена, [Имя|Список], Выход);
        уже_в_базе(Шаблоны, Имена, Список, Выход)
    ).

вне_шаблонов([[_, Шаблон]|_], Слово):-
    re_match(Шаблон, Слово),
    fail.

вне_шаблонов([[_, Шаблон]|Шаблоны], Слово):-
    \+ re_match(Шаблон, Слово),
    вне_шаблонов(Шаблоны, Слово).

вне_шаблонов([[_, Шаблон]], Слово):-
    \+ re_match(Шаблон, Слово),
    вне_шаблонов([], Слово).

вне_шаблонов([], _):- !.

добавить_слово(re_match{0:Имя}, Список, Вывод):-
	\+ уже_в_списке(Имя, Список),
	string_lower(Имя, Слово),
	\+ это_служебная_часть_речи(Слово),
	\+ это_местоимение(Слово),
	\+ это_числительное(Слово),
	\+ это_распространенное(Слово),
	%\+ уже_в_базе(Имя),
	добавить_слово(_, [Имя|Список], Вывод).
	%string_lower(Имя, Слово),
	%\+ это_местоимение(Слово),
	%\+ это_служебная_часть_речи(Слово),
	%\+ это_числительное(Слово),
	%это_распространенное(Слово).

добавить_слово(_, Список, Выход):- Выход = Список.

уже_в_списке(Имя, Список):-
	member(Имя, Список).

это_местоимение(Слово):-
	местоимения(Местоимения),
	member(Слово, Местоимения).

это_служебная_часть_речи(Слово):-
	служебные_части_речи(СЧР),
	member(Слово, СЧР).

это_числительное(Слово):-
	числительные(Числительные),
	member(Слово, Числительные).

это_распространенное(Слово):-
	распространенные(Распространенные),
	member(Слово, Распространенные).

это_наречие(Слово):-	
	наречия_и_предикативы(НП),
	member(Слово, НП).

%
% ==========================================
%

частотности(Текст, СловаИШаблоны, Список):-
    добавить_частотность(Текст, СловаИШаблоны, [], Список).

добавить_частотность(Текст, [[Слово, Шаблон]|СиШ], Вход, Список):-
    частотность(Текст, Слово, Шаблон, Факт),
    (
        \+ member(Факт, Вход) ->
        добавить_частотность(Текст, СиШ, [Факт|Вход], Список);
        добавить_частотность(Текст, СиШ, Вход, Список)
    ),!.

добавить_частотность(_, [], Вход, Список):-
    Список = Вход,!.

частотность(Текст, Слово, Шаблон, Факт):-
    re_foldl(increment, Шаблон, Текст, 0, Число, []),
    format(atom(Факт), "~w ~w", [Слово, Число]).

increment(_Match, V0, V1) :-
    V1 is V0+1.


служебные_части_речи([
	"а",
	"ага",
	"аж",
	"ай",
	"ах",
	"б",
	"без",
	"безо",
	"благо",
	"благодаря",
	"близ",
	"блин",
	"будто",
	"бы",
	"было",
	"в",
	"вблизи",
	"ввиду",
	"вдоль",
	"ведь",
	"включая",
	"вместо",
	"вне",
	"внутри",
	"во",
	"возле",
	"вокруг",
	"вон",
	"вообще",
	"вопреки",
	"вот",
	"впереди",
	"вроде",
	"все",
	"всего",
	"вследствие",
	"выше",
	"господи",
	"да",
	"дабы",
	"давай",
	"давайте",
	"даже",
	"де",
	"для",
	"до",
	"едва",
	"ежели",
	"если",
	"еще",
	"ж",
	"же",
	"за",
	"зато",
	"и",
	"ибо",
	"из",
	"изо",
	"или",
	"именно",
	"иначе",
	"исключительно",
	"итак",
	"к",
	"ка",
	"как",
	"ко",
	"когда",
	"коли",
	"коль",
	"конечно",
	"кроме",
	"ладно",
	"ли",
	"либо",
	"лишь",
	"лучше",
	"меж",
	"между",
	"мимо",
	"мм",
	"мол",
	"на",
	"над",
	"надо",
	"накануне",
	"напротив",
	"насчет",
	"не",
	"небось",
	"нежели",
	"нет",
	"неужели",
	"ни",
	"но",
	"ну",
	"о",
	"об",
	"обо",
	"однако",
	"ой",
	"около",
	"от",
	"относительно",
	"ох",
	"перед",
	"передо",
	"плюс",
	"по",
	"поверх",
	"под",
	"подобно",
	"пожалуйста",
	"позади",
	"пока",
	"помимо",
	"поскольку",
	"после",
	"посреди",
	"посредством",
	"прежде",
	"при",
	"притом",
	"причем",
	"про",
	"просто",
	"против",
	"прямо",
	"пускай",
	"пусть",
	"путем",
	"ради",
	"раз",
	"разве",
	"с",
	"свыше",
	"себе",
	"сквозь",
	"словно",
	"со",
	"согласно",
	"спасибо",
	"спустя",
	"среди",
	"таки",
	"там",
	"тем",
	"то",
	"только",
	"точно",
	"тьфу",
	"у",
	"увы",
	"угодно",
	"угу",
	"уж",
	"ура",
	"фон",
	"хорошо",
	"хоть",
	"хотя",
	"чем",
	"через",
	"что",
	"чтоб",
	"чтобы",
	"э",
	"эй",
	"это",
	"эх",
	"якобы"
]).

местоимения([
	"я",
	"он",
	"это",
	"она",
	"этот",
	"они",
	"мы",
	"который",
	"то",
	"свой",
	"что",
	"весь",
	"так",
	"ты",
	"все",
	"тот",
	"вы",
	"такой",
	"его",
	"себя",
	"один",
	"как",
	"сам",
	"другой",
	"наш",
	"мой",
	"кто",
	"ее",
	"где",
	"там",
	"какой",
	"их",
	"самый",
	"потом",
	"ничто",
	"сейчас",
	"тут",
	"каждый",
	"теперь",
	"тогда",
	"здесь",
	"потому",
	"всегда",
	"никто",
	"ваш",
	"почему",
	"все",
	"поэтому",
	"некоторый",
	"любой",
	"никогда",
	"оно",
	"никакой",
	"всякий",
	"твой",
	"куда",
	"иной",
	"многий",
	"зачем",
	"данный",
	"сей",
	"туда",
	"откуда",
	"сюда",
	"столь",
	"никак",
	"когда",
	"иначе",
	"многое",
	"некий",
	"что",
	"остальной",
	"прочий",
	"прочее",
	"отсюда",
	"нечто",
	"многие",
	"чей",
	"оттуда",
	"навсегда",
	"нечего",
	"таков",
	"столько",
	"никуда",
	"чего",
	"сколько",
	"каков",
	"другое",
	"остальное",
	"везде",
	"оттого",
	"таковой",
	"остальные",
	"отчего",
	"кой",
	"нигде",
	"некоторые",
	"всюду",
	"некогда",
	"свое",
	"ничуть",
	"повсюду",
	"вон",
	"нисколько",
	"се",
	"ничего",
	"этакий",
	"сколь",
	"немногий",
	"много",
	"некто"
]).

наречия_и_предикативы([
	"абсолютно",
	"автоматически",
	"аккуратно",
	"активно",
	"английски",
	"безнадежно",
	"безусловно",
	"бережно",
	"бесконечно",
	"бесплатно",
	"благополучно",
	"близко",
	"бодро",
	"более",
	"больно",
	"больше",
	"буквально",
	"бывало",
	"быстро",
	"в",
	"важно",
	"вверх",
	"вдали",
	"вдвое",
	"вдвоем",
	"вдруг",
	"вежливо",
	"вернее",
	"верно",
	"вероятно",
	"весело",
	"весьма",
	"вечно",
	"видимо",
	"видимому",
	"видно",
	"влево",
	"вместе",
	"вначале",
	"внезапно",
	"внешне",
	"вниз",
	"внизу",
	"внимательно",
	"вновь",
	"внутренне",
	"внутри",
	"внутрь",
	"во",
	"вовремя",
	"вовсе",
	"вовсю",
	"возможно",
	"вокруг",
	"вообще",
	"вот",
	"впервые",
	"вперед",
	"впереди",
	"вплотную",
	"вплоть",
	"вполне",
	"впоследствии",
	"вправду",
	"вправе",
	"вправо",
	"впрочем",
	"впрямь",
	"временно",
	"вряд",
	"всерьез",
	"вскоре",
	"вслед",
	"вслух",
	"всячески",
	"вторых",
	"втроем",
	"вчера",
	"выгодно",
	"высоко",
	"вяло",
	"главное",
	"глубоко",
	"глупо",
	"глухо",
	"говорят",
	"гораздо",
	"гордо",
	"горько",
	"горячо",
	"громко",
	"грубо",
	"грустно",
	"густо",
	"давно",
	"давным",
	"далее",
	"далеко",
	"даром",
	"дважды",
	"действительно",
	"дескать",
	"добровольно",
	"довольно",
	"долго",
	"должно",
	"дома",
	"домой",
	"дополнительно",
	"дорого",
	"достаточно",
	"достойно",
	"дружно",
	"едва",
	"единственно",
	"ежегодно",
	"ежедневно",
	"еле",
	"естественно",
	"еще",
	"жадно",
	"жалко",
	"жаль",
	"жарко",
	"желательно",
	"жестко",
	"живо",
	"заведомо",
	"завтра",
	"задолго",
	"задумчиво",
	"заметно",
	"замечательно",
	"замуж",
	"заново",
	"заодно",
	"запросто",
	"заранее",
	"затем",
	"зачастую",
	"здорово",
	"зло",
	"значит",
	"значительно",
	"зря",
	"известно",
	"издалека",
	"издали",
	"изначально",
	"изнутри",
	"изредка",
	"изрядно",
	"иногда",
	"интересно",
	"исключительно",
	"искренне",
	"испуганно",
	"кажется",
	"категорически",
	"конечно",
	"конкретно",
	"коротко",
	"крайне",
	"красиво",
	"крепко",
	"кругом",
	"круто",
	"кстати",
	"ладно",
	"ласково",
	"легко",
	"лениво",
	"лично",
	"ловко",
	"любопытно",
	"максимально",
	"мало",
	"машинально",
	"мгновенно",
	"медленно",
	"менее",
	"мимо",
	"мирно",
	"много",
	"может",
	"можно",
	"молча",
	"моментально",
	"мрачно",
	"мучительно",
	"мысленно",
	"мягко",
	"наверно",
	"наверное",
	"наверняка",
	"наверх",
	"наверху",
	"навстречу",
	"надо",
	"надолго",
	"назад",
	"наиболее",
	"наизусть",
	"накануне",
	"наконец",
	"налево",
	"намного",
	"наоборот",
	"наполовину",
	"направо",
	"напрасно",
	"например",
	"напротив",
	"напрямую",
	"нарочно",
	"наружу",
	"наряду",
	"насквозь",
	"насколько",
	"настойчиво",
	"настолько",
	"настоящему",
	"наутро",
	"небрежно",
	"неважно",
	"невероятно",
	"невозможно",
	"невольно",
	"негде",
	"негромко",
	"недавно",
	"недалеко",
	"недаром",
	"недовольно",
	"недолго",
	"недостаточно",
	"нежно",
	"независимо",
	"незадолго",
	"незаметно",
	"неизбежно",
	"неизвестно",
	"неизменно",
	"некуда",
	"нелегко",
	"неловко",
	"нельзя",
	"немедленно",
	"немного",
	"немножко",
	"ненадолго",
	"необходимо",
	"необыкновенно",
	"необычайно",
	"неоднократно",
	"неожиданно",
	"неплохо",
	"неподалеку",
	"неподвижно",
	"непонятно",
	"непосредственно",
	"неправильно",
	"непременно",
	"непрерывно",
	"неприятно",
	"нервно",
	"нередко",
	"несколько",
	"несмотря",
	"несомненно",
	"нет",
	"неторопливо",
	"нету",
	"неудобно",
	"нехорошо",
	"ниже",
	"низко",
	"нормально",
	"нужно",
	"ныне",
	"нынче",
	"обидно",
	"обратно",
	"объективно",
	"обычно",
	"обязательно",
	"одинаково",
	"однажды",
	"однако",
	"одновременно",
	"однозначно",
	"окончательно",
	"определенно",
	"опять",
	"особенно",
	"особо",
	"осторожно",
	"остро",
	"отдельно",
	"откровенно",
	"открыто",
	"отлично",
	"относительно",
	"отныне",
	"отнюдь",
	"отчасти",
	"отчаянно",
	"отчетливо",
	"официально",
	"охотно",
	"очевидно",
	"очень",
	"параллельно",
	"первоначально",
	"первых",
	"периодически",
	"печально",
	"пешком",
	"плавно",
	"плотно",
	"плохо",
	"по",
	"подробно",
	"подряд",
	"подчас",
	"пожалуй",
	"позади",
	"поздно",
	"поистине",
	"пока",
	"полно",
	"полностью",
	"поначалу",
	"понемногу",
	"понятно",
	"пополам",
	"попросту",
	"пора",
	"последовательно",
	"послушно",
	"поспешно",
	"постепенно",
	"постоянно",
	"потихоньку",
	"похоже",
	"почти",
	"правда",
	"правильно",
	"практически",
	"предварительно",
	"предельно",
	"прежде",
	"прежнему",
	"преимущественно",
	"прекрасно",
	"приблизительно",
	"привычно",
	"применительно",
	"примерно",
	"принципиально",
	"пристально",
	"приятно",
	"просто",
	"против",
	"противно",
	"прочно",
	"прочь",
	"прямо",
	"публично",
	"пусто",
	"равно",
	"равнодушно",
	"радостно",
	"разному",
	"разом",
	"разумеется",
	"ранее",
	"рано",
	"растерянно",
	"реально",
	"регулярно",
	"редко",
	"резко",
	"решительно",
	"робко",
	"ровно",
	"русски",
	"рядом",
	"самостоятельно",
	"сбоку",
	"сверху",
	"свободно",
	"сегодня",
	"сердито",
	"серьезно",
	"сзади",
	"сильно",
	"скажем",
	"скоро",
	"скромно",
	"скучно",
	"слабо",
	"слева",
	"слегка",
	"следовательно",
	"следом",
	"слишком",
	"словом",
	"сложно",
	"случайно",
	"слышно",
	"смело",
	"смешно",
	"снаружи",
	"сначала",
	"снизу",
	"снова",
	"собственно",
	"совершенно",
	"совместно",
	"совсем",
	"сознательно",
	"соответственно",
	"спасибо",
	"сперва",
	"специально",
	"сплошь",
	"спокойно",
	"справа",
	"справедливо",
	"сравнительно",
	"сразу",
	"срочно",
	"старательно",
	"странно",
	"страшно",
	"стремительно",
	"строго",
	"стыдно",
	"сугубо",
	"сухо",
	"существенно",
	"счастливо",
	"также",
	"таки",
	"твердо",
	"темно",
	"теоретически",
	"тепло",
	"терпеливо",
	"тесно",
	"тихо",
	"тихонько",
	"тоже",
	"толком",
	"торжественно",
	"торопливо",
	"тотчас",
	"точно",
	"традиционно",
	"третьих",
	"трижды",
	"трудно",
	"туго",
	"тщательно",
	"тяжело",
	"убедительно",
	"уверенно",
	"угодно",
	"удачно",
	"удивительно",
	"удивленно",
	"удобно",
	"уж",
	"ужасно",
	"уже",
	"умело",
	"упорно",
	"условно",
	"успешно",
	"устало",
	"фактически",
	"физически",
	"формально",
	"холодно",
	"хорошо",
	"целиком",
	"частично",
	"часто",
	"чересчур",
	"честно",
	"четко",
	"чисто",
	"чрезвычайно",
	"чуть",
	"шепотом",
	"широко",
	"шумно",
	"эффективно",
	"явно",
	"ярко",
	"ясно"
]).

числительные([
	"более",
	"больше",
	"восемнадцатый",
	"восемнадцать",
	"восемь",
	"восемьдесят",
	"восемьсот",
	"восьмеро",
	"восьмидесятый",
	"восьмой",
	"второй",
	"два",
	"двадцатый",
	"двадцать",
	"двенадцатый",
	"двенадцать",
	"двести",
	"двое",
	"девяносто",
	"девяностый",
	"девятнадцатый",
	"девятнадцать",
	"девятый",
	"девять",
	"девятьсот",
	"десятеро",
	"десятый",
	"десять",
	"мало",
	"меньше",
	"много",
	"немало",
	"немного",
	"немножко",
	"несколько",
	"оба",
	"обоего",
	"один",
	"одиннадцатый",
	"одиннадцать",
	"первый",
	"пол",
	"полста",
	"полтора",
	"полтораста",
	"пятеро",
	"пятидесятый",
	"пятнадцатый",
	"пятнадцать",
	"пятый",
	"пять",
	"пятьдесят",
	"пятьсот",
	"седьмой",
	"семеро",
	"семидесятый",
	"семнадцатый",
	"семнадцать",
	"семь",
	"семьдесят",
	"семьсот",
	"сколько",
	"сорок",
	"сороковой",
	"сотый",
	"сто",
	"столько",
	"третий",
	"три",
	"тридевять",
	"тридцатый",
	"тридцать",
	"тринадцатый",
	"тринадцать",
	"триста",
	"трое",
	"четверо",
	"четвертый",
	"четыре",
	"четыреста",
	"четырнадцатый",
	"четырнадцать",
	"шестеро",
	"шестидесятый",
	"шестисотый",
	"шестнадцатый",
	"шестнадцать",
	"шестой",
	"шесть",
	"шестьдесят",
	"шестьсот"
]).

% существительные
распространенные([
	"автобус",
	"автомат",
	"автомобиль",
	"автор",
	"администрация",
	"адрес",
	"академия",
	"акт",
	"актер",
	"активность",
	"акция",
	"американец",
	"анализ",
	"аппарат",
	"апрель",
	"армия",
	"артист",
	"атмосфера",
	"баба",
	"бабушка",
	"база",
	"банк",
	"беда",
	"безопасность",
	"берег",
	"беседа",
	"библиотека",
	"бизнес",
	"билет",
	"блок",
	"бог",
	"бой",
	"бок",
	"болезнь",
	"боль",
	"больница",
	"больной",
	"большинство",
	"борьба",
	"брак",
	"брат",
	"будущее",
	"буква",
	"бумага",
	"бутылка",
	"бюджет",
	"вагон",
	"вариант",
	"век",
	"величина",
	"вера",
	"версия",
	"вершина",
	"вес",
	"весна",
	"ветер",
	"вечер",
	"вещество",
	"вещь",
	"взаимодействие",
	"взгляд",
	"взрыв",
	"вид",
	"вина",
	"вино",
	"вирус",
	"вкус",
	"владелец",
	"власть",
	"влияние",
	"внимание",
	"вода",
	"водитель",
	"водка",
	"возвращение",
	"воздействие",
	"воздух",
	"возможность",
	"возраст",
	"война",
	"войско",
	"волна",
	"волос",
	"воля",
	"вопрос",
	"ворота",
	"воспитание",
	"воспоминание",
	"восток",
	"восторг",
	"впечатление",
	"враг",
	"врач",
	"время",
	"встреча",
	"вход",
	"выбор",
	"выборы",
	"вывод",
	"выполнение",
	"выпуск",
	"выражение",
	"высота",
	"выставка",
	"выступление",
	"выход",
	"газ",
	"газета",
	"генерал",
	"герой",
	"глава",
	"главное",
	"глаз",
	"глубина",
	"год",
	"голова",
	"голос",
	"гора",
	"горло",
	"город",
	"господин",
	"господь",
	"гостиница",
	"гость",
	"государство",
	"гражданин",
	"граница",
	"грех",
	"грудь",
	"группа",
	"губа",
	"губернатор",
	"давление",
	"дама",
	"данные",
	"дача",
	"дверь",
	"двигатель",
	"движение",
	"двор",
	"дворец",
	"девочка",
	"девушка",
	"дед",
	"действие",
	"действительность",
	"декабрь",
	"дело",
	"день",
	"деньги",
	"депутат",
	"деревня",
	"дерево",
	"десяток",
	"деталь",
	"детство",
	"деятельность",
	"диван",
	"директор",
	"длина",
	"дно",
	"добро",
	"договор",
	"дождь",
	"доказательство",
	"доклад",
	"доктор",
	"документ",
	"долг",
	"должность",
	"доллар",
	"доля",
	"дом",
	"дорога",
	"доска",
	"достижение",
	"достоинство",
	"доход",
	"дочка",
	"дочь",
	"друг",
	"дружба",
	"дума",
	"дурак",
	"дух",
	"душа",
	"дым",
	"дыхание",
	"дядя",
	"еврей",
	"еда",
	"единица",
	"желание",
	"жена",
	"женщина",
	"жертва",
	"живот",
	"животное",
	"жизнь",
	"жилье",
	"житель",
	"журнал",
	"журналист",
	"забота",
	"зависимость",
	"завод",
	"задача",
	"заказ",
	"заключение",
	"закон",
	"законодательство",
	"зал",
	"заместитель",
	"замок",
	"занятие",
	"запад",
	"запас",
	"запах",
	"записка",
	"запись",
	"зарплата",
	"заседание",
	"затрата",
	"защита",
	"заявление",
	"звезда",
	"звонок",
	"звук",
	"здание",
	"здоровье",
	"земля",
	"зеркало",
	"зима",
	"зло",
	"знак",
	"знакомый",
	"знание",
	"значение",
	"золото",
	"зона",
	"зрение",
	"зритель",
	"зуб",
	"игра",
	"идея",
	"известие",
	"издание",
	"изменение",
	"изображение",
	"изучение",
	"имущество",
	"имя",
	"инженер",
	"инициатива",
	"институт",
	"инструмент",
	"интерес",
	"информация",
	"исключение",
	"искусство",
	"исполнение",
	"использование",
	"испытание",
	"исследование",
	"история",
	"источник",
	"итог",
	"июль",
	"июнь",
	"кабинет",
	"кадр",
	"камень",
	"камера",
	"канал",
	"кандидат",
	"капитал",
	"капитан",
	"карман",
	"карта",
	"картина",
	"категория",
	"качество",
	"квартира",
	"километр",
	"кино",
	"класс",
	"клетка",
	"клиент",
	"клуб",
	"ключ",
	"книга",
	"книжка",
	"князь",
	"кодекс",
	"кожа",
	"колено",
	"колесо",
	"количество",
	"коллега",
	"коллектив",
	"кольцо",
	"команда",
	"командир",
	"комиссия",
	"комитет",
	"коммунист",
	"комната",
	"компания",
	"комплекс",
	"компьютер",
	"конец",
	"конкурс",
	"конструкция",
	"контакт",
	"контроль",
	"конференция",
	"конфликт",
	"концепция",
	"концерт",
	"корабль",
	"корень",
	"коридор",
	"король",
	"корпус",
	"кость",
	"костюм",
	"кофе",
	"край",
	"краска",
	"красота",
	"кредит",
	"кресло",
	"крест",
	"кризис",
	"крик",
	"кровать",
	"кровь",
	"круг",
	"крыло",
	"крыша",
	"кулак",
	"культура",
	"курс",
	"кусок",
	"куст",
	"кухня",
	"лагерь",
	"ладонь",
	"лев",
	"лед",
	"лейтенант",
	"лес",
	"лестница",
	"лето",
	"лидер",
	"линия",
	"лист",
	"литература",
	"лицо",
	"личность",
	"лоб",
	"лодка",
	"лошадь",
	"любовь",
	"магазин",
	"май",
	"майор",
	"мальчик",
	"мальчишка",
	"мама",
	"март",
	"масло",
	"масса",
	"мастер",
	"масштаб",
	"материал",
	"мать",
	"машина",
	"мгновение",
	"мера",
	"мероприятие",
	"место",
	"месяц",
	"металл",
	"метод",
	"метр",
	"механизм",
	"мечта",
	"мешок",
	"миг",
	"милиция",
	"миллион",
	"министерство",
	"министр",
	"минута",
	"мир",
	"мнение",
	"множество",
	"модель",
	"мозг",
	"молодежь",
	"молоко",
	"момент",
	"монастырь",
	"море",
	"москвич",
	"мост",
	"мощность",
	"муж",
	"мужик",
	"мужчина",
	"музей",
	"музыка",
	"мысль",
	"мясо",
	"наблюдение",
	"набор",
	"надежда",
	"название",
	"назначение",
	"наличие",
	"налог",
	"направление",
	"народ",
	"нарушение",
	"население",
	"настроение",
	"наука",
	"начало",
	"начальник",
	"начальство",
	"небо",
	"неделя",
	"недостаток",
	"немец",
	"необходимость",
	"нефть",
	"новость",
	"нога",
	"нож",
	"номер",
	"норма",
	"нос",
	"ночь",
	"ноябрь",
	"обед",
	"обеспечение",
	"область",
	"оборона",
	"оборудование",
	"обработка",
	"образ",
	"образец",
	"образование",
	"обращение",
	"обстановка",
	"обстоятельство",
	"обучение",
	"общение",
	"общество",
	"объединение",
	"объект",
	"объем",
	"объяснение",
	"обязанность",
	"обязательство",
	"огонь",
	"одежда",
	"ожидание",
	"озеро",
	"окно",
	"окончание",
	"округ",
	"октябрь",
	"опасность",
	"операция",
	"описание",
	"оплата",
	"определение",
	"опыт",
	"орган",
	"организация",
	"организм",
	"оружие",
	"осень",
	"основа",
	"основание",
	"основное",
	"особенность",
	"остаток",
	"остров",
	"ответ",
	"ответственность",
	"отдел",
	"отделение",
	"отдых",
	"отец",
	"отказ",
	"открытие",
	"отличие",
	"отношение",
	"отрасль",
	"отсутствие",
	"офицер",
	"охрана",
	"оценка",
	"очередь",
	"очки",
	"ошибка",
	"ощущение",
	"пакет",
	"палата",
	"палец",
	"памятник",
	"память",
	"папа",
	"пара",
	"параметр",
	"парень",
	"парк",
	"партия",
	"партнер",
	"пенсия",
	"перевод",
	"переговоры",
	"передача",
	"переход",
	"период",
	"перспектива",
	"песня",
	"песок",
	"печать",
	"пиво",
	"писатель",
	"пистолет",
	"письмо",
	"план",
	"плата",
	"платье",
	"плечо",
	"площадка",
	"площадь",
	"победа",
	"поведение",
	"поверхность",
	"повод",
	"поворот",
	"повышение",
	"подарок",
	"подготовка",
	"поддержка",
	"подразделение",
	"подруга",
	"подход",
	"подъезд",
	"поезд",
	"поездка",
	"позиция",
	"поиск",
	"показатель",
	"покой",
	"поколение",
	"покупатель",
	"пол",
	"поле",
	"полет",
	"политика",
	"полковник",
	"половина",
	"положение",
	"полоса",
	"получение",
	"польза",
	"помещение",
	"помощник",
	"помощь",
	"понимание",
	"понятие",
	"попытка",
	"пора",
	"порог",
	"портрет",
	"порядок",
	"поселок",
	"последствие",
	"пост",
	"постановление",
	"постель",
	"потеря",
	"поток",
	"потолок",
	"потребность",
	"почва",
	"поэзия",
	"поэт",
	"появление",
	"правда",
	"правило",
	"правительство",
	"право",
	"праздник",
	"практика",
	"предел",
	"предложение",
	"предмет",
	"предприятие",
	"председатель",
	"представитель",
	"представление",
	"президент",
	"премия",
	"препарат",
	"преступление",
	"прием",
	"признак",
	"признание",
	"приказ",
	"применение",
	"пример",
	"принцип",
	"принятие",
	"природа",
	"присутствие",
	"причина",
	"приятель",
	"проблема",
	"проведение",
	"проверка",
	"программа",
	"продажа",
	"продукт",
	"продукция",
	"проект",
	"произведение",
	"производитель",
	"производство",
	"прокурор",
	"промышленность",
	"пространство",
	"просьба",
	"противник",
	"профессия",
	"профессор",
	"процедура",
	"процент",
	"процесс",
	"прошлое",
	"психология",
	"птица",
	"публика",
	"пункт",
	"путь",
	"пыль",
	"пьеса",
	"работа",
	"работник",
	"рабочий",
	"радость",
	"раз",
	"развитие",
	"разговор",
	"размер",
	"разница",
	"разработка",
	"разрешение",
	"район",
	"ракета",
	"рамка",
	"рассказ",
	"рассмотрение",
	"расстояние",
	"растение",
	"расход",
	"расчет",
	"реакция",
	"реализация",
	"реальность",
	"ребенок",
	"ребята",
	"революция",
	"регион",
	"редактор",
	"редакция",
	"режим",
	"режиссер",
	"результат",
	"река",
	"реклама",
	"ремонт",
	"республика",
	"ресторан",
	"ресурс",
	"реформа",
	"речь",
	"решение",
	"риск",
	"рисунок",
	"род",
	"родина",
	"родитель",
	"родственник",
	"рождение",
	"роль",
	"роман",
	"рост",
	"рот",
	"рубеж",
	"рубль",
	"рука",
	"руководитель",
	"руководство",
	"русский",
	"ручка",
	"рыба",
	"рынок",
	"ряд",
	"сад",
	"самолет",
	"сапог",
	"сбор",
	"сведение",
	"свет",
	"свидетель",
	"свобода",
	"свойство",
	"связь",
	"сделка",
	"сезон",
	"секретарь",
	"секунда",
	"село",
	"семья",
	"сентябрь",
	"сердце",
	"середина",
	"серия",
	"сестра",
	"сеть",
	"сигарета",
	"сигнал",
	"сила",
	"система",
	"ситуация",
	"сказка",
	"скорость",
	"слава",
	"след",
	"следователь",
	"следствие",
	"слеза",
	"слово",
	"слой",
	"служба",
	"слух",
	"случай",
	"смена",
	"смерть",
	"смех",
	"смысл",
	"снег",
	"снижение",
	"собака",
	"собрание",
	"собственность",
	"событие",
	"совесть",
	"совет",
	"соглашение",
	"содержание",
	"соединение",
	"сожаление",
	"создание",
	"сознание",
	"солдат",
	"солнце",
	"сомнение",
	"сон",
	"сообщение",
	"соответствие",
	"сосед",
	"состав",
	"состояние",
	"сотня",
	"сотрудник",
	"сотрудничество",
	"сочинение",
	"союз",
	"спектакль",
	"специалист",
	"спина",
	"список",
	"спор",
	"спорт",
	"способ",
	"способность",
	"сравнение",
	"среда",
	"средство",
	"срок",
	"ставка",
	"стакан",
	"станция",
	"старик",
	"старуха",
	"статус",
	"статья",
	"стекло",
	"стена",
	"степень",
	"стиль",
	"стихи",
	"стоимость",
	"стол",
	"столик",
	"столица",
	"сторона",
	"страна",
	"страница",
	"страсть",
	"страх",
	"строительство",
	"строй",
	"строка",
	"структура",
	"студент",
	"стул",
	"субъект",
	"суд",
	"судьба",
	"судья",
	"сумка",
	"сумма",
	"сутки",
	"суть",
	"существо",
	"существование",
	"сущность",
	"сфера",
	"схема",
	"сцена",
	"счастье",
	"счет",
	"сын",
	"сюжет",
	"таблица",
	"тайна",
	"талант",
	"танец",
	"танк",
	"творчество",
	"театр",
	"текст",
	"телевизор",
	"телефон",
	"тело",
	"тема",
	"темнота",
	"температура",
	"тенденция",
	"тень",
	"теория",
	"территория",
	"тетя",
	"техника",
	"технология",
	"течение",
	"тип",
	"тишина",
	"товар",
	"товарищ",
	"толпа",
	"том",
	"тон",
	"торговля",
	"точка",
	"трава",
	"традиция",
	"транспорт",
	"требование",
	"труба",
	"трубка",
	"труд",
	"тысяча",
	"тюрьма",
	"убийство",
	"увеличение",
	"угол",
	"угроза",
	"удар",
	"удивление",
	"удовольствие",
	"ужас",
	"указание",
	"улица",
	"улыбка",
	"ум",
	"университет",
	"управление",
	"уровень",
	"урок",
	"усилие",
	"условие",
	"услуга",
	"успех",
	"установка",
	"устройство",
	"утро",
	"ухо",
	"уход",
	"участие",
	"участник",
	"участок",
	"ученик",
	"ученый",
	"учет",
	"учитель",
	"учреждение",
	"факт",
	"фактор",
	"фамилия",
	"февраль",
	"федерация",
	"фигура",
	"философия",
	"фильм",
	"фирма",
	"фон",
	"фонд",
	"форма",
	"формирование",
	"формула",
	"фотография",
	"фраза",
	"фронт",
	"функция",
	"характер",
	"характеристика",
	"хвост",
	"хлеб",
	"ход",
	"хозяин",
	"хозяйка",
	"хозяйство",
	"храм",
	"художник",
	"царь",
	"цвет",
	"цветок",
	"целое",
	"цель",
	"цена",
	"ценность",
	"центр",
	"церковь",
	"цифра",
	"чай",
	"час",
	"частность",
	"часть",
	"часы",
	"человек",
	"человечество",
	"чемпионат",
	"черт",
	"черта",
	"честь",
	"чиновник",
	"число",
	"читатель",
	"член",
	"чтение",
	"чувство",
	"чудо",
	"шаг",
	"шанс",
	"шея",
	"школа",
	"штаб",
	"штат",
	"штука",
	"шум",
	"шутка",
	"щека",
	"экономика",
	"экран",
	"эксперимент",
	"эксперт",
	"эксплуатация",
	"элемент",
	"энергия",
	"эпоха",
	"этаж",
	"этап",
	"эффект",
	"эффективность",
	"яблоко",
	"явление",
	"язык",
	"январь",
	"ящик",
% прилагательные
	"абсолютный",
	"абстрактный",
	"авиационный",
	"автоматический",
	"автомобильный",
	"автономный",
	"авторский",
	"агрессивный",
	"адекватный",
	"административный",
	"академический",
	"аккуратный",
	"актерский",
	"активный",
	"актуальный",
	"акционерный",
	"альтернативный",
	"алюминиевый",
	"американский",
	"аналитический",
	"аналогичный",
	"английский",
	"арабский",
	"арбитражный",
	"армейский",
	"архитектурный",
	"атомный",
	"базовый",
	"банковский",
	"бедный",
	"безопасный",
	"безумный",
	"белорусский",
	"белый",
	"беременный",
	"бесконечный",
	"бесплатный",
	"бесполезный",
	"бессмысленный",
	"бетонный",
	"бешеный",
	"биологический",
	"благодарный",
	"благополучный",
	"благоприятный",
	"благородный",
	"блаженный",
	"бледный",
	"блестящий",
	"ближайший",
	"ближний",
	"близкий",
	"богатый",
	"боевой",
	"божественный",
	"божий",
	"боковой",
	"болезненный",
	"больничный",
	"больной",
	"больший",
	"большой",
	"босой",
	"британский",
	"бронзовый",
	"будущий",
	"бумажный",
	"бурный",
	"бывший",
	"былой",
	"быстрый",
	"бытовой",
	"бюджетный",
	"важнейший",
	"важный",
	"валютный",
	"ведущий",
	"великий",
	"великолепный",
	"величайший",
	"верный",
	"вероятный",
	"вертикальный",
	"верхний",
	"верховный",
	"веселый",
	"весенний",
	"ветхий",
	"вечерний",
	"вечный",
	"взаимный",
	"взрослый",
	"видимый",
	"видный",
	"виноватый",
	"вирусный",
	"вкусный",
	"влажный",
	"властный",
	"внезапный",
	"внешний",
	"внимательный",
	"внутренний",
	"водный",
	"военный",
	"воздушный",
	"возможный",
	"возрастной",
	"воинский",
	"волшебный",
	"вольный",
	"вооруженный",
	"восточный",
	"вредный",
	"временной",
	"всевозможный",
	"всемирный",
	"всеобщий",
	"всероссийский",
	"встречный",
	"всяческий",
	"вторичный",
	"входной",
	"вчерашний",
	"выгодный",
	"выдающийся",
	"вынужденный",
	"высокий",
	"высший",
	"выходной",
	"газетный",
	"газовый",
	"генеральный",
	"генетический",
	"гениальный",
	"географический",
	"геологический",
	"германский",
	"героический",
	"гибкий",
	"гигантский",
	"главный",
	"гладкий",
	"глобальный",
	"глубокий",
	"глупый",
	"глухой",
	"годовой",
	"головной",
	"голодный",
	"голубой",
	"голый",
	"гордый",
	"горный",
	"городской",
	"горький",
	"горячий",
	"государственный",
	"готовый",
	"гражданский",
	"грамотный",
	"грандиозный",
	"греческий",
	"грозный",
	"громадный",
	"громкий",
	"грубый",
	"грузинский",
	"грузовой",
	"грустный",
	"грядущий",
	"грязный",
	"гуманитарный",
	"густой",
	"давний",
	"далекий",
	"дальнейший",
	"дальний",
	"двойной",
	"дежурный",
	"действительный",
	"действующий",
	"декоративный",
	"деловой",
	"демократический",
	"денежный",
	"деревенский",
	"деревянный",
	"детский",
	"дешевый",
	"дикий",
	"дипломатический",
	"длинный",
	"длительный",
	"дневной",
	"добровольный",
	"добрый",
	"довольный",
	"долгий",
	"долгосрочный",
	"должен",
	"должностной",
	"должный",
	"домашний",
	"дополнительный",
	"дорогой",
	"дорожный",
	"достаточный",
	"достоверный",
	"достойный",
	"доступный",
	"драгоценный",
	"драматический",
	"древний",
	"дружеский",
	"дурацкий",
	"дурной",
	"духовный",
	"душевный",
	"еврейский",
	"европейский",
	"единственный",
	"единый",
	"ежегодный",
	"ежедневный",
	"естественный",
	"жалкий",
	"жаркий",
	"железнодорожный",
	"железный",
	"желтый",
	"женатый",
	"женский",
	"жесткий",
	"жестокий",
	"живой",
	"животный",
	"жидкий",
	"жизненный",
	"жилищный",
	"жилой",
	"жирный",
	"жуткий",
	"забавный",
	"заводской",
	"загадочный",
	"заданный",
	"задний",
	"заинтересованный",
	"законный",
	"законодательный",
	"закрытый",
	"заметный",
	"замечательный",
	"занятый",
	"западный",
	"запасной",
	"заработный",
	"зарубежный",
	"защитный",
	"звездный",
	"здешний",
	"здоровый",
	"здравый",
	"зеленый",
	"земельный",
	"земной",
	"зенитный",
	"зимний",
	"злой",
	"знакомый",
	"знаменитый",
	"значимый",
	"значительный",
	"золотой",
	"зрительный",
	"идеальный",
	"идеологический",
	"избирательный",
	"известный",
	"излишний",
	"израильский",
	"изящный",
	"импортный",
	"инвестиционный",
	"индивидуальный",
	"индийский",
	"инженерный",
	"иностранный",
	"интеллектуальный",
	"интеллигентный",
	"интенсивный",
	"интересный",
	"интимный",
	"информационный",
	"иркутский",
	"исключительный",
	"искренний",
	"искусственный",
	"испанский",
	"исполнительный",
	"истинный",
	"исторический",
	"исходный",
	"итальянский",
	"кавказский",
	"кадровый",
	"казенный",
	"каменный",
	"капитальный",
	"качественный",
	"квадратный",
	"киевский",
	"кирпичный",
	"китайский",
	"классический",
	"классный",
	"клинический",
	"ключевой",
	"книжный",
	"кожаный",
	"количественный",
	"коллективный",
	"колоссальный",
	"колючий",
	"командный",
	"коммерческий",
	"коммунальный",
	"коммунистический",
	"комплексный",
	"компьютерный",
	"комсомольский",
	"конечный",
	"конкретный",
	"конституционный",
	"конструктивный",
	"контрольный",
	"коренной",
	"коричневый",
	"королевский",
	"короткий",
	"корпоративный",
	"космический",
	"крайний",
	"красивый",
	"красный",
	"краткий",
	"кредитный",
	"кремлевский",
	"крепкий",
	"крестьянский",
	"кривой",
	"криминальный",
	"критический",
	"кровавый",
	"крохотный",
	"крошечный",
	"круглый",
	"крупнейший",
	"крупный",
	"крутой",
	"культурный",
	"лагерный",
	"ласковый",
	"латинский",
	"левый",
	"легендарный",
	"легкий",
	"ледяной",
	"лекарственный",
	"ленинградский",
	"ленинский",
	"лесной",
	"летний",
	"либеральный",
	"линейный",
	"литературный",
	"личной",
	"личный",
	"лишний",
	"логический",
	"ложный",
	"локальный",
	"лошадиный",
	"лунный",
	"лучший",
	"лысый",
	"любимый",
	"любовный",
	"любопытный",
	"людской",
	"люсин",
	"магнитный",
	"максимальный",
	"малейший",
	"маленький",
	"малый",
	"мамин",
	"массовый",
	"математический",
	"материальный",
	"материнский",
	"медицинский",
	"медленный",
	"медный",
	"международный",
	"мелкий",
	"меньший",
	"мертвый",
	"местный",
	"металлический",
	"металлургический",
	"механический",
	"милицейский",
	"милый",
	"минеральный",
	"минимальный",
	"минувший",
	"мирный",
	"мировой",
	"младший",
	"многолетний",
	"многочисленный",
	"мобильный",
	"могучий",
	"модный",
	"мокрый",
	"молодежный",
	"молоденький",
	"молодой",
	"молочный",
	"молчаливый",
	"моральный",
	"морской",
	"московский",
	"мощный",
	"мрачный",
	"мудрый",
	"мужской",
	"музыкальный",
	"муниципальный",
	"мутный",
	"мучительный",
	"мягкий",
	"мясной",
	"надежный",
	"наибольший",
	"наивный",
	"налоговый",
	"намерен",
	"напряженный",
	"народный",
	"наружный",
	"настоящий",
	"натуральный",
	"научно",
	"научный",
	"национальный",
	"начальный",
	"небесный",
	"небольшой",
	"неведомый",
	"неверный",
	"невероятный",
	"невидимый",
	"невинный",
	"невозможный",
	"невысокий",
	"негативный",
	"недавний",
	"недовольный",
	"недостаточный",
	"недоступный",
	"нежный",
	"независимый",
	"незаконный",
	"незнакомый",
	"незначительный",
	"неизбежный",
	"неизвестный",
	"неизменный",
	"нелегкий",
	"нелепый",
	"немалый",
	"немецкий",
	"немыслимый",
	"ненужный",
	"необходимый",
	"необыкновенный",
	"необычный",
	"неожиданный",
	"неплохой",
	"неподвижный",
	"непонятный",
	"непосредственный",
	"неправильный",
	"непрерывный",
	"неприятный",
	"непростой",
	"нервный",
	"несчастный",
	"неудачный",
	"нефтяной",
	"нехороший",
	"неясный",
	"нижний",
	"низкий",
	"ничтожный",
	"новейший",
	"новенький",
	"новогодний",
	"новый",
	"нормальный",
	"нормативный",
	"ночной",
	"нравственный",
	"нужный",
	"нынешний",
	"областной",
	"оборонный",
	"образованный",
	"образовательный",
	"обратный",
	"обширный",
	"общественный",
	"общий",
	"объективный",
	"обыкновенный",
	"обычный",
	"обязанный",
	"обязательный",
	"огненный",
	"ограниченный",
	"огромный",
	"одетый",
	"одинаковый",
	"одинокий",
	"окончательный",
	"окружающий",
	"октябрьский",
	"олимпийский",
	"опасный",
	"оперативный",
	"определенный",
	"оптимальный",
	"опытный",
	"оранжевый",
	"организационный",
	"организованный",
	"органический",
	"оригинальный",
	"осенний",
	"основной",
	"особенный",
	"особый",
	"осторожный",
	"острый",
	"ответный",
	"ответственный",
	"отвратительный",
	"отдаленный",
	"отдельный",
	"отечественный",
	"откровенный",
	"открытый",
	"отличный",
	"относительный",
	"отрицательный",
	"отчаянный",
	"офицерский",
	"официальный",
	"очевидный",
	"очередной",
	"парадный",
	"параллельный",
	"парижский",
	"парламентский",
	"партийный",
	"педагогический",
	"пенсионный",
	"первичный",
	"первоначальный",
	"передний",
	"передовой",
	"пермский",
	"персональный",
	"перспективный",
	"пестрый",
	"петербургский",
	"печальный",
	"печатный",
	"письменный",
	"питерский",
	"пищевой",
	"пластиковый",
	"плоский",
	"плотный",
	"плохой",
	"поверхностный",
	"повседневный",
	"повышенный",
	"пограничный",
	"подводный",
	"подземный",
	"подлинный",
	"подмосковный",
	"подобный",
	"подозрительный",
	"подробный",
	"подходящий",
	"пожарный",
	"пожилой",
	"поздний",
	"позитивный",
	"покойный",
	"полевой",
	"полезный",
	"политический",
	"полноценный",
	"полный",
	"половой",
	"положенный",
	"положительный",
	"польский",
	"понятный",
	"популярный",
	"поразительный",
	"порядочный",
	"послевоенный",
	"последний",
	"последовательный",
	"последующий",
	"посторонний",
	"постоянный",
	"потенциальный",
	"потребительский",
	"похожий",
	"почетный",
	"почтовый",
	"поэтический",
	"правильный",
	"правительственный",
	"правовой",
	"правоохранительный",
	"православный",
	"правый",
	"праздничный",
	"практический",
	"предварительный",
	"предвыборный",
	"предельный",
	"предстоящий",
	"предыдущий",
	"прежний",
	"президентский",
	"прекрасный",
	"преподобный",
	"престижный",
	"преступный",
	"привлекательный",
	"привычный",
	"прикладной",
	"приличный",
	"примитивный",
	"принципиальный",
	"принятый",
	"природный",
	"присущий",
	"приятный",
	"провинциальный",
	"программный",
	"прогрессивный",
	"прозрачный",
	"производственный",
	"проклятый",
	"промежуточный",
	"промышленный",
	"простой",
	"просторный",
	"пространственный",
	"противный",
	"противоположный",
	"профессиональный",
	"прохладный",
	"процентный",
	"процессуальный",
	"прочный",
	"прошедший",
	"прошлый",
	"прямой",
	"психический",
	"психологический",
	"публичный",
	"пустой",
	"пустынный",
	"пушкинский",
	"пыльный",
	"пышный",
	"пьяный",
	"рабочий",
	"равнодушный",
	"равный",
	"рад",
	"радикальный",
	"радостный",
	"развитой",
	"различный",
	"разнообразный",
	"разноцветный",
	"разный",
	"разумный",
	"районный",
	"ракетный",
	"ранний",
	"растительный",
	"рациональный",
	"реальный",
	"революционный",
	"региональный",
	"регулярный",
	"редкий",
	"резиновый",
	"резкий",
	"рекламный",
	"религиозный",
	"решающий",
	"решительный",
	"римский",
	"ровный",
	"родительский",
	"родной",
	"розовый",
	"роковой",
	"романтический",
	"роскошный",
	"российский",
	"русский",
	"ручной",
	"рыбный",
	"рыжий",
	"рыночный",
	"рядовой",
	"садовый",
	"самарский",
	"самостоятельный",
	"саратовский",
	"свежий",
	"светлый",
	"светский",
	"свободный",
	"своеобразный",
	"свойственный",
	"связанный",
	"святой",
	"священный",
	"северный",
	"сегодняшний",
	"седой",
	"секретный",
	"сексуальный",
	"сельский",
	"сельскохозяйственный",
	"семейный",
	"сердечный",
	"серебряный",
	"серый",
	"серьезный",
	"сибирский",
	"силовой",
	"сильный",
	"симпатичный",
	"синий",
	"системный",
	"сказочный",
	"склонный",
	"скорый",
	"скромный",
	"скрытый",
	"скучный",
	"слабый",
	"славный",
	"славянский",
	"сладкий",
	"следственный",
	"следующий",
	"слепой",
	"сложный",
	"служебный",
	"случайный",
	"слышный",
	"смелый",
	"смертельный",
	"смертный",
	"смешной",
	"смутный",
	"снежный",
	"собачий",
	"собственный",
	"совершенный",
	"советский",
	"совместный",
	"современный",
	"согласный",
	"сознательный",
	"солдатский",
	"соленый",
	"солидный",
	"солнечный",
	"сомнительный",
	"сонный",
	"соответствующий",
	"соседний",
	"социалистический",
	"социально",
	"социальный",
	"специализированный",
	"специальный",
	"специфический",
	"сплошной",
	"спокойный",
	"спортивный",
	"способный",
	"справедливый",
	"сравнительный",
	"средневековый",
	"средний",
	"срочный",
	"стабильный",
	"сталинский",
	"стальной",
	"стандартный",
	"старинный",
	"старший",
	"старый",
	"статистический",
	"стеклянный",
	"столичный",
	"столовый",
	"странный",
	"страстный",
	"стратегический",
	"страховой",
	"страшный",
	"строгий",
	"строительный",
	"стройный",
	"структурный",
	"студенческий",
	"субъективный",
	"судебный",
	"сумасшедший",
	"суровый",
	"сухой",
	"существенный",
	"существующий",
	"сходный",
	"счастливый",
	"сырой",
	"сытый",
	"таинственный",
	"тайный",
	"талантливый",
	"таможенный",
	"татарский",
	"твердый",
	"тверской",
	"творческий",
	"театральный",
	"текущий",
	"телевизионный",
	"телефонный",
	"темный",
	"теоретический",
	"тепловой",
	"теплый",
	"территориальный",
	"тесный",
	"технический",
	"технологический",
	"типичный",
	"тихий",
	"товарный",
	"тогдашний",
	"толстый",
	"тоненький",
	"тонкий",
	"торговый",
	"торжественный",
	"точный",
	"трагический",
	"традиционный",
	"транспортный",
	"тревожный",
	"трезвый",
	"трудный",
	"трудовой",
	"тупой",
	"турецкий",
	"тюремный",
	"тяжелый",
	"тяжкий",
	"убедительный",
	"убежденный",
	"уважаемый",
	"уверенный",
	"уголовный",
	"ударный",
	"удачный",
	"удивительный",
	"удобный",
	"ужасный",
	"узкий",
	"указанный",
	"украинский",
	"уличный",
	"умный",
	"умственный",
	"универсальный",
	"уникальный",
	"управляющий",
	"условный",
	"успешный",
	"усталый",
	"установленный",
	"устойчивый",
	"утренний",
	"учебный",
	"ученый",
	"уютный",
	"фактический",
	"фантастический",
	"федеральный",
	"физический",
	"философский",
	"финансовый",
	"финский",
	"фирменный",
	"формальный",
	"французский",
	"фундаментальный",
	"функциональный",
	"футбольный",
	"характерный",
	"химический",
	"хитрый",
	"хозяйственный",
	"холодный",
	"хороший",
	"христианский",
	"христов",
	"хрупкий",
	"художественный",
	"худой",
	"худший",
	"царский",
	"цветной",
	"целевой",
	"целый",
	"ценный",
	"центральный",
	"церковный",
	"цивилизованный",
	"чайный",
	"частный",
	"частый",
	"человеческий",
	"черный",
	"честный",
	"четкий",
	"чеченский",
	"чистый",
	"чрезвычайный",
	"чудесный",
	"чудовищный",
	"чуждый",
	"чужой",
	"шахматный",
	"шелковый",
	"широкий",
	"школьный",
	"шумный",
	"экологический",
	"экономический",
	"экспериментальный",
	"экспертный",
	"электрический",
	"электронный",
	"элементарный",
	"эмоциональный",
	"энергетический",
	"энергичный",
	"эстетический",
	"этнический",
	"эффективный",
	"южный",
	"юный",
	"юридический",
	"явный",
	"ядерный",
	"японский",
	"яркий",
	"ясный"
]).
