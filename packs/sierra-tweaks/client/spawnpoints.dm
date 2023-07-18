/datum/spawnpoint/cryo/after_join(mob/living/victim)
	if(!istype(victim))
		return
	var/area/A = get_area(victim)
	var/list/spots = list()

	for(var/obj/machinery/cryopod/C in A)
		if(!C.occupant)
			spots += C

	if(!length(spots))
		to_chat(victim, "Вы проснулись чуть раньше остальных.")
		turfs -= get_turf(victim)
		return

	for(var/obj/machinery/cryopod/C in shuffle(spots))
		if(!C.occupant)
			C.set_occupant(victim, 1)
			to_chat(victim, SPAN_NOTICE("Вы пробуждаетесь от крио-сна. Это может занять пару секунд"))
			if (istype(victim, /mob/living/carbon))
				var/mob/living/carbon/H = victim
				H.bodytemperature = H.species.cold_level_1 // Very cold, but a point before damage

			if(!victim.isSynthetic())
				to_chat(victim, SPAN_NOTICE("Вы чувствуете озноб и капли воды на себе. Криогенная жидкость только \
				прекратила охлаждать атмосферу внутри капсулы... Сквозь веки бьёт яркий свет, пытаясь заставить проснуться. \
				Похоже, смена начинается."))
			else
				to_chat(victim, SPAN_NOTICE("Получен сигнал к пробуждению. Батарея заряжена. Все системы в норме."))

			if(!victim.isSynthetic())
				give_effect(victim)
				give_advice(victim)

			break

/datum/spawnpoint/cryo/proc/give_effect(mob/living/carbon/human/H)
	var/message = ""

	if(prob(5))
		H.make_dizzy(50)

	if(prob(10))
		message += SPAN_WARNING("В ушках звон, в голове белый шум... ")
		H.hallucination(30, 30)

	if(prob(5))
		message += SPAN_DANGER("Вы чувствуете ужасающий холод во всём теле! Крио всё ещё охлаждает! ")
		H.bodytemperature = H.species.cold_level_2

	if(prob(5))
		message += SPAN_WARNING("Вы долго не могли уснуть, не смотря на все усилия этой машины. \
		Так не хочется вставать... Ноги ватные, руки тяжелые... ")

	if(prob(20))
		message += SPAN_WARNING("Кажется, вы забыли поесть перед тем, как уйти в сон. Горло пересохло, а \
		живот скрутило в спазме. ")
		H.nutrition = rand(0,200)
		H.hydration = rand(0,200)
		if(H.species.name == SPECIES_UNATHI)
			H.nutrition = rand(100,200)

	if(prob(10))
		message += SPAN_WARNING("Трясет от холода. ")
		H.make_jittery(120)
		H.stuttering = 20

	if(prob(5))
		message += SPAN_WARNING("Тошнит... ")
		H.vomit()

	if(!message)
		message += SPAN_NOTICE("Кажется, в этот раз без осложнений... Правда, выспаться в саркофаге всё равно не удалось.")
	else
		message += SPAN_WARNING("Не удалось даже нормально выспаться в этом гробу...")

	to_chat(H, message)
	return TRUE

/datum/spawnpoint/cryo/proc/give_advice(mob/H)
	var/desc = pick(
	SPAN_NOTICE("Вы чувствуете себя нормально. Не смотря на капсулу, хочется покушать и заняться работой."),
	SPAN_NOTICE("Вы чувствуете усталость. Вас всё ещё немного клонит в сон..."),
	SPAN_NOTICE("<b>Вы уверены в себе. Надо держаться в тонусе и не унывать - если не вы, то никто.</b>"),
	SPAN_NOTICE("Вы чувствуете привкус железа во рту. К чему бы это..."),
	SPAN_NOTICE("У вас лёгкое головокружение. Типичное пробуждение..."),
	SPAN_NOTICE("Вы чувствуете себя грязно. В прямом смысле. Нужно будет посетить душ..."),
	SPAN_NOTICE("Этот запах... Криогенная жидкость. Жжёт в носу."),
	SPAN_NOTICE("Вы что-то забыли. Вы точно что-то хотели сделать в эту смену, но не помните что..."),
	SPAN_NOTICE("Вы чувствуете слабость. Возможно, это из-за влияния космоса... Может, стоит посетить спортзал?"),
	SPAN_NOTICE("Вы практически не помните, что происходило в вашей прошлой смене... Это странно."),
	SPAN_NOTICE("Хочется чего-то вкусного и необычного..."),
	SPAN_NOTICE("Хм... А мне точно не должны платить больше за то, что я делаю в этой дыре?"),
	SPAN_NOTICE("Этот космос совсем доканает... Может, стоит запить всё это в баре?"),
	SPAN_NOTICE("Может, стоит разыграть кого-нибудь? Это будет забавно."),
	SPAN_WARNING("Вы чувствуете раздражение и лёгкую обиду. Криокапсула, теснота корабля, задержки с едой... Впрочем, это довольно легко побороть."),
	SPAN_WARNING("Вы чувствуете лёгкую тревогу. В этой смене что-то произойдет..."),
	SPAN_WARNING("У вас затекли конечности. И как только заснули в такой неудобной позе..."),
	SPAN_WARNING("Вы чувствуете лёгкий испуг. Как будто снилось что-то плохое..."))

	to_chat(H, desc)

	return TRUE
