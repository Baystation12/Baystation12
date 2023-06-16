/datum/event/minispasm
	startWhen = 60
	endWhen = 90
	var/alarm_sound = 'sound/misc/foundation_alarm.ogg'
	var/static/list/psi_operancy_messages = list(
		"Вы чувствуете инородное что-то прямо в твоём сознание!",
		"Что-то пожирает ваш разум изнутри!",
		"Вы можете почувствовать, как переписывается ваш мозг!",
		"SomВаш разум медленно угасает и поглощается иномирной сущностью!",
		"<b>АЛЬФА СИГНАЛ БЕТА СИГНАЛ ДЕЛЬТА СИГНАЛ ЭПСИЛОН СИГНАЛ</b>"
		)


/datum/event/minispasm/announce()
	priority_announcement.Announce( \
		"ПРИОРИТЕТНОЕ ОПОВЕЩЕНИЕ: ОБНАРУЖЕНА ЛОКАЛЬНАЯ ПЕРЕДАЧА ПСИОНИЧЕСКОГО СИГНАЛА СИГМА-[rand(50,80)] \
		Всему персоналу рекомендуется избегать воздействия активной через оборудование \
		аудиопередачи, включая радиогарнитуры, сеть 'Интерком'\
		и ручные коротковолновые рации на время трансляции сигнала.", \
		"Cuchulain Automated Array DEL-145" \
		)
	sound_to(world, sound(alarm_sound))

/datum/event/minispasm/start()
	var/list/victims = list()
	for(var/obj/item/device/radio/radio in GLOB.listening_objects)
		if(radio.on)
			for(var/mob/living/victim in range(radio.canhear_range, radio.loc))
				if(isnull(victims[victim]) && victim.stat == CONSCIOUS && !victim.ear_deaf)
					victims[victim] = radio
	for(var/thing in victims)
		var/mob/living/victim = thing
		var/obj/item/device/radio/source = victims[victim]
		do_spasm(victim, source)

/datum/event/minispasm/proc/do_spasm(var/mob/living/victim, var/obj/item/device/radio/source)
	set waitfor = 0

	if(iscarbon(victim) && !victim.isSynthetic())
		var/list/disabilities = list(NEARSIGHTED, NERVOUS)
		for(var/disability in disabilities)
			if(victim.disabilities & disability)
				disabilities -= disability
		if(disabilities.len)
			victim.disabilities |= pick(disabilities)

	if(victim.psi)
		to_chat(victim, SPAN_DANGER("A hauntingly familiar sound hisses from [icon2html(source, victim)] \the [source], and your vision flickers!"))
		victim.psi.backblast(rand(5,15))
		victim.Paralyse(5)
		victim.make_jittery(100)
	else
		to_chat(victim, SPAN_DANGER("An indescribable, brain-tearing sound hisses from [icon2html(source, victim)] \the [source], and you collapse in a seizure!"))
		victim.seizure()
		var/new_latencies = rand(2,4)
		var/list/faculties = list(PSI_COERCION, PSI_REDACTION, PSI_ENERGISTICS, PSI_PSYCHOKINESIS)
		for(var/i = 1 to new_latencies)
			to_chat(victim, SPAN_DANGER("<font size = 3>[pick(psi_operancy_messages)]</font>"))
			victim.adjustBrainLoss(rand(10,20))
			victim.set_psi_rank(pick_n_take(faculties), 1)
			sleep(30)
		victim.psi.update()
	sleep(45)
	victim.psi.check_latency_trigger(100, "a psionic scream", redactive = TRUE)

/datum/event/minispasm/end()
	priority_announcement.Announce( \
		"ПРИОРИТЕТНОЕ ОПОВЕЩЕНИЕ: ТРАНСЛЯЦИЯ ПСИОНИЧЕСКОГО СИГНАЛА БЫЛА ПРЕКРАЩЕНА. Персоналу разрешено возобновить использование незащищенного радиопередающего оборудования. Фонд Кучулейн желает вам хорошего дня.", \
		"Cuchulain Automated Array DEL-145",
		new_sound = 'sound/misc/foundation_restore.ogg' )
