/obj/structure/closet/secure_closet/captains
	name = "Captain's Closet"
	req_access = list(access_captain)


	New()
		..()
		sleep(2)
		new /obj/item/clothing/suit/captunic(src)
		new /obj/item/clothing/head/helmet/cap(src)
		new /obj/item/clothing/under/rank/captain(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/gloves/captain(src)
		new /obj/item/clothing/head/helmet/swat(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/device/radio/headset/heads/captain(src)
		new /obj/item/weapon/reagent_containers/food/drinks/flask(src)
		new /obj/item/weapon/gun/energy/gun(src)
		return



/obj/structure/closet/secure_closet/hop
	name = "Head of Personnel"
	req_access = list(access_hop)


	New()
		..()
		sleep(2)
		new /obj/item/clothing/under/rank/head_of_personnel(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/device/radio/headset/heads/hop(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/weapon/storage/id_kit(src)
		new /obj/item/weapon/storage/id_kit( src )
		new /obj/item/weapon/gun/energy/gun(src)
		new /obj/item/device/flash(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		return



/obj/structure/closet/secure_closet/hos
	name = "Head Of Security"
	req_access = list(access_hos)


	New()
		..()
		sleep(2)
		new /obj/item/clothing/under/jensen(src)
		new /obj/item/clothing/suit/armor/hos/jensen(src)
		new /obj/item/clothing/head/helmet/HoS/dermal(src)
		new /obj/item/device/radio/headset/heads/hos(src)
		new /obj/item/weapon/shield/riot(src)
		new /obj/item/weapon/storage/lockbox/loyalty(src)
		new /obj/item/weapon/storage/flashbang_kit(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/weapon/gun/energy/gun(src)
		new /obj/item/device/flash(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		return



/obj/structure/closet/secure_closet/warden
	name = "Warden's Locker"
	req_access = list(access_armory)


	New()
		..()
		sleep(2)
		new /obj/item/clothing/under/rank/warden(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/head/helmet/warden(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/weapon/storage/flashbang_kit(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/weapon/gun/energy/taser(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		return



/obj/structure/closet/secure_closet/security
	name = "Security Locker"
	req_access = list(access_security)


	New()
		..()
		sleep(2)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/weapon/flashbang(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/weapon/gun/energy/taser(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		return



/obj/structure/closet/secure_closet/detective
	name = "Detective"
	req_access = list(access_forensics_lockers)
	icon_state = "cabinetdetective"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"


	New()
		..()
		sleep(2)
		new /obj/item/clothing/under/det(src)
		new /obj/item/clothing/suit/det_suit/armor(src)
		new /obj/item/clothing/suit/det_suit(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/head/det_hat(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/weapon/storage/fcard_kit(src)
		new /obj/item/weapon/fcardholder(src)
		new /obj/item/weapon/clipboard(src)
		new /obj/item/device/detective_scanner(src)
		return



/obj/structure/closet/secure_closet/injection
	name = "Lethal Injections"
	req_access = list(access_hos)


	New()
		..()
		sleep(2)
		new /obj/item/weapon/reagent_containers/ld50_syringe/choral(src)
		new /obj/item/weapon/reagent_containers/ld50_syringe/choral(src)
		return



/obj/structure/closet/secure_closet/brig
	name = "Brig Locker"
	req_access = list(access_brig)
	anchored = 1
	var/id = null

	New()
		new /obj/item/clothing/under/color/orange( src )
		new /obj/item/clothing/shoes/orange( src )
		return



/obj/structure/closet/secure_closet/courtroom
	name = "Courtroom Locker"
	req_access = list(access_court)

	New()
		..()
		sleep(2)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/weapon/paper/Court (src)
		new /obj/item/weapon/paper/Court (src)
		new /obj/item/weapon/paper/Court (src)
		new /obj/item/weapon/pen (src)
		new /obj/item/clothing/suit/judgerobe (src)
		new /obj/item/clothing/head/powdered_wig (src)
		new /obj/item/weapon/storage/briefcase(src)
		return
