/mob/living/carbon/alien/diona/confirm_evolution()

	if(!is_species_whitelisted(src, SPECIES_DIONA))
		to_chat(src, alert("You are currently not whitelisted to play as a full diona."))
		return null

	if(amount_grown < max_grown)
		to_chat(src, "You are not yet ready for your growth...")
		return null

	src.split()

	if(istype(loc,/obj/item/weapon/holder/diona))
		var/obj/item/weapon/holder/diona/L = loc
		src.forceMove(L.loc)
		qdel(L)

	src.visible_message("<span class='warning'>\The [src] begins to shift and quiver, and erupts in a shower of shed bark as it splits into a tangle of nearly a dozen new dionaea.</span>","<span class='warning'>You begin to shift and quiver, feeling your awareness splinter. All at once, we consume our stored nutrients to surge with growth, splitting into a tangle of at least a dozen new dionaea. We have attained our gestalt form.</span>")
	return SPECIES_DIONA