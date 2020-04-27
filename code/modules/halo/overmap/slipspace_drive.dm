
/obj/structure/covenant_slipspace
	name = "Long Range Slipspace Generator"
	icon = 'code/modules/halo/overmap/icons/slipspace_drive_cov.dmi'
	icon_state = "slipspace"
	desc = "An incredibly advanced machine capable of precise slipspace jumps, modified for single-purpose fast transportation to a pre-set endpoint."
	anchored = 1
	density = 1
	bound_width = 64
	bound_height = 64
	var/slipspace_activate_timer = 10 SECONDS
	var/slipspace_chargeup_timer = 60 SECONDS
	var/slipspace_jump_time = 0

/obj/structure/covenant_slipspace/allowed(var/mob/user)
	var/mob/living/carbon/human/h = user
	if(istype(h) && h.species.type in COVENANT_SPECIES_AND_MOBS)
		return 1
	if(user && user.type in COVENANT_SPECIES_AND_MOBS)
		return 1
	return 0

/obj/structure/covenant_slipspace/attack_hand(var/mob/user)
	if(allowed(user))
		var/obj/effect/overmap/ship/ship = map_sectors["[z]"]
		if(istype(ship))
			if(slipspace_jump_time)
				if(alert("Do you want to shutdown the slipspace engine and remain in the system?","Shutdown slipspace jump","Shutdown","Cancel") == "Shutdown")
					slipspace_jump_time = 0
					GLOB.processing_objects -= src
					src.visible_message("<span class='info'>[user] begins working at the console of [src]...</span>")
					to_chat(user,"<span class='notice'>You shutdown the slipspace engine.</span>")
			else
				if(alert("Do you want to activate the slipspace engine to leave the system?","Enter slipspace","Engage","Cancel") == "Engage")
					message_admins("[user] the [user.mind.assigned_role] (CKEY: [user.ckey]) has begun activating the slipspace engine. Without interference, the ship will enter slipspace in [(slipspace_activate_timer + slipspace_chargeup_timer) / 10] seconds from now.")
					src.visible_message("<span class='info'>[user] begins working at the console of [src]...</span>")
					if(do_after(user, slipspace_activate_timer))
						slipspace_jump_time = world.time + slipspace_chargeup_timer
						GLOB.processing_objects |= src
						log_admin("[user] the [user.mind.assigned_role] (CKEY: [user.ckey]) activated the slipspace engine. Jump timer: [slipspace_chargeup_timer / 10] seconds.")
						if(istype(ship))
							to_chat(user,"<span class='notice'>[src] has been activated. [ship] will enter slipspace in [slipspace_chargeup_timer / 10] seconds.</span>")
	else
		to_chat(user,"<span class='warning'>You are unable to decipher how [src] works.</span>")

/obj/structure/covenant_slipspace/process()
	if(slipspace_jump_time && world.time > slipspace_jump_time)
		slipspace_jump_time = 0
		GLOB.processing_objects -= src
		var/obj/effect/overmap/ship/ship = map_sectors["[z]"]
		if(istype(ship))
			//hard brake the ship to avoid visual bugs with the slipspace effect
			ship.speed = list(0,0)

			//tell the gamemode handler
			var/datum/game_mode/game_mode = ticker.mode
			if(istype(game_mode))
				game_mode.handle_slipspace_jump(ship)

			//dont block here, we're going to do some time sensitive stuff
			spawn(0)
				//animate the slipspacejump
				var/headingdir = ship.get_heading()
				if(!headingdir)
					headingdir = ship.dir
				var/turf/T = ship.loc
				for(var/i=0, i<6, i++)
					T = get_step(T,headingdir)
				new /obj/effect/slipspace_rupture(T)

				//rapidly move into the portal
				walk_to(ship,T,0,1,0)

				//despawn the ship
				ship.do_superstructure_fail()

/datum/game_mode/proc/handle_slipspace_jump(var/obj/effect/overmap/ship/ship)
