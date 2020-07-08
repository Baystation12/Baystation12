
/obj/machinery/autosurgeon/proc/do_incision(var/obj/item/organ/external/O)
	//make a surgical incision so we can access it
	var/datum/wound/W = O.createwound(CUT, O.min_broken_damage/2, 1)
	if (W.infection_check(dirtiness))
		W.germ_level += 1
	playsound(src.loc, 'sound/weapons/bladeslice.ogg', 15, 1)

	//stop the bleeding
	O.clamp_organ()
	O.update_damages()

	buckled_mob:shock_stage += 10
	src.visible_message("<span class='info'>[src] opens a surgical incision on [buckled_mob]'s [O] then clamps the wound.</span>")
