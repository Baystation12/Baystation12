/*******************
Random item spawning
*******************/

/obj/random/solgov
	name = "random solgov equipment"
	desc = "This is a random piece of solgov equipment or clothing."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "helmet_sol"

/obj/random/solgov/spawn_choices()
	return list(/obj/item/clothing/head/solgov/utility/fleet = 4,
				/obj/item/clothing/head/solgov/utility/marine = 4,
				/obj/item/clothing/head/solgov/utility/marine/tan = 3,
				/obj/item/clothing/head/solgov/utility/marine/urban = 3,
				/obj/item/clothing/head/soft/solgov/expedition = 2,
				/obj/item/clothing/head/soft/solgov/fleet = 4,
				/obj/item/clothing/head/helmet/solgov = 1,
				/obj/item/clothing/suit/storage/vest/solgov = 2,
				/obj/item/clothing/under/solgov/utility/marine/tan = 2,
				/obj/item/clothing/under/solgov/utility/marine/urban = 2,
				/obj/item/clothing/under/solgov/utility/marine = 3,
				/obj/item/clothing/under/solgov/utility = 5,
				/obj/item/clothing/under/solgov/utility/fleet = 3,
				/obj/item/clothing/under/solgov/pt/expeditionary = 4,
				/obj/item/clothing/under/solgov/pt/marine = 2,
				/obj/item/clothing/under/solgov/pt/fleet = 4,
				)

/obj/random/maintenance/solgov
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"

/obj/random/maintenance/solgov/spawn_choices()
	return list(/obj/random/junk = 4,
				/obj/random/trash = 4,
				/obj/random/maintenance/solgov/clean = 5)

/obj/random/maintenance/solgov/clean
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift2"

/obj/random/maintenance/solgov/clean/spawn_choices()
	return list(/obj/random/solgov = 3,
				/obj/random/maintenance/clean = 800)

/*******************
Torch specific items
*******************/

/obj/item/device/pda/explorer
	icon_state = "pda-explorer"

/obj/item/device/pda/pathfinder
	icon_state = "pda-pathfinder"

/***********
Unique items
***********/

/obj/item/weapon/pen/multi/cmd/xo
	name = "executive officer's pen"
	icon = 'maps/torch/icons/obj/uniques.dmi'
	icon_state = "pen_xo"
	desc = "A slightly bulky pen with a silvery case. Twisting the top allows you to switch the nib for different colors."

/obj/item/weapon/pen/multi/cmd/co
	name = "commanding officer's pen"
	icon = 'maps/torch/icons/obj/uniques.dmi'
	icon_state = "pen_co"
	desc = "A slightly bulky pen with a golden case. Twisting the top allows you to switch the nib for different colors."

/obj/item/weapon/pen/multi/cmd/attack_self(mob/user)
	if(++selectedColor > 3)
		selectedColor = 1
	colour = colors[selectedColor]
	to_chat(user, "<span class='notice'>Changed color to '[colour].'</span>")

/******
Weapons
******/

/obj/item/weapon/gun/projectile/revolver/webley/captain
	name = "captain's revolver"
	icon = 'maps/torch/icons/obj/uniques.dmi'
	icon_state = "webley2"
	desc = "A shiny Webley style top-break revolver with black accents and a captain's rank pin set into the grip.  Uses .44 magnum rounds."

/obj/item/weapon/gun/energy/secure/stunrevolver
	name = "stun revolver"
	desc = "This LAEP20 is fitted with an NT1019 chip, a component that allows remote authorization of weapon functionality, created by NanoTrasen following the Baetiff Incident."
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	projectile_type = /obj/item/projectile/energy/electrode
	max_shots = 8
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/energy/electrode, modifystate="stunrevolver"),
		list(mode_name="shock", projectile_type=/obj/item/projectile/energy/electrode/stunshot, modifystate="stunrevolver")
		)
	req_access = list(access_sec_guard)