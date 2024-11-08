// PISTOLS

/obj/item/gun/projectile/pistol/optimus
	name = "military pistol"
	desc = "A HelTek 'Optimus'. A heavy pistol best known as one of the Confederation Navy's service weapons."

	icon = 'packs/factions/iccgn/weapons.dmi'
	icon_state = "optimus"
	item_state = "secgundark"
	safety_icon = "optimus-safety"

	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ESOTERIC = 4)
	ammo_indicator = TRUE

	magazine_type = /obj/item/ammo_magazine/pistol/double
	allowed_magazines = list(/obj/item/ammo_magazine/pistol/double)
	fire_delay = 8


/obj/item/gun/projectile/pistol/bobcat
	name = "military pistol"
	desc = "An Amaranth Armorers P87 'Bobcat'. A market pistol issued as a Confederation Navy service weapon."

	icon = 'packs/factions/iccgn/weapons.dmi'
	icon_state = "bobcat"
	item_state = "secgundark"
	safety_icon = "bobcat-safety"

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ESOTERIC = 4)
	w_class = ITEM_SIZE_SMALL
	fire_delay = 4

	magazine_type = /obj/item/ammo_magazine/pistol
	allowed_magazines = list(/obj/item/ammo_magazine/pistol)
	banned_magazines = list(
		/obj/item/ammo_magazine/pistol/double,
		/obj/item/ammo_magazine/pistol/small
	)


// RIFLE

/obj/item/gun/projectile/automatic/panther // Semi-automatic only.
	name = "marksman rifle"
	desc = "An NZ MA6 'Panther'. It is a simple and durable rifle made of stamped steel manufactured by Novaya Zemlya Arms for the GCN. \
	While it lacks the burst fire of other military rifles, it's exceptionally accurate and has a powerful optic."

	icon = 'packs/factions/iccgn/weapons.dmi'
	icon_state = "dmr"
	item_state = "dmr"
	wielded_item_state = "dmr-wielded"

	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	racksound = 'sound/weapons/guns/interaction/rifle_rack.ogg'

	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_ESOTERIC = 5)
	load_method = MAGAZINE
	bulk = GUN_BULK_RIFLE
	caliber = CALIBER_RIFLE

	magazine_type = /obj/item/ammo_magazine/rifle
	allowed_magazines = list(/obj/item/ammo_magazine/rifle)

	fire_delay = 8
	one_hand_penalty = 8
	scoped_accuracy = 8
	scope_zoom = 1
	accuracy_power = 8
	accuracy = 4


/obj/item/gun/projectile/automatic/panther/on_update_icon()
	if(ammo_magazine)
		icon_state = "dmr"
	else
		icon_state = "dmr-empty"
	..()


// SUB-MACHINEGUN

/obj/item/gun/projectile/automatic/smg/jaguar
	name = "suppressed submachine gun"
	desc = "An NZ SMG-15 'Jaguar' suppressed sub machinegun. The latest iteration in boarding and ship-defense initiative for the GCN. \
	It comes with a folding stock for tighter environments, and an integral suppressor to lessen loss of hearing in enclosed spaces."

	icon = 'packs/factions/iccgn/weapons.dmi'
	icon_state = "smgsd"
	item_state = "smgsd"

	fire_sound = 'sound/weapons/gunshot/gunshot_suppressed.ogg'

	foldable = TRUE
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ESOTERIC = 3)
	fire_closed_bolt = FALSE
	hold_open = FALSE
	caliber = CALIBER_PISTOL

	magazine_type = /obj/item/ammo_magazine/machine_pistol
	allowed_magazines = list(/obj/item/ammo_magazine/machine_pistol) // More damage compared to the wt550, smaller mag size.
	one_hand_penalty = 2
	burst_delay = 1

	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=null, move_delay=3,    one_hand_penalty=0.5, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.4, 0.8)),
		)


/obj/item/gun/projectile/automatic/smg/jaguar/on_update_icon()
	..()

	if (ammo_magazine)
		AddOverlays("[initial(icon_state)]_mag")
	else
		CutOverlays("[initial(icon_state)]_mag")


/obj/item/gun/projectile/automatic/smg/jaguar/toggle_stock()
	..()

	w_class = folded ? ITEM_SIZE_SMALL : ITEM_SIZE_NORMAL
	accuracy = folded ? -1.5 : 1


// SHOTGUN

/obj/item/gun/projectile/shotgun/magshot
	name = "auto shotgun"
	desc = "An Amaranth Armorers Modele-B 'Kodkod' magazine-fed shotgun. It is used by the GCN as a self-defense weapon on ships and colonies. \
	With changing doctrines for on-board personnel, the weapon is currently on its way out and can often be found in peculiar hands."

	icon = 'packs/factions/iccgn/weapons.dmi'
	icon_state = "magshot"
	item_state = "magshot"
	wielded_item_state = "magshot-wielded"
	safety_icon = "magshot-safety"

	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	racksound = 'sound/weapons/guns/interaction/rifle_rack.ogg'

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE
	auto_eject = TRUE
	hold_open = FALSE
	bulk = GUN_BULK_RIFLE

	magazine_type = /obj/item/ammo_magazine/shotgunmag
	allowed_magazines = list(/obj/item/ammo_magazine/shotgunmag)
	one_hand_penalty = 8
	burst_delay = 2
	accuracy = -1
	jam_chance = 0.2

	firemodes = list(
		list(mode_name="semi-auto",     burst=1, fire_delay=2, move_delay=3, one_hand_penalty=7, burst_accuracy=null, dispersion=1.5),
		list(mode_name="3 shell burst", burst=3, fire_delay=1.5, move_delay=6, one_hand_penalty=9, burst_accuracy=list(-1,-1, -2), dispersion=list(2, 2, 4)),
		list(mode_name="full auto",		can_autofire=TRUE, burst=1, fire_delay=1, move_delay=6, one_hand_penalty=15, burst_accuracy = list(-1,-2,-2,-3,-3,-3,-4,-4), dispersion = list(2, 4, 4, 6, 6, 8))
		)


/obj/item/gun/projectile/shotgun/magshot/on_update_icon()
	..()

	if(ammo_magazine)
		icon_state = initial(icon_state)
		wielded_item_state = initial(wielded_item_state)

		if(LAZYLEN(ammo_magazine.stored_ammo) == ammo_magazine.max_ammo)
			AddOverlays(image(icon, "[initial(icon_state)]-ammo100"))
		else if(LAZYLEN(ammo_magazine.stored_ammo) <= 0.75 * ammo_magazine.max_ammo)
			AddOverlays(image(icon, "[initial(icon_state)]-ammo75"))
		else if(LAZYLEN(ammo_magazine.stored_ammo) <= 0.5 * ammo_magazine.max_ammo)
			AddOverlays(image(icon, "[initial(icon_state)]-ammo50"))
		else
			AddOverlays(image(icon, "[initial(icon_state)]-ammo25"))

	else
		icon_state = "[initial(icon_state)]-empty"
		wielded_item_state = "[initial(wielded_item_state)]-empty"
