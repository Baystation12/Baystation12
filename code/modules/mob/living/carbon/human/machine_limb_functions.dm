/datum/species/machine
	inherent_verbs = list(/mob/living/carbon/human/proc/detach_limb, /mob/living/carbon/human/proc/attach_limb)

/mob/living/carbon/human/proc/detach_limb()
	set category = "Abilities"
	set name = "Detach Limb"
	set desc = "Detach one of your robotic appendages."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained())
		to_chat(src,"<span class='warning'>You can't do that in your current state!</span>")
		return

	var/obj/item/organ/external/E = get_organ(zone_sel.selecting)

	if(!E)
		to_chat(src,"<span class='warning'>You are missing that limb.</span>")
		return

	if(!BP_IS_ROBOTIC(E))
		to_chat(src,"<span class='warning'>You can only detach robotic limbs.</span>")
		return

	if(E.is_stump() || E.is_broken())
		to_chat(src,"<span class='warning'>The limb is too damaged to be removed manually!</span>")
		return

	if(E.vital)
		to_chat(src,"<span class='warning'>Your safety system stops you from removing \the [E].</span>")
		return

	if(!do_after(src, 2 SECONDS, src)) return

	last_special = world.time + 20

	E.removed(src)
	E.forceMove(get_turf(src))

	update_body()
	updatehealth()
	UpdateDamageIcon()

	visible_message("<span class='notice'>\The [src] detaches \his [E]!</span>",
			"<span class='notice'>You detach your [E]!</span>")

/mob/living/carbon/human/proc/attach_limb()
	set category = "Abilities"
	set name = "Attach Limb"
	set desc = "Attach a robotic limb to your body."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained())
		to_chat(src,"<span class='warning'>You can not do that in your current state!</span>")
		return

	var/obj/item/organ/external/O = src.get_active_hand()

	if(istype(O))

		if(!BP_IS_ROBOTIC(O))
			to_chat(src,"<span class='warning'>You are unable to interface with organic matter.</span>")
			return

	if(!O)
		return


	var/obj/item/organ/external/E = get_organ(zone_sel.selecting)

	if(E)
		to_chat(src,"<span class='warning'>You are not missing that limb.</span>")
		return

	if(!do_after(src, 2 SECONDS, src)) return

	last_special = world.time + 20

	src.drop_from_inventory(O)
	O.replaced(src)
	src.update_body()
	src.updatehealth()
	src.UpdateDamageIcon()

	update_body()
	updatehealth()
	UpdateDamageIcon()

	visible_message("<span class='notice'>\The [src] attaches \the [O] to \his body!</span>",
			"<span class='notice'>You attach \the [O] to your body!</span>")
