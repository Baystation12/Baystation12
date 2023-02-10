/obj/item/gun/projectile/pistol/goodman
	name = "military pistol"
	desc = "The Hephaestus Industries P20 - a mass produced kinetic sidearm in widespread service with the SCGDF."
	caliber = CALIBER_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	icon = 'proxima/icons/obj/guns/aurora_port/sol_pistol.dmi'
	icon_state = "m8"
	item_state = "m8"
	item_icons = list(
		slot_r_hand_str = 'proxima/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'proxima/icons/mob/onmob/lefthand.dmi',
		)
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_delay = 7

/obj/item/gun/projectile/pistol/goodman/on_update_icon()
	..()
	icon_state = (ammo_magazine)? "adhomian_heavy_pistol" : "adhomian_heavy_pistol-e"

/obj/item/gun/projectile/pistol/magnum_pistol/sol
	name = "magnum pistol"
	desc = "The Herne-tek, just a cqc handgun that uses high-caliber ammo."
	icon = 'proxima/icons/obj/guns/aurora_port/adhomian_heavy_pistol.dmi'
	icon_state = "adhomian_heavy_pistol"
	item_state = "adhomian_heavy_pistol"
	item_icons = list(
		slot_r_hand_str = 'proxima/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'proxima/icons/mob/onmob/lefthand.dmi',
		)
	force = 10
	caliber = CALIBER_PISTOL_MAGNUM
	fire_delay = 5
	magazine_type = /obj/item/ammo_magazine/magnum
	accuracy = 2
	one_hand_penalty = 2
	bulk = 3

/obj/item/gun/projectile/pistol/magnum_pistol/sol/on_update_icon()
	..()
	icon_state = (ammo_magazine)? "adhomian_heavy_pistol" : "adhomian_heavy_pistol-e"

/obj/item/gun/projectile/revolver/auto
	name = "auto revolver"
	icon = 'proxima/icons/obj/guns/aurora_port/autorevolver.dmi'
	icon_state = "autorevolver"
	item_state = "autorevolver"
	item_icons = list(
		slot_r_hand_str = 'proxima/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'proxima/icons/mob/onmob/lefthand.dmi',
		)
	caliber = CALIBER_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	desc = "The Lumoco Arms' Solid is a rugged revolver for people who don't keep their guns well-maintained."
	accuracy = 1
	bulk = 0
	fire_delay = 3
	has_safety = FALSE

/obj/item/gun/projectile/automatic/bandit
	name = "old submachine gun"
	desc = "Old and rusty submachine gun, what is used by all sorts of bandits in SCG. Uses 6mmR rounds"
	icon_state = "coltauto"
	item_state = "coltauto"
	icon = 'proxima/icons/obj/guns/aurora_port/coltauto.dmi'
	item_icons = list(
		slot_r_hand_str = 'proxima/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'proxima/icons/mob/onmob/lefthand.dmi',
		)

	caliber = CALIBER_PISTOL_FLECHETTE
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/flechette
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/proto_smg
	screen_shake = 0.5 //SMG

	init_firemodes = list(
		list(mode_name = "semiauto",  mode_desc = "Fire as fast as you can pull the trigger", burst=1, fire_delay=0, move_delay=null),
		list(mode_name="2-round bursts", mode_desc = "Short, controlled bursts", burst=2, fire_delay=null, move_delay=2, one_hand_penalty=2),
		list(mode_name="3-round bursts", mode_desc = "Short, controlled bursts", burst=3, fire_delay=null, move_delay=4, one_hand_penalty=3),
		list(mode_name = "full auto",  mode_desc = "600 rounds per minute",   mode_type = /datum/firemode/automatic, fire_delay = 2, one_hand_penalty=4)
		)

	bulk = GUN_BULK_RIFLE - 1
	w_class = ITEM_SIZE_NORMAL
	one_hand_penalty = 2

/obj/item/gun/projectile/automatic/bandit/on_update_icon()
	..()
	icon_state = (ammo_magazine)? "coltauto" : "coltauto-e"

/obj/item/gun/projectile/sniper/semistrip/stealth
	name = "stealth sniper rifle"
	desc = "it's special design weapon that was designed for stealth assassination."
	icon = 'proxima/icons/obj/guns/aurora_port/heavysniper.dmi'
	icon_state = "heavysniper"
	item_state = "heavysniper"
	item_icons = list(
		slot_r_hand_str = 'proxima/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'proxima/icons/mob/onmob/lefthand.dmi',
		slot_back_str = 'proxima/icons/mob/onmob/items/back-guns.dmi'
		)
	w_class = ITEM_SIZE_LARGE
	force = 10
	origin_tech = list(TECH_COMBAT = 2)
	slot_flags = SLOT_BACK
	caliber = CALIBER_PISTOL_ANTIQUE
	ammo_type = /obj/item/ammo_casing/pistol/throwback
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 10
	accuracy = 3
	recoil_buildup = 5
	scope_zoom = 5
	scoped_accuracy = -2
	wielded_item_state = "heavysniper-wielded"
