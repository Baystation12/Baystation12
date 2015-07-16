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
	if(!istype(M))
		user << "<span class='warning'>\The [src] cannot be applied to [M].</span>"
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.display_name == "head")
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				user << "<span class='warning'>You can't apply [src] through [H.head].</span>"
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				user << "<span class='warning'>You can't apply [src] through [H.wear_suit].</span>"
				return 1

		if(affecting.status & ORGAN_ROBOT)
			user << "<span class='warning'>This isn't useful at all on a robotic limb.</span>"
			return 1

	else
		M.heal_organ_damage((heal_brute / 2), (heal_burn / 2))
		user.visible_message("<span class='notice'>[M] has been applied with [src] by [user].</span>", "<span class='notice'>You apply \the [src] to [M].</span>")
		use(1)
		return 1

	return 0

/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = "biotech=1"

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(!affecting.bandage())
				user << "<span class='warning'>The wounds on [M]'s [affecting.display_name] have already been bandaged.</span>"
				return 1
			else
				var/list/bleed = list()
				var/list/bruise = list()
				var/list/scratch = list()
				for(var/datum/wound/W in affecting.wounds)
					if(W.internal)
						continue
					if(W.current_stage <= W.max_bleeding_stage)
						bleed += "\a [W.desc]"
					else if(istype(W, /datum/wound/bruise))
						bruise += "\a [W.desc]"
					else
						scratch += "\a [W.desc]"
				if(bleed.len)
					var/mes = "[bleed.len == 1 ? "a bandage" : "bandages"] over [english_list(bleed)] on [M]'s [affecting.display_name]"
					user.visible_message("<span class='notice'>[user] places [mes].</span>", "<span class='notice'>You place [mes].</span>")
				if(bruise.len)
					var/mes = "[bruise.len == 1 ? "a bruise patch" : "bruise patches"] over [english_list(bruise)] on [M]'s [affecting.display_name]"
					user.visible_message("<span class='notice'>[user] places [mes].</span>", "<span class='notice'>You place [mes].</span>")
				if(scratch.len)
					var/mes = "[scratch.len == 1 ? "a bandaid" : "bandaids"] over [english_list(scratch)] on [M]'s [affecting.display_name]"
					user.visible_message("<span class='notice'>[user] places [mes].</span>", "<span class='notice'>You place [mes].</span>")
				use(1)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='warning'>The [affecting.display_name] is cut open, you'll need more than a bandage.</span>"

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = "biotech=1"

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(!affecting.salve())
				user << "<span class='warning'>The wounds on [M]'s [affecting.display_name] have already been salved.</span>"
				return 1
			else
				user.visible_message("<span class='notice'>[user] salves wounds on [M]'s [affecting.display_name].</span>", "<span class='notice'>You salve wounds on [M]'s [affecting.display_name].</span>" )
				use(1)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='warning'>The [affecting.display_name] is cut open, you'll need more than a bandage.</span>"

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 12
	origin_tech = "biotech=1"

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			var/bandaged = affecting.bandage()
			var/disinfected = affecting.disinfect()

			if(!(bandaged || disinfected))
				user << "<span class='warning'>The wounds on [M]'s [affecting.display_name] have already been treated.</span>"
				return 1
			else
				var/list/bleed = list()
				var/list/bruise = list()
				var/list/scratch = list()
				for(var/datum/wound/W in affecting.wounds)
					if(W.internal)
						continue
					if(W.current_stage <= W.max_bleeding_stage)
						bleed += "\a [W.desc]"
					else if(istype(W, /datum/wound/bruise))
						bruise += "\a [W.desc]"
					else
						scratch += "\a [W.desc]"
				if(bleed.len)
					var/mes = "[english_list(bleed)] on [M]'s [affecting.display_name]"
					user.visible_message("<span class='notice'>[user] cleans [mes] and seals edges with bioglue.</span>", "<span class='notice'>You clean and seal [mes].</span>")
				if(bruise.len)
					var/mes = "[bruise.len == 1 ? "a medicine patch" : "medicine patches"] over [english_list(bruise)] on [M]'s [affecting.display_name]"
					user.visible_message("<span class='notice'>[user] places [mes].</span>", "<span class='notice'>You place [mes].</span>")
				if(scratch.len)
					var/mes = "some bioglue over [english_list(scratch)] on [M]'s [affecting.display_name]"
					user.visible_message("<span class='notice'>[user] smears [mes].</span>", "<span class='notice'>You smear [mes].</span>")
				if(bandaged)
					affecting.heal_damage(heal_brute, 0)
				use(1)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='warning'>The [affecting.display_name] is cut open, you'll need more than a bandage.</span>"

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 12
	origin_tech = "biotech=1"

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(!affecting.salve())
				user << "<span class='warning'>The wounds on [M]'s [affecting.display_name] have already been salved.</span>"
				return 1
			else
				user.visible_message("<span class='notice'>[user] covers wounds on [M]'s [affecting.display_name] with regenerative membrane.</span>", "<span class='notice'>You cover wounds on [M]'s [affecting.display_name] with regenerative membrane.</span>" )
				affecting.heal_damage(0, heal_burn)
				use(1)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>The [affecting.display_name] is cut open, you'll need more than a bandage!</span>"

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
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)
		var/limb = affecting.display_name
		if(!(affecting.name == "l_arm" || affecting.name == "r_arm" || affecting.name == "l_leg" || affecting.name == "r_leg"))
			user << "<span class='warning'>You can't apply a splint there.</span>"
			return
		if(affecting.status & ORGAN_SPLINTED)
			user << "<span class='warning'>[M]'s [limb] is already splinted.</span>"
			return
		if(M != user)
			user.visible_message("<span class='notice'>[user] starts to apply \the [src] to [M]'s [limb].</span>", "<span class='notice'>You start to apply \the [src] to [M]'s [limb]...</span>", "<span class='notice'>You hear something being wrapped.</span>")
		else
			if((!user.hand && affecting.name == "r_arm") || (user.hand && affecting.name == "l_arm"))
				user << "<span class='warning'>You can't apply a splint to the arm you're using!</span>"
				return
			user.visible_message("<span class='notice'>[user] starts to apply \the [src] to their [limb].</span>", "<span class='notice'>You start to apply \the [src] to your [limb]...</span>", "<span class='notice'>You hear something being wrapped.</span>")
		if(do_after(user, 50))
			if(M != user)
				user.visible_message("<span class='notice'>[user] finishes applying \the [src] to [M]'s [limb].</span>", "<span class='notice'>You finish applying \the [src] to [M]'s [limb].</span>", "<span class='notice'>You hear something being wrapped.</span>")
			else
				if(prob(25))
					user.visible_message("<span class='notice'>[user] successfully applies \the [src] to their [limb].</span>", "<span class='notice'>You successfully apply \the [src] to your [limb].</span>", "<span class='notice'>You hear something being wrapped.</span>")
				else
					user.visible_message("<span class='warning'>[user] fumbles \the [src].</span>", "<span class='warning'>You fumble \the [src].</span>", "<span class='notice'>You hear something being wrapped.</span>")
					return
			affecting.status |= ORGAN_SPLINTED
			use(1)
		return
