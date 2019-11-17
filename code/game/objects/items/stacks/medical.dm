/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/medical_kits.dmi'
	amount = 5
	max_amount = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 20

	var/heal_brute = 0
	var/heal_burn = 0
	var/animal_heal = 3
	var/apply_sounds

/obj/item/stack/medical/proc/check_limb_state(var/mob/user, var/obj/item/organ/external/limb)
	. = FALSE
	if(BP_IS_CRYSTAL(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a crystalline limb."))
	else if(BP_IS_ROBOTIC(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a robotic limb."))
	else
		. = TRUE

/obj/item/stack/medical/attack(var/mob/living/carbon/M, var/mob/user)

	if (!istype(M))
		to_chat(user, SPAN_WARNING("\The [src] cannot be applied to [M]!"))
		return 1

	if ( ! (istype(user, /mob/living/carbon/human) || \
			istype(user, /mob/living/silicon)) )
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(!affecting)
			to_chat(user, SPAN_WARNING("\The [M] is missing that body part!"))
			return 1

		if(!check_limb_state(user, affecting))
			return 1

		if(affecting.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				to_chat(user, SPAN_WARNING("You can't apply [src] through [H.head]!"))
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				to_chat(user, SPAN_WARNING("You can't apply [src] through [H.wear_suit]!"))
				return 1

		H.UpdateDamageIcon()

	else

		M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
		user.visible_message( \
			SPAN_NOTICE("[M] has been applied with [src] by [user]."), \
			SPAN_NOTICE("You apply \the [src] to [M].") \
		)
		use(1)

	M.updatehealth()
/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(TECH_BIO = 1)
	animal_heal = 5
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg')
	amount = 10

/obj/item/stack/medical/bruise_pack/attack(var/mob/living/carbon/M, var/mob/user)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()

		if(affecting.is_bandaged())
			to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been bandaged."))
			return 1
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts treating [M]'s [affecting.name]."), \
					             SPAN_NOTICE("You start treating [M]'s [affecting.name]."))
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if(W.bandaged)
					continue
				if(used == amount)
					break
				if(!do_mob(user, M, W.damage/5))
					to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
					break

				if (W.current_stage <= W.max_bleeding_stage)
					user.visible_message(SPAN_NOTICE("\The [user] bandages \a [W.desc] on [M]'s [affecting.name]."), \
					                              SPAN_NOTICE("You bandage \a [W.desc] on [M]'s [affecting.name]."))
					//H.add_side_effect("Itch")
				else if (W.damage_type == BRUISE)
					user.visible_message(SPAN_NOTICE("\The [user] places a bruise patch over \a [W.desc] on [M]'s [affecting.name]."), \
					                              SPAN_NOTICE("You place a bruise patch over \a [W.desc] on [M]'s [affecting.name].") )
				else
					user.visible_message(SPAN_NOTICE("\The [user] places a bandaid over \a [W.desc] on [M]'s [affecting.name]."), \
					                              SPAN_NOTICE("You place a bandaid over \a [W.desc] on [M]'s [affecting.name].") )
				W.bandage()
				playsound(src, pick(apply_sounds), 25)
				used++
			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					to_chat(user, SPAN_WARNING("\The [src] is used up."))
				else
					to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
			use(used)
			H.update_bandages(1)

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = list(TECH_BIO = 1)
	animal_heal = 4
	apply_sounds = list('sound/effects/ointment.ogg')

/obj/item/stack/medical/ointment/attack(var/mob/living/carbon/M, var/mob/user)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()

		if(affecting.is_salved())
			to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved."))
			return 1
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts salving wounds on [M]'s [affecting.name]."), \
					             SPAN_NOTICE("You start salving the wounds on [M]'s [affecting.name].") )
			playsound(src, pick(apply_sounds), 25)
			if(!do_mob(user, M, 10))
				to_chat(user, SPAN_NOTICE("You must stand still to salve wounds."))
				return 1
			user.visible_message(SPAN_NOTICE("[user] salved wounds on [M]'s [affecting.name]."), \
			                         SPAN_NOTICE("You salved wounds on [M]'s [affecting.name].") )
			use(1)
			affecting.salve()
			affecting.disinfect()

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 0
	origin_tech = list(TECH_BIO = 1)
	animal_heal = 12
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg','sound/effects/tape.ogg')
	amount = 10

/obj/item/stack/medical/advanced/bruise_pack/attack(var/mob/living/carbon/M, var/mob/user)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()
		if(affecting.is_bandaged() && affecting.is_disinfected())
			to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been treated."))
			return 1
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts treating [M]'s [affecting.name]."), \
					             SPAN_NOTICE("You start treating [M]'s [affecting.name].") )
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if (W.bandaged && W.disinfected)
					continue
				if(used == amount)
					break
				if(!do_mob(user, M, W.damage/5))
					to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
					break
				if (W.current_stage <= W.max_bleeding_stage)
					user.visible_message(SPAN_NOTICE("\The [user] cleans \a [W.desc] on [M]'s [affecting.name] and seals the edges with bioglue."), \
					                     SPAN_NOTICE("You clean and seal \a [W.desc] on [M]'s [affecting.name].") )
				else if (W.damage_type == BRUISE)
					user.visible_message(SPAN_NOTICE("\The [user] places a medical patch over \a [W.desc] on [M]'s [affecting.name]."), \
					                              SPAN_NOTICE("You place a medical patch over \a [W.desc] on [M]'s [affecting.name].") )
				else
					user.visible_message(SPAN_NOTICE("\The [user] smears some bioglue over \a [W.desc] on [M]'s [affecting.name]."), \
					                              SPAN_NOTICE("You smear some bioglue over \a [W.desc] on [M]'s [affecting.name].") )
				playsound(src, pick(apply_sounds), 25)
				W.bandage()
				W.disinfect()
				W.heal_damage(heal_brute)
				used++
			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					to_chat(user, SPAN_WARNING("\The [src] is used up."))
				else
					to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
			use(used)
			H.update_bandages(1)

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 5
	origin_tech = list(TECH_BIO = 1)
	animal_heal = 7
	apply_sounds = list('sound/effects/ointment.ogg')


/obj/item/stack/medical/advanced/ointment/attack(var/mob/living/carbon/M, var/mob/user)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()

		if(affecting.is_salved())
			to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved."))
			return 1
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts salving wounds on [M]'s [affecting.name]."), \
					             SPAN_NOTICE("You start salving the wounds on [M]'s [affecting.name].") )
			playsound(src, pick(apply_sounds), 25)
			if(!do_mob(user, M, 10))
				to_chat(user, SPAN_NOTICE("You must stand still to salve wounds."))
				return 1
			user.visible_message( 	SPAN_NOTICE("[user] covers wounds on [M]'s [affecting.name] with regenerative membrane."), \
									SPAN_NOTICE("You cover wounds on [M]'s [affecting.name] with regenerative membrane.") )
			affecting.heal_damage(0,heal_burn)
			use(1)
			affecting.salve()
			affecting.disinfect()

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	desc = "Modular splints capable of supporting and immobilizing bones in both limbs and appendages."
	icon_state = "splint"
	amount = 5
	max_amount = 5
	animal_heal = 0
	var/list/splintable_organs = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT)	//List of organs you can splint, natch.

/obj/item/stack/medical/splint/check_limb_state(var/mob/user, var/obj/item/organ/external/limb)
	if(BP_IS_ROBOTIC(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a robotic limb."))
		return FALSE
	return TRUE

/obj/item/stack/medical/splint/attack(var/mob/living/carbon/M, var/mob/user)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()
		var/limb = affecting.name
		if(!(affecting.organ_tag in splintable_organs))
			to_chat(user, SPAN_DANGER("You can't use \the [src] to apply a splint there!"))
			return
		if(affecting.splinted)
			to_chat(user, SPAN_DANGER("[M]'s [limb] is already splinted!"))
			return
		if (M != user)
			user.visible_message(SPAN_DANGER("[user] starts to apply \the [src] to [M]'s [limb]."), SPAN_DANGER("You start to apply \the [src] to [M]'s [limb]."), SPAN_DANGER("You hear something being wrapped."))
		else
			if(( !user.hand && (affecting.organ_tag in list(BP_R_ARM, BP_R_HAND)) || \
				user.hand && (affecting.organ_tag in list(BP_L_ARM, BP_L_HAND)) ))
				to_chat(user, SPAN_DANGER("You can't apply a splint to the arm you're using!"))
				return
			user.visible_message(SPAN_DANGER("[user] starts to apply \the [src] to their [limb]."), SPAN_DANGER("You start to apply \the [src] to your [limb]."), SPAN_DANGER("You hear something being wrapped."))
		if(user.do_skilled(5 SECONDS, SKILL_MEDICAL, M))
			if((M == user && prob(75)) || prob(user.skill_fail_chance(SKILL_MEDICAL,50, SKILL_ADEPT)))
				user.visible_message(SPAN_DANGER("\The [user] fumbles [src]."), SPAN_DANGER("You fumble [src]."), SPAN_DANGER("You hear something being wrapped."))
				return
			var/obj/item/stack/medical/splint/S = split(1, TRUE)
			if(S)
				if(affecting.apply_splint(S))
					M.verbs += /mob/living/carbon/human/proc/remove_splints
					S.forceMove(affecting)
					if (M != user)
						user.visible_message(SPAN_DANGER("\The [user] finishes applying [src] to [M]'s [limb]."), SPAN_DANGER("You finish applying \the [src] to [M]'s [limb]."), SPAN_DANGER("You hear something being wrapped."))
					else
						user.visible_message(SPAN_DANGER("\The [user] successfully applies [src] to their [limb]."), SPAN_DANGER("You successfully apply \the [src] to your [limb]."), SPAN_DANGER("You hear something being wrapped."))
					return
				S.dropInto(src.loc) //didn't get applied, so just drop it
			user.visible_message(SPAN_DANGER("\The [user] fails to apply [src]."), SPAN_DANGER("You fail to apply [src]."), SPAN_DANGER("You hear something being wrapped."))
		return

/obj/item/stack/medical/splint/ghetto
	name = "makeshift splints"
	singular_name = "makeshift splint"
	desc = "For holding your limbs in place with duct tape and scrap metal."
	icon_state = "tape-splint"
	amount = 1
	splintable_organs = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)

// For Kharmaani/adherent.
/obj/item/stack/medical/resin
	name = "resin patches"
	singular_name = "resin patch"
	desc = "A resin-based patching kit used to repair crystalline bodyparts. The label is written in a colourful, angular, unreadable script."
	icon_state = "resin-pack"
	heal_brute = 10
	heal_burn =  10

/obj/item/stack/medical/resin/drone
	amount = 25
	max_amount = 25

/obj/item/stack/medical/resin/handmade
	name = "resin globules"
	desc = "A lump of slick, shiny resin. Used to repair damage to crystalline bodyparts."
	singular_name = "resin globule"
	icon_state = "resin-lump"
	heal_brute = 5
	heal_burn =  5

/obj/item/stack/medical/resin/check_limb_state(var/mob/user, var/obj/item/organ/external/limb)
	if(!BP_IS_ROBOTIC(limb) && !BP_IS_CRYSTAL(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat an organic limb."))
		return FALSE
	return TRUE

/obj/item/stack/medical/resin/attack(var/mob/living/carbon/M, var/mob/user)
	. = ..()
	if(!. && ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)
		if((affecting.brute_dam + affecting.burn_dam) <= 0)
			to_chat(user, SPAN_WARNING("\The [M]'s [affecting.name] is undamaged."))
			return 1
		user.visible_message(
			SPAN_NOTICE("\The [user] starts patching fractures on \the [M]'s [affecting.name]."), \
			SPAN_NOTICE("You start patching fractures on \the [M]'s [affecting.name].") )
		playsound(src, pick(apply_sounds), 25)
		if(!do_mob(user, M, 10))
			to_chat(user, SPAN_NOTICE("You must stand still to patch fractures."))
			return 1
		user.visible_message( \
			SPAN_NOTICE("\The [user] patches the fractures on \the [M]'s [affecting.name] with resin."), \
			SPAN_NOTICE("You patch fractures on \the [M]'s [affecting.name] with resin."))
		affecting.heal_damage(heal_brute, heal_burn, robo_repair = TRUE)
		use(1)
