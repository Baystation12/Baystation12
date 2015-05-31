/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items.dmi'
	amount = 5
	max_amount = 5
	w_class = 2
	throw_speed = 4
	throw_range = 20
	var/heal_brute = 0
	var/heal_burn = 0

/obj/item/stack/medical/attack(mob/living/carbon/M as mob, mob/user as mob)
	if (!istype(M))
		user << "\red \The [src] cannot be applied to [M]!"
		return 1

	if ( ! (istype(user, /mob/living/carbon/human) || \
			istype(user, /mob/living/silicon)) )
		user << "\red You don't have the dexterity to do this!"
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.name == "head")
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				user << "\red You can't apply [src] through [H.head]!"
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				user << "\red You can't apply [src] through [H.wear_suit]!"
				return 1

		if(affecting.status & ORGAN_ROBOT)
			user << "\red This isn't useful at all on a robotic limb.."
			return 1

		H.UpdateDamageIcon()

	else

		M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
		user.visible_message( \
			"\blue [M] has been applied with [src] by [user].", \
			"\blue You apply \the [src] to [M]." \
		)
		use(1)

	M.updatehealth()
/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(TECH_BIO = 1)

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(!affecting.bandage())
				user << "\red The wounds on [M]'s [affecting.name] have already been bandaged."
				return 1
			else
				for (var/datum/wound/W in affecting.wounds)
					if (W.internal)
						continue
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message("<span class='notice'>\The [user] bandages [W.desc] on [M]'s [affecting.name].</span>", \
										"<span class='notice'>You bandage [W.desc] on [M]'s [affecting.name].</span>" )
						//H.add_side_effect("Itch")
					else if (istype(W,/datum/wound/bruise))
						user.visible_message("<span class='notice'>\The [user] places a bruise patch over [W.desc] on [M]'s [affecting.name].</span>", \
										"<span class='notice'>You place a bruise patch over [W.desc] on [M]'s [affecting.name].</span>" )
					else
						user.visible_message("<span class='notice'>\The [user] places a bandaid over [W.desc] on [M]'s [affecting.name].</span>", \
										"<span class='notice'>You place a bandaid over [W.desc] on [M]'s [affecting.name].</span>" )
				use(1)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>"

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = list(TECH_BIO = 1)

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(!affecting.salve())
				user << "\red The wounds on [M]'s [affecting.name] have already been salved."
				return 1
			else
				user.visible_message( 	"\blue [user] salves wounds on [M]'s [affecting.name].", \
										"\blue You salve wounds on [M]'s [affecting.name]." )
				use(1)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>"

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 12
	origin_tech = list(TECH_BIO = 1)

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			var/bandaged = affecting.bandage()
			var/disinfected = affecting.disinfect()

			if(!(bandaged || disinfected))
				user << "<span class='warning'>The wounds on [M]'s [affecting.name] have already been treated.</span>"
				return 1
			else
				for (var/datum/wound/W in affecting.wounds)
					if (W.internal)
						continue
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message("<span class='notice'>\The [user] cleans [W.desc] on [M]'s [affecting.name] and seals the edges with bioglue.</span>", \
										"<span class='notice'>You clean and seal [W.desc] on [M]'s [affecting.name].</span>" )
						//H.add_side_effect("Itch")
					else if (istype(W,/datum/wound/bruise))
						user.visible_message("<span class='notice'>\The [user] places a medical patch over [W.desc] on [M]'s [affecting.name].</span>", \
										"<span class='notice'>You place a medical patch over [W.desc] on [M]'s [affecting.name].</span>" )
					else
						user.visible_message("<span class='notice'>\The [user] smears some bioglue over [W.desc] on [M]'s [affecting.name].</span>", \
										"<span class='notice'>You smear some bioglue over [W.desc] on [M]'s [affecting.name].</span>" )
				if (bandaged)
					affecting.heal_damage(heal_brute,0)
				use(1)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>"

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 12
	origin_tech = list(TECH_BIO = 1)


/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(!affecting.salve())
				user << "\red The wounds on [M]'s [affecting.name] have already been salved."
				return 1
			else
				user.visible_message( 	"\blue [user] covers wounds on [M]'s [affecting.name] with regenerative membrane.", \
										"\blue You cover wounds on [M]'s [affecting.name] with regenerative membrane." )
				affecting.heal_damage(0,heal_burn)
				use(1)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>"

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	icon_state = "splint"
	amount = 5
	max_amount = 5

/obj/item/stack/medical/splint/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)
		var/limb = affecting.name
		if(!(affecting.limb_name in list("l_arm","r_arm","l_leg","r_leg")))
			user << "<span class='danger'>You can't apply a splint there!</span>"
			return
		if(affecting.status & ORGAN_SPLINTED)
			user << "<span class='danger'>[M]'s [limb] is already splinted!</span>"
			return
		if (M != user)
			user.visible_message("<span class='danger'>[user] starts to apply \the [src] to [M]'s [limb].</span>", "<span class='danger'>You start to apply \the [src] to [M]'s [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
		else
			if((!user.hand && affecting.limb_name == "r_arm") || (user.hand && affecting.limb_name == "l_arm"))
				user << "<span class='danger'>You can't apply a splint to the arm you're using!</span>"
				return
			user.visible_message("<span class='danger'>[user] starts to apply \the [src] to their [limb].</span>", "<span class='danger'>You start to apply \the [src] to your [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
		if(do_after(user, 50))
			if (M != user)
				user.visible_message("<span class='danger'>[user] finishes applying \the [src] to [M]'s [limb].</span>", "<span class='danger'>You finish applying \the [src] to [M]'s [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
			else
				if(prob(25))
					user.visible_message("<span class='danger'>[user] successfully applies \the [src] to their [limb].</span>", "<span class='danger'>You successfully apply \the [src] to your [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
				else
					user.visible_message("<span class='danger'>[user] fumbles \the [src].</span>", "<span class='danger'>You fumble \the [src].</span>", "<span class='danger'>You hear something being wrapped.</span>")
					return
			affecting.status |= ORGAN_SPLINTED
			use(1)
		return
