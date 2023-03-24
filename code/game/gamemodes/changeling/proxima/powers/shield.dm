/mob/proc/changeling_shield()
	set category = "Changeling"
	set name = "Form Shield (10)"
	set desc="Bend the flesh and bone of your hand into a grotesque shield."

	var/datum/changeling/changeling = changeling_power(10,0,0)
	if(!changeling)	return 0
	src.mind.changeling.chem_charges -= 10

	var/mob/living/M = src

	var/obj/item/shield/riot/changeling/shield = M
	for(shield in M.contents)
		M.drop_from_inventory(shield)
		return

	if(M.l_hand && M.r_hand)
		to_chat(M, SPAN_LING("Our hands are full."))
		return

	M.visible_message(SPAN_DANGER("[M]\'s arm begins to twist and rip!"),
							SPAN_LING("Our arm twists and mutates, transforming it into a deadly blade."),
							SPAN_DANGER("You hear organic matter ripping and tearing!"))
	playsound(get_turf(src), 'proxima/sound/effects/lingextends.ogg', 50, 1)
	spawn(6)
		shield = new(M)
		shield.creator = M
		M.put_in_hands(shield)
		playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
