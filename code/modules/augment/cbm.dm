#define CBM_STEP_CUT_OPEN "cut open"
#define CBM_STEP_FRACTURE "fracture"
#define CBM_STEP_INSTALL_AUGMENT "install augment"
#define CBM_STEP_SEAL "seal"

/obj/item/device/compact_bionic_module
	name = "compact bionic module"
	desc = "An oblong box with an irregular shape and a seam running down the center."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "compact_bionic_module"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_DATA = 3, TECH_ESOTERIC = 3)
	var/obj/item/organ/internal/augment/loaded_augment
	var/augment_type
	var/working
	/// If not false, then installation will be instant and cause no damage; useful for admins or debugging
	var/cbm_debug = FALSE

/obj/item/device/compact_bionic_module/Initialize()
	. = ..()
	if (!isnull(augment_type))
		loaded_augment = new augment_type(src)

/obj/item/device/compact_bionic_module/examine(mob/user)
	. = ..()
	if (isobserver(user) || (user.mind && user.mind.special_role != null) || user.skill_check(SKILL_DEVICES, SKILL_PROF))
		to_chat(user, "This is a compact bionic module - an illicit, one-use augment installer. It can be used even by individuals with no medical knowledge.")
		to_chat(user, SPAN_DANGER("This device does NOT come with its own painkillers or anesthetic. Installing without painkillers is theoretically possible, but dangerous and very traumatic."))
	// Label is keyed based on "is it safe from detection?"
	// Two Y's means it's fully hidden
	// One N means that either it can be scanned or that it can be discovered via limb inspection
	// Two N's means that it can be scanned as well as discovered through limb inspection
	if (!isnull(loaded_augment))
		to_chat(user, "A machine-printed label on the side reads \
		'[SPAN_NOTICE(uppertext(loaded_augment.name))] - [loaded_augment.known ? "N" : "Y"][loaded_augment.discoverable ? "N" : "Y"]'.")
	else
		to_chat(user, "It seems to be empty.")
	if (isadmin(user) && !user.is_stealthed())
		to_chat(user, SPAN_NOTICE("<b>ADMIN NOTICE:</b> If you'd like to make installation instant, varedit the <b>cbm_debug</b> variable to anything but 0."))

/obj/item/device/compact_bionic_module/attackby(obj/item/W, mob/living/user)
	if (isScrewdriver(W) && loaded_augment)
		return loaded_augment.attackby(W, user)
	else if (isCrowbar(W) && loaded_augment)
		user.visible_message(
			SPAN_WARNING("\The [user] starts prying out \the [loaded_augment] from \the [src]!"),
			SPAN_WARNING("You start prying out \the [loaded_augment] from \the [src]..."),
			SPAN_WARNING("You hear metal creaking.")
		)
		playsound(user, 'sound/items/Crowbar.ogg', 50, TRUE)
		if (!do_after(user, 10 SECONDS, src) || !loaded_augment)
			return
		user.visible_message(
			SPAN_WARNING("\The [user] levers \the [loaded_augment] out of \the [src]."),
			SPAN_WARNING("You permanently remove \the [src]'s [loaded_augment.name]."),
			SPAN_WARNING("You hear a clunk.")
		)
		playsound(user, 'sound/items/Deconstruct.ogg', 50, TRUE)
		loaded_augment.forceMove(get_turf(user))
		loaded_augment = null
	..()

/obj/item/device/compact_bionic_module/attack_self(mob/living/user)
	. = ..()
	if (working)
		return
	if (!loaded_augment)
		to_chat(user, SPAN_WARNING("\The [src] has no augment, or has been used up."))
		return
	if (!ishuman(user))
		to_chat(user, SPAN_WARNING("\The [src] detects an incompatible physiology and refuses to activate."))
		return
	if (!user.buckled && !user.lying && !cbm_debug)
		to_chat(user, SPAN_WARNING("You must be buckled or lying to use the CBM."))
		return
	else
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affected = H.get_organ(loaded_augment.parent_organ)
		var/beep_boop = BP_IS_ROBOTIC(affected)
		if (!affected)
			to_chat (user, SPAN_WARNING("\The [src] detects no valid operation spot."))
			return
		else if(beep_boop && !(loaded_augment.augment_flags != AUGMENTATION_MECHANIC))
			to_chat(user, SPAN_WARNING("The [loaded_augment.name] cannot function within a mechanical part."))
			return
		else if (!beep_boop && !(loaded_augment.augment_flags & AUGMENTATION_ORGANIC))
			to_chat(user, SPAN_WARNING("The [loaded_augment.name] cannot function within an organic part."))
			return
		else if (affected.get_damage() >= affected.max_damage * 0.25 && !cbm_debug)
			to_chat(user, SPAN_WARNING("Your [affected.name] is too damaged to safely use a CBM on."))
			return
		else
			var/obj/item/organ/internal/I = H.internal_organs_by_name[loaded_augment.organ_tag]
			if(I && (I.parent_organ == loaded_augment.parent_organ))
				to_chat(H, SPAN_WARNING("You can only have one [loaded_augment.organ_tag]."))
				return
			operate(user, affected)

/obj/item/device/compact_bionic_module/proc/operate(mob/living/carbon/human/user, obj/item/organ/external/affected)
	if (!cbm_debug)
		working = TRUE
		to_chat(user, SPAN_WARNING("\icon[src] Commencing operation. Please remain still."))
		user.visible_message(
			SPAN_WARNING("\The [user] places \the [src] against \his [affected.name]..."),
			SPAN_DANGER("You push \the [src] against your [affected.name] and activate it...")
		)
		if (!do_after(user, 2 SECONDS))
			working = FALSE
			return
		var/robot_part = BP_IS_ROBOTIC(affected)
		if (!robot_part)
			user.visible_message(
				SPAN_DANGER("\The [src] whirrs and begins slicing open \the [user]'s [affected.name]!"),
				SPAN_DANGER("\The [src] viciously cuts open your [affected.name] and starts operating on it!")
			)
			user.custom_pain("Your [affected.name] feels like it's being torn apart!", 160) // Massive pain because of the trauma of installation
		else
			user.visible_message(
				SPAN_DANGER("\The [src] whirrs and begins operating on \the [user]'s [affected.name]!"),
				SPAN_DANGER("\The [src] pries open your [affected.name] and starts rooting through its components.")
			)
			playsound(user, 'sound/items/electronic_assembly_emptying.ogg', 50, TRUE)
		affected.createwound(CUT, affected.min_broken_damage / 2, 1)
		affected.clamp_organ()
		affected.open_incision()
		affected.fracture()
		if (!do_after(user, 8 SECONDS))
			working = FALSE
			to_chat(user, SPAN_WARNING("\The [src] falls away from your [affected.name], leaving behind a mangled mess."))
			return
		user.visible_message(
			SPAN_WARNING("\The [src] inserts something into \the [user]'s [affected.name]!"),
			SPAN_WARNING("\The [src] starts installing \the [loaded_augment] into your [affected.name]!")
		)
		if (!robot_part)
			user.custom_pain("You feel something moving around inside your [affected.name]!", 160)
			playsound(user, 'sound/effects/squelch1.ogg', 25, TRUE)
		else
			playsound(user, 'sound/items/jaws_pry.ogg', 50, TRUE)
		if (!do_after(user, 8 SECONDS))
			working = FALSE
			to_chat(user, SPAN_WARNING("\The [src] falls away from your [affected.name], leaving behind a mangled mess."))
			return
	loaded_augment.forceMove(user)
	loaded_augment.replaced(user, affected)
	loaded_augment = null
	if (!cbm_debug)
		to_chat(user, SPAN_WARNING("\The [src] seals up your [affected.name] and powers down."))
		affected.status &= ~ORGAN_BROKEN
		affected.stage = 0
		affected.update_wounds()
		var/datum/wound/W = affected.get_incision()
		if(istype(W))
			W.close()
		if(affected.clamped())
			affected.remove_clamps()
		affected.update_wounds()
	to_chat(user, SPAN_WARNING("\icon[src] Operation complete."))
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	working = FALSE



/obj/item/device/compact_bionic_module/iatric_monitor
	augment_type = /obj/item/organ/internal/augment/active/iatric_monitor/hidden

/obj/item/device/compact_bionic_module/wrist_blade
	augment_type = /obj/item/organ/internal/augment/active/simple/wrist_blade

/obj/item/device/compact_bionic_module/popout_shotgun
	augment_type = /obj/item/organ/internal/augment/active/simple/popout_shotgun

/obj/item/device/compact_bionic_module/nerve_dampeners
	augment_type = /obj/item/organ/internal/augment/active/nerve_dampeners

/obj/item/device/compact_bionic_module/internal_air_system
	augment_type = /obj/item/organ/internal/augment/active/internal_air_system/hidden

/obj/item/device/compact_bionic_module/adaptive_binoculars
	augment_type = /obj/item/organ/internal/augment/active/simple/equip/adaptive_binoculars/hidden

/obj/item/device/compact_bionic_module/engineering_toolset
	augment_type = /obj/item/organ/internal/augment/active/polytool/engineer

#undef CBM_STEP_CUT_OPEN
#undef CBM_STEP_FRACTURE
#undef CBM_STEP_INSTALL_AUGMENT
#undef CBM_STEP_SEAL
