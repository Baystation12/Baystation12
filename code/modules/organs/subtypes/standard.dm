/****************************************************
			   ORGAN DEFINES
****************************************************/

//Make sure that w_class is set as if the parent mob was medium sized! This is because w_class is adjusted automatically for mob_size in New()

/obj/item/organ/external/chest
	name = "upper body"
	organ_tag = BP_CHEST
	icon_name = "torso"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEM_SIZE_HUGE //Used for dismembering thresholds, in addition to storage. Humans are w_class 6, so it makes sense that chest is w_class 5.
	body_part = UPPER_TORSO
	vital = 1
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	gendered_icon = 1
	cannot_amputate = 1
	parent_organ = null
	encased = "ribcage"
	artery_name = "aorta"

/obj/item/organ/external/groin
	name = "lower body"
	organ_tag = BP_GROIN
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEM_SIZE_LARGE
	body_part = LOWER_TORSO
	vital = 1
	parent_organ = BP_CHEST
	amputation_point = "lumbar"
	joint = "hip"
	dislocated = -1
	gendered_icon = 1
	artery_name = "iliac artery"

/obj/item/organ/external/arm
	organ_tag = BP_L_ARM
	name = "left arm"
	icon_name = "l_arm"
	max_damage = 50
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL
	body_part = ARM_LEFT
	parent_organ = BP_CHEST
	joint = "left elbow"
	amputation_point = "left shoulder"
	can_grasp = 1
	has_tendon = TRUE
	tendon_name = "palmaris longus tendon"
	artery_name = "basilic vein"
	arterial_bleed_severity = 0.75

/obj/item/organ/external/arm/stun_act(var/stun_amount, var/agony_amount)
	if(!owner || (agony_amount < 5))
		return
	if(prob(25))
		owner.grasp_damage_disarm(src)

/obj/item/organ/external/arm/right
	organ_tag = BP_R_ARM
	name = "right arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"

/obj/item/organ/external/leg
	organ_tag = BP_L_LEG
	name = "left leg"
	icon_name = "l_leg"
	max_damage = 50
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	joint = "left knee"
	amputation_point = "left hip"
	can_stand = 1
	has_tendon = TRUE
	tendon_name = "cruciate ligament"
	artery_name = "femoral artery"
	arterial_bleed_severity = 0.75

/obj/item/organ/external/leg/stun_act(var/stun_amount, var/agony_amount)
	if(!owner || agony_amount < 5)
		return
	if(prob(agony_amount*2))
		to_chat(owner, "<span class='warning'>Your [src] buckles from the shock!</span>")
		owner.Weaken(5)

/obj/item/organ/external/leg/right
	organ_tag = BP_R_LEG
	name = "right leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"

/obj/item/organ/external/foot
	organ_tag = BP_L_FOOT
	name = "left foot"
	icon_name = "l_foot"
	max_damage = 30
	min_broken_damage = 15
	w_class = ITEM_SIZE_SMALL
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = BP_L_LEG
	joint = "left ankle"
	amputation_point = "left ankle"
	can_stand = 1
	has_tendon = TRUE
	tendon_name = "Achilles tendon"
	arterial_bleed_severity = 0.5

/obj/item/organ/external/foot/stun_act(var/stun_amount, var/agony_amount)
	if(!owner || agony_amount < 5)
		return
	if(prob(agony_amount*4))
		to_chat(owner, "<span class='warning'>You lose your footing as your [src] spasms!</span>")
		owner.Weaken(5)

/obj/item/organ/external/foot/removed()
	if(owner) owner.drop_from_inventory(owner.shoes)
	..()

/obj/item/organ/external/foot/right
	organ_tag = BP_R_FOOT
	name = "right foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = BP_R_LEG
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/hand
	organ_tag = BP_L_HAND
	name = "left hand"
	icon_name = "l_hand"
	max_damage = 30
	min_broken_damage = 15
	w_class = ITEM_SIZE_SMALL
	body_part = HAND_LEFT
	parent_organ = BP_L_ARM
	joint = "left wrist"
	amputation_point = "left wrist"
	can_grasp = 1
	has_tendon = TRUE
	tendon_name = "carpal ligament"
	arterial_bleed_severity = 0.5

/obj/item/organ/external/hand/stun_act(var/stun_amount, var/agony_amount)
	if(!owner || (agony_amount < 5))
		return
	owner.grasp_damage_disarm(src)

/obj/item/organ/external/hand/removed()
	owner.drop_from_inventory(owner.gloves)
	..()

/obj/item/organ/external/hand/right
	organ_tag = BP_R_HAND
	name = "right hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = BP_R_ARM
	joint = "right wrist"
	amputation_point = "right wrist"

/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	slot_flags = SLOT_BELT
	max_damage = 75
	min_broken_damage = 35
	w_class = ITEM_SIZE_NORMAL
	body_part = HEAD
	vital = 1
	parent_organ = BP_CHEST
	joint = "jaw"
	amputation_point = "neck"
	gendered_icon = 1
	encased = "skull"
	artery_name = "cartoid artery"

	var/can_intake_reagents = 1
	var/eye_icon = "eyes_s"
	var/has_lips

/obj/item/organ/external/head/get_agony_multiplier()
	return (owner && owner.headcheck(organ_tag)) ? 1.50 : 1

/obj/item/organ/external/head/robotize(var/company, var/skip_prosthetics, var/keep_organs)
	if(company)
		var/datum/robolimb/R = all_robolimbs[company]
		if(R)
			can_intake_reagents = R.can_eat
			eye_icon = R.use_eye_icon
	. = ..(company, skip_prosthetics, 1)
	has_lips = null

/obj/item/organ/external/head/removed()
	if(owner)
		name = "[owner.real_name]'s head"
		owner.drop_from_inventory(owner.glasses)
		owner.drop_from_inventory(owner.head)
		owner.drop_from_inventory(owner.l_ear)
		owner.drop_from_inventory(owner.r_ear)
		owner.drop_from_inventory(owner.wear_mask)
		spawn(1)
			owner.update_hair()
	..()

/obj/item/organ/external/head/take_damage(brute, burn, damage_flags, used_weapon = null)
	. = ..()
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/item/organ/external/head/no_eyes
	eye_icon = "blank_eyes"