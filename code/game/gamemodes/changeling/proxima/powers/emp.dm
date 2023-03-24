/mob/proc/changeling_dissonant_shriek()
	set category = "Changeling"
	set name = "Dissonant Shriek (35)"
	set desc = "Shift your vocal cords to release a high-frequency sound that overloads nearby electronics."

	var/datum/changeling/changeling = changeling_power(35, 0)
	if(!changeling) return 0
	changeling.chem_charges -= 35

	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(!H.is_ventcrawling)
			for(var/obj/machinery/light/L in range(5, usr))
				L.flicker()
				if(prob(30))
					L.on = 1
					L.broken()
			empulse(get_turf(usr), 2, 4, 1)
			playsound(loc, 'sound/effects/screech.ogg', 40, 1)
			visible_message("<b>[src]</b> кричит!")
		else
			to_chat(src, SPAN_LING("We cannot do this in vents..."))
	return 1
