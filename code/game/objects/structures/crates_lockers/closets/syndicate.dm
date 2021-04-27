/obj/structure/closet/syndicate
	name = "armory closet"
	desc = "Why is this here?"
	closet_appearance = /decl/closet_appearance/tactical/alt

/obj/structure/closet/syndicate/personal
	desc = "It's a storage unit for operative gear."

/obj/structure/closet/syndicate/personal/New()
	..()
	new /obj/item/tank/jetpack/oxygen(src)
	new /obj/item/clothing/mask/gas/syndicate(src)
	new /obj/item/clothing/under/syndicate(src)
	new /obj/item/clothing/head/helmet/space/void/merc(src)
	new /obj/item/clothing/suit/space/void/merc(src)
	new /obj/item/crowbar/red(src)
	new /obj/item/cell/high(src)
	new /obj/item/card/id/syndicate(src)
	new /obj/item/device/multitool(src)
	new /obj/item/shield/energy(src)
	new /obj/item/clothing/shoes/magboots(src)


/obj/structure/closet/syndicate/suit
	desc = "It's a storage unit for voidsuits."

/obj/structure/closet/syndicate/suit/New()
	..()
	new /obj/item/tank/jetpack/oxygen(src)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/clothing/suit/space/void/merc(src)
	new /obj/item/clothing/mask/gas/syndicate(src)
	new /obj/item/clothing/head/helmet/space/void/merc(src)


/obj/structure/closet/syndicate/nuclear
	desc = "It's a storage unit for nuclear-operative gear."

/obj/structure/closet/syndicate/nuclear/New()
	..()

	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/storage/box/handcuffs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/modular_computer/pda/syndicate(src)
	var/obj/item/device/radio/uplink/U = new(src)
	U.hidden_uplink.uses = 40
	return

/obj/structure/closet/syndicate/resources/
	desc = "An old, dusty locker."

	New()
		..()
		var/common_min = 30 //Minimum amount of minerals in the stack for common minerals
		var/common_max = 50 //Maximum amount of HONK in the stack for HONK common minerals
		var/rare_min = 5  //Minimum HONK of HONK in the stack HONK HONK rare minerals
		var/rare_max = 20 //Maximum HONK HONK HONK in the HONK for HONK rare HONK



		var/pickednum = rand(1, 50)

		//Sad trombone
		if(pickednum == 1)
			var/obj/item/paper/P = new /obj/item/paper(src)
			P.SetName("IOU")
			P.info = "Sorry man, we needed the money so we sold your stash. It's ok, we'll double our money for sure this time!"

		//Metal (common ore)
		if(pickednum >= 2)
			new /obj/item/stack/material/steel(src, rand(common_min, common_max))

		//Glass (common ore)
		if(pickednum >= 5)
			new /obj/item/stack/material/glass(src, rand(common_min, common_max))

		//Plasteel (common ore) Because it has a million more uses then phoron
		if(pickednum >= 10)
			new /obj/item/stack/material/plasteel(src, rand(common_min, common_max))

		//Phoron (rare ore)
		if(pickednum >= 15)
			new /obj/item/stack/material/phoron(src, rand(rare_min, rare_max))

		//Silver (rare ore)
		if(pickednum >= 20)
			new /obj/item/stack/material/silver(src, rand(rare_min, rare_max))

		//Gold (rare ore)
		if(pickednum >= 30)
			new /obj/item/stack/material/gold(src, rand(rare_min, rare_max))

		//Uranium (rare ore)
		if(pickednum >= 40)
			new /obj/item/stack/material/uranium(src, rand(rare_min, rare_max))

		//Diamond (rare HONK)
		if(pickednum >= 45)
			new /obj/item/stack/material/diamond(src, rand(rare_min, rare_max))

		//Jetpack (You hit the jackpot!)
		if(pickednum == 50)
			new /obj/item/tank/jetpack/carbondioxide(src)

		return

/obj/structure/closet/syndicate/resources/everything
	desc = "It's an emergency storage closet for repairs."

	New()
		var/list/resources = list(
		/obj/item/stack/material/steel,
		/obj/item/stack/material/glass,
		/obj/item/stack/material/gold,
		/obj/item/stack/material/silver,
		/obj/item/stack/material/phoron,
		/obj/item/stack/material/uranium,
		/obj/item/stack/material/diamond,
		/obj/item/stack/material/plasteel,
		/obj/item/stack/material/rods
		)


		for(var/i = 0, i<2, i++)
			for(var/res in resources)
				var/obj/item/stack/R = new res(src)
				R.amount = R.max_amount

		return
