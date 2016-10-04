/obj/structure/closet/secure_closet/cargotech
	name = "cargo technician's locker"
	req_access = list(access_cargo)
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_broken = "securecargobroken"
	icon_off = "securecargooff"

	New()
		..()
		if(prob(75))
			new /obj/item/weapon/storage/backpack(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_norm(src)
		if(prob(25))
			new /obj/item/weapon/storage/backpack/dufflebag(src)
		new /obj/item/clothing/under/rank/cargotech(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/clothing/gloves/thick(src)
		new /obj/item/clothing/head/soft(src)
//		new /obj/item/weapon/cartridge/quartermaster(src)
		return

/obj/structure/closet/secure_closet/quartermaster
	name = "quartermaster's locker"
	req_access = list(access_qm)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

	New()
		..()
		if(prob(75))
			new /obj/item/weapon/storage/backpack(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_norm(src)
		if(prob(25))
			new /obj/item/weapon/storage/backpack/dufflebag(src)
		new /obj/item/clothing/under/rank/cargo(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/clothing/gloves/thick(src)
//		new /obj/item/weapon/cartridge/quartermaster(src)
		new /obj/item/clothing/suit/fire/firefighter(src)
		new /obj/item/weapon/tank/emergency/oxygen(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/clothing/glasses/meson(src)
		new /obj/item/clothing/head/soft(src)
		return

/obj/structure/closet/secure_closet/decktech
	name = "deck technician's locker"
	req_access = list(access_cargo)
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_broken = "securecargobroken"
	icon_off = "securecargooff"

/obj/structure/closet/secure_closet/decktech/New()
	..()
	if(prob(75))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_norm(src)
	if(prob(25))
		new /obj/item/weapon/storage/backpack/dufflebag(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/weapon/cartridge/quartermaster(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/accessory/storage/webbing_large(src)
	new /obj/item/weapon/storage/belt/utility/atmostech(src)
	new /obj/item/weapon/hand_labeler(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/yellow(src)
	new /obj/item/weapon/packageWrap(src)
	return

/obj/structure/closet/secure_closet/deckofficer
	name = "deck officer's locker"
	req_access = list(access_qm)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

/obj/structure/closet/secure_closet/deckofficer/New()
	..()
	if(prob(75))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_norm(src)
	if(prob(25))
		new /obj/item/weapon/storage/backpack/dufflebag(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/weapon/cartridge/quartermaster(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/accessory/storage/brown_vest(src)
	new /obj/item/weapon/storage/belt/utility/full(src)
	new /obj/item/weapon/hand_labeler(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder/yellow(src)
	new /obj/item/weapon/packageWrap(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/megaphone(src)
	new /obj/item/clothing/suit/armor/vest/solgov(src)
	return

/obj/structure/closet/secure_closet/prospector
	name = "prospector's locker"
	req_access = list(access_mining)
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"

/obj/structure/closet/secure_closet/prospector/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/industrial(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_eng(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/accessory/storage/webbing(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/weapon/storage/ore(src)
	new /obj/item/device/flashlight/lantern(src)
	new /obj/item/weapon/shovel(src)
	new /obj/item/weapon/pickaxe(src)
	new /obj/item/clothing/glasses/material(src)
	new /obj/item/clothing/glasses/meson(src)
	return