//crime scene kit
/obj/item/weapon/storage/briefcase/crimekit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	item_state = "case"
	startswith = list(
		/obj/item/weapon/storage/box/swabs,
		/obj/item/weapon/storage/box/fingerprints,
		/obj/item/weapon/reagent_containers/spray/luminol,
		/obj/item/device/uv_light,
		/obj/item/weapon/forensics/sample_kit,
		/obj/item/weapon/forensics/sample_kit/powder,
		/obj/item/weapon/storage/csi_markers
		)
