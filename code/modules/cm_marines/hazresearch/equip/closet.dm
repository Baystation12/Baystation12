//CHARLIE CLOTHING CLOSET
/obj/structure/closet/secure_closet/hazteam_closet
	name = "HazMat Clothing Locker"
	req_access = list()
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	New()
		sleep(2)
		new /obj/item/clothing/suit/bio/marine(src)
		new /obj/item/clothing/head/helmet/bio/marine(src)
		new /obj/item/clothing/shoes/swat(src)
		new /obj/item/clothing/gloves/swat(src)
		return