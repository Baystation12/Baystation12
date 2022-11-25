/obj/machinery/vending/security
	name = "\improper SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	icon_vend = "sec-vend"
	vend_delay = 14
	base_type = /obj/machinery/vending/security
	req_access = list(access_security)
	products = list(
		/obj/item/handcuffs = 8,
		/obj/item/grenade/flashbang = 4,
		/obj/item/grenade/chem_grenade/teargas = 4,
		/obj/item/device/flash = 5,
		/obj/item/reagent_containers/food/snacks/donut/normal = 12,
		/obj/item/storage/box/evidence = 6)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,/obj/item/storage/box/donut = 2)
