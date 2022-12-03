/obj/machinery/vending/wallmed1
	name = "\improper NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	density = FALSE
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	icon_vend = "wallmed-vend"
	base_type = /obj/machinery/vending/wallmed1
	product_ads = {"\
		Go save some lives!;\
		The best stuff for your medbay.;\
		Only the finest tools.;\
		Natural chemicals!;\
		This stuff saves lives.;\
		Don't you want some?\
	"}
	products = list(
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 3,
		/obj/item/reagent_containers/pill/paracetamol = 4,
		/obj/item/storage/med_pouch/trauma,
		/obj/item/storage/med_pouch/burn,
		/obj/item/storage/med_pouch/oxyloss,
		/obj/item/storage/med_pouch/toxin
	)
	contraband = list(
		/obj/item/reagent_containers/syringe/antitoxin = 4,
		/obj/item/reagent_containers/syringe/antiviral = 4,
		/obj/item/reagent_containers/pill/tox = 1
	)
