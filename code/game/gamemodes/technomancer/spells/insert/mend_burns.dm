/datum/technomancer/spell/mend_burns
	name = "Mend Burns"
	desc = "Heals minor burns, such as from exposure to flame, electric shock, or lasers."
	cost = 50
	obj_path = /obj/item/weapon/spell/insert/mend_burns
	ability_icon_state = "tech_mendburns"
	category = SUPPORT_SPELLS

/obj/item/weapon/spell/insert/mend_burns
	name = "mend burns"
	desc = "Ointment is a thing of the past."
	icon_state = "mend_burns"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/weapon/inserted_spell/mend_burns

/obj/item/weapon/inserted_spell/mend_burns/on_insert()
	spawn(1)
		if(ishuman(host))
			var/mob/living/carbon/human/H = host
			var/heal_power = host == origin ? 10 : 30
			origin.adjust_instability(10)
			for(var/i = 0, i<5,i++)
				if(H)
					H.adjustFireLoss(-heal_power / 5)
					sleep(1 SECOND)
		on_expire()