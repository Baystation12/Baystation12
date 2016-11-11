/datum/technomancer/spell/unstable_aura
	name = "Degen Aura"
	desc = "Destabalizes your enemies, breaking their elements down to their basic levels, slowly killing them from the inside.  \
	For each person within fourteen meters of you, they suffer 1% of their current health every second.  Your allies are unharmed."
	cost = 150
	obj_path = /obj/item/weapon/spell/aura/unstable
	ability_icon_state = "tech_unstableaura"
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/aura/unstable
	name = "degen aura"
	desc = "Breaks down your entities from the inside."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_UNSTABLE
	glow_color = "#0000FF" //TODO

/obj/item/weapon/spell/aura/unstable/process()
	if(!pay_energy(200))
		qdel(src)
	var/list/nearby_mobs = range(14,owner)
	for(var/mob/living/L in nearby_mobs)
		if(is_ally(L))
			continue

		var/damage_to_inflict = max(L.health / L.maxHealth, 0) // Otherwise, those in crit would actually be healed.

		var/armor_factor = abs(L.getarmor(null, "energy") - 100)
		armor_factor = armor_factor / 100

		damage_to_inflict = damage_to_inflict * armor_factor

		if(L.isSynthetic())
			L.adjustBruteLoss(damage_to_inflict)
			if(damage_to_inflict && prob(10))
				to_chat(L,"<span class='danger'>Your chassis seems to slowly be decaying and breaking down.</span>")
		else
			L.adjustToxLoss(damage_to_inflict)
			if(damage_to_inflict && prob(10))
				to_chat(L,"<span class='danger'>You feel almost like you're melting from the inside!</span>")


	adjust_instability(2)