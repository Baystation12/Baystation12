/obj/machinery/drone_fabricator
	name = "drone fabricator"
	desc = "A large automated factory for producing maintenance drones."

	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 5000

	var/drone_progress = 0
	var/produce_drones = 1
	var/time_last_drone = 500

	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"

/obj/machinery/drone_fabricator/New()
	..()

/obj/machinery/drone_fabricator/power_change()
	..()
	if (stat & NOPOWER)
		icon_state = "drone_fab_nopower"

/obj/machinery/drone_fabricator/process()

	if(ticker.current_state < GAME_STATE_PLAYING)
		return

	if(stat & NOPOWER || !produce_drones)
		if(icon_state != "drone_fab_nopower") icon_state = "drone_fab_nopower"
		return

	if(drone_progress >= 100)
		icon_state = "drone_fab_idle"
		return

	icon_state = "drone_fab_active"
	var/elapsed = world.time - time_last_drone
	drone_progress = round((elapsed/config.drone_build_time)*100)

	if(drone_progress >= 100)
		visible_message("\The [src] voices a strident beep, indicating a drone chassis is prepared.")

/obj/machinery/drone_fabricator/examine(mob/user)
	..(user)
	if(produce_drones && drone_progress >= 100 && istype(user,/mob/dead) && config.allow_drone_spawn && count_drones() < config.max_maint_drones)
		user << "<BR><B>A drone is prepared. Select 'Join As Drone' from the Ghost tab to spawn as a maintenance drone.</B>"

/obj/machinery/drone_fabricator/proc/count_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in world)
		if(D.key && D.client)
			drones++
	return drones

/obj/machinery/drone_fabricator/proc/create_drone(var/client/player)

	if(stat & NOPOWER)
		return

	if(!produce_drones || !config.allow_drone_spawn || count_drones() >= config.max_maint_drones)
		return

	if(!player || !istype(player.mob,/mob/dead))
		return

	announce_ghost_joinleave(player, 0, "They have taken control over a maintenance drone.")
	visible_message("\The [src] churns and grinds as it lurches into motion, disgorging a shiny new drone after a few moments.")
	flick("h_lathe_leave",src)

	time_last_drone = world.time
	var/mob/living/silicon/robot/drone/new_drone = new(get_turf(src))
	new_drone.transfer_personality(player)

	drone_progress = 0



/mob/dead/verb/join_as_drone()

	set category = "Ghost"
	set name = "Join As Drone"
	set desc = "If there is a powered, enabled fabricator in the game world with a prepared chassis, join as a maintenance drone."


	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "\red The game hasn't started yet!"
		return

	if(!(config.allow_drone_spawn))
		src << "\red That verb is not currently permitted."
		return

	if (!src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if(jobban_isbanned(src,"Cyborg"))
		usr << "\red You are banned from playing synthetics and cannot spawn as a drone."
		return
		
	if(!MayRespawn(1))
		return

	var/deathtime = world.time - src.timeofdeath
	if(istype(src,/mob/dead/observer))
		var/mob/dead/observer/G = src
		if(G.has_enabled_antagHUD == 1 && config.antag_hud_restricted)
			usr << "\blue <B>Upon using the antagHUD you forfeighted the ability to join the round.</B>"
			return

	var/deathtimeminutes = round(deathtime / 600)
	var/pluralcheck = "minute"
	if(deathtimeminutes == 0)
		pluralcheck = ""
	else if(deathtimeminutes == 1)
		pluralcheck = " [deathtimeminutes] minute and"
	else if(deathtimeminutes > 1)
		pluralcheck = " [deathtimeminutes] minutes and"
	var/deathtimeseconds = round((deathtime - deathtimeminutes * 600) / 10,1)

	if (deathtime < 6000)
		usr << "You have been dead for[pluralcheck] [deathtimeseconds] seconds."
		usr << "You must wait 10 minutes to respawn as a drone!"
		return

	for(var/obj/machinery/drone_fabricator/DF in world)
		if(DF.stat & NOPOWER || !DF.produce_drones)
			continue

		if(DF.count_drones() >= config.max_maint_drones)
			src << "\red There are too many active drones in the world for you to spawn."
			return

		if(DF.drone_progress >= 100)
			DF.create_drone(src.client)
			return

	src << "\red There are no available drone spawn points, sorry."