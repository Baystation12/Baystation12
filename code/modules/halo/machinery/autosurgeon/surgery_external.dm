
/obj/machinery/autosurgeon/proc/surgery_external()
	//return 1 if we have done some successful medicing
	. = 0

	if(buckled_mob && ishuman(buckled_mob))
		if(surgery_target_ext)

			//we have foreign objects embedded in us... shrapnel etc
			if(buckled_mob.embedded.len)
				//identify the embedded object
				var/obj/item/embedded_object = buckled_mob.embedded[1]

				//remove it
				surgery_target_ext.implants -= embedded_object
				for(var/datum/wound/wound in surgery_target_ext.wounds)
					wound.embedded_objects -= embedded_object
				buckled_mob:shock_stage += 20
				buckled_mob:embedded -= embedded_object
				surgery_target_ext.implants -= embedded_object
				embedded_object.forceMove(get_turf(src))

				//remove the yank out verb
				var/list/valid_objects = buckled_mob.get_visible_implants(0)
				if(valid_objects.len == 1) //Yanking out last object - removing verb.
					buckled_mob.verbs -= /mob/proc/yank_out_object
					buckled_mob:embedded_flag = 0

				//feedback to players
				src.visible_message("<span class='info'>\The [src] has removed a foreign object ([embedded_object]) from [buckled_mob]'s [surgery_target_ext.name].</span>")
				playsound(src.loc, 'sound/effects/squelch1.ogg', 15, 1)
				. = 1
				surgery_target_ext = null

			else if(surgery_target_ext.open())

				if(surgery_target_ext.status & ORGAN_ARTERY_CUT)
					//massive bleed outs... its important this get healed first
					surgery_target_ext.status &= ~ORGAN_ARTERY_CUT
					surgery_target_ext.update_damages()

					//feedback to players
					src.visible_message("<span class='info'>\The [src] has mended a severed artery in [buckled_mob]'s [surgery_target_ext.name].</span>")
					playsound(src.loc, 'sound/items/Welder.ogg', 15, 1)

					buckled_mob:shock_stage += 20
					. = 1
					surgery_target_ext = null

				else if(surgery_target_ext.status & ORGAN_BROKEN)
					//we have to fix some of the brute damage, otherwise the bone will immediately break again
					var/list/brute_wounds = list()
					for(var/datum/wound/W in surgery_target_ext.wounds)
						if(W.damage_type in list(CUT, PIERCE, BRUISE))
							brute_wounds.Add(W)

					//funnily enough this may actually partially fix the surgical incision made to fix the bone in the first place
					for(var/datum/wound/W in brute_wounds)
						var/amount_healed = W.damage - ((surgery_target_ext.min_broken_damage * config.organ_health_multiplier) / brute_wounds.len)
						W.heal_damage(amount_healed)
					surgery_target_ext.update_damages()

					//actually mend the break
					surgery_target_ext.mend_fracture()

					//feedback to players
					src.visible_message("<span class='info'>\The [src] has mended a fractured bone in [buckled_mob]'s [surgery_target_ext.name].</span>")
					playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)

					buckled_mob:shock_stage += 20
					. = 1
					surgery_target_ext = null

				else if(surgery_target_ext.status & ORGAN_TENDON_CUT)
					//fix artery cut
					surgery_target_ext.status &= ~ORGAN_TENDON_CUT
					surgery_target_ext.update_damages()

					//feedback to players
					src.visible_message("<span class='info'>\The [src] has mended a severed tendon in [buckled_mob]'s [surgery_target_ext.name].</span>")
					playsound(src.loc, 'sound/items/Welder.ogg', 15, 1)

					buckled_mob:shock_stage += 20
					. = 1

			else
				//make a surgical incision so we can access it
				var/datum/wound/W = surgery_target_ext.createwound(CUT, surgery_target_ext.min_broken_damage/2, 1)
				if (W.infection_check(dirtiness))
					W.germ_level += 1
				playsound(src.loc, 'sound/weapons/bladeslice.ogg', 15, 1)

				//stop the bleeding
				surgery_target_ext.clamp_organ()
				surgery_target_ext.update_damages()

				buckled_mob:shock_stage += 10
				src.visible_message("<span class='info'>\The [src] opens a surgical incision on [buckled_mob]'s [surgery_target_ext.name] then clamps the wound.</span>")
				. = 1

		else if(buckled_mob.embedded.len)

			var/obj/item/embedded_object = buckled_mob.embedded[1]
			for(var/obj/item/organ/external/organ in buckled_mob:organs) //find the organ holding the implant.
				for(var/obj/item/O in organ.implants)
					if(embedded_object == O)
						embedded_object = O
						surgery_target_ext = organ
						break

				if(surgery_target_ext)
					break

			src.visible_message("<span class='info'>\The [src] has located a foreign object ([embedded_object]) in [buckled_mob]'s [surgery_target_ext.name].</span>")
			playsound(src.loc, 'sound/machines/buttonbeep.ogg', 15, 1)
			. = 1

		else

			for(var/obj/item/organ/external/external in buckled_mob:bad_external_organs)

				if(external.status & ORGAN_ARTERY_CUT)
					surgery_target_ext = external
					src.visible_message("<span class='info'>\The [src] has located a severed artery in [buckled_mob]'s [surgery_target_ext.name].</span>")

				else if(external.status & ORGAN_BROKEN)
					surgery_target_ext = external
					src.visible_message("<span class='info'>\The [src] has located a broken bone in [buckled_mob]'s [surgery_target_ext.name].</span>")

				else if(external.status & ORGAN_TENDON_CUT)
					surgery_target_ext = external
					src.visible_message("<span class='info'>\The [src] has located a severed tendon in [buckled_mob]'s [surgery_target_ext.name].</span>")

				if(surgery_target_ext)
					. = 1
					break
