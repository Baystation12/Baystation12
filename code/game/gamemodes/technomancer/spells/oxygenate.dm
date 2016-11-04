/datum/technomancer/spell/oxygenate
	name = "Oxygenate"
	desc = "This function creates oxygen at a location of your chosing.  If used on a humanoid entity, it heals oxygen deprivation.  \
	If casted on the envirnment, air (oxygen and nitrogen) is moved from a distant location to your target."
	cost = 50
	obj_path = /obj/item/weapon/spell/oxygenate
	ability_icon_state = "oxygenate"
	category = SUPPORT_SPELLS

/obj/item/weapon/spell/oxygenate
	name = "oxygenate"
	desc = "Atmospherics is obsolete."
	icon_state = "darkness" //wip
	cast_methods = CAST_RANGED
	aspect = ASPECT_AIR
	cooldown = 30

/obj/item/weapon/spell/oxygenate/on_ranged_cast(atom/hit_atom, mob/user)
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		if(pay_energy(1500))
			H.adjustOxyLoss(-35)
			adjust_instability(10)
			return
	else if(isturf(hit_atom))
		var/turf/T = hit_atom
		if(pay_energy(1500))
			T.assume_gas("oxygen", 200)
			T.assume_gas("nitrogen", 800)
			playsound(src.loc, 'sound/effects/spray.ogg', 50, 1, -3)
			adjust_instability(10)