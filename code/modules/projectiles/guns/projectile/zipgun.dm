
/obj/item/gun/projectile/pirate
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon = 'icons/obj/guns/zipgun.dmi'
	icon_state = "zipgun"
	item_state = "sawnshotgun"
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	load_method = SINGLE_CASING
	max_shells = 1 //literally just a barrel
	has_safety = FALSE
	w_class = ITEM_SIZE_NORMAL

	var/global/list/ammo_types = list(
		/obj/item/ammo_casing/pistol,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun/pellet,
		/obj/item/ammo_casing/shotgun/pellet,
		/obj/item/ammo_casing/shotgun/pellet,
		/obj/item/ammo_casing/shotgun/beanbag ,
		/obj/item/ammo_casing/shotgun/stunshell,
		/obj/item/ammo_casing/shotgun/flash,
		/obj/item/ammo_casing/rifle/military,
		/obj/item/ammo_casing/rifle
		)

/obj/item/gun/projectile/pirate/toggle_safety(var/mob/user)
	to_chat(user, "<span class='warning'>There's no safety on \the [src]!</span>")

/obj/item/gun/projectile/pirate/Initialize()
	var/obj/item/ammo_casing/ammo = pick(ammo_types)
	caliber = initial(ammo.caliber)
	desc += " Uses [caliber] rounds."
	. = ..()

/obj/item/gun/projectile/pirate/unloaded
	starts_loaded = FALSE
