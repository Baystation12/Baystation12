/obj/machinery/vending/wallmed2
	name = "\improper NanoMed Mini"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	density = FALSE
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	icon_vend = "wallmed-vend"
	base_type = /obj/machinery/vending/wallmed2
	product_ads = {"\
		Go save some lives!;\
		The best stuff for your medbay.;\
		Only the finest tools.;\
		Natural chemicals!;\
		This stuff saves lives.;\
		Don't you want some?\
	"}
	products = list(
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 5,
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
		/obj/item/storage/med_pouch/trauma,
		/obj/item/storage/med_pouch/burn,
		/obj/item/storage/med_pouch/oxyloss,
		/obj/item/storage/med_pouch/toxin,
		/obj/item/storage/med_pouch/radiation
	)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 3,
		/obj/item/reagent_containers/hypospray/autoinjector/pain = 2
	)
