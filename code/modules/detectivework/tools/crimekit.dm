//crime scene kit
/obj/item/storage/briefcase/crimekit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	item_state = "case"
	startswith = list(
		/obj/item/storage/box/swabs,
		/obj/item/storage/box/fingerprints,
		/obj/item/reagent_containers/spray/luminol,
		/obj/item/device/uv_light,
		/obj/item/forensics/sample_kit,
		/obj/item/forensics/sample_kit/powder,
		/obj/item/storage/csi_markers
		)
	can_hold = list(
		/obj/item/storage/box/swabs,
		/obj/item/storage/box/fingerprints,
		/obj/item/reagent_containers/spray/luminol,
		/obj/item/device/uv_light,
		/obj/item/reagent_containers/syringe,
		/obj/item/forensics/swab,
		/obj/item/sample/print,
		/obj/item/sample/fibers,
		/obj/item/device/taperecorder,
		/obj/item/device/tape,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/forensic,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item/forensics/sample_kit,
		/obj/item/device/camera,
		/obj/item/device/taperecorder,
		/obj/item/device/tape,
		/obj/item/storage/csi_markers,
		/obj/item/device/scanner
		)
