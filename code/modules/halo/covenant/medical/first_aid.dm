/obj/item/stack/medical/advanced/ointment/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "covie_burnkit"

/obj/item/stack/medical/advanced/bruise_pack/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "covie_brutekit"

/obj/item/weapon/storage/firstaid/fire/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purplefireaid"

	startswith = list(
		/obj/item/device/healthanalyzer/covenant,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/ointment,
		/obj/item/weapon/storage/pill_bottle/covenant/kelotane,
		/obj/item/weapon/storage/pill_bottle/covenant/paracetamol
		)

/obj/item/weapon/storage/firstaid/fire/covenant/New()
	. = ..()
	icon_state = "purplefireaid"

/obj/item/weapon/storage/firstaid/toxin/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpletoxaid"

/obj/item/weapon/storage/firstaid/toxin/covenant/New()
	. = ..()
	icon_state = "purpletoxaid"

/obj/item/weapon/storage/firstaid/toxin/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpletoxaid"

	startswith = list(
		/obj/item/weapon/reagent_containers/syringe/antitoxin = 3,
		/obj/item/weapon/storage/pill_bottle/covenant/antitox,
		/obj/item/device/healthanalyzer/covenant,
		)

/obj/item/weapon/storage/firstaid/regular/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purplefirstaid"

	startswith = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/device/healthanalyzer/covenant,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/storage/pill_bottle/covenant/antidexafen,
		/obj/item/weapon/storage/pill_bottle/covenant/paracetamol
		)

/obj/item/weapon/storage/firstaid/o2/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpleo2aid"

	startswith = list(
		/obj/item/weapon/storage/pill_bottle/covenant/dexalin,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/syringe/inaprovaline,
		/obj/item/device/healthanalyzer/covenant,
		)

/obj/item/weapon/storage/firstaid/combat/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpletraumakit"
	startswith = list(
		/obj/item/weapon/storage/pill_bottle/covenant/bicaridine,
		/obj/item/weapon/storage/pill_bottle/covenant/dermaline,
		/obj/item/weapon/storage/pill_bottle/covenant/dexalin_plus,
		/obj/item/weapon/storage/pill_bottle/covenant/dylovene,
		/obj/item/weapon/storage/pill_bottle/covenant/tramadol,
		/obj/item/weapon/storage/pill_bottle/covenant/spaceacillin,
		/obj/item/stack/medical/splint/covenant,
		)

/obj/item/weapon/storage/firstaid/surgery/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpletraumakit2"
	startswith = list(
		/obj/item/weapon/bonesetter/covenant,
		/obj/item/weapon/cautery/covenant,
		/obj/item/weapon/circular_saw/covenant,
		/obj/item/weapon/hemostat/covenant,
		/obj/item/weapon/retractor/covenant,
		/obj/item/weapon/scalpel/covenant,
		/obj/item/weapon/surgicaldrill/covenant,
		/obj/item/weapon/bonegel,
		/obj/item/weapon/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		)
/obj/item/weapon/storage/firstaid/erk/cov
	desc = "A hull breach kit for Covenant damage control teams. It appears to be bulkier than general medical kits."
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purplefirstaid"

/obj/item/weapon/storage/firstaid/unsc/cov
	name = "Covenant medkit"
	desc = "A general medical kit for Covenant personnel and installations."
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purplefirstaid"

	startswith = list(
		/obj/item/stack/medical/advanced/bruise_pack/covenant,
		/obj/item/stack/medical/advanced/ointment/covenant,
		/obj/item/weapon/storage/pill_bottle/covenant/inaprovaline,
		/obj/item/weapon/reagent_containers/syringe/biofoam,
		/obj/item/weapon/reagent_containers/syringe/biofoam,
		/obj/item/weapon/storage/pill_bottle/covenant/iron,
		/obj/item/weapon/storage/pill_bottle/covenant/tramadol,
		/obj/item/device/healthanalyzer/covenant,
		)

/obj/item/weapon/storage/firstaid/combat/unsc/cov
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpletraumakit"

	startswith = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat = 3,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/painkiller = 3,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/antibiotic = 2,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/necrosis,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/otomax,
		/obj/item/stack/medical/compression,
		/obj/item/stack/medical/splint/covenant,
		/obj/item/device/healthanalyzer/covenant,
		)
