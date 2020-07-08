
/obj/machinery/autosurgeon/proc/surgery_external()
	//return 1 if we have done some successful medicing
	. = 0

	if(buckled_mob && ishuman(buckled_mob))
		if(surgery_target_ext)

			//we have foreign objects embedded in us... shrapnel etc
			if(buckled_mob.embedded.len)
				if(surgery_target_ext.open())
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
					playsound(src.loc, 'sound/effects/squelch1.ogg', 50, 1)

					//find the next limb that needs attention (could be this one again)
					surgery_target_ext = null
					. = 1

				else
					//we have to open a surgical incision to remove an embedded object
					do_incision(surgery_target_ext)
					. = 1

			else if(do_autopsy)
				//amputate the limb
				surgery_target_ext.droplimb(TRUE)
				surgery_target_ext.plane = ABOVE_OBJ_PLANE		//so its visible

				src.visible_message("<span class='info'>[src] has amputated [buckled_mob]'s [surgery_target_ext.name].</span>")
				playsound(src.loc, 'sound/weapons/rapidslice.ogg', 50, 1)

				//find the next limb that needs attention
				. = 1
				surgery_target_ext = null

			else if(surgery_target_ext.open())

				//try and fix a problem with this limb

				if(surgery_target_ext.status & ORGAN_ARTERY_CUT)
					//massive bleed outs... its important this get healed first
					surgery_target_ext.status &= ~ORGAN_ARTERY_CUT
					surgery_target_ext.update_damages()

					//feedback to players
					src.visible_message("<span class='info'>\The [src] has mended the severed [surgery_target_ext.artery_name] in [buckled_mob]'s [surgery_target_ext.name].</span>")
					playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
					buckled_mob:shock_stage += 20

					//find the next limb that needs attention (could be this one again)
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

					//find the next limb that needs attention (could be this one again)
					. = 1
					surgery_target_ext = null

				else if(surgery_target_ext.status & ORGAN_TENDON_CUT)
					//fix artery cut
					surgery_target_ext.status &= ~ORGAN_TENDON_CUT
					surgery_target_ext.update_damages()

					//feedback to players
					src.visible_message("<span class='info'>\The [src] has mended the severed [surgery_target_ext.tendon_name] in [buckled_mob]'s [surgery_target_ext.name].</span>")
					playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
					buckled_mob:shock_stage += 20

					//find the next limb that needs attention (could be this one again)
					. = 1
					surgery_target_ext = null

			else
				//we have to make a surgical incision to fix any problems with this limb
				do_incision(surgery_target_ext)
				. = 1

		else if(buckled_mob.embedded.len)

			//this is a terrible way to do this, but there is no other way
			//i could fix it by tweaking organs slightly but that's a future project
			var/obj/item/embedded_object = buckled_mob.embedded[1]

			//loop over organs to find the one holding the implant.
			for(var/obj/item/organ/external/organ in buckled_mob:organs)
				for(var/obj/item/O in organ.implants)
					if(embedded_object == O)
						//found it
						embedded_object = O
						surgery_target_ext = organ
						break

				if(surgery_target_ext)
					break

			src.visible_message("<span class='info'>\The [src] has located a foreign object ([embedded_object]) in [buckled_mob]'s [surgery_target_ext.name].</span>")
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
			. = 1

		else

			if(do_autopsy)
				//find a limb to remove
				for(var/obj/item/organ/external/external in buckled_mob:organs)
					if(external.cannot_amputate)
						continue

					//dont remove limbs with sublimbs
					//this means feet and hands will be removed before their leg or arm
					if(external.children && external.children.len)
						continue

					surgery_target_ext = external
					src.visible_message("<span class='info'>[src] starts severing [buckled_mob]'s [external.amputation_point]...</span>")
					. = 1
					break

			else
				for(var/obj/item/organ/external/external in buckled_mob:bad_external_organs)

					//is there something wrong with this limb?

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
						playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
						break
