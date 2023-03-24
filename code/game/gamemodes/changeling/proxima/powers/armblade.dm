/mob/proc/armblades()
	set category = "Changeling"
	set name = "Form Blades (10)"
	set desc="Rupture the flesh and mend the bone of your hand into a deadly blade."

	var/datum/changeling/changeling = changeling_power(10,0,0)
	if(!changeling)	return 0
	src.mind.changeling.chem_charges -= 10

	var/mob/living/M = src

	var/obj/item/melee/arm_blade/blade = M
	for(blade in M.contents)
		M.drop_from_inventory(blade)
		return

	if(M.l_hand && M.r_hand)
		to_chat(M, SPAN_LING("Our hands are full."))
		return

	M.visible_message(SPAN_DANGER("[M]\'s arm begins to twist and rip!"),
							SPAN_LING("Our arm twists and mutates, transforming it into a deadly blade."),
							SPAN_DANGER("You hear organic matter ripping and tearing!"))
	playsound(get_turf(src), 'proxima/sound/effects/lingextends.ogg', 50, 1)
	spawn(1 SECOND)
		blade = new(M)
		blade.creator = M
		M.put_in_hands(blade)
		playsound(loc, 'proxima/sound/weapons/bloodyslice.ogg', 30, 1)
