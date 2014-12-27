/****************************************************
			   EXTERNAL ORGAN ITEMS
****************************************************/

/obj/item/organ/external
	var/list/organs_internal = list() // Tracks organ data of organ items within.
	var/op_stage = 0                  // Tracks state of internal organ removal.
	health = 300                      // Significantly longer delay on organ death for limbs.

/obj/item/organ/external/New(loc, mob/living/carbon/human/H)

	..()
	// Setting base icon for this mob's race.
	var/icon/base
	if(H)
		// Transferring over organs from the host.
		for(var/datum/organ/internal/I in H.internal_organs)
			if(I.parent_organ != name)
				continue
			var/obj/item/organ/internal/current_organ = I.remove()
			current_organ.removed(H)
			current_organ.loc = src
			if(current_organ.organ_data)
				organs_internal |= current_organ.organ_data

		// Forming icon for the limb
		if(H.species && H.species.icobase)
			base = icon(H.species.icobase)
		else
			base = icon('icons/mob/human_races/r_human.dmi')
	if(base)
		//Changing limb's skin tone to match owner
		if(!H.species || H.species.flags & HAS_SKIN_TONE)
			if (H.s_tone >= 0)
				base.Blend(rgb(H.s_tone, H.s_tone, H.s_tone), ICON_ADD)
			else
				base.Blend(rgb(-H.s_tone,  -H.s_tone,  -H.s_tone), ICON_SUBTRACT)

	if(base)
		//Changing limb's skin color to match owner
		if(!H.species || H.species.flags & HAS_SKIN_COLOR)
			base.Blend(rgb(H.r_skin, H.g_skin, H.b_skin), ICON_ADD)

	icon = base
	set_dir(SOUTH)
	src.transform = turn(src.transform, rand(70,130))

/****************************************************
			   EXTERNAL ORGAN ITEMS DEFINES
****************************************************/

/obj/item/organ/external/l_arm
	name = "left arm"
	icon_state = "l_arm"
	part = "l_arm"

/obj/item/organ/external/l_foot
	name = "left foot"
	icon_state = "l_foot"
	part = "l_foot"

/obj/item/organ/external/l_hand
	name = "left hand"
	icon_state = "l_hand"
	part = "l_hand"

/obj/item/organ/external/l_leg
	name = "left leg"
	icon_state = "l_leg"
	part = "l_leg"

/obj/item/organ/external/r_arm
	name = "right arm"
	icon_state = "r_arm"
	part = "r_arm"

/obj/item/organ/external/r_foot
	name = "right foot"
	icon_state = "r_foot"
	part = "r_foot"

/obj/item/organ/external/r_hand
	name = "right hand"
	icon_state = "r_hand"
	part = "r_hand"

/obj/item/organ/external/r_leg
	name = "right leg"
	icon_state = "r_leg"
	part = "r_leg"

/obj/item/organ/external/head
	name = "head"
	icon_state = "head_m"
	part = "head"

/obj/item/organ/external/chest
	name = "chest"
	icon_state = "chest" //todo
	part = "chest"

// Prosthetics.
/obj/item/organ/external/l_arm/robot
	robotic = 1
/obj/item/organ/external/l_foot/robot
	robotic = 1
/obj/item/organ/external/l_hand/robot
	robotic = 1
/obj/item/organ/external/l_leg/robot
	robotic = 1
/obj/item/organ/external/r_arm/robot
	robotic = 1
/obj/item/organ/external/r_foot/robot
	robotic = 1
/obj/item/organ/external/r_hand/robot
	robotic = 1
/obj/item/organ/external/r_leg/robot
	robotic = 1
/obj/item/organ/external/head/robot
	robotic = 1
/obj/item/organ/external/chest/robot
	robotic = 1

/obj/item/organ/external/head/New(loc, mob/living/carbon/human/H)
	if(istype(H))
		src.icon_state = H.gender == MALE? "head_m" : "head_f"
	..()
	//Add (facial) hair.
	if(H.f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[H.f_style]
		if(facial_hair_style)
			var/icon/facial = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial.Blend(rgb(H.r_facial, H.g_facial, H.b_facial), ICON_ADD)

			overlays.Add(facial) // icon.Blend(facial, ICON_OVERLAY)

	if(H.h_style && !(H.head && (H.head.flags & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair_style = hair_styles_list[H.h_style]
		if(hair_style)
			var/icon/hair = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				hair.Blend(rgb(H.r_hair, H.g_hair, H.b_hair), ICON_ADD)

			overlays.Add(hair) //icon.Blend(hair, ICON_OVERLAY)

	name = "[H.real_name]'s head"
	H.regenerate_icons()

/obj/item/organ/external/attackby(obj/item/weapon/W as obj, mob/user as mob)
	switch(op_stage)
		if(0)
			if(istype(W,/obj/item/weapon/scalpel))
				user.visible_message("<span class='danger'><b>[user]</b> cuts [src] open with [W]!")
				op_stage++
				return
		if(1)
			if(istype(W,/obj/item/weapon/retractor))
				user.visible_message("<span class='danger'><b>[user]</b> cracks [src] open like an egg with [W]!")
				op_stage++
				return
		if(2)
			if(istype(W,/obj/item/weapon/hemostat))
				if(contents.len)
					var/obj/item/removing = pick(contents)
					removing.loc = src.loc
					if(istype(removing,/obj/item/organ/internal))
						var/obj/item/organ/internal/removed_organ = removing
						organs_internal -= removed_organ.organ_data
					user.visible_message("<span class='danger'><b>[user]</b> extracts [removing] from [src] with [W]!")
				else
					user.visible_message("<span class='danger'><b>[user]</b> fishes around fruitlessly in [src] with [W].")
				return
	..()