/datum/technomancer/spell/haste
	name = "Haste"
	desc = "Allows the target to run at speeds that should not be possible for an ordinary being.  For five seconds, the target \
	runs extremly fast, and cannot be slowed by any means."
	cost = 100
	obj_path = /obj/item/weapon/spell/insert/haste
	ability_icon_state = "tech_haste"
	category = SUPPORT_SPELLS

/obj/item/weapon/spell/insert/haste
	name = "haste"
	desc = "Now you can outrun a Tajaran!"
	icon_state = "haste"
	cast_methods = CAST_RANGED
	aspect = ASPECT_FORCE
	light_color = "#FF5C5C"
	inserting = /obj/item/weapon/inserted_spell/haste

/obj/item/weapon/inserted_spell/haste/on_insert()
	spawn(1)
		if(istype(host, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = host
			H.force_max_speed = 1
			to_chat(H,"<span class='notice'>You suddenly find it much easier to move.</span>")
			H.adjust_instability(10)
			spawn(5 SECONDS)
				if(src)
					on_expire()

/obj/item/weapon/inserted_spell/haste/on_expire()
	if(istype(host, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = host
		H.force_max_speed = 0
		to_chat(H,"<span class='warning'>You feel slow again.</span>")
		..()