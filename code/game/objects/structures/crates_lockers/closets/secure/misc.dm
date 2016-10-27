/obj/structure/closet/secure_closet/liaison
	name = "/improper NanoTrasen liaison's locker"
	req_access = list(access_lawyer)
	icon_state = "nanottwo1"
	icon_closed = "nanottwo"
	icon_locked = "nanottwo1"
	icon_opened = "nanottwoopen"
	icon_broken = "nanottwobroken"
	icon_off = "nanottwooff"

/obj/structure/closet/secure_closet/liaison/New()
	..()
	new /obj/item/device/flash(src)
	new /obj/item/weapon/hand_labeler(src)
	new /obj/item/device/camera(src)
	new /obj/item/device/camera_film(src)
	new /obj/item/device/camera_film(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/weapon/storage/secure/briefcase(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/under/rank/internalaffairs(src)
	new /obj/item/clothing/suit/storage/toggle/internalaffairs(src)
	new /obj/item/clothing/glasses/sunglasses/big(src)
	return

/obj/structure/closet/secure_closet/representative
	name = "/improper Sol Central Government representative's locker"
	req_access = list(access_lawyer)
	icon_state = "solsecure1"
	icon_closed = "solsecure"
	icon_locked = "solsecure1"
	icon_opened = "solsecureopen"
	icon_broken = "solsecurebroken"
	icon_off = "solsecureoff"

/obj/structure/closet/secure_closet/representative/New()
	..()
	new /obj/item/device/flash(src)
	new /obj/item/weapon/hand_labeler(src)
	new /obj/item/device/camera(src)
	new /obj/item/device/camera_film(src)
	new /obj/item/device/camera_film(src)
	new /obj/item/weapon/clipboard(src)
	new /obj/item/weapon/folder(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/weapon/storage/secure/briefcase(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/under/rank/internalaffairs/plain(src)
	new /obj/item/clothing/suit/storage/toggle/internalaffairs/plain(src)
	new /obj/item/clothing/glasses/sunglasses/big(src)
	return

//equipment closets that everyone on the crew or in research can access, for storing things securely

/obj/structure/closet/secure_closet/crew
	name = "crew equipment locker"
	icon_state = "sol1"
	icon_closed = "sol"
	icon_locked = "sol1"
	icon_opened = "solopen"
	icon_broken = "solbroken"
	icon_off = "soloff"

/obj/structure/closet/secure_closet/crew/New()
	..()
	new /obj/item/device/radio(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/device/flashlight(src)
	new /obj/random/maintenance/clean(src)
	new /obj/random/maintenance/clean(src)
	new /obj/random/maintenance/clean(src)
	return

/obj/structure/closet/secure_closet/research
	name = "research equipment locker"
	icon_state = "nanot1"
	icon_closed = "nanot"
	icon_locked = "nanot1"
	icon_opened = "nanotopen"
	icon_broken = "nanotbroken"
	icon_off = "nanotoff"

/obj/structure/closet/secure_closet/research/New()
	..()
	new /obj/item/device/radio(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/device/flashlight(src)
	new /obj/random/maintenance/clean(src)
	new /obj/random/maintenance/clean(src)
	new /obj/random/maintenance/clean(src)
	return
