/decl/appearance_handler/cardborg
	var/static/list/appearances

/decl/appearance_handler/cardborg/proc/item_equipped(var/obj/item/item, var/mob/user, var/slot)
	if(!(slot == slot_head || slot == slot_wear_suit|| slot == slot_back))
		return
	if(!ishuman(user))
		return
	if(!(istype(item, /obj/item/clothing/suit/cardborg) || istype(item, /obj/item/clothing/head/cardborg) || istype(item, /obj/item/weapon/storage/backpack)))
		return
	if(user in appearance_sources)
		return

	var/mob/living/carbon/human/H = user
	if(!(istype(H.wear_suit, /obj/item/clothing/suit/cardborg) && istype(H.head, /obj/item/clothing/head/cardborg) && istype(H.back, /obj/item/weapon/storage/backpack)))
		return

	var/image/I = get_image_from_backpack(H)
	AddAltAppearance(H, I, GLOB.silicon_mob_list+H) //you look like a robot to robots! (including yourself because you're totally a robot)
	GLOB.logged_in_event.register_global(src, /decl/appearance_handler/cardborg/proc/mob_joined)	// Duplicate registration request are handled for us

/decl/appearance_handler/cardborg/proc/item_removed(var/obj/item/item, var/mob/user)
	if((istype(item, /obj/item/clothing/suit/cardborg) || istype(item, /obj/item/clothing/head/cardborg)) || istype(item, /obj/item/weapon/storage/backpack))
		RemoveAltAppearance(user)
		if(!appearance_sources.len)
			GLOB.logged_in_event.unregister_global(src)	// Only listen to the logged in event for as long as it's relevant

/decl/appearance_handler/cardborg/proc/mob_joined(var/mob/user)
	if(issilicon(user))
		DisplayAllAltAppearancesTo(user)

/decl/appearance_handler/cardborg/proc/get_image_from_backpack(var/mob/living/carbon/human/H)
	init_appearances()
	var/decl/cardborg_appearance/ca = appearances[H.back.type]
	if(!ca) ca = appearances[/obj/item/weapon/storage/backpack]

	var/image/I = image(icon = 'icons/mob/robots.dmi', icon_state = ca.icon_state, loc = H)
	I.override = 1
	I.overlays += image(icon = 'icons/mob/robots.dmi', icon_state = "eyes-[ca.icon_state]") //gotta look realistic
	return I

/decl/appearance_handler/cardborg/proc/init_appearances()
	if(!appearances)
		appearances = list()
		for(var/decl/cardborg_appearance/ca in init_subtypes(/decl/cardborg_appearance))
			appearances[ca.backpack_type] = ca

/decl/cardborg_appearance
	var/backpack_type
	var/icon_state
	backpack_type = /obj/item/weapon/storage/backpack

/decl/cardborg_appearance/standard
	icon_state = "robot"

/decl/cardborg_appearance/standard/satchel1
	backpack_type = /obj/item/weapon/storage/backpack/satchel

/decl/cardborg_appearance/standard/satchel2
	backpack_type = /obj/item/weapon/storage/backpack/satchel/grey

/decl/cardborg_appearance/engineering
	icon_state = "engineerrobot"
	backpack_type = /obj/item/weapon/storage/backpack/industrial

/decl/cardborg_appearance/engineering/satchel
	backpack_type = /obj/item/weapon/storage/backpack/satchel_eng

/decl/cardborg_appearance/medical
	icon_state = "Medbot"
	backpack_type = /obj/item/weapon/storage/backpack/medic

/decl/cardborg_appearance/medical/satchel
	backpack_type = /obj/item/weapon/storage/backpack/satchel_med

/decl/cardborg_appearance/science
	icon_state = "droid-science"
	backpack_type = /obj/item/weapon/storage/backpack/toxins

/decl/cardborg_appearance/science/satchel
	backpack_type = /obj/item/weapon/storage/backpack/satchel_tox

/decl/cardborg_appearance/security
	icon_state = "securityrobot"
	backpack_type = /obj/item/weapon/storage/backpack/security

/decl/cardborg_appearance/security/satchel
	backpack_type = /obj/item/weapon/storage/backpack/satchel_sec

/decl/cardborg_appearance/centcom
	icon_state = "centcomborg"
	backpack_type = /obj/item/weapon/storage/backpack/captain

/decl/cardborg_appearance/centcom/satchel
	backpack_type = /obj/item/weapon/storage/backpack/satchel_cap

/decl/cardborg_appearance/syndicate
	icon_state = "droid-combat"
	backpack_type = /obj/item/weapon/storage/backpack/dufflebag/syndie

/decl/cardborg_appearance/syndicate/med
	backpack_type = /obj/item/weapon/storage/backpack/dufflebag/syndie/med

/decl/cardborg_appearance/syndicate/ammo
	backpack_type = /obj/item/weapon/storage/backpack/dufflebag/syndie/ammo
