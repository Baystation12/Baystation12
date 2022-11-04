/obj/item/gun/energy/gatlinglaser
	name = "gatling laser"
	desc = "A highly sophisticated rapid fire laser weapon."
	icon = 'proxima/icons/obj/guns/minigun.dmi'
	icon_state = "minigun"
	item_state = "minigun"
	item_icons = list(
		slot_r_hand_str = 'proxima/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'proxima/icons/mob/onmob/lefthand.dmi',
		)
	fire_sound = 'sound/weapons/pulse2.ogg'
	origin_tech = list(TECH_COMBAT = 7, TECH_PHORON = 7, TECH_MATERIAL = 7)
	charge_meter = 0
	slot_flags = SLOT_BACK
	force = 20
	projectile_type = /obj/item/projectile/beam/smalllaser
	max_shots = 350
	burst = 10
	burst_delay = 3
	fire_delay = 8

	init_firemodes = list(
		list(mode_name="20-shoot bursts", mode_desc = "Short, controlled bursts", burst=20, fire_delay=null, move_delay=6, one_hand_penalty=6),
		list(mode_name="40-shoot bursts", mode_desc = "Medium, controlled bursts", burst=40, fire_delay=null, move_delay=10, one_hand_penalty=13),
		list(mode_name = "fuller auto",  mode_desc = "800 rounds per minute",   mode_type = /datum/firemode/automatic, fire_delay = 1, one_hand_penalty=20)
		)


/obj/item/gun/projectile/pistol/goodman
	name = "military pistol"
	desc = "The Hephaestus Industries P20 - a mass produced kinetic sidearm in widespread service with the SCGDF."
	magazine_type = /obj/item/ammo_magazine/pistol/double
	allowed_magazines = /obj/item/ammo_magazine/pistol/double
	icon = 'proxima/icons/obj/guns/aurora_port/sol_pistol.dmi'
	icon_state = "m8"
	item_state = "m8"
	item_icons = list(
		slot_r_hand_str = 'proxima/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'proxima/icons/mob/onmob/lefthand.dmi',
		)
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_delay = 7

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

/obj/item/gun/projectile/revolver/auto
	name = "revolver"
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

	caliber = CALIBER_PISTOL_FAST
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/corpo
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/corpo
	allowed_magazines = /obj/item/ammo_magazine/corpo
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

/obj/item/gun/projectile/heavysniper/mag
	name = "dragunov sniper rifle"
	desc = "Dragunov is a semi-auto heavy sniper rifle was originally designed to be used against heavy infantry."
	icon = 'proxima/icons/obj/guns/aurora_port/dragunov.dmi'
	icon_state = "dragunov"
	item_state = "dragunov"
	item_icons = list(
		slot_r_hand_str = 'proxima/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'proxima/icons/mob/onmob/lefthand.dmi',
		slot_back_str = 'proxima/icons/mob/onmob/items/back-guns.dmi'
		)
	w_class = ITEM_SIZE_HUGE
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ESOTERIC = 8)
	caliber = CALIBER_RIFLE_MILITARY
	screen_shake = 1
	handle_casings = EJECT_CASINGS
	load_method = MAGAZINE
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/rifle/military
	one_hand_penalty = 6
	accuracy = -2
	recoil_buildup = 75
	bulk = 8
	scoped_accuracy = 6
	scope_zoom = 3
	wielded_item_state = "dragunov-wielded"
	load_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	fire_delay = 7

/obj/item/gun/projectile/sniper/semistrip/stealth
	name = "stealth sniper rifle"
	desc = "it's special design weapon that was designed for stealt assassination."
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

