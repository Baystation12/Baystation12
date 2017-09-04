/obj/item/weapon/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	startswith = list(/obj/item/weapon/forensics/swab = DEFAULT_BOX_STORAGE)

/obj/item/weapon/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	startswith = list(/obj/item/weapon/evidencebag = 7)

/obj/item/weapon/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	startswith = list(/obj/item/weapon/sample/print = DEFAULT_BOX_STORAGE)
