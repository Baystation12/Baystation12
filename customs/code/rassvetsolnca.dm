/obj/item/gun/projectile/revolver/rassvetsolnca
	name = "Revolver 'Kisen-Isu'"
	desc = "This is a rather old revolver that has seen many shootings. It was custom-made to fit a fairly large man's hand. The caliber of the gun is old .38 Special. Its surface is covered with numerous scratches, and the inscription on the handle is carved with something sharp: 'Kangya', in Yangui letters."
	icon = 'proxima/icons/obj/guns/ballistic.dmi'
	icon_state = "detective_panther"
	handle_casings = CYCLE_CASINGS
	caliber = CALIBER_PISTOL_SMALL
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/pistol/small

/obj/item/storage/secure/briefcase/rassvetsolnca
	l_code = "12345"
	l_set = 1
	startswith = list(
		/obj/item/gun/projectile/revolver/rassvetsolnca,
		/obj/item/ammo_magazine/speedloader/small/rubber,
		/obj/item/ammo_magazine/speedloader/small/rubber,
		/obj/item/ammo_magazine/speedloader/small/rubber,
		/obj/item/ammo_magazine/speedloader/small/rubber,
	)
