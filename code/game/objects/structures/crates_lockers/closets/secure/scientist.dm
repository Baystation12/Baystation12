/obj/structure/closet/secure_closet/scientist
	name = "scientist's locker"
	req_one_access = list(access_tox,access_tox_storage)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/toxins(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_tox(src)
		new /obj/item/clothing/under/rank/scientist(src)
		//new /obj/item/clothing/suit/labcoat/science(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat(src)
		new /obj/item/clothing/shoes/white(src)
		//new /obj/item/weapon/cartridge/signal/science(src)
		new /obj/item/device/radio/headset/headset_sci(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/weapon/clipboard(src)

/obj/structure/closet/secure_closet/xenobio
	name = "xenobiologist's locker"
	req_access = list(access_xenobiology)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/toxins(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_tox(src)
		new /obj/item/clothing/under/rank/scientist(src)
		//new /obj/item/clothing/suit/labcoat/science(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat(src)
		new /obj/item/clothing/shoes/white(src)
		//new /obj/item/weapon/cartridge/signal/science(src)
		new /obj/item/device/radio/headset/headset_sci(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/clothing/gloves/latex(src)
		new /obj/item/weapon/clipboard(src)
		return


/obj/structure/closet/secure_closet/RD
	name = "research director's locker"
	req_access = list(access_rd)
	icon_state = "rdsecure1"
	icon_closed = "rdsecure"
	icon_locked = "rdsecure1"
	icon_opened = "rdsecureopen"
	icon_broken = "rdsecurebroken"
	icon_off = "rdsecureoff"

	New()
		..()
		new /obj/item/clothing/suit/bio_suit/scientist(src)
		new /obj/item/clothing/head/bio_hood/scientist(src)
		new /obj/item/clothing/under/rank/research_director(src)
		new /obj/item/clothing/under/rank/research_director/rdalt(src)
		new /obj/item/clothing/under/rank/research_director/dress_rd(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat(src)
		new /obj/item/weapon/cartridge/rd(src)
		new /obj/item/clothing/shoes/white(src)
		new /obj/item/clothing/shoes/leather(src)
		new /obj/item/clothing/gloves/latex(src)
		new /obj/item/device/radio/headset/heads/rd(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/clipboard(src)

/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	req_access = list(access_research)


/obj/structure/closet/secure_closet/animal/New()
	..()
	new /obj/item/device/assembly/signaler(src)
	new /obj/item/device/radio/electropack(src)
	new /obj/item/device/radio/electropack(src)
	new /obj/item/device/radio/electropack(src)
	new /obj/item/weapon/gun/launcher/syringe/rapid(src)
	new /obj/item/weapon/storage/box/syringegun(src)
	new /obj/item/weapon/storage/box/syringes(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/stoxin(src)
	return

