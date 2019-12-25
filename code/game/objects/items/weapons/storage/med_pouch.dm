/*
Single Use Emergency Pouches
 */

/obj/item/weapon/storage/med_pouch
	name = "emergency medical pouch"
	desc = "For use in emergency situations only."
	icon = 'icons/obj/med_pouch.dmi'
	storage_slots = 7
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	icon_state = "pack0"
	opened = FALSE
	open_sound = 'sound/effects/rip1.ogg'
	var/injury_type = "generic"
	var/global/image/cross_overlay

	var/instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Use ointment on any burns if required\n\
	\t7) Contact the medical team with your location.
	8) Stay in place once they respond.\
		"}

/obj/item/weapon/storage/med_pouch/Initialize()
	. = ..()
	name = "emergency [injury_type] pouch"
	make_exact_fit()
	for(var/obj/item/weapon/reagent_containers/pill/P in contents)
		P.color = color
	for(var/obj/item/weapon/reagent_containers/hypospray/autoinjector/A in contents)
		A.band_color = color
		A.update_icon()

/obj/item/weapon/storage/med_pouch/on_update_icon()
	overlays.Cut()
	if(!cross_overlay)
		cross_overlay = image(icon, "cross")
		cross_overlay.appearance_flags = RESET_COLOR
	overlays += cross_overlay
	icon_state = "pack[opened]"

/obj/item/weapon/storage/med_pouch/examine(mob/user)
	. = ..()
	to_chat(user, "<A href='?src=\ref[src];show_info=1'>Please read instructions before use.</A>")

/obj/item/weapon/storage/med_pouch/CanUseTopic()
	return STATUS_INTERACTIVE

/obj/item/weapon/storage/med_pouch/OnTopic(var/user, var/list/href_list)
	if(href_list["show_info"])
		to_chat(user, instructions)
		return TOPIC_HANDLED

/obj/item/weapon/storage/med_pouch/attack_self(mob/user)
	open(user)

/obj/item/weapon/storage/med_pouch/open(mob/user)
	if(!opened)
		user.visible_message("<span class='notice'>\The [user] tears open [src], breaking the vacuum seal!</span>", "<span class='notice'>You tear open [src], breaking the vacuum seal!</span>")
	. = ..()

/obj/item/weapon/storage/med_pouch/trauma
	name = "trauma pouch"
	injury_type = "trauma"
	color = COLOR_RED

	startswith = list(
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/inaprovaline,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/paracetamol,
	/obj/item/stack/medical/bruise_pack = 2,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Contact the medical team with your location.
	7) Stay in place once they respond.\
		"}

/obj/item/weapon/storage/med_pouch/burn
	name = "burn pouch"
	injury_type = "burn"
	color = COLOR_SEDONA

	startswith = list(
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol,
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/paracetamol,
	/obj/item/stack/medical/ointment = 2,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply the emergency deletrathol autoinjector to the injured party.\n\
	\t4) Apply all remaining autoinjectors to the injured party.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Use ointment on any burns if required\n\
	\t7) Contact the medical team with your location.
	8) Stay in place once they respond.\
		"}

/obj/item/weapon/storage/med_pouch/oxyloss
	name = "low oxygen pouch"
	injury_type = "low oxygen"
	color = COLOR_BLUE

	startswith = list(
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin,
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/inaprovaline,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/dexalin,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.\n\
	\t6) Find a source of oxygen if possible.\n\
	\t7) Update the medical team with your new location.\n\
	8) Stay in place once they respond.\
		"}

/obj/item/weapon/storage/med_pouch/toxin
	name = "toxin pouch"
	injury_type = "toxin"
	color = COLOR_GREEN

	startswith = list(
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/dylovene,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	6) Stay in place once they respond.\
		"}

/obj/item/weapon/storage/med_pouch/radiation
	name = "radiation pouch"
	injury_type = "radiation"
	color = COLOR_AMBER

	startswith = list(
	/obj/item/weapon/reagent_containers/hypospray/autoinjector/antirad,
	/obj/item/weapon/reagent_containers/pill/pouch_pill/dylovene,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	6) Stay in place once they respond.\
		"}

/obj/item/weapon/reagent_containers/pill/pouch_pill
	name = "emergency pill"
	desc = "An emergency pill from an emergency medical pouch"
	icon_state = "pill2"
	var/datum/reagent/chem_type
	var/chem_amount = 15

/obj/item/weapon/reagent_containers/pill/pouch_pill/inaprovaline
	chem_type = /datum/reagent/inaprovaline

/obj/item/weapon/reagent_containers/pill/pouch_pill/dylovene
	chem_type = /datum/reagent/dylovene

/obj/item/weapon/reagent_containers/pill/pouch_pill/dexalin
	chem_type = /datum/reagent/dexalin

/obj/item/weapon/reagent_containers/pill/pouch_pill/paracetamol
	chem_type = /datum/reagent/paracetamol

/obj/item/weapon/reagent_containers/pill/pouch_pill/New()
	..()
	reagents.add_reagent(chem_type, chem_amount)
	name = "emergency [reagents.get_master_reagent_name()] pill ([reagents.total_volume]u)"
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto
	name = "emergency autoinjector"
	desc = "An emergency autoinjector from an emergency medical pouch"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline
	name = "emergency inaprovaline autoinjector"
	starts_with = list(/datum/reagent/inaprovaline = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol
	name = "emergency deletrathol autoinjector"
	starts_with = list(/datum/reagent/deletrathol = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene
	name = "emergency dylovene autoinjector"
	starts_with = list(/datum/reagent/dylovene = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin
	name = "emergency dexalin autoinjector"
	starts_with = list(/datum/reagent/dexalin = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline
	name = "emergency adrenaline autoinjector"
	amount_per_transfer_from_this = 8
	starts_with = list(/datum/reagent/adrenaline = 8)
