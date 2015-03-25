/obj/item/projectile/change
	name = "bolt of change"
	icon_state = "ice_1"
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"

/obj/item/projectile/change/on_hit(var/atom/change)
	wabbajack(change)

/obj/item/projectile/change/proc/wabbajack(var/mob/M)
	if(istype(M, /mob/living) && M.stat != DEAD)
		if(M.monkeyizing)
			return
		if(M.has_brain_worms())
			return //Borer stuff - RR

		M.monkeyizing = 1
		M.canmove = 0
		M.icon = null
		M.overlays.Cut()
		M.invisibility = 101

		if(istype(M, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/Robot = M
			if(Robot.mmi)
				del(Robot.mmi)
		else
			for(var/obj/item/W in M)
				if(istype(W, /obj/item/weapon/implant))	//TODO: Carn. give implants a dropped() or something
					del(W)
					continue
				W.layer = initial(W.layer)
				W.loc = M.loc
				W.dropped(M)

		var/mob/living/new_mob

		var/options = list("monkey", "robot", "slime")
		for(var/t in all_species)
			options += t
		options -= "Xenomorph Queen"
		if(ismonkey(M))
			options -= "monkey"
		if(isrobot(M))
			options -= "robot"
		if(isslime(M))
			options -= "slime"
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.species)
				options -= H.species.name

		var/randomize = pick(options)
		switch(randomize)
			if("monkey")
				new_mob = new /mob/living/carbon/monkey(M.loc)
				new_mob.universal_speak = 1
			if("robot")
				new_mob = new /mob/living/silicon/robot(M.loc)
				new_mob.gender = M.gender
				new_mob.invisibility = 0
				new_mob.job = "Cyborg"
				var/mob/living/silicon/robot/Robot = new_mob
				Robot.mmi = new /obj/item/device/mmi(new_mob)
				Robot.mmi.transfer_identity(M)	//Does not transfer key/client.
			if("slime")
				new_mob = new /mob/living/carbon/slime(M.loc)
				new_mob.universal_speak = 1
			if("Xenomorph Hunter", "Xenomorph Sentinel", "Xenomorph Drone")
				new_mob = create_new_xenomorph(copytext(randomize, 11), M.loc)
				new_mob.universal_speak = 1
			else
				new_mob = new /mob/living/carbon/human(M.loc, randomize)
				if(M.gender == MALE)
					new_mob.gender = MALE
					new_mob.name = pick(first_names_male)
				else
					new_mob.gender = FEMALE
					new_mob.name = pick(first_names_female)
				new_mob.name += " [pick(last_names)]"
				new_mob.real_name = new_mob.name

				var/datum/preferences/A = new()	//Randomize appearance for the human
				A.randomize_appearance_for(new_mob)
			else
				return

		for (var/obj/effect/proc_holder/spell/S in M.spell_list)
			new_mob.spell_list += new S.type

		new_mob.a_intent = "hurt"
		if(M.mind)
			M.mind.transfer_to(new_mob)
		else
			new_mob.key = M.key

		new_mob << "<B>Your form morphs into that of a [lowertext(randomize)].</B>"

		del(M)
		return new_mob
