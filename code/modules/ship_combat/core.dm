/obj/machinery/space_battle/ship_core
	name = "ship core"
	desc = "A large central machine required for a ship to function"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "core"
	anchored = 1
	density = 0
	var/armour = 5
	idle_power_usage = 1000
	power_channel = EQUIP
	var/self_destructing = 0
	var/timer = 90
	max_damage = 12
	can_be_destroyed = 0 // Destroyed in a special way.
	var/ship_name = ""
	var/reset_time = 0
	var/can_be_reset = 0
	var/obj/missile_start/start


	initialize()
		..()
		for(var/obj/missile_start/S in world)
			if(S.z == src.z)
				start = S
				break
		spawn(10)
			var/obj/effect/overmap/linked = map_sectors["[z]"]
			if(linked)
				linked.team = src.team


	Destroy()
		var/obj/effect/overmap/ship/linked = map_sectors["[z]"]
		map_sectors["[z]"] = null
		if(linked)
			if(istype(linked, /obj/effect/overmap/ship))
				linked.fire_controls.Cut()
			qdel(linked)
		for(var/obj/machinery/M in machines)
			if(M == src) continue
			if(M.z == src.z)
				if(istype(M, /obj/machinery/space_battle))
					qdel(M)
		start = null
		for(var/obj/machinery/space_battle/computer/targeting/computer in world)
			computer.find_targets()
		return ..()

	break_machine(var/num)
		if(armour > num)
			armour -= num
			return 0
		..()
		if(damage_level > 6)
			if(!self_destructing)
				var/obj/effect/overmap/O = map_sectors["[z]"]
				if(O)
					world << "<span class='danger'><BIG>[O.name]'s core self destruct sequence engaged!</BIG></span>"
				self_destructing = 1
		for(var/mob/living/carbon/human/H in world)
			if(H.z == src.z && text2num(H.get_team()) == text2num(src.team))
				H << "<span class='warning'>You hear a voice: \"Core damaged!\"</span>"

	attackby(var/obj/item/I, var/mob/user)
		if(istype(I, /obj/item/device/multitool) && self_destructing && damage_level < 8)
			var/mob/living/carbon/human/H = user
			if(H && istype(H))
				H.visible_message("<span class='notice'>\The [H] begins setting \the [src] to reset!</span>")
				spawn(30)
					if(team && H.get_team() == team)
						H << "<span class='warning'>You hear a voice, \"Core Destruction Attempt detected. Cease immediately.\"</span>"
						H.Weaken(5) // TO cancel the do after
						return
				if(do_after(user, 100))
					H.visible_message("<span class='notice'>\The [H] sets the \the [src] to begin resetting!</span>")
					H << "<span class='notice'>You estimate that \the [src] will have finished resetting in 10 minutes.</span>"
					reset_time = world.timeofday+12000 // 1200 seconds = 10 minutes
		else if(istype(I, /obj/item/weapon/screwdriver) && can_be_reset)
			var/mob/living/carbon/human/H = user
			if(H && istype(H))
				if(!H.get_team())
					H << "<span class='warning'>\The [src] is unable to read your neural lace!</span>"
					return
				else
					team = H.get_team()
					linked = src.team
					for(var/area/ship_battle/A in world)
						if(A.z == src.z)
							A.change_team(src.team)
					start.team = src.team
					start.refresh_alive()
					start.refresh_active()
		..()

	power_change()
		..()
		if(stat & NOPOWER && prob(10))
			for(var/mob/living/carbon/human/H in world)
				if(H.z == src.z && H.get_team() == src.team)
					H << "<span class='warning'>Your hear a voice: \"Core unpowered!\"</span>"

	examine(var/mob/user)
		..()
		if(self_destructing)
			user << "<span class='warning'>It's self-destruct protocol is active!</span>"
			if(timer < 120)
				user << "<span class='warning'>The self-destruct timer is set to [timer] seconds!</span>"

	process()
		..()
		if(stat & NOPOWER)
			if(prob(10))
				break_machine(1)
		var/turf/T = get_turf(src)
		if(T)
			var/datum/gas_mixture/environment = T.return_air()
			if(environment)
				var/cp = environment.return_pressure()
				if(cp < 40)
					if(prob(10))
						for(var/mob/living/carbon/human/H in world)
							if(H.z == src.z && H.get_team() == src.team)
								H << "<span class='warning'>Your hear a voice: \"Core unpressurised!\"</span>"
						break_machine(1)

		if(self_destructing && !reset_time)
			var/obj/effect/overmap/O = map_sectors["[z]"]
			if(damage_level < 6)
				world << "<span class='danger'>[O.name]'s core self destruct sequences disengaged!</span>"
				self_destructing = 0
			timer--
			if(timer == 10)
				world << "<span class='danger'>[O.name]'s  core self destruct imminent..</span>"
			if(timer <= 0)
				processing_objects.Remove(src)
				self_destruct()
				timer+=10
		else if(reset_time && reset_time > world.timeofday)
			src.visible_message("<span class='notice'>\icon[src] \The [src] beeps, \"Reset procedure complete!\"</span>")
			reset_time = 0
			can_be_reset = 1
			timer = min(initial(timer), timer+60) // Give em another minute to reset it.


	ex_act(severity)
		switch(severity)
			if(1)
				break_machine(rand(7,12))
			if(2)
				break_machine(rand(1,8))
			if(1)
				break_machine(rand(0,4))

	bullet_act(var/obj/item/projectile/bullet/P)
		if(prob(50))
			src.visible_message("<span class='notice'>\The [P] bounces off of \the [src] harmlessly!</span>")
			return
		if(P && istype(P) && P.damage_type == BRUTE)
			break_machine(round(P.damage / 5, 1))

	proc/self_destruct()
		if(self_destructing == 1)
			for(var/mob/living/carbon/human/M in world)
				if(M.z == src.z)
					M << "<span class='danger'>You feel something pierce through you, and as your vision fades to darkness your last thoughts are, \"Shit.\""
					spawn(50)
						M.ghostize(0)
			spawn(10)
				for(var/obj/missile_start/S in world)
					if(S.z == src.z && S.team == src.team)
						S.active = 0
				spawn(10)
					qdel(src)
