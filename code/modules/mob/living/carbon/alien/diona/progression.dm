/mob/living/carbon/alien/diona/confirm_evolution()

	if(!is_alien_whitelisted(src, "Diona") && config.usealienwhitelist)
		src << alert("You are currently not whitelisted to play as a full diona.")
		return null

	if(amount_grown < max_grown)
		src << "You are not yet ready for your growth..."
		return null

	if(istype(src.loc,/mob/living/carbon))
		var/mob/living/carbon/C = src.loc
		if(src in C.stomach_contents)
			C.gib() //sudden diona growth means bad time for eater
		var/spell/free/split/S = locate() in spell_list
		if(S)
			S.perform(src)

	if(istype(loc,/obj/item/weapon/holder/diona))
		var/obj/item/weapon/holder/diona/L = loc
		src.loc = L.loc
		qdel(L)

	src.visible_message("\red [src] begins to shift and quiver, and erupts in a shower of shed bark as it splits into a tangle of nearly a dozen new dionaea.","\red You begin to shift and quiver, feeling your awareness splinter. All at once, we consume our stored nutrients to surge with growth, splitting into a tangle of at least a dozen new dionaea. We have attained our gestalt form.")
	return "Diona"