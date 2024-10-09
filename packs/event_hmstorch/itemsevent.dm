///THE PATHS ARE UNFINISHED!!!! THE ICON PATHS ARE SET TO PLACEHOLDER DMIS! I'VE COPIED ALL ITEM STATS FROM THE SOLGOV-SUIT.DMI


/obj/item/clothing/suit/storage/hmstorch
	abstract_type = /obj/item/clothing/suit/storage/hmstorch
	name = "master solar central empire suit with pockets"
	icon = 'itemevent.dmi'
	item_icons = list(slot_wear_suit_str = 'onmobevent.dmi')
	sprite_sheets = list()
///i hope you aren't bring unathi, joey

/obj/item/clothing/suit/storage/hmstorch/service
	name = "master solar central empire service jacket"
	desc = "YOU SHOULD NOT SEE THIS"
	icon_state = "ecdress_xpl"
	item_state = "ecdress_xpl"
	body_parts_covered = UPPER_TORSO|ARMS
	siemens_coefficient = 0.9
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_INSIGNIA)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)


/obj/item/clothing/suit/storage/hmstorch/service/officer
	name = "royal navy officer's jacket"
	desc = "A brilliant crimson SCE officer's service jacket. The golden trim shines under light."
	icon_state = "royaldress_officer"
	item_state = "royaldress_officer"

/obj/item/clothing/suit/storage/hmstorch/service/enlisted
	name = "royal navy enlisted jacket"
	desc = "A brilliant crimson SCE enlisted service jacket. The silver looks dull if you compare it to an officer's gold."
	icon_state = "royaldress"
	item_state = "royaldress"

/obj/item/clothing/suit/storage/hmstorch/service/ec
	name = "royal navy explorer's jacket"
	desc = "A dark-slate SCE explorer's service jacket, with fuschia accents. Controversial in circles of high-fashion since introduction in 2295, the bold piping represents the resilence and loyalty of all explorers. Or so you are told."
	icon_state = "royaldress_ec"
	item_state = "royaldress_ec"


//THIS SUCKS I KNOW I'M OUT OF TIME TO MAKE A COPY WE CAN CLEAN IT UP AFTER THE EVENT THANKS RYAN LOVE YOU
/obj/item/clothing/shoes/hmstorch
	abstract_type = /obj/item/clothing/shoes/hmstorch
	name = "master solar empire shoes"
	desc = "YOU SHOULD NOT SEE THIS"
	icon = 'packs/factions/iccgn/clothing.dmi'
	item_icons = list(
		slot_shoes_str = 'packs/factions/iccgn/clothing.dmi'
	)
	sprite_sheets = list()


/obj/item/clothing/shoes/hmstorch/service
	name = "riding boots"
	desc = "Tall synthleather riding boots. Enlistedmen scoff at them, but one quickly realizes their importance riding a horse."
	icon_state = "boots_service"
	item_state_slots = list(
		slot_l_hand_str = "boots_service_held_l",
		slot_r_hand_str = "boots_service_held_r",
		slot_shoes_str = "boots_service_worn"
	)

/obj/item/clothing/head/hmstorch/formal
	name = "royal navy service cap"
	desc = "A crisp, white SCE service cover. Wear it with pride, and away from rain; water spots it."
	icon_state = "officercap"
