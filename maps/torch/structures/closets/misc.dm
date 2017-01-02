/obj/structure/closet/secure_closet/liaison
	name = "\improper NanoTrasen liaison's locker"
	req_access = list(access_liaison)
	icon_state = "nanottwo1"
	icon_closed = "nanottwo"
	icon_locked = "nanottwo1"
	icon_opened = "nanottwoopen"
	icon_broken = "nanottwobroken"
	icon_off = "nanottwooff"

	will_contain = list(
		/obj/item/device/flash,
		/obj/item/weapon/hand_labeler,
		/obj/item/device/camera,
		/obj/item/device/camera_film = 2,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/weapon/storage/secure/briefcase,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/under/rank/internalaffairs/plain/nt,
		/obj/item/clothing/suit/storage/toggle/internalaffairs/plain,
		/obj/item/clothing/glasses/sunglasses/big
	)

/obj/structure/closet/secure_closet/representative
	name = "\improper Sol Central Government representative's locker"
	req_access = list(access_representative)
	icon_state = "solsecure1"
	icon_closed = "solsecure"
	icon_locked = "solsecure1"
	icon_opened = "solsecureopen"
	icon_broken = "solsecurebroken"
	icon_off = "solsecureoff"

	will_contain = list(
		/obj/item/device/flash,
		/obj/item/weapon/hand_labeler,
		/obj/item/device/camera,
		/obj/item/device/camera_film = 2,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/weapon/storage/secure/briefcase,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/under/rank/internalaffairs/plain/solgov,
		/obj/item/clothing/suit/storage/toggle/internalaffairs/plain,
		/obj/item/clothing/glasses/sunglasses/big
	)

//equipment closets that everyone on the crew or in research can access, for storing things securely

/obj/structure/closet/secure_closet/crew
	name = "crew equipment locker"
	req_access = list(access_solgov_crew)
	icon_state = "sol1"
	icon_closed = "sol"
	icon_locked = "sol1"
	icon_opened = "solopen"
	icon_broken = "solbroken"
	icon_off = "soloff"

	will_contain = list(
		/obj/item/device/radio,
		/obj/item/weapon/crowbar,
		/obj/item/device/flashlight,
		/obj/item/weapon/storage/box
	)

/obj/structure/closet/secure_closet/crew/research
	name = "research equipment locker"
	req_access = list(access_nanotrasen)
	icon_state = "nanot1"
	icon_closed = "nanot"
	icon_locked = "nanot1"
	icon_opened = "nanotopen"
	icon_broken = "nanotbroken"
	icon_off = "nanotoff"
