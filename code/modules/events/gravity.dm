/datum/event/gravity
	announceWhen = 5
	var/list/gravity_status = list()

/datum/event/gravity/setup()
	endWhen = rand(15, 60)

/datum/event/gravity/announce()
	command_announcement.Announce("Всплеск обратной связи обнаружен в системах массового распределения. Искусственная гравитация была отключена, чтобы избежать перегрузки системы.", "[station_name()] Gravity Subsystem", zlevels = affecting_z)

/datum/event/gravity/start()
	for (var/area/A in world)
		if (A.has_gravity() && (A.z in affecting_z))
			gravity_status += A
			A.gravitychange(FALSE)

/datum/event/gravity/end()
	for (var/area/A in gravity_status)
		if (!A.has_gravity() && (A.z in affecting_z))
			A.gravitychange(TRUE)
	gravity_status.Cut()
	command_announcement.Announce("Гравитационные генераторы снова работают в пределах нормальных параметров. Приносим извинения за причиненные неудобства.", "[station_name()] Gravity Subsystem", zlevels = affecting_z)
