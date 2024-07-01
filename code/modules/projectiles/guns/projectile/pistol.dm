
/obj/item/gun/projectile/pistol
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	allowed_magazines = list(/obj/item/ammo_magazine/pistol)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	accuracy_power = 7
	var/empty_icon = TRUE  //If it should change icon when empty
	var/ammo_indicator = FALSE

/obj/item/gun/projectile/pistol/on_update_icon()
	..()
	if(empty_icon)
		if(ammo_magazine && length(ammo_magazine.stored_ammo))
			icon_state = initial(icon_state)
		else
			icon_state = "[initial(icon_state)]-e"
	if(ammo_indicator)
		if(!ammo_magazine || !LAZYLEN(ammo_magazine.stored_ammo))
			AddOverlays(image(icon, "[initial(icon_state)]-ammo0"))
		else if(LAZYLEN(ammo_magazine.stored_ammo) <= 0.5 * ammo_magazine.max_ammo)
			AddOverlays(image(icon, "[initial(icon_state)]-ammo1"))
		else
			AddOverlays(image(icon, "[initial(icon_state)]-ammo2"))

/obj/item/gun/projectile/pistol/sec
	name = "pistol"
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. Found pretty much everywhere humans are."
	icon = 'icons/obj/guns/pistol.dmi'
	icon_state = "secguncomp"
	safety_icon = "safety"
	magazine_type = /obj/item/ammo_magazine/pistol/rubber
	accuracy = -1
	fire_delay = 6
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

/obj/item/gun/projectile/pistol/sec/empty
	starts_loaded = FALSE

/obj/item/gun/projectile/pistol/sec/lethal
	magazine_type = /obj/item/ammo_magazine/pistol

/obj/item/gun/projectile/pistol/magnum_pistol
	name = "magnum pistol"
	desc = "The HelTek Magnus, a robust handgun that uses high-caliber ammo. Issued to Confederation Pioneers for holster sized defence."
	icon = 'icons/obj/guns/magnum_pistol.dmi'
	icon_state = "magnum"
	item_state = "magnum"
	safety_icon = "safety"
	force = 9
	caliber = CALIBER_PISTOL_MAGNUM
	fire_delay = 12
	screen_shake = 2
	magazine_type = /obj/item/ammo_magazine/magnum
	allowed_magazines = list(/obj/item/ammo_magazine/magnum)
	mag_insert_sound = 'sound/weapons/guns/interaction/hpistol_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/hpistol_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	accuracy = 2
	one_hand_penalty = 2
	bulk = 3
	ammo_indicator = TRUE

/obj/item/gun/projectile/pistol/throwback
	name = "pistol"
	desc = "A product of one of thousands of illegal workshops from around the galaxy. This one appears to be a clone of a 20th century design."
	icon = 'icons/obj/guns/pistol_throwback.dmi'
	icon_state = "pistol1"
	magazine_type = /obj/item/ammo_magazine/pistol/throwback
	accuracy_power = 5
	one_hand_penalty = 2
	fire_delay = 7
	caliber = CALIBER_PISTOL_ANTIQUE
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	var/base_icon = "pistol1"

/obj/item/gun/projectile/pistol/throwback/Initialize()
	. = ..()
	base_icon = "pistol[rand(1,4)]"
	update_icon()

/obj/item/gun/projectile/pistol/throwback/on_update_icon()
	..()
	if(ammo_magazine && length(ammo_magazine.stored_ammo))
		icon_state = base_icon
	else
		icon_state = "[base_icon]-e"

/obj/item/gun/projectile/pistol/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds."
	icon = 'icons/obj/guns/gyropistol.dmi'
	icon_state = "gyropistol"
	max_shells = 8
	caliber = CALIBER_GYROJET
	origin_tech = list(TECH_COMBAT = 3)
	magazine_type = /obj/item/ammo_magazine/gyrojet
	allowed_magazines = list(/obj/item/ammo_magazine/gyrojet)
	handle_casings = CLEAR_CASINGS	//the projectile is the casing
	fire_delay = 25
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	mag_insert_sound = 'sound/weapons/guns/interaction/hpistol_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/hpistol_magout.ogg'
	empty_icon = FALSE

/obj/item/gun/projectile/pistol/gyropistol/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"

/obj/item/gun/projectile/pistol/holdout
	name = "holdout pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	icon_state = "pistol"
	item_state = null
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	fire_delay = 4
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ESOTERIC = 2)
	magazine_type = /obj/item/ammo_magazine/pistol/small
	allowed_magazines = list(/obj/item/ammo_magazine/pistol/small)
	var/obj/item/silencer/silencer

/obj/item/gun/projectile/pistol/holdout/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if (!user.IsHolding(src))
				..()
				return
			if (silencer)
				to_chat(user, SPAN_NOTICE("You unscrew \the [silencer] from \the [src]."))
				user.put_in_hands(silencer)
				silencer = null
			silenced = FALSE
			w_class = initial(w_class)
			update_icon()
			return
	..()


/obj/item/gun/projectile/pistol/holdout/use_tool(obj/item/tool, mob/user, list/click_params)
	// Silencer - Attach silencer
	if (istype(tool, /obj/item/silencer))
		if (silenced)
			if (silencer)
				USE_FEEDBACK_FAILURE("\The [src] already has \a [silencer] attached.")
			else
				USE_FEEDBACK_FAILURE("\The [src] is already silenced.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_FAILURE(user, tool)
			return TRUE
		silenced = TRUE
		silencer = tool
		w_class = ITEM_SIZE_NORMAL
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] screws \a [tool] onto \a [src]."),
			SPAN_NOTICE("You screw \a [tool] onto \a [src]."),
			range = 2
		)
		return TRUE

	return ..()


/obj/item/gun/projectile/pistol/holdout/on_update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"
	if(!(ammo_magazine && length(ammo_magazine.stored_ammo)))
		icon_state = "[icon_state]-e"

/obj/item/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	icon_state = "silencer"
	w_class = ITEM_SIZE_SMALL

/obj/item/gun/projectile/pistol/broomstick
	name = "broomstick"
	desc = "An antique gun that makes you want to yell 'IT BELONGS IN A MUSEUM!'. There appears to be some thing scratched next to the fireselector, though you cant make it out."
	icon = 'icons/obj/guns/broomstick.dmi'
	icon_state = "broomstick"
	accuracy_power = 6
	one_hand_penalty = 3
	fire_delay = 5
	caliber = CALIBER_PISTOL_SMALL
	origin_tech = list(
						TECH_COMBAT = 2,
						TECH_MATERIAL = 2
						)
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 10

	firemodes = list(
		list(
			mode_name="semi auto",
			burst=1,
			fire_delay=5,
			move_delay=null,
			one_hand_penalty=3,
			burst_accuracy=null,
			dispersion=null
			),
		list(
			mode_name="scratched out option",
			burst=10,
			fire_delay=1,
			one_hand_penalty=8,
			burst_accuracy = list(0,-1,-2,-3,-4,-4,-4,-4,-4),
			dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)
			)
		)
