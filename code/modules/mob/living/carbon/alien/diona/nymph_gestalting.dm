/mob/living/carbon/alien/diona/proc/do_merge(var/mob/living/carbon/human/H)
	if(!istype(H) || !src || !(src.Adjacent(H)) || src.incapacitated() || H.incapacitated())
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
		gestalt.shed_atom(src, TRUE, FALSE)
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
				dropInto(loc)
			return

	to_chat(src, "<span>You are not within a gestalt currently.</span>")

/mob/living/carbon/alien/diona/verb/split_human_gestalt_apart()
	set name = "Split Apart"
	set desc = "Split your humanoid form into its constituent nymphs."
	set category = "Abilities"
	set src = usr.contents
	if(ishuman(loc))
		split_into_nymphs(loc)

/mob/living/carbon/alien/diona/verb/jump_to_next_nymph()
	set name = "Jump to next nymph"
	set desc = "Switch control to another nymph from your last gestalt."
	set category = "Abilities"

	if (next_nymph && next_nymph.stat != DEAD && !next_nymph.client)

		var/mob/living/carbon/alien/diona/S = next_nymph
		transfer_languages(src, S)

		if(mind)
			to_chat(src, "<span class='info'>You're now in control of [S].</span>")
			mind.transfer_to(S)
			log_and_message_admins("has transfered to another nymph; player now controls [key_name_admin(S)]", src)
	else
		to_chat(src, "<span class='info'>There are no appropriate nymphs for you to jump into.</span>")