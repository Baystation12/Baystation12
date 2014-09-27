//Verbs after this point.
/mob/living/carbon/alien/diona/proc/merge()

	set category = "Abilities"
	set name = "Merge with gestalt"
	set desc = "Merge with another diona."

	if(istype(src.loc,/mob/living/carbon))
		src.verbs -= /mob/living/carbon/alien/diona/proc/merge
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(1,src))

		if(!(src.Adjacent(C)) || !(C.client)) continue

		if(istype(C,/mob/living/carbon/human))
			var/mob/living/carbon/human/D = C
			if(D.species && D.species.name == "Diona")
				choices += C

	var/mob/living/M = input(src,"Who do you wish to merge with?") in null|choices

	if(!M || !src || !(src.Adjacent(M))) return

	if(istype(M,/mob/living/carbon/human))
		M << "You feel your being twine with that of [src] as it merges with your biomass."
		M.status_flags |= PASSEMOTES

		src << "You feel your being twine with that of [M] as you merge with its biomass."
		src.loc = M
		src.verbs += /mob/living/carbon/alien/diona/proc/split
		src.verbs -= /mob/living/carbon/alien/diona/proc/merge
	else
		return

/mob/living/carbon/alien/diona/proc/split()

	set category = "Abilities"
	set name = "Split from gestalt"
	set desc = "Split away from your gestalt as a lone nymph."

	if(!(istype(src.loc,/mob/living/carbon)))
		src.verbs -= /mob/living/carbon/alien/diona/proc/split
		return

	src.loc << "You feel a pang of loss as [src] splits away from your biomass."
	src << "You wiggle out of the depths of [src.loc]'s biomass and plop to the ground."

	var/mob/living/M = src.loc

	src.loc = get_turf(src)
	src.verbs -= /mob/living/carbon/alien/diona/proc/split
	src.verbs += /mob/living/carbon/alien/diona/proc/merge

	if(istype(M))
		for(var/atom/A in M.contents)
			if(istype(A,/mob/living/simple_animal/borer) || istype(A,/obj/item/weapon/holder))
				return
	M.status_flags &= ~PASSEMOTES

/mob/living/carbon/alien/diona/proc/steal_blood()
	set category = "Abilities"
	set name = "Steal Blood"
	set desc = "Take a blood sample from a suitable donor."

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in oview(1,src))
		if(src.Adjacent(H))
			choices += H

	var/mob/living/carbon/human/M = input(src,"Who do you wish to take a sample from?") in null|choices

	if(!M || !src) return

	if(M.species.flags & NO_BLOOD)
		src << "\red That donor has no blood to take."
		return

	if(donors.Find(M.real_name))
		src << "\red That donor offers you nothing new."
		return

	src.visible_message("\red [src] flicks out a feeler and neatly steals a sample of [M]'s blood.","\red You flick out a feeler and neatly steal a sample of [M]'s blood.")
	donors += M.real_name
	for(var/datum/language/L in M.languages)
		languages |= L

	spawn(25)
		update_progression()