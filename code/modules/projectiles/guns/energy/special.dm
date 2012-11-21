/obj/item/weapon/gun/energy/ionrifle
	name = "ion rifle"
	desc = "A man portable anti-armor weapon designed to disable mechanical threats"
	icon_state = "ionrifle"
	fire_sound = 'Laser.ogg'
	origin_tech = "combat=2;magnets=4"
	w_class = 4.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	slot_flags = SLOT_BACK
	charge_cost = 100
	projectile_type = "/obj/item/projectile/ion"



/obj/item/weapon/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	fire_sound = 'pulse3.ogg'
	origin_tech = "combat=5;materials=4;powerstorage=3"
	charge_cost = 100
	projectile_type = "/obj/item/projectile/energy/declone"


/obj/item/weapon/gun/energy/proc/wabbajack (mob/M as mob in world)
	if(istype(M, /mob/living) && M.stat != 2)
		for(var/obj/item/W in M)
			if (istype(M, /mob/living/silicon/robot)||istype(W, /obj/item/weapon/implant))
				del (W)
			M.drop_from_slot(W)
		var/randomize = pick("monkey","robot","human")
		switch(randomize)
			if("monkey")
				if (M.monkeyizing)
					return
				M.update_clothing()
				M.monkeyizing = 1
				M.canmove = 0
				M.icon = null
				M.invisibility = 101
				var/mob/living/carbon/monkey/O = new /mob/living/carbon/monkey( M.loc )
				O.name = "monkey"
				if (M.client)
					M.client.mob = O
				if(M.mind)
					M.mind.transfer_to(O)
				O.a_intent = "hurt"
				O.universal_speak = 1
				O << "<B>You are now a monkey.</B>"
				del(M)
				return O
			if("robot")
				if (M.monkeyizing)
					return
				M.update_clothing()
				M.monkeyizing = 1
				M.canmove = 0
				M.icon = null
				M.invisibility = 101
				if(M.client)
					M.client.screen -= M.hud_used.contents
					M.client.screen -= M.hud_used.adding
					M.client.screen -= M.hud_used.mon_blo
					M.client.screen -= list( M.oxygen, M.throw_icon, M.i_select, M.m_select, M.toxin, M.internals, M.fire, M.hands, M.healths, M.pullin, M.blind, M.flash, M.rest, M.sleep, M.mach )
					M.client.screen -= list( M.zone_sel, M.oxygen, M.throw_icon, M.i_select, M.m_select, M.toxin, M.internals, M.fire, M.hands, M.healths, M.pullin, M.blind, M.flash, M.rest, M.sleep, M.mach )

				var/mob/living/silicon/robot/O = new /mob/living/silicon/robot( M.loc )
				O.cell = new(O)
				O.cell.maxcharge = 7500
				O.cell.charge = 7500
				O.gender = M.gender
				O.invisibility = 0
				O.name = "Cyborg"
				O.real_name = "Cyborg"
				if (M.mind)
					M.mind.transfer_to(O)
					if (M.mind.assigned_role == "Cyborg")
						M.mind.original = O
					else if (M.mind.special_role) O.mind.store_memory("In case you look at this after being borged, the objectives are only here until I find a way to make them not show up for you, as I can't simply delete them without screwing up round-end reporting. --NeoFite")
				else
					M.mind = new /datum/mind(  )
					M.mind.key = M.key
					M.mind.current = O
					M.mind.original = O
					M.mind.transfer_to(O)

				if(!(O.mind in ticker.minds))
					ticker.minds += O.mind//Adds them to regular mind list.

				O.loc = loc
				O << "<B>You are playing a Robot. A Robot can interact with most electronic objects in its view point.</B>"
				O << "<B>You must follow the laws that the AI has. You are the AI's assistant to the station basically.</B>"
				O << "To use something, simply double-click it."
				O << {"Use say ":s to speak to fellow cyborgs and the AI through binary."}

				O.job = "Cyborg"

				O.mmi = new /obj/item/device/mmi(O)
				O.mmi.transfer_identity(M)//Does not transfer key/client.
				del(M)
				return O
			/*if("metroid")
				if (M.monkeyizing)
					return
				M.update_clothing()
				M.monkeyizing = 1
				M.canmove = 0
				M.icon = null
				M.invisibility = 101
				if(prob(50))
					var/mob/living/carbon/metroid/adult/new_metroid = new /mob/living/carbon/metroid/adult (M.loc)
					if (M.client)
						M.client.mob = new_metroid
					if(M.mind)
						M.mind.transfer_to(new_metroid)

					new_metroid.a_intent = "hurt"
					new_metroid << "<B>You are now an adult Metroid.</B>"
					new_metroid.universal_speak = 1
					del(M)
					return new_metroid
				else
					var/mob/living/carbon/metroid/new_metroid = new /mob/living/carbon/metroid (M.loc)
					if (M.client)
						M.client.mob = new_metroid
					if(M.mind)
						M.mind.transfer_to(new_metroid)
					new_metroid.a_intent = "hurt"
					new_metroid.universal_speak = 1
					new_metroid << "<B>You are now a baby Metroid.</B>"
					del(M)
					return new_metroid
			if("alien")
				if (M.monkeyizing)
					return
				M.update_clothing()
				M.monkeyizing = 1
				M.canmove = 0
				M.icon = null
				M.invisibility = 101
				var/alien_caste = pick("Hunter","Sentinel","Drone")
				var/mob/living/carbon/alien/humanoid/new_xeno
				switch(alien_caste)
					if("Hunter")
						new_xeno = new /mob/living/carbon/alien/humanoid/hunter (M.loc)
					if("Sentinel")
						new_xeno = new /mob/living/carbon/alien/humanoid/sentinel (M.loc)
					if("Drone")
						new_xeno = new /mob/living/carbon/alien/humanoid/drone (M.loc)
				if (M.client)
					M.client.mob = new_xeno
				if(M.mind)
					M.mind.transfer_to(new_xeno)
				new_xeno.a_intent = "hurt"
				new_xeno.universal_speak = 1
				new_xeno << "<B>You are now an alien.</B>"
				del(M)
				return new_xeno */
			if("human")
				if (M.monkeyizing)
					return
				M.update_clothing()
				M.monkeyizing = 1
				M.canmove = 0
				M.icon = null
				M.invisibility = 101
				var/mob/living/carbon/human/O = new /mob/living/carbon/human( M.loc )

				var/first = pick(first_names_male)
				var/last = pick(last_names)
				O.name = "[first] [last]"
				O.real_name = "[first] [last]"
				var/race = pick("lizard","golem","metroid","plant","normal")
				switch(race)
					if("lizard")
						O.mutantrace = "lizard"
					if("golem")
						O.mutantrace = "golem"
					if("metroid")
						O.mutantrace = "metroid"
					if("plant")
						O.mutantrace = "plant"
					if("normal")
						O.mutantrace = ""
				if (M.client)
					M.client.mob = O
				if(M.mind)
					M.mind.transfer_to(O)
				O.a_intent = "hurt"
				O << "<B>You are now a human.</B>"
				del(M)
				return O
		return
obj/item/weapon/gun/energy/staff
	name = "staff of change"
	desc = "an artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	icon = 'gun.dmi'
	icon_state = "staffofchange"
	item_state = "staffofchange"
	fire_sound = 'emitter.ogg'
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	slot_flags = SLOT_BACK
	w_class = 4.0
	charge_cost = 200
	projectile_type = "/obj/item/projectile/change"
	origin_tech = null
	var/charge_tick = 0

	special_check(var/mob/living/carbon/human/M)
		if(ishuman(M))
			if(M.mind in ticker.mode.wizards)
				M << "\red You are wizard."
				return 1
			var/r = rand(0,100)
			if (r < 1)
				M << "\red <FONT size = 3><B>Something really bad happened when you touched the rod</B></FONT>"
				playsound(M, fire_sound, 50, 1)
				M.gib()
				return 0
			if (r < 40)
				M << "\red <FONT size = 3><B>You took the rod from the wrong side!</B></FONT>"
				playsound(M, fire_sound, 50, 1)
				wabbajack(M)
				return 0
			return 1
		return 0
		return 1


	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()


	process()
		charge_tick++
		if(charge_tick < 4) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(200)
		update_icon()
		return 1

/obj/item/weapon/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon_state = "floramut100"
	item_state = "gun"
	fire_sound = 'stealthoff.ogg'
	charge_cost = 100
	projectile_type = "/obj/item/projectile/energy/floramut"
	origin_tech = "materials=2;biotech=3;powerstorage=3"
	modifystate = "floramut"
	var/charge_tick = 0
	var/mode = 0 //0 = mutate, 1 = yield boost

	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()


	process()
		charge_tick++
		if(charge_tick < 4) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(100)
		update_icon()
		return 1

	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 100
				user << "\red The [src.name] is now set to increase yield."
				projectile_type = "/obj/item/projectile/energy/florayield"
				modifystate = "florayield"
			if(1)
				mode = 0
				charge_cost = 100
				user << "\red The [src.name] is now set to induce mutations."
				projectile_type = "/obj/item/projectile/energy/floramut"
				modifystate = "floramut"
		update_icon()
		return

/obj/item/weapon/gun/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "riotgun"
	item_state = "c20r"
	w_class = 4
	projectile_type = "/obj/item/projectile/meteor"
	charge_cost = 100
	cell_type = "/obj/item/weapon/cell/potato"
	clumsy_check = 0 //Admin spawn only, might as well let clowns use it.
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in ticks)

	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()

	process()
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(100)

	update_icon()
		return


/obj/item/weapon/gun/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	w_class = 1