/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Reinforced headgear. Protects the head from impacts."
	icon_state = "helmet"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 50, laser = 50,energy = 25, bomb = 30, bio = 0, rad = 0)
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/head/helmet/solgov
	name = "\improper Sol Central Government helmet"
	desc = "A helmet painted in Peacekeeper blue. Stands out like a sore thumb."
	icon_state = "helmet_sol"

/obj/item/clothing/head/helmet/solgov/command
	name = "command helmet"
	desc = "A helmet with 'SOL CENTRAL GOVERNMENT' printed on the back in gold lettering."
	icon_state = "helmet_command"

/obj/item/clothing/head/helmet/solgov/security
	name = "security helmet"
	desc = "A helmet with 'MASTER AT ARMS' printed on the back in silver lettering."
	icon_state = "helmet_security"

/obj/item/clothing/head/helmet/nt
	name = "\improper corporate security helmet"
	desc = "A helmet with 'CORPORATE SECURITY' printed on the back in red lettering."
	icon_state = "helmet_nt"

/obj/item/clothing/head/helmet/pcrc
	name = "\improper PCRC helmet"
	desc = "A helmet with 'PRIVATE SECURITY' printed on the back in cyan lettering."
	icon_state = "helmet_pcrc"

/obj/item/clothing/head/helmet/nt/guard
	name = "\improper NanoTrasen helmet"
	desc = "A helmet painted in NanoTrasen colors. Probably belongs to corporate security."
	icon_state = "helmet_ntguard"

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "A tan helmet made from advanced ceramic. Comfortable and robust."
	icon_state = "helmet_tac"
	armor = list(melee = 50, bullet = 60, laser = 60, energy = 45, bomb = 30, bio = 0, rad = 0)
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/merc
	name = "combat helmet"
	desc = "A heavily reinforced helmet painted with red markings. Feels like it could take a lot of punishment."
	icon_state = "helmet_merc"
	armor = list(melee = 70, bullet = 70, laser = 70, energy = 35, bomb = 30, bio = 0, rad = 0)
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "helmet_riot"
	body_parts_covered = HEAD|FACE|EYES //face shield
	armor = list(melee = 82, bullet = 15, laser = 5, energy = 5, bomb = 5, bio = 2, rad = 0)
	siemens_coefficient = 0.7
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/helmet/riot/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]_up"
		to_chat(user, "You raise the visor on the [src].")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on the [src].")
	update_clothing_icon()

/obj/item/clothing/head/helmet/ablative
	name = "ablative helmet"
	desc = "A helmet made from advanced materials which protects against concentrated energy weapons."
	icon_state = "helmet_reflect"
	armor = list(melee = 15, bullet = 5, laser = 82, energy = 50, bomb = 5, bio = 2, rad = 0)
	siemens_coefficient = 0

/obj/item/clothing/head/helmet/ballistic
	name = "ballistic helmet"
	desc = "A helmet with reinforced plating to protect against ballistic projectiles."
	icon_state = "helmet_bulletproof"
	armor = list(melee = 5, bullet = 82, laser = 15, energy = 5, bomb = 30, bio = 2, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon_state = "helmet_merc"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	siemens_coefficient = 1

/*
/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "An armored helmet capable of being fitted with a multitude of attachments."
	icon_state = "swathelm"
	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/helmet.dmi',
		"Unathi" = 'icons/mob/species/unathi/helmet.dmi'
		)

	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7
*/

/obj/item/clothing/head/helmet/augment
	name = "Augment Array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon_state = "v62"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|EYES|BLOCKHEADHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

//Non-hardsuit ERT helmets.
//Commander
/obj/item/clothing/head/helmet/ert
	name = "asset protection command helmet"
	desc = "An in-atmosphere helmet worn by many corporate and private asset protection forces. Has blue highlights."
	icon_state = "erthelmet_cmd"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-helm-green",
		slot_r_hand_str = "syndicate-helm-green",
		)
	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)

//Security
/obj/item/clothing/head/helmet/ert/security
	name = "asset protection security helmet"
	desc = "An in-atmosphere helmet worn by many corporate and private asset protection forces. Has red highlights."
	icon_state = "erthelmet_sec"

//Engineer
/obj/item/clothing/head/helmet/ert/engineer
	name = "asset protection engineering helmet"
	desc = "An in-atmosphere helmet worn by many corporate and private asset protection forces. Has orange highlights."
	icon_state = "erthelmet_eng"

//Medical
/obj/item/clothing/head/helmet/ert/medical
	name = "asset protection medical helmet"
	desc = "An in-atmosphere helmet worn by many corporate and private asset protection forces. Has red and white highlights."
	icon_state = "erthelmet_med"
