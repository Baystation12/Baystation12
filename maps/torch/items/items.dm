/*******************
Random item spawning
*******************/

/obj/random/solgov
	name = "random solgov equipment"
	desc = "This is a random piece of solgov equipment or clothing."
	icon = 'maps/torch/icons/obj/obj_head_solgov.dmi'
	icon_state = "solsoft"

/obj/random/solgov/spawn_choices()
	return list(/obj/item/clothing/head/solgov/utility/fleet = 4,
				/obj/item/clothing/head/soft/solgov/expedition = 2,
				/obj/item/clothing/head/soft/solgov/fleet = 4,
				/obj/item/clothing/head/helmet/solgov = 1,
				/obj/item/clothing/suit/storage/vest/solgov = 2,
				/obj/item/clothing/under/solgov/utility = 5,
				/obj/item/clothing/under/solgov/utility/fleet = 3,
				/obj/item/clothing/under/solgov/pt/expeditionary = 4,
				/obj/item/clothing/under/solgov/pt/fleet = 4
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

/obj/item/modular_computer/pda/explorer
	icon_state = "pda-exp"
	icon_state_unpowered = "pda-exp"

/obj/item/modular_computer/pda/heads/hop
	stored_pen = /obj/item/weapon/pen/multi/cmd/xo

/obj/item/modular_computer/pda/captain
	stored_pen = /obj/item/weapon/pen/multi/cmd/co

/obj/item/weapon/storage/backpack/explorer
	name = "explorer backpack"
	desc = "A rugged backpack."
	icon_state = "exppack"

/obj/item/weapon/storage/backpack/satchel/explorer
	name = "explorer satchel"
	desc = "A rugged satchel for field work."
	icon_state = "satchel-exp"

/obj/item/weapon/storage/backpack/messenger/explorer
	name = "explorer messenger bag"
	desc = "A rugged backpack worn over one shoulder."
	icon_state = "courierbagexp"

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

/obj/item/weapon/storage/fakebook
	name = "Workplace Crisis Management"
	desc = "Also known as 'I fucked up, what do?'. A very popular book amongst corporate management."
	icon = 'icons/obj/library.dmi'
	icon_state = "booknanoregs"
	attack_verb = list("bashed", "whacked", "educated")
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 4
	startswith = list(
			/obj/item/weapon/reagent_containers/pill/tox,
			/obj/item/weapon/paper/liason_note
	)

/obj/item/clothing/accessory/watch/fancy/co
	name = "captain's watch"
	desc = "A heavy, gold, Falco-branded Mahimaku Spacemaster, one of only a few dozen that Falco \
		commissioned and gifted to the Corps at its 24th Century expo."
	color = ACCESSORY_COLOR_GOLD
	face_color = ACCESSORY_COLOR_LIGHTYELLOW

/obj/item/clothing/accessory/watch/fancy/officer
	name = "officer's watch"
	desc = "A white gold Montreux Voidfarer, given to some senior officers for their years of \
		service."
	color = ACCESSORY_COLOR_IVORY
	face_color = ACCESSORY_COLOR_MIDNIGHTBLUE
	hour24 = TRUE

/obj/item/clothing/accessory/watch/fancy/cpo
	name = "chief's watch"
	desc = "A Montreux Voidfarer wristwatch, gifted by the MCPOF to those that attended the 2306 \
		CPO board and sent to a few other senior NCOs."
	color = ACCESSORY_COLOR_LIGHTSTEELBLUE
	hour24 = TRUE

/obj/item/clothing/accessory/watch/digital/xpl
	name = "explorer's watch"
	desc = "An unbranded edition of the Eclipse Chronos issued to many in Field Ops. Its ability \
		to survive even the harshest of conditions is well-known among the exploration team."
	color = ACCESSORY_COLOR_SLATEGRAY_25
	inaccuracy = 2 MINUTES

/******
Weapons
******/

/obj/item/weapon/gun/energy/gun/secure/corporate
	desc = "An access-locked EXO-branded LAEP90-S. It's designed to please paranoid corporate liaisons. Body cam not included."
	req_access = list(access_liaison)

/obj/item/weapon/gun/projectile/revolver/medium/captain
	name = "\improper Final Argument"
	icon = 'maps/torch/icons/obj/uniques.dmi'
	icon_state = "mosley"
	desc = "A shiny al-Maliki & Mosley Autococker automatic revolver, with black accents. Marketed as the 'Revolver for the Modern Era'. This one has 'To the Captain of SEV Torch' engraved."
	fire_delay = 5.7 //Autorevolver. Also synced with the animation
	fire_anim = "mosley_fire"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	starts_loaded = 0 //Nobody keeps ballistic weapons loaded

/obj/item/weapon/gun/energy/stunrevolver/secure/nanotrasen
	name = "corporate stun revolver"
	desc = "This A&M X6 is fitted with an NT1019 chip which allows remote authorization of weapon functionality. It has a NanoTrasen logo on the grip."
	req_access = list(list(access_brig, access_heads, access_rd, access_sec_guard))

/obj/item/weapon/gun/projectile/pistol/holdout/liaison
	magazine_type = /obj/item/ammo_magazine/pistol/small/oneway

/obj/item/ammo_magazine/pistol/small/oneway
	initial_ammo = 1

/obj/effect/paint/hull
	color = COLOR_HULL

/obj/effect/paint/expeditionary
	color = "#68099e"