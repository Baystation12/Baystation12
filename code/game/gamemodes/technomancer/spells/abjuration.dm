/datum/technomancer/spell/abjuration
	name = "Abjuration"
	desc = "This ability attempts to send summoned or teleported entities or anomalies to the place from whence they came, or at least \
	far away from the caster.  Failing that, it may inhibit those entities in some form."
	cost = 25
	obj_path = /obj/item/weapon/spell/abjuration
	ability_icon_state = "tech_abjuration"
	category = UTILITY_SPELLS

/obj/item/weapon/spell/abjuration
	name = "abjuration"
	desc = "Useful for unruly minions, hostile summoners, or for fighting the horrors that may await you with your hubris."
	icon_state = "generic"
	cast_methods = CAST_RANGED
	aspect = ASPECT_TELE

/obj/item/weapon/spell/abjuration/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /mob/living) && pay_energy(500))
		var/mob/living/L = hit_atom
		var/mob/living/simple_animal/SA = null

		//Bit of a roundabout typecheck, in order to test for two variables from two different mob types in one line.
		if(istype(L, /mob/living/simple_animal))
			SA = L
		if(L.summoned || (SA && SA.supernatural) )
			if(L.client) // Player-controlled mobs are immune to being killed by this.
				to_chat(user,"<span class='warning'>\The [L] resists your attempt to banish it!</span>")
				to_chat(L,"<span class='warning'>\The [user] tried to teleport you far away, but failed.</span>")
				return 0
			else
				visible_message("<span class='notice'>\The [L] vanishes!</span>")
				qdel(L)
		else if(istype(L, /mob/living/simple_animal/construct))
			var/mob/living/simple_animal/construct/evil = L
			to_chat(evil,"<span class='danger'>\The [user]'s abjuration purges your form!</span>")
			evil.purge = 3
		adjust_instability(5)
	// In case NarNar comes back someday.
	if(istype(hit_atom, /obj/singularity/narsie))
		to_chat(user,"<span class='danger'>One does not simply abjurate Nar'sie away.</span>")
		adjust_instability(200)