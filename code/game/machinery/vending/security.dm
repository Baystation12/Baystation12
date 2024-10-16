/obj/machinery/vending/security
	name = "\improper SecTech"
	desc = "A security equipment vendor."
	icon_state = "sec"
	icon_deny = "sec-deny"
	icon_vend = "sec-vend"
	base_type = /obj/machinery/vending/security
	req_access = list(access_security)
	product_ads = {"\
		Crack recidivist skulls!;\
		Beat some heads in!;\
		Don't forget - harm is good!;\
		Your weapons are right here.;\
		Handcuffs!;\
		Freeze, scumbag!;\
		Don't tase me bro!;\
		Tase them, bro.;\
		Why not have a donut?\
	"}
	antag_slogans = {"\
		If I had arms you'd be dead by now, capitalist pig.;\
		Guilty until proven innocent!;\
		Feeling down? We'll help you make someone else feel worse.;\
		Civilian tested, Sol approved!;\
		Did you know stun batons can also be used for non-lethal takedowns? Your security team doesn't!;\
		Our flashbangs only work on non-Solars. It's true, look it up!;\
		Civilians only have rights if you let them.\
	"}
	products = list(
		/obj/item/handcuffs = 8,
		/obj/item/grenade/flashbang = 4,
		/obj/item/grenade/chem_grenade/teargas = 4,
		/obj/item/device/flash = 5,
		/obj/item/reagent_containers/food/snacks/donut/normal = 12,
		/obj/item/storage/box/evidence = 6
	)
	rare_products = list(
		/obj/item/clothing/accessory/armor_plate/sneaky = 0,
		/obj/item/gun/projectile/revolving/holdout = 40
	)
	contraband = list(
		/obj/item/clothing/glasses/sunglasses = 2,
		/obj/item/storage/box/donut = 2
	)
	antag = list(
		/obj/item/device/uplink_service/fake_command_report = 1,
		/obj/item/clothing/accessory/armor_plate/sneaky = 0,
		/obj/item/gun/projectile/revolving/holdout = 0
	)
