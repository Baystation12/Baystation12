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
	var/timer = 60
	max_damage = 1000

	Destroy()
		for(var/obj/machinery/space_battle/M in world)
			if(M == src) continue
			if(M.z == src.z)
				qdel(M)
		for(var/obj/missile_start/S	in world)
			if(S.z == src.z || S.team == src.team)
				qdel(S)
		for(var/obj/machinery/space_battle/missile_computer/computer in world)
			computer.reconnect()
		return ..()

	proc/take_damage(var/damage, var/external = 1)
		if(external && armour > 1)
			var/a = armour // Should this be necessary?
			armour -= damage
			damage -= a
		if(damage > 1)
			break_machine(round(damage/2))
			for(var/mob/living/carbon/human/H in world)
				if(H.mind && H.mind.team == src.team)
					H << "<span class='warning'>You hear a voice: \"Core damaged!\"</span>"

	break_machine(var/num)
		..()
		if(damage_level > 6)
			if(!self_destructing)
				world << "<span class='danger'>Team [team] core self destruct sequence engaged!</span>"
				self_destructing = 1

	power_change()
		..()
		if(stat & NOPOWER && prob(10))
			for(var/mob/living/carbon/human/H in world)
				if(H.mind && H.mind.team == src.team)
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
							if(H.mind && H.mind.team == src.team)
								H << "<span class='warning'>Your hear a voice: \"Core unpressurised!\"</span>"
						take_damage(1)

		if(self_destructing)
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

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			team = A.team


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
