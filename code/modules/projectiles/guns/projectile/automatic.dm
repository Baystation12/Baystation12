
//Automatic firing
//Todo: Way more checks and safety here
/datum/firemode/automatic
	settings = list(burst = 1, suppress_delay_warning = TRUE, dispersion=null)
	//The full auto clickhandler we have
	var/datum/click_handler/fullauto/CH

/datum/firemode/automatic/update(force_state = null)
	var/mob/living/L
	if (gun && gun.is_held())
		L = gun.loc

	var/enable = FALSE
	//Force state is used for forcing it to be disabled in circumstances where it'd normally be valid
	if (!isnull(force_state))
		enable = force_state
	else if (L && L.client)

		//First of all, lets determine whether we're enabling or disabling the click handler


		//We enable it if the gun is held in the user's active hand and the safety is off
		if (L.get_active_hand() == gun)
			//Lets also make sure it can fire
			var/can_fire = TRUE

			//Safety stops it
			if (gun.safety_state)
				can_fire = FALSE

			//Projectile weapons need to have enough ammo to fire
			if(istype(gun, /obj/item/gun/projectile))
				var/obj/item/gun/projectile/P = gun
				if (!P.get_ammo())
					can_fire = FALSE

			//TODO: Centralise all this into some can_fire proc
			if (can_fire)
				enable = TRUE
		else
			enable = FALSE

	//Ok now lets set the desired state
	if (!enable)
		if (!CH)
			//If we're turning it off, but the click handler doesn't exist, then we have nothing to do
			return

		//Todo: make client click handlers into a list
		if (CH.owner) //Remove our handler from the client
			CH.owner.CH = null //wew
		QDEL_NULL(CH) //And delete it
		return

	else
		//We're trying to turn things on
		if (CH)
			return //The click handler exists, we dont need to do anything


		//Create and assign the click handler
		//A click handler intercepts mouseup/drag/down events which allow fullauto firing
		CH = new /datum/click_handler/fullauto()
		CH.reciever = gun //Reciever is the gun that gets the fire events
		L.client.CH = CH //Put it on the client
		CH.owner = L.client //And tell it where it is


/obj/item/gun/projectile/automatic
	name = "prototype SMG"
	desc = "A protoype lightweight, fast firing submachine gun."
	icon = 'icons/obj/guns/prototype_smg.dmi'
	icon_state = "prototype"
	item_state = "saber"
	w_class = ITEM_SIZE_NORMAL
	bulk = -1
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL_FLECHETTE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/flechette
	magazine_type = /obj/item/ammo_magazine/proto_smg
	allowed_magazines = /obj/item/ammo_magazine/proto_smg
	multi_aim = 1
	recoil_buildup = 1.2
	burst_delay = 2
	mag_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'

	//machine pistol, easier to one-hand with
	init_firemodes = list(
		// list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		// list(mode_name="4-round bursts", burst=4, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,0,-1,-1),       dispersion=list(0.0, 0.0, 0.5, 0.6)),
		// list(mode_name="long bursts",   burst=8, fire_delay=null, move_delay=4,    one_hand_penalty=2, burst_accuracy=list(0,0,-1,-1,-1,-1,-2,-2), dispersion=list(0.0, 0.0, 0.5, 0.6, 0.8, 1.0, 1.0, 1.2)),
			SEMI_AUTO_NODELAY,
			BURST_3_ROUND,
			FULL_AUTO_600
		)

/obj/item/gun/projectile/automatic/machine_pistol
	name = "machine pistol"
	desc = "The Hephaestus Industries MP6 Vesper, A fairly common machine pistol. Sometimes refered to as an 'uzi' by the backwater spacers it is often associated with."
	icon = 'icons/obj/guns/machine_pistol.dmi'
	icon_state = "mpistolen"
	safety_icon = "safety"
	item_state = "mpistolen"
	caliber = CALIBER_PISTOL
	burst_delay = 0.5
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ESOTERIC = 3)
	ammo_type = /obj/item/ammo_casing/pistol
	magazine_type = /obj/item/ammo_magazine/machine_pistol
	allowed_magazines = /obj/item/ammo_magazine/machine_pistol //more damage compared to the wt550, smaller mag size
	one_hand_penalty = 2

	init_firemodes = list(
			SEMI_AUTO_NODELAY,
			BURST_3_ROUND
		)

/obj/item/gun/projectile/automatic/machine_pistol/on_update_icon()
	..()
	icon_state = "mpistolen"
	if(ammo_magazine)
		overlays += image(icon, "mag")

	if(!ammo_magazine || !LAZYLEN(ammo_magazine.stored_ammo))
		icon_state = "mpistolen-empty"
		overlays += image(icon, "ammo_bad")
	else if(LAZYLEN(ammo_magazine.stored_ammo) <= 0.5 * ammo_magazine.max_ammo)
		overlays += image(icon, "ammo_warn")
		return
	else
		overlays += image(icon, "ammo_ok")

/obj/item/gun/projectile/automatic/merc_smg
	name = "submachine gun"
	desc = "The NanoTrasen C-20r is a lightweight and rapid firing SMG, for when you REALLY need someone dead. Has a 'Per falcis, per pravitas' buttstamp."
	icon = 'icons/obj/guns/merc_smg.dmi'
	icon_state = "c20r"
	item_state = "c20r"
	safety_icon = "safety"
	w_class = ITEM_SIZE_LARGE
	force = 10
	caliber = CALIBER_PISTOL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ESOTERIC = 8)
	slot_flags = SLOT_BELT|SLOT_BACK
	recoil_buildup = 1.5
	magazine_type = /obj/item/ammo_magazine/smg
	allowed_magazines = /obj/item/ammo_magazine/smg
	fire_sound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	bulk = -1
	accuracy = 1
	one_hand_penalty = 4

	//SMG
	init_firemodes = list(
			SEMI_AUTO_NODELAY,
			BURST_3_ROUND,
			FULL_AUTO_800
		)

/obj/item/gun/projectile/automatic/merc_smg/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "c20r"

/obj/item/gun/projectile/automatic/assault_rifle
	name = "assault rifle"
	desc = "The rugged STS-35 is a durable automatic weapon of a make popular on the frontier worlds. Originally produced by Hephaestus. The serial number has been scratched off."
	icon = 'icons/obj/guns/assault_rifle.dmi'
	icon_state = "arifle"
	item_state = null
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = CALIBER_RIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 5)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle
	allowed_magazines = /obj/item/ammo_magazine/rifle
	one_hand_penalty = 8
	recoil_buildup = 2.4
	accuracy = 2
	bulk = GUN_BULK_RIFLE + 1
	wielded_item_state = "arifle-wielded"
	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'

	//Assault rifle, burst fire degrades quicker than SMG, worse one-handing penalty, slightly increased move delay
	init_firemodes = list(
			SEMI_AUTO_NODELAY,
			BURST_3_ROUND,
			FULL_AUTO_400
		)

/obj/item/gun/projectile/automatic/assault_rifle/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "arifle"
		wielded_item_state = "arifle-wielded"
	else
		icon_state = "arifle-empty"
		wielded_item_state = "arifle-wielded-empty"

/obj/item/gun/projectile/automatic/sec_smg
	name = "submachine gun"
	desc = "The WT-550 Saber is a cheap self-defense weapon, mass-produced by Ward-Takahashi for paramilitary and private use."
	icon = 'icons/obj/guns/sec_smg.dmi'
	icon_state = "smg"
	item_state = "wt550"
	safety_icon = "safety"
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_PISTOL_SMALL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/pistol/small
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/smg_top/rubber
	allowed_magazines = /obj/item/ammo_magazine/smg_top
	one_hand_penalty = 3

	//machine pistol, like SMG but easier to one-hand with
	init_firemodes = list(
			SEMI_AUTO_NODELAY,
			BURST_3_ROUND,
			FULL_AUTO_600
		)

/obj/item/gun/projectile/automatic/sec_smg/on_update_icon()
	..()
	if(ammo_magazine)
		overlays += image(icon, "mag-[round(ammo_magazine.stored_ammo.len,5)]")
	if(ammo_magazine && LAZYLEN(ammo_magazine.stored_ammo))
		overlays += image(icon, "ammo-ok")
	else
		overlays += image(icon, "ammo-bad")

/obj/item/gun/projectile/automatic/bullpup_rifle
	name = "bullpup assault rifle"
	desc = "The Hephaestus Industries Z8 Bulldog is an older model bullpup carbine. Makes you feel like a space marine when you hold it."
	icon = 'icons/obj/guns/bullpup_rifle.dmi'
	icon_state = "carbine"
	item_state = "z8carbine"
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	ammo_type = /obj/item/ammo_casing/rifle/military
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mil_rifle
	allowed_magazines = /obj/item/ammo_magazine/mil_rifle
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	accuracy = 2
	one_hand_penalty = 8
	recoil_buildup = 1
	bulk = GUN_BULK_RIFLE
	wielded_item_state = "z8carbine-wielded"
	mag_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	init_firemodes = list(
		list(mode_name = "semiauto",  mode_desc = "Fire as fast as you can pull the trigger", use_launcher=0, burst=1, fire_delay=0, move_delay=null),
		list(mode_name = "full auto",  mode_desc = "400 rounds per minute", use_launcher=0, mode_type = /datum/firemode/automatic, fire_delay = 4, one_hand_penalty=3),
		list(mode_name = "fire grenades",  burst=null, fire_delay=null, move_delay=null, use_launcher=1,    one_hand_penalty=10)
		)

	var/use_launcher = 0
	var/obj/item/gun/launcher/grenade/underslung/launcher

/obj/item/gun/projectile/automatic/bullpup_rifle/Initialize()
	. = ..()
	launcher = new(src)

/obj/item/gun/projectile/automatic/bullpup_rifle/refresh_upgrades()
	use_launcher = initial(use_launcher)
	. = ..()

/obj/item/gun/projectile/automatic/bullpup_rifle/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/gun/projectile/automatic/bullpup_rifle/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/gun/projectile/automatic/bullpup_rifle/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/gun/projectile/automatic/bullpup_rifle/on_update_icon()
	..()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "carbine-loaded"
		else
			icon_state = "carbine-empty"
	else
		icon_state = "carbine"

/obj/item/gun/projectile/automatic/bullpup_rifle/examine(mob/user)
	. = ..()
	if(launcher.chambered)
		to_chat(user, "\The [launcher] has \a [launcher.chambered] loaded.")
	else
		to_chat(user, "\The [launcher] is empty.")

/obj/item/gun/projectile/automatic/l6_saw
	name = "light machine gun"
	desc = "A rather traditionally made L6 SAW with a pleasantly lacquered wooden pistol grip. Has 'Aussec Armoury- 2281' engraved on the reciever." //probably should refluff this
	icon = 'icons/obj/guns/saw.dmi'
	icon_state = "l6closed50"
	item_state = "l6closedmag"
	w_class = ITEM_SIZE_HUGE
	bulk = 10
	force = 10
	slot_flags = 0
	max_shells = 50
	caliber = CALIBER_RIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 2)
	slot_flags = 0 //need sprites for SLOT_BACK
	ammo_type = /obj/item/ammo_casing/rifle
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/box/machinegun
	allowed_magazines = list(/obj/item/ammo_magazine/box/machinegun, /obj/item/ammo_magazine/rifle)
	one_hand_penalty = 10
	recoil_buildup = 3
	wielded_item_state = "gun_wielded"
	mag_insert_sound = 'sound/weapons/guns/interaction/lmg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/lmg_magout.ogg'
	can_special_reload = FALSE

	//LMG, better sustained fire accuracy than assault rifles (comparable to SMG), higer move delay and one-handing penalty
	//No single-shot or 3-round-burst modes since using this weapon should come at a cost to flexibility.
	init_firemodes = list(
			BURST_5_ROUND,
			BURST_8_ROUND,
			FULL_AUTO_600
		)

	var/cover_open = 0

/obj/item/gun/projectile/automatic/l6_saw/mag
	magazine_type = /obj/item/ammo_magazine/rifle

/obj/item/gun/projectile/automatic/l6_saw/special_check(mob/user)
	if(cover_open)
		to_chat(user, "<span class='warning'>[src]'s cover is open! Close it before firing!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/automatic/l6_saw/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	to_chat(user, "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>")
	update_icon()

/obj/item/gun/projectile/automatic/l6_saw/attack_self(mob/user as mob)
	if(cover_open)
		toggle_cover(user) //close the cover
	else
		return ..() //once closed, behave like normal

/obj/item/gun/projectile/automatic/l6_saw/attack_hand(mob/user as mob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
	else
		return ..() //once open, behave like normal

/obj/item/gun/projectile/automatic/l6_saw/on_update_icon()
	..()
	if(istype(ammo_magazine, /obj/item/ammo_magazine/box))
		icon_state = "l6[cover_open ? "open" : "closed"][min(round(ammo_magazine.stored_ammo.len, 10), 50)]"
		item_state = "l6[cover_open ? "open" : "closed"]"
	else if(ammo_magazine)
		icon_state = "l6[cover_open ? "open" : "closed"]mag"
		item_state = "l6[cover_open ? "open" : "closed"]mag"
	else
		icon_state = "l6[cover_open ? "open" : "closed"]-empty"
		item_state = "l6[cover_open ? "open" : "closed"]-empty"

/obj/item/gun/projectile/automatic/l6_saw/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		to_chat(user, "<span class='warning'>You need to open the cover to load that into [src].</span>")
		return
	..()

/obj/item/gun/projectile/automatic/l6_saw/unload_ammo(mob/user, var/allow_dump=1)
	if(!cover_open)
		to_chat(user, "<span class='warning'>You need to open the cover to unload [src].</span>")
		return
	..()

/obj/item/gun/projectile/automatic/battlerifle
	name = "battle rifle"
	desc = "The battle rifle hasn't changed much since its inception in the mid 20th century. Built to last in the toughest conditions, you can't tell if this one was even made this century."
	icon = 'icons/obj/guns/battlerifle.dmi'
	icon_state = "battlerifle"
	item_state = null
	w_class = ITEM_SIZE_HUGE
	force = 12
	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 1, TECH_ESOTERIC = 5)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mil_rifle
	allowed_magazines = /obj/item/ammo_magazine/mil_rifle
	one_hand_penalty = 10
	accuracy = 1
	bulk = GUN_BULK_RIFLE + 1
	wielded_item_state = "battlerifle-wielded"
	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'

	//Battle Rifle is only accurate in semi-automatic fire.
	init_firemodes = list(
			SEMI_AUTO_NODELAY,
			FULL_AUTO_400
		)

/obj/item/gun/projectile/automatic/battlerifle/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "battlerifle"
		wielded_item_state = "battlerifle-wielded"
	else
		icon_state = "battlerifle-empty"
		wielded_item_state = "battlerifle-wielded-empty"
