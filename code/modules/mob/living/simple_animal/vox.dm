/mob/living/simple_animal/vox/armalis/

	name = "serpentine alien"
	real_name = "serpentine alien"
	desc = "A one-eyed, serpentine creature, half-machine, easily nine feet from tail to beak!"
	icon = 'icons/mob/vox.dmi'
	icon_state = "armalis"
	icon_living = "armalis"
	maxHealth = 500
	health = 500
	response_harm   = "flails ineffectually at the"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 40
	attacktext = "slammed its enormous claws into"
	speed = -1
	wall_smash = 1
	attack_sound = 'sound/weapons/bladeslice.ogg'
	status_flags = 0

/mob/living/simple_animal/vox/armalis/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		if(O.force >= 25)
			var/damage = O.force
			if (O.damtype == HALLOSS)
				damage = 0
			health -= damage
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message("\red \b [src] has been attacked with the [O] by [user]. ")
		else
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message("\red \b The [O] bounces harmlessly off of [src]. ")
	else
		usr << "\red This weapon is ineffective, it does no damage."
		for(var/mob/M in viewers(src, null))
			if ((M.client && !( M.blinded )))
				M.show_message("\red [user] gently taps [src] with the [O]. ")

/mob/living/simple_animal/vox/armalis/verb/fire_quill(mob/target as mob in oview())

	set name = "Fire quill"
	set desc = "Fires a viciously pointed quill at a high speed."
	set category = "Alien"

	src << "\red You launch a razor-sharp quill at [target]!"
	for(var/mob/O in oviewers())
		if ((O.client && !( O.blinded )))
			O << "\red [src] launches a razor-sharp quill at [target]!"

	var/obj/item/weapon/arrow/quill/Q = new(loc)
	Q.fingerprintslast = src
	Q.throw_at(target,10,15)