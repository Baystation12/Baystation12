
/obj/overmap/visitable/sector/miningpirate
	name = "large asteroid"
	desc = "Sensor array is reading an station inside the asteroid and more small structure. "
	icon_state = "object"
	initial_generic_waypoints = list(
		"nav_miningpirate_1",
		"nav_miningpirate_2",
		"nav_miningpirate_3",
		"nav_miningpirate_4",
		"nav_miningpirate_antag"
	)

/datum/map_template/ruin/away_site/miningpirate
	name = "miningpirate"
	id = "awaysite_miningpirate"
	description = "ArRrRrR"
	prefix = "mods/_maps/miningpirate/maps/"
	suffixes = list("miningpirate.dmm")
	spawn_cost = 0.5
	area_usage_test_exempted_root_areas = list(/area/miningpirate)

/obj/shuttle_landmark/nav_miningpirate_1
	name = "Mine Supply #1"
	landmark_tag = "nav_miningpirate_1"

/obj/shuttle_landmark/nav_miningpirate_2
	name = "Mine Supply #2"
	landmark_tag = "nav_miningpirate_2"

/obj/shuttle_landmark/nav_miningpirate_3
	name = "Mine Supply #3"
	landmark_tag = "nav_miningpirate_3"

/obj/shuttle_landmark/nav_miningpirate_4
	name = "Mine Supply #4"
	landmark_tag = "nav_miningpirate_4"

/obj/shuttle_landmark/nav_miningpirate_5
	name = "Mine Supply Base #5"
	landmark_tag = "nav_miningpirate_antag"




//paper


/obj/item/paper/pirate1
	name = "Day 3"
	info = {"
			Майкл, мне кажется или у нашего челнока какие-то проблемы, где его черти носят... Прошло уже три грёбаных цикла... ладно, придется ждать.
			"}

/obj/item/paper/pirate2
	name = "Day 4"
	info = {"
			Тревор, я не знаю почему они задержались, однако могу сказать точно, что были и более длинные поиски жертвы, вспомни рейд где погиб "Блестящий сапог".  К слову, как давно кто-то убирался в библиотеке?
			"}

/obj/item/paper/pirate3
	name = "Day 8-9"
	info = {"
			Прошло уже больше недели, восемь или девять циклов... Я сбился... Грёбаный Шаррес!!! Зачем мы доверили ему возглавление этого рейда! К слову Майкл, я понял к чему был твой вопрос про уборку в библиотеке - кажется я слышал шорохи за шкафом, думаешь крысы?
			"}


/obj/item/paper/pirate4
	name = "Day 17"
	info = {"
			Прошло уже 17 циклов Тревор!! Я говорил с Тони, по его прогнозам прокормить всех столь частыми и объемными пирами не получится. Нужно отправить весточку Боссу, чтобы урезать пайку нашим пленным.
			"}

/obj/item/paper/pirate4
	name = "Day 19"
	info = {"
			 Все зеки были убиты и разделаны на мясо... Черт, я не хочу есть человечену!! Агх, к черту. Отправлюсь на наблюдательный пост, как я понмю... он находится в противоположной части астероида.... Мда.
			"}


/obj/item/paper/pirateboss
	name = "Boss"
	info = {"
			Смотритель, вам нужно знать, что частые пиры как у нас сейчас - быстро погубят нас всех, нужно урезать пайку зекам. Рассмотрите предложение?
			<i> Порезать их на мясо.... Большую часть закопать. </i>
			"}

/obj/item/paper/pirate11
	name = "Spider"
	info = {"
			Тревор!! Паук сожрал Тони когда ттот хотел найти новые рецепты для готовки!! Это ужасно! Мы направим туда людей для убийства пауков, а так-же на будущее оградим тот угол.
			"}
