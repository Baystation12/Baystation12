/obj/item/gun/projectile/revolving
	abstract_type = /obj/item/gun/projectile/revolving
	name = "master revolver object"
	desc = "You should not see this."

	mag_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

	var/misaligned = FALSE
	var/misaligned_penalty = 2

	handle_casings = CYCLE_CASINGS
	allow_dump = TRUE
	hold_open = FALSE

	fire_delay = 12 // Revolvers are naturally slower-firing.


/obj/item/gun/projectile/revolving/AltClick()
	if(CanPhysicallyInteract(usr))
		spin_cylinder()
		return TRUE
	return ..()


/obj/item/gun/projectile/revolving/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull. Or to try fix a misaligned chamber."
	set category = "Object"

	chamber_offset = 0
	visible_message(
		SPAN_WARNING("\The [usr] spins the cylinder of \the [src]!"),
		SPAN_NOTICE("You hear something metallic spin and click.")
	)
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > length(loaded))
		chamber_offset = rand(0,max_shells - length(loaded))


/obj/item/gun/projectile/revolving/consume_next_projectile()
	if (chamber_offset)
		chamber_offset--
		return
	if (prob(jam_chance))
		misaligned = TRUE // Timing malfunction.
		accuracy -= misaligned_penalty

	. = ..()


/obj/item/gun/projectile/revolving/load_ammo(obj/item/ammo, mob/user)
	chamber_offset = 0
	return ..()


/obj/item/gun/projectile/revolving/handle_post_fire()
	if (misaligned)
		playsound(loc, 'sound/weapons/guns/ricochet1.ogg', 10, TRUE)
		accuracy += misaligned_penalty // Return to normal accuracy after the shot has already gone wide.
		misaligned = FALSE
	. = ..()


/obj/item/gun/projectile/revolving/heavy
	name = "double-action revolver"
	desc = "The al-Maliki & Mosley Magnum Double Action is a choice revolver for when you absolutely, \
			positively need to put a hole in the other guy. You feelin' lucky punk?"

	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = "revolver"
	item_state = "revolver"

	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'

	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	caliber = CALIBER_PISTOL_MAGNUM
	bulk = GUN_BULK_LIGHT_RIFLE - 1

	ammo_type = /obj/item/ammo_casing/pistol/magnum
	max_shells = 6
	accuracy = 2
	accuracy_power = 8
	one_hand_penalty = 2


/obj/item/gun/projectile/revolving/medium
	name = "revolver"
	desc = "The Lumoco Arms' 'Solid' is a rugged revolver for people who don't keep their guns well-maintained."

	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = "medium"
	safety_icon = "medium_safety"

	caliber = CALIBER_PISTOL

	ammo_type = /obj/item/ammo_casing/pistol
	accuracy = 1
	fire_delay = 9

/obj/item/gun/projectile/revolving/holdout
	name = "holdout revolver"
	desc = "The al-Maliki & Mosley 'Partner' is a concealed-carry revolver made for people who do not trust \
			automatic pistols any more than the people they're dealing with."

	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = "holdout"
	item_state = "pistol"

	caliber = CALIBER_PISTOL_SMALL
	w_class = ITEM_SIZE_SMALL

	ammo_type = /obj/item/ammo_casing/pistol/small
	accuracy = 1
	one_hand_penalty = 0
	fire_delay = 7


/obj/item/gun/projectile/revolving/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."

	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = "revolver-toy"

	fire_sound = 'sound/weapons/gunshot/gunshot.ogg'

	var/snipped = FALSE

	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	caliber = CALIBER_CAPS

	ammo_type = /obj/item/ammo_casing/cap


/obj/item/gun/projectile/revolving/capgun/on_update_icon()
	if (snipped)
		icon_state = "revolver"
	else
		icon_state = "revolver-toy"
	..()


/obj/item/gun/projectile/revolving/capgun/proc/set_snipped(new_snipped = TRUE)
	snipped = new_snipped
	if (new_snipped)
		SetName("revolver")
		desc += " Someone snipped off the barrel's toy mark. How dastardly, this could get someone shot."
	else
		SetName(initial(name))
		desc = initial(desc)
	update_icon()


/obj/item/gun/projectile/revolving/capgun/use_tool(obj/item/tool, mob/user, list/click_params)
	// Wirecutters - Remove toy marking.
	if (isWirecutter(tool))
		if (snipped)
			USE_FEEDBACK_FAILURE("\The [src] has already had it's barrel snipped.")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] snips \a [src]'s toy markings with \a [tool]."),
			SPAN_NOTICE("You snip \the [src]'s toy markings with \the [tool]."),
			range = 3
		)
		set_snipped()
		return TRUE

	return ..()


/obj/item/gun/projectile/revolving/minigun
	name = "minigun"
	desc = "A man-portable minigun lacking any branding on it. It fires small 7mm projectiles at an obscene rate of fire. \
			Six barrels of fun."

	icon = 'icons/obj/guns/minigun.dmi'
	icon_state = "minigun"
	item_state = "l6closedmag" // Onmob is WIP sprite.

	mag_insert_sound = 'sound/weapons/guns/interaction/lmg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/lmg_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/minigun.ogg'

	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 4, TECH_ESOTERIC = 8)
	w_class = ITEM_SIZE_HUGE
	caliber = CALIBER_PISTOL_SMALL
	can_special_reload = FALSE
	load_method = MAGAZINE
	multi_aim = TRUE
	slot_flags = 0

	magazine_type = /obj/item/ammo_magazine/box/minigun
	allowed_magazines = list(/obj/item/ammo_magazine/box/minigun)
	accuracy = 1
	one_hand_penalty = 20
	force = 15

	firemodes = list(
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=0.4, move_delay=1, burst_accuracy = list(0,-1,-2,-3,-4,-4,-4,-4,-4), dispersion = list(1.0, 1.0, 2.0, 2.0, 2.5), burst_delay = 1),
		list(mode_name="long bursts",	can_autofire=0, burst=10, fire_delay=0.2, burst_accuracy = list(0,-1,-2,-3,-4,-8,-8,-16,-16), dispersion = list(1.0, 2.0, 3.0, 3.0, 4.0), burst_delay = 1)
		)


/obj/item/gun/projectile/revolving/minigun/handle_post_fire() // Miniguns get special handling as essentially automatic revolvers.
	..()

	var/obj/item/ammo_casing/end_cartridge = null

	if (ammo_magazine && length(ammo_magazine.stored_ammo))
		end_cartridge = ammo_magazine.stored_ammo[length(ammo_magazine.stored_ammo)]
	if (end_cartridge)
		if(end_cartridge.BB)
			end_cartridge.expend()
		end_cartridge.dropInto(get_turf(loc))
		end_cartridge.throw_at(get_ranged_target_turf(get_turf(src),turn(loc.dir,270),1), rand(0,1), 5)
		if (length(end_cartridge.fall_sounds))
			playsound(loc, pick(end_cartridge.fall_sounds), 50, 1)
		ammo_magazine.stored_ammo -= end_cartridge

	end_cartridge = null


/obj/item/gun/projectile/revolving/minigun/mounted
	name = "mounted minigun"

	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	has_safety = FALSE
	auto_eject = TRUE

	accuracy = 0 // Less accurate than a full-sized minigun and only fires in bursts, but has no one-hand penalty.
	one_hand_penalty = 0

	firemodes = list(
		list(mode_name="long bursts",			can_autofire=0, burst=5, fire_delay=0.2, burst_accuracy = list(0,-1,-2,-3,-4,-4,-4,-4,-4), dispersion = list(1.0, 1.0, 2.0, 2.0, 2.5), burst_delay = 1),
		list(mode_name="longer bursts",		can_autofire=0, burst=10, fire_delay=0.2, burst_accuracy = list(0,-1,-2,-3,-4,-8,-8,-16,-16), dispersion = list(1.0, 2.0, 3.0, 3.0, 4.0), burst_delay = 1)
		)


/obj/item/gun/projectile/automatic/minigun/mounted/load_ammo(obj/item/ammo, mob/user)
	var/obj/item/rig/rig = get_rig()
	if (!istype(rig))
		USE_FEEDBACK_FAILURE("ERROR: Could not find a rig to reload \the [src]. This is a bug. Report it.")
		crash_with("\A [src] ([type]) tried to load ammo but couldn't find a rig.")
		return TRUE
	if (rig.offline)
		USE_FEEDBACK_FAILURE("\The [rig] needs to be online before you can reload \the [src].")
		return TRUE
	if (!rig.suit_is_deployed())
		USE_FEEDBACK_FAILURE("\The [rig] needs to be deployed before you can reload \the [src].")
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] begins the slow process of re-arming \the [rig]'s [name] with \a [ammo]."),
		SPAN_NOTICE("You begin the slow process of re-arming \the [rig]'s [name] with \the [ammo].")
	)
	if (!do_after(user, 10 SECONDS, src, DO_PUBLIC_UNIQUE | DO_BAR_OVER_USER) || !user.use_sanity_check(src, ammo))
		return TRUE
	return ..()


/obj/item/gun/projectile/automatic/minigun/mounted/unload_ammo(mob/user, allow_dump = FALSE)
	var/obj/item/rig/rig = get_rig()
	if (!istype(rig))
		USE_FEEDBACK_FAILURE("ERROR: Could not find a rig to unload \the [src]. This is a bug. Report it.")
		crash_with("\A [src] ([type]) tried to unload ammo but couldn't find a rig.")
		return TRUE
	if (rig.offline)
		USE_FEEDBACK_FAILURE("\The [rig] needs to be online before you can unload \the [src].")
		return TRUE
	if (!rig.suit_is_deployed())
		USE_FEEDBACK_FAILURE("\The [rig] needs to be deployed before you can unload \the [src].")
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] starts ejecting \the [rig]'s [name]'s magazine."),
		SPAN_NOTICE("You start ejecting \the [rig]'s [name]'s magazine.")
	)
	if (!do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE | DO_BAR_OVER_USER) || !user.use_sanity_check(src))
		return
	..()
