/spell/free/merge
	name = "Merge with gestalt"
	desc = "Merge with another diona."
	hud_state = "alien_merge"
	spell_flags = 0

/spell/free/merge/choose_targets()
	var/list/choices = list()
	for(var/mob/living/carbon/human/H in view(1,holder))
		if(!holder.Adjacent(H) || !(H.client))
			continue

		if(H.species && H.species.name == "Diona")
			choices += H

	return choices

/spell/free/merge/cast(var/list/targets, var/mob/user)
	var/mob/living/M = input(user, "Who do you wish to merge with?") in null|targets
	if(!istype(user,/mob/living/carbon/alien/diona))
		return
	var/mob/living/carbon/alien/diona/D = user

	if(!M)
		user << "There is nothing nearby to merge with."
	else if(!D.do_merge(M))
		user << "You fail to merge with \the [M]"
		return
	user.remove_spell(src)


/mob/living/carbon/alien/diona/proc/do_merge(var/mob/living/carbon/human/H)
	if(!istype(H) || !src || !(src.Adjacent(H)))
		return 0
	H << "You feel your being twine with that of \the [src] as it merges with your biomass."
	H.status_flags |= PASSEMOTES
	src << "You feel your being twine with that of \the [H] as you merge with its biomass."
	loc = H
	add_spell(new /spell/free/split,0, /obj/screen/movable/spell_master/genetic)
	return 1

/spell/free/split
	name = "Split from gestalt"
	desc = "Split away from your gestalt as a lone nymph."
	spell_flags = 0
	hud_state = "wiz_diona"

/spell/free/split/choose_targets()
	if(!istype(holder.loc,/mob/living/carbon))
		var/mob/M = holder
		M.remove_spell(src)
		return null

	return list(holder)

/spell/free/split/cast(var/list/targets, var/mob/user)
	var/mob/target = targets[1]

	target.loc << "You feel a pang of loss as [target] splits away from your biomass."
	target << "You wiggle out of the depths of [target.loc]'s biomass and plop to the ground."
	var/mob/living/M = target.loc
	target.loc = get_turf(target)
	target.remove_spell(src)
	target.add_spell(new /spell/free/merge, 0, /obj/screen/movable/spell_master/genetic)

	if(istype(M))
		for(var/atom/A in M.contents)
			if(istype(A,/mob/living/simple_animal/borer) || istype(A,/obj/item/weapon/holder))
				return
	M.status_flags &= ~PASSEMOTES