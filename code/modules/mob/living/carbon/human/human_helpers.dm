#define add_clothing_protection(A)	\
	var/obj/item/clothing/C = A; \
	flash_protection += C.flash_protection; \
	equipment_tint_total += C.tint;

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
		add_clothing_protection(head)
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
