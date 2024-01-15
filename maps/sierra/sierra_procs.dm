/datum/map/make_maint_all_access(radstorm = 0)
	maint_all_access = 1
	if(radstorm)
		priority_announcement.Announce("Требования к доступу у шлюзов в технические тоннели временнно отключены. Экранированные отсеки - технические тоннели, челноки, камеры заключения, дормиторий.", "Внимание!")
	else
		priority_announcement.Announce("Требования к доступу у шлюзов в технические тоннели временнно отключены.", "Внимание!")

/datum/map/revoke_maint_all_access(radstorm = 0)
	maint_all_access = 0
	priority_announcement.Announce("Требования к доступу у шлюзов в технические тоннели восстановлены.", "Внимание!")

/datum/map/sierra/roundend_player_status()
	for(var/mob/Player in GLOB.player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(evacuation_controller.round_over() && evacuation_controller.emergency_evacuation)
					if(isNotAdminLevel(playerTurf.z))
						to_chat(Player, "<font color='blue'><b>Вам удалось выжить, но вы были брошены на [station_name()], [Player.real_name]...</b></font>")
					else
						to_chat(Player, "<font color='green'><b>Вам удалось пережить события на [station_name()], [Player.real_name]!</b></font>")
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, "<font color='green'><b>Вы успешно избежали событий на [station_name()], [Player.real_name].</b></font>")
				else if(issilicon(Player))
					to_chat(Player, "<font color='green'><b>Ваши системы сохранили свою функциональность после событий на [station_name()], [Player.real_name].</b></font>")
				else
					to_chat(Player, "<font color='blue'><b>Вы пережили очередную смену на [station_name()], [Player.real_name].</b></font>")
			else
				if(isghost(Player))
					var/mob/observer/ghost/O = Player
					if(!O.started_as_observer)
						to_chat(Player, "<font color='red'><b>Вы не пережили события на [station_name()]...</b></font>")
				else
					to_chat(Player, "<font color='red'><b>Вы не пережили события на [station_name()]...</b></font>")

/datum/map/sierra/do_interlude_teleport(atom/movable/target, atom/destination, duration = 30 SECONDS, precision, type)
	var/turf/T = pick_area_turf(/area/bluespace_interlude/platform, list(/proc/not_turf_contains_dense_objects, /proc/IsTurfAtmosSafe))

	if (!T)
		do_teleport(target, destination)
		return

	if (isliving(target))
		to_chat(target, FONT_LARGE(SPAN_WARNING("Your vision goes blurry and nausea strikes your stomach. Where are you...?")))
		do_teleport(target, T, precision, type)
		addtimer(new Callback(GLOBAL_PROC, /proc/do_teleport, target, destination), duration)

/datum/map/bolt_saferooms()
	for(var/atype in typesof(/area/crew_quarters/safe_room))
		var/area/A = locate(atype)
		if(istype(A))
			for(var/obj/machinery/door/airlock/vault/bolted/V in A.contents)
				if(!V.locked)
					V.lock()

/datum/map/unbolt_saferooms()
	for(var/atype in typesof(/area/crew_quarters/safe_room))
		var/area/A = locate(atype)
		if(istype(A))
			for(var/obj/machinery/door/airlock/vault/bolted/V in A.contents)
				if(V.locked)
					V.unlock()
