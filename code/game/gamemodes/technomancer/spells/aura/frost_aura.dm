/datum/technomancer/spell/frost_aura
	name = "Chilling Aura"
	desc = "Lowers the core body temperature of everyone around you (except for your friends), causing them to freeze to death if \
	they stay within four meters of you."
	enhancement_desc = "The chill becomes lethal."
	cost = 100
	obj_path = /obj/item/weapon/spell/aura/frost
	ability_icon_state = "tech_frostaura"
	category = DEFENSIVE_SPELLS // Scepter-less frost aura is nonlethal.

/obj/item/weapon/spell/aura/frost
	name = "chilling aura"
	desc = "Your enemies will find it hard to chase you if they freeze to death."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_FROST
	glow_color = "#00B3FF"

/obj/item/weapon/spell/aura/frost/process()
	if(!pay_energy(100))
		qdel(src)
	var/list/nearby_mobs = range(4,owner)

	var/temp_change = 25
	var/temp_cap = 260 // Just above the damage threshold, for humans.  Unathi are less fortunate.

	if(check_for_scepter())
		temp_change = 50
		temp_cap = 200
	for(var/mob/living/carbon/human/H in nearby_mobs)
		if(is_ally(H))
			continue

		var/protection = H.get_cold_protection(1000)
		if(protection < 1)
			var/cold_factor = abs(protection - 1)
			H.bodytemperature = max( (H.bodytemperature - temp_change) * cold_factor, temp_cap)

	adjust_instability(1)