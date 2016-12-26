/datum/technomancer/spell/targeting_matrix
	name = "Targeting Matrix"
	desc = "Automatically targets and fires a ranged weapon or function at a non-friendly target near a targeted tile.  \
	Each target assisted attack costs some energy and instability."
	cost = 50
	ability_icon_state = "tech_targetingmatrix"
	obj_path = /obj/item/weapon/spell/targeting_matrix
	category = UTILITY_SPELLS

/obj/item/weapon/spell/targeting_matrix
	name = "targeting matrix"
	desc = "Aiming is too much effort for you."
	icon_state = "targeting_matrix"
	cast_methods = CAST_RANGED
	aspect = ASPECT_FORCE //idk?

/obj/item/weapon/spell/targeting_matrix/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T)
		var/mob/living/chosen_target = targeting_assist(T,5)		//The person who's about to get attacked.

		if(!chosen_target)
			return 0

		var/obj/item/I = user.get_inactive_hand()
		if(I && pay_energy(200))
			var/prox = user.Adjacent(chosen_target)
			if(prox) // Needed or else they can attack with melee from afar.
				I.attack(chosen_target,owner)
			I.afterattack(chosen_target,owner, prox)
			adjust_instability(2)

			var/image/target_image = image(icon = 'icons/obj/spells.dmi', loc = get_turf(chosen_target), icon_state = "target")
			image_to(user,target_image)
			sleep(5)
			qdel(target_image)
