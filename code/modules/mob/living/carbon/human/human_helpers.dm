#define HUMAN_EATING_NO_ISSUE		0
#define HUMAN_EATING_NO_MOUTH		1
#define HUMAN_EATING_BLOCKED_MOUTH	2

#define add_clothing_protection(A)	\
	var/obj/item/clothing/C = A; \
	flash_protection += C.flash_protection; \
	equipment_tint_total += C.tint;

/mob/living/carbon/human/can_eat(var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NO_MOUTH)
			src << "Where do you intend to put \the [food]? You don't have a mouth!"
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			src << "<span class='warning'>\The [status[2]] is in the way!</span>"
	return 0

/mob/living/carbon/human/can_force_feed(var/feeder, var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NO_MOUTH)
			feeder << "Where do you intend to put \the [food]? \The [src] doesn't have a mouth!"
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			feeder << "<span class='warning'>\The [status[2]] is in the way!</span>"
	return 0

/mob/living/carbon/human/proc/can_eat_status()
	if(!check_has_mouth())
		return list(HUMAN_EATING_NO_MOUTH)
	var/obj/item/blocked = check_mouth_coverage()
	if(blocked)
		return list(HUMAN_EATING_BLOCKED_MOUTH, blocked)
	return list(HUMAN_EATING_NO_ISSUE)

//This is called when we want different types of 'cloaks' to stop working, e.g. when attacking.
/mob/living/carbon/human/break_cloak()
	if(mind && mind.changeling) //Changeling visible camo
		mind.changeling.cloaked = 0
	if(istype(back, /obj/item/weapon/rig)) //Ninja cloak
		var/obj/item/weapon/rig/suit = back
		for(var/obj/item/rig_module/stealth_field/cloaker in suit.installed_modules)
			if(cloaker.active)
				cloaker.deactivate()

/mob/living/carbon/human/get_ear_protection()
	var/sum = 0
	if(istype(l_ear, /obj/item/clothing/ears))
		var/obj/item/clothing/ears/L = l_ear
		sum += L.ear_protection
	if(istype(r_ear, /obj/item/clothing/ears))
		var/obj/item/clothing/ears/R = r_ear
		sum += R.ear_protection
	if(istype(head, /obj/item/clothing/head))
		var/obj/item/clothing/head/H = head
		sum += H.ear_protection
	return sum


#undef HUMAN_EATING_NO_ISSUE
#undef HUMAN_EATING_NO_MOUTH
#undef HUMAN_EATING_BLOCKED_MOUTH

/mob/living/carbon/human/proc/update_equipment_vision()
	flash_protection = 0
	equipment_tint_total = 0
	equipment_see_invis	= 0
	equipment_vision_flags = 0
	equipment_prescription = 0
	equipment_darkness_modifier = 0
	equipment_overlays.Cut()

	if(istype(src.head, /obj/item/clothing/head))
		add_clothing_protection(head)
	if(istype(src.glasses, /obj/item/clothing/glasses))
		process_glasses(glasses)
	if(istype(src.wear_mask, /obj/item/clothing/mask))
		add_clothing_protection(wear_mask)
	if(istype(back,/obj/item/weapon/rig))
		process_rig(back)

/mob/living/carbon/human/proc/process_glasses(var/obj/item/clothing/glasses/G)
	if(G && G.active)
		equipment_darkness_modifier += G.darkness_view
		equipment_vision_flags |= G.vision_flags
		equipment_prescription = equipment_prescription || G.prescription
		if(G.overlay)
			equipment_overlays |= G.overlay
		if(G.see_invisible >= 0)
			if(equipment_see_invis)
				equipment_see_invis = min(equipment_see_invis, G.see_invisible)
			else
				equipment_see_invis = G.see_invisible

		add_clothing_protection(G)
		G.process_hud(src)

/mob/living/carbon/human/proc/process_rig(var/obj/item/weapon/rig/O)
	if(O.helmet && O.helmet == head && (O.helmet.body_parts_covered & EYES))
		if((O.offline && O.offline_vision_restriction == 2) || (!O.offline && O.vision_restriction == 2))
			equipment_tint_total += TINT_BLIND
	if(O.visor && O.visor.active && O.visor.vision && O.visor.vision.glasses && (!O.helmet || (head && O.helmet == head)))
		process_glasses(O.visor.vision.glasses)
