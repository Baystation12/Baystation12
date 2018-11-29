
//these are just copy paste of the bruise pack and ointment code
/obj/machinery/autosurgeon/proc/first_aid_bruise()
	//return 1 if we have done some successful first aiding
	. = 0
	if(buckled_mob)
		if(internal_bruise_pack && internal_bruise_pack.amount > 0)
			for(var/obj/item/organ/external/affecting in buckled_mob)

				if(affecting.is_bandaged())
					continue

				var/used = 0
				for (var/datum/wound/W in affecting.wounds)
					if(W.bandaged)
						continue
					if(used == internal_bruise_pack.amount)
						break

					if (W.current_stage <= W.max_bleeding_stage)
						src.visible_message("<span class='info'>[src] bandages \a [W.desc] on [buckled_mob]'s [affecting.name].</span>")
					else if (W.damage_type == BRUISE)
						src.visible_message("<span class='info'>[src] places a bruise patch over \a [W.desc] on [buckled_mob]'s [affecting.name].</span>")
					else
						src.visible_message("<span class='info'>[src] places a bandaid over \a [W.desc] on [buckled_mob]'s [affecting.name].</span>")
					W.bandage()
					W.disinfect()
					used++
					. = 1

					//only repair 1 piece of damage per tick
					break

				affecting.update_damages()
				if(used == internal_bruise_pack.amount)
					if(affecting.is_bandaged())
						src.visible_message("<span class='warning'>\The [src] has used up its [internal_bruise_pack].</span>")
					else
						src.visible_message("<span class='warning'>\The [src] has used up its [internal_bruise_pack], but there are more wounds to treat on [buckled_mob]'s [affecting.name].</span>")
				internal_bruise_pack.use(used)

				//only repair 1 piece of damage per tick
				if(.)
					break

/obj/machinery/autosurgeon/proc/first_aid_burn()
	//return 1 if we have done some successful first aiding
	. = 0
	if(buckled_mob)
		if(internal_ointment && internal_ointment.amount > 0)
			for(var/obj/item/organ/external/affecting in buckled_mob)

				if(affecting.is_bandaged())
					continue

				var/used = 0
				for (var/datum/wound/W in affecting.wounds)
					if(W.bandaged)
						continue
					if(used == internal_ointment.amount)
						break
					if(!do_mob(buckled_mob, src, W.damage/5))
						break

					if (W.current_stage <= W.max_bleeding_stage)
						src.visible_message("<span class='info'>[src] bandages \a [W.desc] on [buckled_mob]'s [affecting.name].</span>")
					else if (W.damage_type == BRUISE)
						src.visible_message("<span class='info'>[src] places a bruise patch over \a [W.desc] on [buckled_mob]'s [affecting.name].</span>")
					else
						src.visible_message("<span class='info'>[src] places a bandaid over \a [W.desc] on [buckled_mob]'s [affecting.name].</span>")
					W.bandage()
					W.disinfect()
					used++
					. = 1
					break

				affecting.update_damages()
				if(used == internal_ointment.amount)
					if(affecting.is_bandaged())
						src.visible_message("<span class='warning'>\The [src] has used up its [internal_ointment].</span>")
					else
						src.visible_message("<span class='warning'>\The [src] has used up its [internal_ointment], but there are more wounds to treat on [buckled_mob]'s [affecting.name].</span>")
				internal_ointment.use(used)

				if(.)
					break

/obj/machinery/autosurgeon/proc/first_aid_splint()
	//return 1 if we have done some successful first aiding
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
