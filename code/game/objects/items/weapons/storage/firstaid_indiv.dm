//Personal firstaid kit, from infinity

/obj/item/storage/firstaid/individual
	name = "master kit"
	icon = 'icons/obj/items.dmi'
	icon_state = "survivalmed"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	storage_slots  = 10
	can_hold = list(
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment,
		/obj/item/reagent_containers/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical/advanced,
		/obj/item/reagent_containers/syringe,
		/obj/item/bodybag/
		)

/obj/item/storage/firstaid/individual/all
	name = "individual medical kit"
	desc = "A small box decorated in warning colors that contains a limited supply of medical reagents."
	startswith = list(
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment
		)

/obj/item/storage/firstaid/individual/military
	name = "military individual medical kit"
	desc = "A small box decorated in dark colors that contains a limited supply of medical reagents."
	icon_state = "survivalmilmed"
	startswith = list(
		/obj/item/reagent_containers/hypospray/autoinjector/burn = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/brute = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/pain,
		/obj/item/reagent_containers/hypospray/autoinjector/detox,
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline,
		/obj/item/reagent_containers/hypospray/autoinjector/antirad,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment
		)

/obj/item/storage/firstaid/individual/military/exp
	name = "expeditionary individual medical kit"
	desc = "A small box decorated in warning colors that contains a limited supply of medical reagents."
	icon_state = "survivalexp"
	storage_slots  = 7
	startswith = list(
		/obj/item/reagent_containers/hypospray/autoinjector/burn,
		/obj/item/reagent_containers/hypospray/autoinjector/brute,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin,
		/obj/item/reagent_containers/hypospray/autoinjector/pain = 2,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment
		)
