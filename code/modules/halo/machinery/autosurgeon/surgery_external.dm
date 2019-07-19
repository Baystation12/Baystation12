
/obj/machinery/autosurgeon/proc/surgery_external()
	//return 1 if we have done some successful medicing
	. = 0

	if(buckled_mob && ishuman(buckled_mob))
		if(surgery_target_ext)

			if(surgery_target_ext.open())
				if(surgery_target_ext.implants.len)
					//remove bad implant
					for(var/I in surgery_target_ext.implants)
						var/obj/item/weapon/implant/imp = I
						if(!istype(imp) || !imp.known)
							surgery_target_ext.implants -= imp
							for(var/datum/wound/wound in surgery_target_ext.wounds)
								if(imp in wound.embedded_objects)
									wound.embedded_objects -= imp
									break
							src.visible_message("<span class='info'>\The [src] has removed a [imp] from [buckled_mob]'s [surgery_target_ext].</span>")
							imp.dropInto(buckled_mob.loc)
							imp.add_blood(buckled_mob)
							imp.update_icon()
							if(istype(imp))
								imp.removed()
							playsound(src.loc, 'sound/effects/squelch1.ogg', 15, 1)
							. = 1
							surgery_target_ext = null

				else if(surgery_target_ext.status & ORGAN_BROKEN)
					//fix broken
					src.visible_message("<span class='info'>\The [src] has mended a fractured bone in [buckled_mob]'s [surgery_target_ext].</span>")
					playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
					surgery_target_ext.mend_fracture()
					. = 1
					surgery_target_ext = null

				else if(surgery_target_ext.status & ORGAN_TENDON_CUT)
					//fix artery cut
					src.visible_message("<span class='info'>\The [src] has mended a severed tendon in [buckled_mob]'s [surgery_target_ext].</span>")
					playsound(src.loc, 'sound/items/Welder.ogg', 15, 1)
					surgery_target_ext.status &= ~ORGAN_TENDON_CUT
					surgery_target_ext.update_damages()
					. = 1
					surgery_target_ext = null

				else if(surgery_target_ext.status & ORGAN_ARTERY_CUT)
					//fix tendon cut
					src.visible_message("<span class='info'>\The [src] has mended a severed artery in [buckled_mob]'s [surgery_target_ext].</span>")
					playsound(src.loc, 'sound/items/Welder.ogg', 15, 1)
					surgery_target_ext.status &= ~ORGAN_ARTERY_CUT
					. = 1
					surgery_target_ext = null
			else
				//make a surgical incision so we can access it
				var/datum/wound/W = surgery_target_ext.createwound(CUT, surgery_target_ext.min_broken_damage/2, 1)
				if (W.infection_check(dirtiness))
					W.germ_level += 1
				playsound(src.loc, 'sound/weapons/bladeslice.ogg', 15, 1)

				//stop the bleeding
				surgery_target_ext.clamp()
				src.visible_message("<span class='info'>\The [src] opens a surgical incision on [buckled_mob]'s [surgery_target_ext] then clamps the wound.</span>")
				. = 1
		else
			for(var/obj/item/organ/external/external in buckled_mob:bad_external_organs)

				if(external.status & ORGAN_BROKEN)
					surgery_target_ext = external
					src.visible_message("<span class='info'>\The [src] has located a broken bone in [buckled_mob]'s [surgery_target_ext].</span>")

				else if(external.status & ORGAN_TENDON_CUT)
					surgery_target_ext = external
					src.visible_message("<span class='info'>\The [src] has located a severed tendon in [buckled_mob]'s [surgery_target_ext].</span>")

				else if(external.status & ORGAN_ARTERY_CUT)
					surgery_target_ext = external
					src.visible_message("<span class='info'>\The [src] has located a severed artery in [buckled_mob]'s [surgery_target_ext].</span>")

				for(var/I in external.implants)
					var/obj/item/weapon/implant/imp = I
					if(!istype(imp) || !imp.known)
						surgery_target_ext = external
						src.visible_message("<span class='info'>\The [src] has located a foreign body in [buckled_mob]'s [surgery_target_ext].</span>")
						break

				if(surgery_target_ext)
					playsound(src.loc, 'sound/machines/buttonbeep.ogg', 15, 1)
					. = 1
					break
