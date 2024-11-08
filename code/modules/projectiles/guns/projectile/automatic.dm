/obj/item/gun/projectile/automatic
	abstract_type = /obj/item/gun/projectile/automatic
	name = "master automatics object"
	desc = "You should not see this."

	racksound = 'sound/weapons/guns/interaction/rifle_rack.ogg'

	w_class = ITEM_SIZE_HUGE
	load_method = MAGAZINE|SINGLE_CASING
	slot_flags = SLOT_BACK
	multi_aim = TRUE

	force = 10
	burst_delay = 2
	max_shells = 1


/obj/item/gun/projectile/automatic/assault_rifle
	name = "assault rifle"
	desc = "The rugged STS-35 is a durable automatic weapon of a make popular in independent hands. \
			Its original design harkens back to the Terran Commonwealth's armed forces, and their service weaponry. \
			Eventually co-opted by various weapon manufacturers. This one is of Hephaestus Industries make."

	icon = 'icons/obj/guns/assault_rifle.dmi'
	icon_state = "arifle"
	item_state = null
	wielded_item_state = "arifle-wielded"
	wielded_item_state = "arifle-wielded"

	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'

	caliber = CALIBER_RIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 5)
	bulk = GUN_BULK_HEAVY_RIFLE

	magazine_type = /obj/item/ammo_magazine/rifle
	allowed_magazines = list(/obj/item/ammo_magazine/rifle)
	one_hand_penalty = 8
	accuracy_power = 7
	accuracy = 2


	//Assault rifle, burst fire degrades quicker than SMG, worse one-handing penalty, slightly increased move delay
	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=8, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    one_hand_penalty=9, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=6,    one_hand_penalty=11, burst_accuracy=list(0,-1,-2,-3,-3), dispersion=list(0.6, 1.0, 1.2, 1.2, 1.5)),
		)


/obj/item/gun/projectile/automatic/assault_rifle/on_update_icon()
	if (ammo_magazine)
		icon_state = "arifle"
		wielded_item_state = "arifle-wielded"
	else
		icon_state = "arifle-empty"
		wielded_item_state = "arifle-wielded-empty"
	..()


/obj/item/gun/projectile/automatic/bullpup_rifle
	name = "bullpup assault rifle"
	desc = "A Hephaestus Industries Z8 'Bulldog' is one of the oldest weapons currently in service with the SCGDF. \
			Despite its age, it still remains the de-facto rifle of the SCG Army, due to its ease of handling, cheap production costs, \
			reliability, and plentiful surplus stock."

	icon = 'icons/obj/guns/bullpup_rifle.dmi'
	icon_state = "carbine"
	item_state = "z8carbine"
	wielded_item_state = "z8carbine-wielded"

	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	mag_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'

	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	bulk = GUN_BULK_RIFLE
	auto_eject = TRUE

	magazine_type = /obj/item/ammo_magazine/mil_rifle/heavy
	allowed_magazines = list(/obj/item/ammo_magazine/mil_rifle) //Interchangable but poor performance
	accuracy = 2
	accuracy_power = 7
	one_hand_penalty = 8
	burst_delay = 4

	firemodes = list(
		list(mode_name="semi auto",       burst=1,    fire_delay=null,    move_delay=null, use_launcher=null, one_hand_penalty=8, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, move_delay=6,    use_launcher=null, one_hand_penalty=9, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="fire grenades",  burst=null, fire_delay=null, move_delay=null, use_launcher=1,    one_hand_penalty=10, burst_accuracy=null, dispersion=null)
		)

	var/use_launcher = FALSE

	///Determines if bullpup spawns with launcher, used in Initialize()
	var/has_launcher = TRUE
	var/obj/item/gun/launcher/grenade/underslung/launcher


/obj/item/gun/projectile/automatic/bullpup_rifle/Initialize()
	. = ..()
	if (has_launcher)
		launcher = new(src)


/obj/item/gun/projectile/automatic/bullpup_rifle/use_tool(obj/item/tool, mob/user, list/click_params)
	// Grenade - Load launcher
	if (istype(tool, /obj/item/grenade) && launcher)
		launcher.load(tool, user)
		return TRUE

	return ..()


/obj/item/gun/projectile/automatic/bullpup_rifle/toggle_safety(mob/user)
	..()
	if(launcher)
		launcher.safety_state = safety_state //Set the launcher's safety to be equivalent to the bullpup's.


/obj/item/gun/projectile/automatic/bullpup_rifle/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && launcher && use_launcher)
		launcher.unload(user)
	else
		..()


/obj/item/gun/projectile/automatic/bullpup_rifle/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(launcher && use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			handle_click_empty()
	else
		..()


/obj/item/gun/projectile/automatic/bullpup_rifle/on_update_icon()
	..()
	if(ammo_magazine)
		if(length(ammo_magazine.stored_ammo))
			icon_state = "carbine-loaded"
		else
			icon_state = "carbine-empty"
	else
		icon_state = "carbine"


/obj/item/gun/projectile/automatic/bullpup_rifle/examine(mob/user)
	. = ..()
	if(!launcher)
		return
	if(launcher.chambered)
		to_chat(user, "\The [launcher] has \a [launcher.chambered] loaded.")
	else
		to_chat(user, "\The [launcher] is empty.")


/obj/item/gun/projectile/automatic/bullpup_rifle/light
	name = "light bullpup assault rifle"
	desc = "A standard-issue rifle of the SCGF. The Z9 'Pitbull' is the modern answer to violence's question. \
			It has been given a blued finish with a Sol yellow stripe for easy identification of its owner. \
			It's slightly more accurate than its larger cousin, the Z8."

	icon = 'icons/obj/guns/bullpup_rifle_light.dmi'
	item_state = "z9carbine"
	wielded_item_state = "z9carbine-wielded"

	bulk = GUN_BULK_LIGHT_RIFLE
	has_launcher = FALSE

	magazine_type = /obj/item/ammo_magazine/mil_rifle/light
	one_hand_penalty = 6 // Slightly lighter than the Z8. Still don't try it.

	//Two round bursts. More accurate than the Z8 due to less maximum dispersion. More delay between shots, however, so slower.
	firemodes = list(
		list(mode_name="semi auto",       burst=1,    fire_delay=null,    move_delay=null, use_launcher=null, one_hand_penalty=6, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2,    fire_delay=null, move_delay=6,    use_launcher=null, one_hand_penalty=7, burst_accuracy=list(0,-1), dispersion=list(0.0, 0.6))
		)


/obj/item/gun/projectile/automatic/l6_saw
	name = "light machine gun"
	desc = "An L-6 squad automatic weapon, traditional in make with a pleasantly lacquered pistol grip. \
			Made by 'Aussec Armoury - 2281'."

	icon = 'icons/obj/guns/saw.dmi'
	icon_state = "l6closed50"
	item_state = "l6closedmag"
	wielded_item_state = "l6closed-wielded"

	mag_insert_sound = 'sound/weapons/guns/interaction/lmg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/lmg_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'

	var/cover_open = FALSE

	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 2)
	caliber = CALIBER_RIFLE
	bulk = GUN_BULK_HEAVY_RIFLE + 4
	can_special_reload = FALSE
	fire_closed_bolt = FALSE
	hold_open = FALSE

	magazine_type = /obj/item/ammo_magazine/box/machinegun
	allowed_magazines = list(
		/obj/item/ammo_magazine/box/machinegun,
		/obj/item/ammo_magazine/rifle
		)
	ammo_type = /obj/item/ammo_casing/rifle
	max_shells = 50
	slot_flags = 0 //need sprites for SLOT_BACK
	one_hand_penalty = 10

	//LMG, better sustained fire accuracy than assault rifles (comparable to SMG), higer move delay and one-handing penalty
	//No single-shot or 3-round-burst modes since using this weapon should come at a cost to flexibility.
	firemodes = list(
		list(mode_name="short bursts",	can_autofire=0, burst=5, fire_delay=5, move_delay=12, one_hand_penalty=8, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	can_autofire=0, burst=8, fire_delay=5, one_hand_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=1, one_hand_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)


/obj/item/gun/projectile/automatic/l6_saw/mag
	magazine_type = /obj/item/ammo_magazine/rifle


/obj/item/gun/projectile/automatic/l6_saw/special_check(mob/user)
	if(cover_open)
		to_chat(user, SPAN_WARNING("[src]'s cover is open! Close it before firing!"))
		return FALSE
	return ..()


/obj/item/gun/projectile/automatic/l6_saw/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	to_chat(user, SPAN_NOTICE("You [cover_open ? "open" : "close"] [src]'s cover."))
	update_icon()
	user.update_inv_l_hand()
	user.update_inv_r_hand()


/obj/item/gun/projectile/automatic/l6_saw/attack_self(mob/user as mob)
	if(cover_open)
		toggle_cover(user) //close the cover
		update_icon()
		user.update_inv_l_hand()
		user.update_inv_r_hand()

	else
		return ..() //once closed, behave like normal


/obj/item/gun/projectile/automatic/l6_saw/attack_hand(mob/user as mob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
		update_icon()
		user.update_inv_l_hand()
		user.update_inv_r_hand()

	else
		return ..() //once open, behave like normal


/obj/item/gun/projectile/automatic/l6_saw/on_update_icon()
	..()
	if(istype(ammo_magazine, /obj/item/ammo_magazine/box))
		icon_state = "l6[cover_open ? "open" : "closed"][round(length(ammo_magazine.stored_ammo), 10)]"
		item_state = "l6[cover_open ? "open" : "closed"]"
		wielded_item_state = "l6[cover_open ? "open" : "closed"]-wielded"
	else if(ammo_magazine)
		icon_state = "l6[cover_open ? "open" : "closed"]mag"
		item_state = "l6[cover_open ? "open" : "closed"]mag"
		wielded_item_state = "l6[cover_open ? "open" : "closed"]mag-wielded"
	else
		icon_state = "l6[cover_open ? "open" : "closed"]-empty"
		item_state = "l6[cover_open ? "open" : "closed"]-empty"
		wielded_item_state = "l6[cover_open ? "open" : "closed"]-empty-wielded"


/obj/item/gun/projectile/automatic/l6_saw/load_ammo(obj/item/ammo, mob/user)
	if (!cover_open)
		USE_FEEDBACK_FAILURE("\The [src]'s cover needs to be open before you can reload it.")
		return TRUE

	return ..()


/obj/item/gun/projectile/automatic/l6_saw/unload_ammo(mob/user, allow_dump = TRUE)
	if (!cover_open)
		USE_FEEDBACK_FAILURE("\The [src]'s cover needs to be open before you can unload it.")
		return

	..()


/obj/item/gun/projectile/automatic/battlerifle
	name = "battle rifle"
	desc = "The battle rifle hasn't changed much since its inception in the mid 20th century. \
			Built to last in the toughest conditions, the select fire rifle is well reguarded as a dependable weapon."

	icon = 'icons/obj/guns/battlerifle.dmi'
	icon_state = "battlerifle"
	item_state = "battlerifle"
	wielded_item_state = "battlerifle-wielded"

	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'

	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 1, TECH_ESOTERIC = 5)
	bulk = GUN_BULK_HEAVY_RIFLE
	caliber = CALIBER_RIFLE_MILITARY
	hold_open = FALSE

	magazine_type = /obj/item/ammo_magazine/mil_rifle/heavy
	allowed_magazines = list(/obj/item/ammo_magazine/mil_rifle)
	force = 12
	one_hand_penalty = 10
	accuracy_power = 9
	accuracy = 1

	// Battle Rifle is only accurate in semi-automatic fire.
	firemodes = list(
		list(mode_name="semi auto",		burst=1, fire_delay=null,	move_delay=null, one_hand_penalty=8, burst_accuracy=null, dispersion=null),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=1, one_hand_penalty=12, burst_accuracy = list(0,-1,-2,-3,-4,-4,-4,-4,-4), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)


/obj/item/gun/projectile/automatic/battlerifle/on_update_icon()
	..()

	if(ammo_magazine)
		icon_state = "battlerifle"
	else
		icon_state = "battlerifle-magout"

	if (!chambered)
		AddOverlays("[initial(icon_state)]-empty")
	else
		CutOverlays("[initial(icon_state)]-empty")


/**
* SUB-MACHINEGUNS
**/

/obj/item/gun/projectile/automatic/smg
	abstract_type = /obj/item/gun/projectile/automatic/smg
	name = "master smg object"
	desc = "You should not see this."

	mag_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	racksound = 'sound/weapons/guns/interaction/pistol_rack.ogg'

	w_class = ITEM_SIZE_NORMAL
	bulk = GUN_BULK_LIGHT_RIFLE - 5
	slot_flags = SLOT_BELT

	burst_delay = 2
	accuracy = 1


/obj/item/gun/projectile/automatic/smg/prototype
	name = "prototype SMG"
	desc = "A prototype lightweight, fast firing submachine gun chambered in a small caliber."

	icon = 'icons/obj/guns/prototype_smg.dmi'
	icon_state = "prototype"
	item_state = "saber"

	fire_sound = 'sound/weapons/gunshot/gunshot_4mm.ogg'

	caliber = CALIBER_PISTOL_FLECHETTE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3)

	ammo_type = /obj/item/ammo_casing/flechette
	magazine_type = /obj/item/ammo_magazine/proto_smg
	allowed_magazines = list(/obj/item/ammo_magazine/proto_smg)

	//machine pistol, easier to one-hand with
	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="4-round bursts", burst=4, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,0,-1,-1),       dispersion=list(0.0, 0.0, 0.5, 0.6)),
		list(mode_name="long bursts",   burst=8, fire_delay=null, move_delay=4,    one_hand_penalty=2, burst_accuracy=list(0,0,-1,-1,-1,-1,-2,-2), dispersion=list(0.0, 0.0, 0.5, 0.6, 0.8, 1.0, 1.0, 1.2)),
		)


/obj/item/gun/projectile/automatic/smg/machine_pistol
	name = "machine pistol"
	desc = "The Hephaestus Industries MP6 'Vesper'. Coloquially referred to as an 'uzi' in backwater frontier locales."

	icon = 'icons/obj/guns/machine_pistol.dmi'
	icon_state = "mpistolen"
	item_state = "mpistolen"
	safety_icon = "safety"

	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

	caliber = CALIBER_PISTOL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ESOTERIC = 3)
	fire_closed_bolt = FALSE
	hold_open = FALSE

	ammo_type = /obj/item/ammo_casing/pistol
	magazine_type = /obj/item/ammo_magazine/machine_pistol
	allowed_magazines = list(/obj/item/ammo_magazine/machine_pistol) //more damage compared to the wt550, smaller mag size
	one_hand_penalty = 2

	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    one_hand_penalty=2, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)


/obj/item/gun/projectile/automatic/smg/machine_pistol/on_update_icon()
	..()
	if (bolt_open)
		icon_state = "mpistolen-empty"
	else
		icon_state = "mpistolen"
	if (ammo_magazine)
		AddOverlays(image(icon, "mag"))

	if (!ammo_magazine || !LAZYLEN(ammo_magazine.stored_ammo))
		AddOverlays(image(icon, "[initial(icon_state)]-ammo0"))
	else if (LAZYLEN(ammo_magazine.stored_ammo) <= 0.5 * ammo_magazine.max_ammo)
		AddOverlays(image(icon, "[initial(icon_state)]-ammo1"))
	else
		AddOverlays(image(icon, "[initial(icon_state)]-ammo2"))


/obj/item/gun/projectile/automatic/smg/security
	name = "submachine gun"
	desc = "The WT-550 'Saber' is a cheap self-defense weapon, mass-produced by Ward-Takahashi for paramilitary and private use."

	icon = 'icons/obj/guns/sec_smg.dmi'
	icon_state = "smg"
	item_state = "wt550"
	safety_icon = "safety"

	caliber = CALIBER_PISTOL_SMALL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)

	ammo_type = /obj/item/ammo_casing/pistol/small
	magazine_type = /obj/item/ammo_magazine/smg_top
	allowed_magazines = list(/obj/item/ammo_magazine/smg_top)
	accuracy_power = 7
	one_hand_penalty = 3

	//machine pistol, like SMG but easier to one-hand with
	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=3, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=4, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    one_hand_penalty=5, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)


/obj/item/gun/projectile/automatic/smg/security/on_update_icon()
	..()
	if(ammo_magazine)
		AddOverlays(image(icon, "mag-[round(length(ammo_magazine.stored_ammo),5)]"))
	if(ammo_magazine && LAZYLEN(ammo_magazine.stored_ammo))
		AddOverlays(image(icon, "ammo-ok"))
	else
		AddOverlays(image(icon, "ammo-bad"))


/obj/item/gun/projectile/automatic/smg/security/empty
	starts_loaded = FALSE


/obj/item/gun/projectile/automatic/smg/merc
	name = "submachine gun"
	desc = "The Novaya Zemlya Arms C-20r is a lightweight and rapid-firing SMG. In production since the 2280s, \
			the C-20r has proliferated across human space. Priorly used by the GCN before overhauls."

	icon = 'icons/obj/guns/merc_smg.dmi'
	icon_state = "c20r"
	item_state = "c20r"
	safety_icon = "safety"

	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ESOTERIC = 8)
	w_class = ITEM_SIZE_LARGE
	caliber = CALIBER_PISTOL
	slot_flags = SLOT_BELT|SLOT_BACK
	auto_eject = TRUE

	magazine_type = /obj/item/ammo_magazine/smg
	allowed_magazines = list(/obj/item/ammo_magazine/smg)
	one_hand_penalty = 4

	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=4, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=5, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    one_hand_penalty=6, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)


/obj/item/gun/projectile/automatic/smg/merc/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c20r-[round(length(ammo_magazine.stored_ammo),4)]"
	else
		icon_state = "c20r"
