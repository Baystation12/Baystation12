
/obj/machinery/autosurgeon/proc/first_aid()
	//return 1 if we have done some successful medicing
	. = 0
	if(buckled_mob && ishuman(buckled_mob))
		for(var/obj/item/organ/external/affecting in buckled_mob:bad_external_organs)

			for (var/datum/wound/W in affecting.wounds)
				if(W.is_treated())
					continue

				var/action_desc
				var/procname
				var/obj/item/stack/medical/used_medical

				if (W.damage_type == BRUISE)
					action_desc = "places a bruise patch"
					used_medical = internal_bruise_pack
					procname = "bandage"
				else if (W.damage_type == CUT)
					action_desc = "places a bandage"
					used_medical = internal_bruise_pack
					procname = "bandage"
				else if (W.damage_type == PIERCE)
					action_desc = "places a pad"
					used_medical = internal_bruise_pack
					procname = "bandage"
				else if (W.damage_type == BURN)
					action_desc = "salves"
					used_medical = internal_ointment
					procname = "salve"

				//only repair 1 wound per tick
				if(action_desc)
					if(used_medical && used_medical.amount > 0)
						src.visible_message("<span class='info'>[src] [action_desc] over \a [W.desc] on [buckled_mob]'s [affecting.name].</span>")
						call(W, procname)()	//this is extra cheeky, dont do this
						used_medical.use(1)
						. = 1
					else
						src.visible_message("<span class='warning'>\The [src] has used up its [procname].</span>")
					break

			affecting.update_damages()

			//only repair 1 piece of damage per tick
			if(.)
				break

/obj/machinery/autosurgeon/proc/first_aid_splint()
	//return 1 if we have done some successful medicing
	. = 0
	if(buckled_mob)
		if(internal_splint && internal_splint.amount > 0)
			for(var/obj/item/organ/external/affecting in buckled_mob)

				if(!(affecting.status & ORGAN_BROKEN))
					continue
				if(!(affecting.organ_tag in internal_splint.splintable_organs))
					continue
				if(affecting.splinted)
					continue

				var/obj/item/stack/medical/splint/S = internal_splint.split(1)
				if(S)
					if(affecting.apply_splint(S))
						S.forceMove(affecting)
						var/limb = affecting.name
						src.visible_message("<span class='info'>\The [src] applies [internal_splint] to [buckled_mob]'s [limb].</span>")
						. = 1
						break
