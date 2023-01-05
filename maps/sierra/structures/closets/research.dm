/*
 * Sierra Science
 */

/singleton/closet_appearance/secure_closet/sierra/science
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_PURPLE_GRAY,
		"stripe_vertical_right_full" = COLOR_PURPLE_GRAY,
		"research" = COLOR_PURPLE_GRAY
	)

/singleton/closet_appearance/secure_closet/sierra/science/rd
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_PURPLE_GRAY,
		"stripe_vertical_mid_full" =   COLOR_GOLD,
		"stripe_vertical_right_full" = COLOR_PURPLE_GRAY,
		"research" = COLOR_GOLD
	)

/obj/structure/closet/secure_closet/RD_sierra
	name = "research director's locker"
	req_access = list(access_rd)
	icon_state = "rd"

/obj/structure/closet/secure_closet/RD_sierra/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist,
		/obj/item/clothing/under/suit_jacket/corp/nanotrasen,
		/obj/item/clothing/suit/storage/toggle/labcoat/science/nanotrasen,
		/obj/item/clothing/suit/storage/toggle/labcoat/rd/nanotrasen,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/science,
		/obj/item/device/radio/headset/heads/rd,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/storage/belt/general,
		/obj/item/device/remote_device/research_director,
		/obj/item/folder,
		/obj/item/clothing/suit/armor/pcarrier/light,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/device/camera,
		/obj/item/taperoll/research,
		/obj/item/clothing/glasses/welding/superior,
		/obj/item/storage/box/secret_project_disks/science,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/toxins, /obj/item/storage/backpack/satchel/tox)),
		new /datum/atom_creator/simple(/obj/item/storage/backpack/messenger/tox, 50)
	)

/obj/structure/closet/secure_closet/xenoarchaeologist_sierra
	name = "xenoarchaeologist's locker"
	req_access = list(access_xenoarch)
	icon_state = "xenobot"

/obj/structure/closet/secure_closet/xenoarchaeologist_sierra/WillContain()
	return list(
		/obj/item/clothing/suit/storage/toggle/labcoat/science/nanotrasen,
		/obj/item/device/radio/headset/headset_sci,
		/obj/item/clothing/mask/gas,
		/obj/item/material/clipboard,
		/obj/item/folder,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/device/camera,
		/obj/item/device/scanner/gas,
		/obj/item/storage/belt/general,
		/obj/item/taperoll/research,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/science,
		/obj/item/clothing/glasses/meson,
		/obj/item/device/radio,
		/obj/item/device/flashlight/lantern,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/toxins, /obj/item/storage/backpack/satchel/tox)),
		new /datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag, 50)
	)

/obj/structure/closet/secure_closet/scientist_sierra
	name = "researcher's locker"
	req_access = list(access_research)
	icon_state = "science"

/obj/structure/closet/secure_closet/scientist_sierra/WillContain()
	return list(
		/obj/item/clothing/suit/storage/toggle/labcoat/science/nanotrasen,
		/obj/item/device/radio/headset/headset_sci,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/material/clipboard,
		/obj/item/folder,
		/obj/item/device/taperecorder,
		/obj/item/storage/belt/general,
		/obj/item/device/tape/random = 3,
		/obj/item/device/camera,
		/obj/item/device/scanner/gas,
		/obj/item/taperoll/research,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/science,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/toxins, /obj/item/storage/backpack/satchel/tox)),
		new /datum/atom_creator/simple(/obj/item/storage/backpack/messenger/tox, 50)
	)
