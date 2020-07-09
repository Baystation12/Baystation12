
//these are just copy paste of the bruise pack and ointment code
/obj/machinery/autosurgeon/proc/surgery_internal()
	//return 1 if we have done some successful medicing
	. = 0
	if(buckled_mob && ishuman(buckled_mob))
		if(surgery_target_int)
			//get the corresponding external organ to the internal one we are trying to fix
			surgery_target_ext = surgery_target_int.owner.get_organ(surgery_target_int.parent_organ)

			//check if we can access it
			if(surgery_target_int.surface_accessible || surgery_target_ext.open())

				//why are we targetting this internal organ?
				if(do_autopsy)
					surgery_target_int.removed()
					surgery_target_int.plane = ABOVE_OBJ_PLANE		//so its visible
					src.visible_message("<span class='info'>[src] extracts the [surgery_target_int] from [buckled_mob].</span>")
					playsound(src.loc, 'sound/effects/squelch1.ogg', 50, 1)
					buckled_mob:shock_stage += 5
					. = 1

				else if(surgery_target_int.status & ORGAN_BROKEN)
					//fixi the broken status... this is a bit of a gimmick
					surgery_target_int.status &= ~ORGAN_BROKEN
					src.visible_message("<span class='info'>\The [src] fixes [buckled_mob]'s [surgery_target_int.name].</span>")
					playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1)
					buckled_mob:shock_stage += 20
					. = 1

				else if(surgery_target_int.damage > 0)
					//fix ordinary damage
					surgery_target_int.damage = 0
					src.visible_message("<span class='info'>\The [src] treats organ damage in [buckled_mob]'s [surgery_target_int.name].</span>")
					playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1)
					buckled_mob:shock_stage += 20
					. = 1
			else
				//make a surgical incision so we can access it
				var/datum/wound/W = surgery_target_ext.createwound(CUT, surgery_target_ext.min_broken_damage/2, 1)
				if (W.infection_check(dirtiness))
					W.germ_level += 1
				playsound(src.loc, 'sound/weapons/bladeslice.ogg', 50, 1)

				//stop the bleeding
				surgery_target_ext.clamp_organ()
				buckled_mob:shock_stage += 20
				src.visible_message("<span class='info'>\The [src] opens a surgical incision on [buckled_mob]'s [surgery_target_ext.name] then clamps the wound.</span>")
				. = 1
				return

			//if we did something, we are probably finished with this organ
			if(.)
				surgery_target_int = null
				surgery_target_ext = null
		else
			//scan over the internal organs to find any problems
			for(var/obj/item/organ/internal/internal in buckled_mob:internal_organs)

				//why are we interested in this organ?
				if(do_autopsy)
					//dont extract vital organs yet
					if(internal.vital)
						continue
					surgery_target_int = internal
					src.visible_message("<span class='notice'>[src] has located something interesting in [buckled_mob]: [surgery_target_int].</span>")

				else if(internal.is_broken() || internal.is_damaged())
					//something is wrong
					surgery_target_int = internal
					src.visible_message("<span class='notice'>\The [src] has located damage to [buckled_mob]'s [surgery_target_int.name].</span>")

				if(surgery_target_int)
					. = 1
					break

			//we didnt get anything, so do a second pass
			if(do_autopsy && !surgery_target_int)
				for(var/obj/item/organ/internal/internal in buckled_mob:internal_organs)
					surgery_target_int = internal
					src.visible_message("<span class='notice'>[src] has located something vital in [buckled_mob]: [surgery_target_int].</span>")
					. = 1
					break

			if(surgery_target_int)
				playsound(src.loc, 'sound/machines/twobeep.ogg', 15, 1)
