//from infinity
/mob/living/var/emoteCooldown = (3 SECONDS)
/mob/living/var/emoteLastUse = -1000

/mob/living/proc/emoteCooldownCheck()
	if(emoteLastUse <= (world.time - emoteCooldown))
		emoteLastUse = world.time
		return 1
	else
		to_chat(src, "<span class='warning'>Между эмоциями должно пройти не менее [emoteCooldown / 10] секунд.</span>")
		return 0

/mob/living/verb/laugh()
	set name = "Смеяться"
	set category = "Emote"
	emote("laugh")

/mob/living/verb/giggle()
	set name = "Хихикать"
	set category = "Emote"
	emote("giggle")

/mob/living/verb/scratch()
	set name = "Почесаться"
	set category = "Emote"
	emote("scratch")

/mob/living/verb/scream()
	set name = "Кричать"
	set category = "Emote"
	emote("scream")

/mob/living/verb/blush()
	set name = "Краснеть"
	set category = "Emote"
	emote("blush")

/mob/living/verb/blink()
	set name = "Проморгаться"
	set category = "Emote"
	emote("blink")

/mob/living/verb/bow()
	set name = "Поклониться"
	set category = "Emote"
	emote("bow")

/mob/living/verb/choke()
	set name = "Подавиться"
	set category = "Emote"
	emote("choke")

/mob/living/verb/chuckle()
	set name = "Усмехнуться"
	set category = "Emote"
	emote("chuckle")

/mob/living/verb/collapse()
	set name = "Рухнуть"
	set category = "Emote"
	emote("collapse")

/mob/living/verb/cough()
	set name = "Кашлять"
	set category = "Emote"
	emote("cough")

/mob/living/verb/cry()
	set name = "Плакать"
	set category = "Emote"
	emote("cry")

/mob/living/verb/clap()
	set name = "Хлопать"
	set category = "Emote"
	emote("clap")

/mob/living/verb/drool()
	set name = "Нести чепуху"
	set category = "Emote"
	emote("drool")

/mob/living/verb/faint()
	set name = "Потерять сознание"
	set category = "Emote"
	emote("faint")

/mob/living/verb/frown()
	set name = "Хмуриться"
	set category = "Emote"
	emote("frown")

/mob/living/verb/gasp()
	set name = "Задыхаться"
	set category = "Emote"
	emote("gasp")

/mob/living/verb/glare()
	set name = "Недовольно смотреть"
	set category = "Emote"
	emote("glare")

/mob/living/verb/tfist()
	set name = "Сжать руки в кулаки"
	set category = "Emote"
	emote("tfist")

/mob/living/verb/groan()
	set name = "Болезненный стон"
	set category = "Emote"
	emote("groan")

/mob/living/verb/grin()
	set name = "Оскалиться в улыбке"
	set category = "Emote"
	emote("grin")

/mob/living/verb/look()
	set name = "Посмотреть"
	set category = "Emote"
	emote("look")

/mob/living/verb/nod()
	set name = "Кивнуть"
	set category = "Emote"
	emote("nod")

/mob/living/verb/moan()
	set name = "Стонать"
	set category = "Emote"
	emote("moan")

/mob/living/verb/shake()
	set name = "Трясти головой"
	set category = "Emote"
	emote("shake")

/mob/living/verb/sigh()
	set name = "Вздыхать"
	set category = "Emote"
	emote("sigh")

/mob/living/verb/smile()
	set name = "Улыбнуться"
	set category = "Emote"
	emote("smile")

/mob/living/verb/sneeze()
	set name = "Чихнуть"
	set category = "Emote"
	emote("sneeze")

/mob/living/verb/grunt()
	set name = "Ворчать"
	set category = "Emote"
	emote("grunt")

/mob/living/verb/sniff()
	set name = "Понюхать"
	set category = "Emote"
	emote("sniff")

/mob/living/verb/snore()
	set name = "Храпеть"
	set category = "Emote"
	emote("snore")

/mob/living/verb/shrug()
	set name = "Пожать плечами"
	set category = "Emote"
	emote("shrug")

/mob/living/verb/hshrug()
	set name = "Слегка пожать плечами"
	set category = "Emote"
	emote("hshrug")

/mob/living/verb/stare()
	set name = "Пялиться"
	set category = "Emote"
	emote("stare")

/mob/living/verb/tremble()
	set name = "Дрожать в ужасе"
	set category = "Emote"
	emote("tremble")

/mob/living/verb/twitch_v()
	set name = "Сильно дёргаться"
	set category = "Emote"
	emote("twitch_v")

/mob/living/verb/twitch()
	set name = "Дёргаться"
	set category = "Emote"
	emote("twitch")

/mob/living/verb/wave()
	set name = "Махать"
	set category = "Emote"
	emote("wave")

/mob/living/verb/whimper()
	set name = "Хныкать"
	set category = "Emote"
	emote("whimper")

/mob/living/verb/whistle()
	set name = "Свистеть"
	set category = "Emote"
	emote("whistle")

/mob/living/verb/wink()
	set name = "Подмигнуть"
	set category = "Emote"
	emote("wink")

/mob/living/verb/yawn()
	set name = "Зевать"
	set category = "Emote"
	emote("yawn")

/mob/living/verb/salute()
	set name = "Сделать воинское приветствие"
	set category = "Emote"
	emote("salute")

/mob/living/verb/rsalute()
	set name = "Ответить на воинское приветствие"
	set category = "Emote"
	emote("rsalute")

/mob/living/verb/eyebrow()
	set name = "Приподнять бровь"
	set category = "Emote"
	emote("eyebrow")

/mob/living/verb/alook()
	set name = "Отвести взгляд"
	set category = "Emote"
	emote("alook")

/mob/living/verb/snap()
	set name = "Щёлкнуть пальцами"
	set category = "Emote"
	emote("snap")
