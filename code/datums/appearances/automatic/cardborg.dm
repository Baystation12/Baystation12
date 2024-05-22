/singleton/appearance_handler/cardborg
	var/static/list/appearances

/singleton/appearance_handler/cardborg/proc/item_equipped(obj/item/item, mob/user, slot)
	if(!(slot == slot_head || slot == slot_wear_suit|| slot == slot_back))
		return
	if(!ishuman(user))
		return
	if(!(istype(item, /obj/item/clothing/suit/cardborg) || istype(item, /obj/item/clothing/head/cardborg) || istype(item, /obj/item/storage/backpack)))
		return
	if(user in appearance_sources)
		return

	var/mob/living/carbon/human/H = user
	if(!(istype(H.wear_suit, /obj/item/clothing/suit/cardborg) && istype(H.head, /obj/item/clothing/head/cardborg) && istype(H.back, /obj/item/storage/backpack)))
		return

	var/image/I = get_image_from_backpack(H)
	AddAltAppearance(H, I, GLOB.silicon_mobs+H) //you look like a robot to robots! (including yourself because you're totally a robot)
	GLOB.logged_in_event.register_global(src, TYPE_PROC_REF(/singleton/appearance_handler/cardborg, mob_joined))	// Duplicate registration request are handled for us

/singleton/appearance_handler/cardborg/proc/item_removed(obj/item/item, mob/user)
	if((istype(item, /obj/item/clothing/suit/cardborg) || istype(item, /obj/item/clothing/head/cardborg)) || istype(item, /obj/item/storage/backpack))
		RemoveAltAppearance(user)
		if(!length(appearance_sources))
			GLOB.logged_in_event.unregister_global(src)	// Only listen to the logged in event for as long as it's relevant

/singleton/appearance_handler/cardborg/proc/mob_joined(mob/user)
	if(issilicon(user))
		DisplayAllAltAppearancesTo(user)

/singleton/appearance_handler/cardborg/proc/get_image_from_backpack(mob/living/carbon/human/H)
	init_appearances()
	var/singleton/cardborg_appearance/ca = appearances[H.back.type]
	if(!ca) ca = appearances[/obj/item/storage/backpack]

	var/image/I = image(icon = 'icons/mob/robots.dmi', icon_state = ca.icon_state, loc = H)
	I.override = 1
	I.AddOverlays(image(icon = 'icons/mob/robots.dmi', icon_state = "eyes-[ca.icon_state]"))
	return I

/singleton/appearance_handler/cardborg/proc/init_appearances()
	if(!appearances)
		appearances = list()
		for(var/singleton/cardborg_appearance/ca in init_subtypes(/singleton/cardborg_appearance))
			appearances[ca.backpack_type] = ca

/singleton/cardborg_appearance
	var/backpack_type
	var/icon_state
	backpack_type = /obj/item/storage/backpack

/singleton/cardborg_appearance/standard
	icon_state = "robot"

/singleton/cardborg_appearance/standard/satchel1
	backpack_type = /obj/item/storage/backpack/satchel

/singleton/cardborg_appearance/standard/satchel2
	backpack_type = /obj/item/storage/backpack/satchel/grey

/singleton/cardborg_appearance/engineering
	icon_state = "engineerrobot"
	backpack_type = /obj/item/storage/backpack/industrial

/singleton/cardborg_appearance/engineering/satchel
	backpack_type = /obj/item/storage/backpack/satchel/eng

/singleton/cardborg_appearance/medical
	icon_state = "Medbot"
	backpack_type = /obj/item/storage/backpack/medic

/singleton/cardborg_appearance/medical/satchel
	backpack_type = /obj/item/storage/backpack/satchel/med

/singleton/cardborg_appearance/science
	icon_state = "droid-science"
	backpack_type = /obj/item/storage/backpack/corpsci

/singleton/cardborg_appearance/science/satchel
	backpack_type = /obj/item/storage/backpack/satchel/corpsci

/singleton/cardborg_appearance/security
	icon_state = "securityrobot"
	backpack_type = /obj/item/storage/backpack/security

/singleton/cardborg_appearance/security/satchel
	backpack_type = /obj/item/storage/backpack/satchel/sec

/singleton/cardborg_appearance/centcom
	icon_state = "centcomborg"
	backpack_type = /obj/item/storage/backpack/command

/singleton/cardborg_appearance/centcom/satchel
	backpack_type = /obj/item/storage/backpack/satchel/com

/singleton/cardborg_appearance/syndicate
	icon_state = "droid-combat"
	backpack_type = /obj/item/storage/backpack/dufflebag/syndie

/singleton/cardborg_appearance/syndicate/med
	backpack_type = /obj/item/storage/backpack/dufflebag/syndie/med

/singleton/cardborg_appearance/syndicate/ammo
	backpack_type = /obj/item/storage/backpack/dufflebag/syndie/ammo
