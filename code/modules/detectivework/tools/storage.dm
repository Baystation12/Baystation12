/obj/item/weapon/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/weapon/forensics/swab)
	storage_slots = 14

/obj/item/weapon/storage/box/swabs/New()
	..()
	for(var/i=0;i<storage_slots,i++) // Fill 'er up.
		new /obj/item/weapon/forensics/swab(src)

/obj/item/weapon/storage/box/slides
	name = "microscope slide box"
	icon_state = "solution_trays"
	storage_slots = 7

/obj/item/weapon/storage/box/slides/New()
	..()
	for(var/i=0;i<storage_slots,i++)
		new /obj/item/weapon/forensics/slide(src)

/obj/item/weapon/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	storage_slots = 6

/obj/item/weapon/storage/box/evidence/New()
	for(var/i=0;i<storage_slots,i++)
		new /obj/item/weapon/evidencebag(src)

/obj/item/weapon/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/weapon/sample/print)
	storage_slots = 14

/obj/item/weapon/storage/box/fingerprints/New()
	..()
	for(var/i=0;i<storage_slots,i++)
		new /obj/item/weapon/sample/print(src)