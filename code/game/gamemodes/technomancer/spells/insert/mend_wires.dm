/datum/technomancer/spell/mend_wires
	name = "Mend Wires"
	desc = "Binds the internal wiring of robotic limbs and components over time."
	cost = 50
	obj_path = /obj/item/weapon/spell/insert/mend_wires
	ability_icon_state = "tech_mendwounds"
	category = SUPPORT_SPELLS

/obj/item/weapon/spell/insert/mend_wires
	name = "mend wires"
	desc = "A roboticist is now obsolete."
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/weapon/inserted_spell/mend_wires

/obj/item/weapon/inserted_spell/mend_wires/on_insert()
	spawn(1)
		if(ishuman(host))
			var/mob/living/carbon/human/H = host
			var/heal_power = host == origin ? 10 : 30
			origin.adjust_instability(10)
			for(var/i = 0, i<5,i++)
				if(H)
					for(var/obj/item/organ/external/O in H.organs)
						if(O.robotic < ORGAN_ROBOT) // Robot parts only.
							continue
						O.heal_damage(0, heal_power / 5, internal = 1, robo_repair = 1)
					sleep(1 SECOND)
		on_expire()