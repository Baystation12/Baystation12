/obj/item/auto_cpr
	name = "auto-compressor"
	desc = "A device that gives regular compression to the victim's ribcage, used in case of urgent heart issues."
	icon = 'icons/obj/auto_cpr.dmi'
	icon_state = "pumper"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	slot_flags = SLOT_OCLOTHING
	var/last_pump
	var/skilled_setup

/obj/item/auto_cpr/mob_can_equip(mob/living/carbon/human/H, slot, disable_warning = 0, force = 0)
	. = ..()
	if(force || !istype(H) || slot != slot_wear_suit)
		return
	if(H.species.get_bodytype() in list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_ALIEN)) //non-humanoids btfo
		return
	else
		return FALSE

/obj/item/auto_cpr/attack(mob/living/carbon/human/M, mob/living/user, var/target_zone)
	if(istype(M) && user.a_intent == I_HELP)
		if(M.wear_suit)
			to_chat(user, SPAN_WARNING("Their [M.wear_suit] is in the way, remove it first!"))
			return 1
		user.visible_message(SPAN_NOTICE("[user] starts fitting [src] onto the [M]'s chest."))

		if(!do_after(user, 2 SECONDS, M, DO_EQUIP))
			return

		if(user.unEquip(src))
			if(!M.equip_to_slot_if_possible(src, slot_wear_suit, TRYEQUIP_REDRAW | TRYEQUIP_SILENT))
				user.put_in_active_hand(src)
			return 1
	else
		return ..()

/obj/item/auto_cpr/equipped(mob/user, slot)
	..()
	START_PROCESSING(SSobj,src)

/obj/item/auto_cpr/attack_hand(mob/user)
	skilled_setup = user.skill_check(SKILL_ANATOMY, SKILL_BASIC) && user.skill_check(SKILL_MEDICAL, SKILL_BASIC)
	..()

/obj/item/auto_cpr/dropped(mob/user)
	STOP_PROCESSING(SSobj,src)
	..()

/obj/item/auto_cpr/Process()
	if(!ishuman(loc))
		return PROCESS_KILL

	var/mob/living/carbon/human/H = loc
	if(H.get_inventory_slot(src) != slot_wear_suit)
		return PROCESS_KILL

	if(world.time > last_pump + 15 SECONDS)
		last_pump = world.time
		playsound(src, 'sound/machines/pump.ogg', 25)
		if(!skilled_setup && prob(20))
			var/obj/item/organ/external/E = H.get_organ(BP_CHEST)
			E.add_pain(15)
			to_chat(H, "<span class='danger'>Your [E] is compressed painfully!</span>")
			if(prob(5))
				E.fracture()
		else
			var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
			if(heart)
				heart.external_pump = list(world.time, 0.6)
