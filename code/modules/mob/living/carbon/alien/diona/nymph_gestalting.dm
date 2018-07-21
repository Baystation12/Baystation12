/mob/living/carbon/alien/diona/proc/do_merge(var/mob/living/carbon/human/H)
	if(!istype(H) || !src || !(src.Adjacent(H)))
		return 0
	to_chat(H, "You feel your being twine with that of \the [src] as it merges with your biomass.")
	H.status_flags |= PASSEMOTES
	to_chat(src, "You feel your being twine with that of \the [H] as you merge with its biomass.")
	forceMove(H)
	return 1

/mob/living/carbon/alien/diona/verb/split_away()
	set name = "Split From Gestalt"
	set category = "IC"
	set src = usr

	if(incapacitated())
		return

	if(istype(loc, /obj/structure/diona_gestalt)) // Handle nymph katamari.
		var/obj/structure/diona_gestalt/gestalt = loc
		gestalt.visible_message("<span class='notice'>\The [src] wriggles out of \the [gestalt] and plops to the ground.</span>")
		gestalt.shed_nymph(src, TRUE, FALSE)
		return

	if(ishuman(loc)) // Handle larger gestalts. If they are being held inhand, their loc will be a holder item, not the mob.
		var/mob/living/carbon/human/H = loc
		if(H.species.name == SPECIES_DIONA)
			var/nymph_count = 0
			for(var/mob/living/carbon/alien/diona/chirp in H)
				nymph_count++
				if(nymph_count >= 3)
					break
			if(nymph_count < 3)
				split_into_nymphs(H) // plop
			else
				to_chat(H, "You feel a pang of loss as \the [src] splits away from your gestalt.")
				H.visible_message("\The [src] wriggles out of the depths of \the [H] and plops to the ground.")
				src.forceMove(get_turf(H))
			return

	to_chat(src, "<span>You are not within a gestalt currently.</span>")

/mob/living/carbon/alien/diona/verb/split_human_gestalt_apart()
	set name = "Split Apart"
	set desc = "Split your humanoid form into its constituent nymphs."
	set category = "Abilities"
	set src = usr.contents
	if(ishuman(loc))
		split_into_nymphs(loc)