//Terrans

/obj/item/clothing/under/terran
	name = "master terran uniform"
	desc = "You shouldn't be seeing this."
	icon = 'maps/torch/icons/obj/obj_under_terran.dmi'
	item_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_under_terran.dmi')
	armor = list(melee = 5, bullet = 0, laser = 5, energy = 5, bomb = 0, bio = 5, rad = 5)
	siemens_coefficient = 0.8

/obj/item/clothing/under/terran/navy/utility
	name = "terran utility uniform"
	desc = "A comfortable black utility jumpsuit. Worn by the Terran Navy."
	icon_state = "terranutility"
	item_state = "bl_suit"
	worn_state = "terranutility"

/obj/item/clothing/under/terran/navy/service
	name = "terran service uniform"
	desc = "The service uniform of the TCC Navy, for low-ranking crew."
	icon_state = "terranservice"
	worn_state = "terranservice"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 5, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/terran/navy/service/command
	name = "terran command service uniform"
	desc = "The service uniform of the TCC Navy, for high-ranking crew."
	icon_state = "terranservice_comm"
	worn_state = "terranservice_comm"