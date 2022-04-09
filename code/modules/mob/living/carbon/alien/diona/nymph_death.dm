//This essentially makes dionaea spawned by splitting into a doubly linked
//list that, when the nymph dies, transfers the controler's mind
//to the next nymph in the list.

/mob/living/carbon/alien/diona/proc/set_next_nymph(var/mob/living/carbon/alien/diona/D)
	next_nymph = D

/mob/living/carbon/alien/diona/proc/set_previous_nymph(var/mob/living/carbon/alien/diona/D)
	previous_nymph = D
// When there are only two nymphs left in a list and one is to be removed,
// call this to null it out.
/mob/living/carbon/alien/diona/proc/null_nymphs()
	next_nymph = null
	previous_nymph = null

/mob/living/carbon/alien/diona/proc/remove_from_list()
	// Closes over the gap that's going to be made and removes references to
	// the nymph this is called for.
	var/need_links_null = 0

	if (previous_nymph)
		previous_nymph.set_next_nymph(next_nymph)
		if (previous_nymph.next_nymph == previous_nymph)
			need_links_null = 1
	if (next_nymph)
		next_nymph.set_previous_nymph(previous_nymph)
		if (next_nymph.previous_nymph == next_nymph)
			need_links_null = 1
	// This bit checks if a nymphs is the only nymph in the list
	// by seeing if it points to itself. If it is, it nulls it
	// to stop list behaviour.
	if (need_links_null)
		if (previous_nymph)
			previous_nymph.null_nymphs()
		if (next_nymph)
			next_nymph.null_nymphs()
	// Finally, remove the current nymph's references to other nymphs.
	null_nymphs()

/mob/living/carbon/alien/diona/death(gibbed)

	var/obj/structure/diona_gestalt/gestalt = loc
	if(istype(gestalt))
		gestalt.shed_atom(src, TRUE, FALSE)

	if(holding_item)
		unEquip(holding_item)
	if(hat)
		unEquip(hat)

	jump_to_next_nymph()

	remove_from_list()

	return ..(gibbed,death_msg)

/mob/living/carbon/alien/diona/Destroy()
	if (previous_nymph || next_nymph)
		remove_from_list()
	return ..()
