/obj/machinery/space_battle/ship_core
	name = "ship core"
	desc = "A large central machine required for a ship to function"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "core"
	anchored = 1
	density = 0
	var/armour = 5
	var/team = 0
	idle_power_usage = 1000
	power_channel = EQUIP
	var/self_destructing = 0
	var/timer = 90
	max_damage = 12
	can_be_destroyed = 0 // Destroyed in a special way.
	var/ship_name = ""
	var/reset_time = 0
	var/can_be_reset = 0

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			team = A.team

	Destroy()
		for(var/obj/machinery/M in machines)
			if(M == src) continue
			if(M.z == src.z)
				if(istype(M, /obj/machinery/space_battle))
					qdel(M)
				else
					processing_objects.Remove(M)
		for(var/obj/missile_start/S	in world)
			if(S.z == src.z || S.team == src.team)
				qdel(S)
		for(var/obj/machinery/space_battle/missile_computer/computer in world)
			computer.find_targets()
		var/obj/effect/map/ship/linked = map_sectors["[z]"]
		map_sectors["[z]"] = null
		linked.fire_controls.Cut()
		qdel(linked)
		return ..()

	proc/take_damage(var/damage, var/external = 1)
		if(external && armour > 1)
			var/a = armour // Should this be necessary?
			armour -= damage
			damage -= a
		if(damage > 1)
			break_machine(round(damage/2))
			for(var/mob/living/carbon/human/H in world)
				if(H.z == src.z && H.get_team() == src.team)
					H << "<span class='warning'>You hear a voice: \"Core damaged!\"</span>"

	break_machine(var/num)
		..()
		if(damage_level > 6)
			if(!self_destructing)
				world << "<span class='danger'>[ship_name]'s core self destruct sequence engaged!</span>"
				self_destructing = 1

	attackby(var/obj/item/I, var/mob/user)
		if(istype(I, /obj/item/device/multitool) && self_destructing)
			var/mob/living/carbon/human/H = user
			if(H && istype(H))
				H.visible_message("<span class='notice'>\The [H] begins setting \the [src] to reset!</span>")
				spawn(30)
					if(team && H.get_team() == team)
						H << "<span class='warning'>You hear a voice, \"Core Destruction Attempt detected. Engaging lethal injection.\"</span>"
						H.lethal_injection()
						H.Weaken(5) // TO cancel the do after
						return
				if(do_after(user, 100))
					H.visible_message("<span class='notice'>\The [H] sets the \the [src] to begin resetting!</span>")
					H << "<span class='notice'>You estimate that \the [src] will have finished resetting in 10 minutes.</span>"
					reset_time = world.timeofday+12000 // 1200 seconds =/= minutes
		else if(istype(I, /obj/item/weapon/screwdriver) && can_be_reset)
			var/mob/living/carbon/human/H = user
			if(H && istype(H))
				if(!H.get_team())
					H << "<span class='warning'>\The [src] is unable to read your neural lace!</span>"
					return
				else
					team = H.get_team()
					for(var/area/ship_battle/A in world)
						if(A.z == src.z)
							A.team = src.team
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
			if(prob(20))
				take_damage(rand(1,2), 0)
		var/turf/T = get_turf(src)
		if(T)
			var/datum/gas_mixture/environment = T.return_air()
			if(environment)
				var/cp = environment.return_pressure()
				if(cp < 40)
					if(prob(20))
						for(var/mob/living/carbon/human/H in world)
							if(H.z == src.z && H.get_team() == src.team)
								H << "<span class='warning'>Your hear a voice: \"Core unpressurised!\"</span>"
						take_damage(1)

		if(self_destructing && !reset_time)
			if(damage_level < 6)
				world << "<span class='danger'>Team [team] core self destruct sequences disengaged!</span>"
				self_destructing = 0
			timer--
			if(timer == 10)
				world << "<span class='danger'>Team [team] core self destruct imminent..</span>"
			if(timer <= 0)
				processing_objects.Remove(src)
				self_destruct()
				timer+=10
		else if(reset_time && reset_time > world.timeofday)
			src.visible_message("<span class='notice'>\The [src] beeps, \"Reset procedure complete!\"</span>")
			reset_time = 0
			can_be_reset = 1
			timer += 90 // Give em another minute and a half to reset it.


	ex_act(severity)
		switch(severity)
			if(1)
				take_damage(rand(7,12))
			if(2)
				take_damage(rand(1,8))
			if(1)
				take_damage(rand(0,4))

	emp_act(severity)
		take_damage(rand(severity,severity*2), 0)

	bullet_act(var/obj/item/projectile/bullet/P)
		if(prob(50))
			src.visible_message("<span class='notice'>\The [P] bounces off of \the [src] harmlessly!</span>")
			return
		if(P && istype(P) && P.damage_type == BRUTE)
			take_damage(round(P.damage / 5, 1))

	proc/self_destruct()
		if(self_destructing == 1)
			for(var/mob/living/carbon/human/M in world)
				if(M.z == src.z)
					M << "<span class='danger'>You feel something pierce through you, and as your vision fades to darkness your last thoughts are, \"Shit.\""
					spawn(50)
						M.ghostize(0)
			spawn(10)
				for(var/obj/missile_start/S in world)
					if(S.z == src.z)
						S.active = 0
				spawn(10)
					qdel(src)
