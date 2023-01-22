//proxima code //from infinity
/datum/objective/nuclear
	explanation_text = "Активировать систему самоуничтожения объекта."

/datum/objective/nuclear/steal
	explanation_text = "Похитить важные документы с судна - чертежи, отчеты, корпоративные шифры."

/datum/objective/nuclear/steal_AI
	explanation_text = "Перезаписать ИИ на интеллекарту (если он есть)."

/datum/objective/nuclear/researches
	explanation_text = "Перезаписать все исследования на съемный носитель."

/datum/objective/nuclear/kidnap
	var/list/roles = list(/datum/job/captain, /datum/job/rd, /datum/job/scientist, /datum/job/chief_engineer, /datum/job/lawyer)

/datum/objective/nuclear/kidnap/proc/choose_target()
	var/list/possible_targets = list()
	var/list/priority_targets = list()

	for(var/datum/mind/possible_target in SSticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != DEAD) && (!possible_target.special_role))
			possible_targets += possible_target
			for(var/job_type in roles)
				var/datum/job/role = SSjobs.get_by_path(job_type)
				if(possible_target.assigned_role == role.title)
					priority_targets += possible_target
					continue

	if(priority_targets.len > 0)
		target = pick(priority_targets)

	if(target?.current)
		explanation_text = "Похитить [target.current.real_name] ([target.assigned_role]). Цель должна быть живой."
	else
		explanation_text = "Захвать по крайней мере одного высокопоставленного или обладающего ценными данными члена экипажа живым. Приоритет - ученые, главы, инженеры."
	return target

/datum/objective/heist/loot/choose_target()
	var/loot = "an object"
	switch(rand(1,8))
		if(1)
			target = /obj/item/gun/projectile/revolver/medium/captain
			target_amount = 1
			loot = "a captain's revolver"
		if(2)
			target = /obj/machinery/jukebox
			target_amount = 1
			loot = "a mediatronic jukebox"
		if(3)
			target = /obj/machinery/power/emitter
			target_amount = 2
			loot = "two emitters"
		if(4)
			target = /obj/machinery/nuclearbomb
			target_amount = 1
			loot = "a nuclear bomb"
		if(5)
			target = /obj/item/gun
			target_amount = 6
			loot = "six guns"
		if(6)
			target = /obj/item/gun/energy
			target_amount = 4
			loot = "four LAEP90 energy guns"
		if(7)
			target = /obj/item/gun/energy/laser
			target_amount = 2
			loot = "two G40E lasers"
		if(8)
			target = /obj/item/gun/energy/ionrifle
			target_amount = 1
			loot = "an ion gun"

	explanation_text = "It's a buyer's market out here. Steal [loot] for resale."
