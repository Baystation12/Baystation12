/*
 * Torch Supply
 */

/obj/structure/closet/secure_closet/decktech
	name = "deck technician's locker"
	req_access = list(access_cargo)
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_broken = "securecargobroken"
	icon_off = "securecargooff"

	will_contain = list(
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/gloves/thick,
		/obj/item/weapon/cartridge/quartermaster,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/weapon/storage/belt/utility/atmostech,
		/obj/item/weapon/hand_labeler,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder/yellow,
		/obj/item/weapon/packageWrap
	)

/obj/structure/closet/secure_closet/decktech/New()
	..()
	if(prob(75))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_norm(src)
	if(prob(25))
		new /obj/item/weapon/storage/backpack/dufflebag(src)

/obj/structure/closet/secure_closet/deckofficer
	name = "deck officer's locker"
	req_access = list(access_qm)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

	will_contain = list(
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/gloves/thick,
		/obj/item/weapon/cartridge/quartermaster,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/weapon/hand_labeler,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder/yellow,
		/obj/item/weapon/packageWrap,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/device/holowarrant,
		/obj/item/clothing/suit/armor/vest/solgov
	)

/obj/structure/closet/secure_closet/deckofficer/New()
	..()
	if(prob(75))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_norm(src)
	if(prob(25))
		new /obj/item/weapon/storage/backpack/dufflebag(src)