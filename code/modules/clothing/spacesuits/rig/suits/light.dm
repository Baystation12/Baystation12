// Light rigs are not space-capable, but don't suffer excessive slowdown or sight issues when depowered.
/obj/item/weapon/rig/light
	name = "light suit control module"
	desc = "A lighter, less armoured rig suit."
	icon_state = "ninja_rig"
	suit_type = "light suit"
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/cell)
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.4
	emp_protection = 10
	online_slowdown = 0
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL
	offline_slowdown = TINT_NONE
	offline_vision_restriction = TINT_NONE

	chest_type = /obj/item/clothing/suit/space/rig/light
	helm_type =  /obj/item/clothing/head/helmet/space/rig/light
	boot_type =  /obj/item/clothing/shoes/magboots/rig/light
	glove_type = /obj/item/clothing/gloves/rig/light

/obj/item/clothing/suit/space/rig/light
	name = "suit"
	breach_threshold = 18 //comparable to voidsuits

/obj/item/clothing/gloves/rig/light
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/light
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/light
	name = "hood"

/obj/item/weapon/rig/light/hacker
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon_state = "hacker_rig"

	req_access = list(access_syndicate)

	airtight = 0
	seal_delay = 5 //not being vaccum-proof has an upside I guess

	helm_type = /obj/item/clothing/head/lightrig/hacker
	chest_type = /obj/item/clothing/suit/lightrig/hacker
	glove_type = /obj/item/clothing/gloves/lightrig/hacker
	boot_type = /obj/item/clothing/shoes/lightrig/hacker

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/vision,
		)

//The cybersuit is not space-proof. It does however, have good siemens_coefficient values
/obj/item/clothing/head/lightrig/hacker
	name = "HUD"
	flags = 0

/obj/item/clothing/suit/lightrig/hacker
	siemens_coefficient = 0.2

/obj/item/clothing/shoes/lightrig/hacker
	siemens_coefficient = 0.2
	flags = NOSLIP //All the other rigs have magboots anyways, hopefully gives the hacker suit something more going for it.

/obj/item/clothing/gloves/lightrig/hacker
	siemens_coefficient = 0

/obj/item/weapon/rig/light/ninja
	name = "ominous suit control module"
	desc = "A unique, vaccum-proof suit of nano-enhanced armor designed specifically for assassins."
	suit_type = "ominous"
	icon_state = "ninja_rig"
	armor = list(melee = 50, bullet = 15, laser = 30, energy = 10, bomb = 25, bio = 100, rad = 30)
	siemens_coefficient = 0.2 //heavy hardsuit level shock protection
	emp_protection = 40 //change this to 30 if too high.
	online_slowdown = 0
	aimove_power_usage = 50
	chest_type = /obj/item/clothing/suit/space/rig/light/ninja
	glove_type = /obj/item/clothing/gloves/rig/light/ninja
	cell_type =  /obj/item/weapon/cell/hyper

	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/chem_dispenser,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/self_destruct
		)

	..()

/obj/item/weapon/rig/light/ninja/verb/rename_suit()
	set name = "Name Ninja Suit"
	set desc = "Rename your black voidsuit."
	set category = "Object"
	var/mob/M = usr
	if(!M.mind) return 0
	if(M.incapacitated()) return 0
	var/input = sanitizeSafe(input("What do you want to name your suit?", "Rename suit"), MAX_NAME_LEN)
	if(src && input && !M.incapacitated() && in_range(M,src))
		if(!findtext(input, "the", 1, 4))
			input = "\improper [input]"
		name = input
		to_chat(M, "Suit naming succesful!")
		verbs -= /obj/item/weapon/rig/light/ninja/verb/rename_suit
		return 1


/obj/item/weapon/rig/light/ninja/verb/rewrite_suit_desc()
	set name = "Describe Ninja suit"
	set desc = "Give your voidsuit a custom description."
	set category = "Object"
	var/mob/M = usr
	if(!M.mind) return 0
	if(M.incapacitated()) return 0
	var/input = sanitizeSafe(input("Please describe your voidsuit in 128 letters or less.", "write description"), MAX_DESC_LEN)
	if(src && input && !M.incapacitated() && in_range(M,src))
		desc = input
		to_chat(M, "Suit description succesful!")
		verbs -= /obj/item/weapon/rig/light/ninja/verb/rename_suit
		return 1

/obj/item/clothing/gloves/rig/light/ninja
	name = "insulated gloves"
	siemens_coefficient = 0

/obj/item/clothing/suit/space/rig/light/ninja
	breach_threshold = 38 //comparable to regular hardsuits

/obj/item/weapon/rig/light/stealth
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	icon_state = "stealth_rig"

	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/vision
		)
