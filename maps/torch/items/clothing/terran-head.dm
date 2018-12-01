/obj/item/clothing/head/terran
	name = "master terran hat"
	icon = 'maps/torch/icons/obj/obj_head_terran.dmi'
	item_icons = list(slot_head_str = 'maps/torch/icons/mob/onmob_head_terran.dmi')
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/head/terran/navy/service
	name = "terran service cover"
	desc = "A service uniform cover, worn by low-ranking crew within the Terran Navy."
	icon_state = "terranservice"
	item_state = "terranservice"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet")
	body_parts_covered = 0

/obj/item/clothing/head/terran/navy/service/command
	name = "terran command service cover"
	desc = "A service uniform cover, worn by high-ranking crew within the Terran Navy."
	icon_state = "terranservice_comm"
	item_state = "terranservice_comm"