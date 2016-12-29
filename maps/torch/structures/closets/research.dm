/*
 * Torch Science
 */

/obj/structure/closet/secure_closet/RD_torch
	name = "research director's locker"
	req_access = list(access_rd)
	icon_state = "rdsecure1"
	icon_closed = "rdsecure"
	icon_locked = "rdsecure1"
	icon_opened = "rdsecureopen"
	icon_broken = "rdsecurebroken"
	icon_off = "rdsecureoff"

	will_contain = list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist,
		/obj/item/clothing/under/rank/research_director,
		/obj/item/clothing/under/rank/research_director/rdalt,
		/obj/item/clothing/under/rank/research_director/dress_rd,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/labcoat/science,
		/obj/item/weapon/cartridge/rd,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/science,
		/obj/item/device/radio/headset/heads/torchntcommand,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/device/camera,
		/obj/item/taperoll/research,
		/obj/item/clothing/glasses/welding/superior,
		/obj/item/clothing/suit/armor/vest/nt
	)

/obj/structure/closet/secure_closet/secure_closet/xenoarchaeologist_torch
	name = "xenoarchaeologist's locker"
	req_access = list(access_xenoarch)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

	will_contain = list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat/science,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/white,
		/obj/item/weapon/cartridge/signal/science,
		/obj/item/device/radio/headset/torchnanotrasen,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/device/camera,
		/obj/item/taperoll/research,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/science,
		/obj/item/clothing/glasses/meson,
		/obj/item/device/radio,
		/obj/item/device/flashlight/lantern
	)

/obj/structure/closet/secure_closet/secure_closet/xenoarchaeologist_torch/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/toxins(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_tox(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag(src)

/obj/structure/closet/secure_closet/scientist_torch
	name = "researcher's locker"
	req_one_access = list(access_research)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

	will_contain = list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat/science,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/white,
		/obj/item/weapon/cartridge/signal/science,
		/obj/item/device/radio/headset/torchnanotrasen,
		/obj/item/clothing/mask/gas/half,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/device/camera,
		/obj/item/taperoll/research,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/science
	)

/obj/structure/closet/secure_closet/scientist_torch/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/toxins(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_tox(src)


/obj/structure/closet/secure_closet/prospector
	name = "prospector's locker"
	req_access = list(access_mining)
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"

	will_contain = list(
		/obj/item/device/radio/headset/torchnanotrasen,
		/obj/item/clothing/under/rank/miner,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/shoes/workboots,
		/obj/item/device/analyzer,
		/obj/item/weapon/storage/ore,
		/obj/item/device/flashlight/lantern,
		/obj/item/weapon/shovel,
		/obj/item/weapon/pickaxe,
		/obj/item/weapon/crowbar,
		/obj/item/clothing/glasses/material,
		/obj/item/clothing/glasses/meson
	)

/obj/structure/closet/secure_closet/prospector/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/industrial(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_eng(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/eng(src)

/obj/structure/closet/secure_closet/guard
	name = "security guard's locker"
	req_access = list(access_sec_guard)
	icon_state = "guard1"
	icon_closed = "guard"
	icon_locked = "guard1"
	icon_opened = "guardopen"
	icon_broken = "guardbroken"
	icon_off = "guardoff"

	will_contain = list(
		/obj/item/clothing/under/rank/guard,
		/obj/item/clothing/suit/armor/vest/nt,
		/obj/item/clothing/suit/storage/vest/nt,
		/obj/item/clothing/head/helmet/nt/guard,
		/obj/item/clothing/head/soft/sec/corp/guard,
		/obj/item/clothing/accessory/armband/whitered,
		/obj/item/device/radio/headset/torchnanotrasen,
		/obj/item/clothing/mask/gas/half,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/weapon/storage/belt/security,
		/obj/item/device/flash,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/weapon/handcuffs = 2,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/glasses/tacgoggles,
		/obj/item/clothing/mask/balaclava,
		/obj/item/taperoll/research,
		/obj/item/device/hailer,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/device/megaphone
	)

/obj/structure/closet/secure_closet/guard/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_sec(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
