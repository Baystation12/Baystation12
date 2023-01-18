/datum/event/gravity
	announceWhen = 5
	var/list/gravity_status = list()

/datum/event/gravity/setup()
	endWhen = rand(15, 60)

/datum/event/gravity/announce()
	command_announcement.Announce("Отклонения в показателях генератора искусственной гравитации достигли неблагоприятного уровня. Техническому отделу крайне рекомендуется решить эту проблему.", "Ошибка распределения ускорения.", zlevels = affecting_z)

/*[inf.exclude]
/datum/event/gravity/start()
	for (var/area/A in world)
		if (A.has_gravity() && (A.z in affecting_z))
			gravity_status += A
			A.gravitychange(FALSE)

/datum/event/gravity/end()
	if(!gravity_is_on)
		gravity_is_on = 1

		for(var/area/A in world)
			if((A.z in affecting_z) && initial(A.has_gravity))
				A.gravitychange(gravity_is_on)

		command_announcement.Announce("Генератор гравитации успешно перекалиброван и запущен. Текущая сила притяжения - 9.8.", "Гравитация Восстановлена", zlevels = affecting_z)
[/inf.exclude]*/
