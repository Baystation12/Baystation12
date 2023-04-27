/obj/structure/iv_stand
	name = "\improper IV drip"
	icon = 'icons/obj/iv_drip.dmi'
	icon_state = "unhooked"
	anchored = FALSE
	density = FALSE

	/// The IV stand is configured to remove reagents from the attached mob.
	var/const/MODE_EXTRACT = 0

	/// The IV stand is configured to add reagents to the attached mob.
	var/const/MODE_INJECT = 1

	/// One of the IV stand's MODE_* constants.
	var/drip_mode = MODE_INJECT

	/// The mob currently attached to this IV stand, if any.
	var/mob/living/carbon/human/patient

	/// The IV bag currently attached to this IV stand, if any.
	var/obj/item/reagent_containers/ivbag/iv_bag

	/// The color of the last reagent mix placed on the IV stand.
	var/last_reagent_color = "#ffffff"


/obj/structure/iv_stand/Destroy()
	patient = null
	QDEL_NULL(iv_bag)
	return ..()


/obj/structure/iv_stand/Initialize()
	. = ..()
	update_icon()


/obj/structure/iv_stand/on_update_icon()
	if (!patient)
		icon_state = "unhooked"
	else
		icon_state = "hooked"
	overlays.Cut()
	if (!iv_bag)
		return
	var/image/reagents_overlay = image(icon, icon_state = "reagent0")
	reagents_overlay.color = last_reagent_color
	var/image/light_overlay = image(icon, icon_state = "light_low")
	light_overlay.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	light_overlay.layer = ABOVE_LIGHTING_LAYER
	switch (Percent(iv_bag.reagents.total_volume, iv_bag.volume, 0))
		if (-INFINITY to 9)
			reagents_overlay.icon_state = "reagent0"
			light_overlay.icon_state = "light_low"
		if (10 to 24)
			reagents_overlay.icon_state = "reagent10"
			light_overlay.icon_state = "light_low"
		if (25 to 49)
			reagents_overlay.icon_state = "reagent25"
			light_overlay.icon_state = "light_mid"
		if (50 to 74)
			reagents_overlay.icon_state = "reagent50"
			light_overlay.icon_state = "light_mid"
		if (75 to 79)
			reagents_overlay.icon_state = "reagent75"
			light_overlay.icon_state = "light_full"
		if (80 to 90)
			reagents_overlay.icon_state = "reagent80"
			light_overlay.icon_state = "light_full"
		if (91 to INFINITY)
			reagents_overlay.icon_state = "reagent100"
			light_overlay.icon_state = "light_full"
	overlays += reagents_overlay
	overlays += light_overlay


/obj/structure/iv_stand/MouseDrop(atom/over_atom, source_loc, over_loc)
	if (!usr)
		return
	if (!over_atom)
		return
	if (!Adjacent(usr) || !over_atom.Adjacent(usr))
		return
	if (isliving(over_atom))
		MouseDrop_T(over_atom, usr)
	else
		over_atom.MouseDrop_T(src, usr)


/obj/structure/iv_stand/MouseDrop_T(atom/dropped, mob/living/user)
	if (src == dropped && user.canClick())
		user.ClickOn(src)
		return
	if (!CheckDexterity(user))
		to_chat(user, SPAN_WARNING("You're not dextrous enough to do that."))
		return
	if (user.incapacitated())
		to_chat(user, SPAN_WARNING("You're in no condition to do that."))
		return
	if (patient == dropped)
		RemoveDrip(user)
	else if (ishuman(dropped))
		AttachDrip(dropped, user)


/obj/structure/iv_stand/use_tool(obj/item/tool, mob/user, list/click_params)
	// IV Bag - Attach
	if (istype(tool, /obj/item/reagent_containers/ivbag))
		if (iv_bag)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [iv_bag] attached.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] attaches \a [tool] to \a [src]."),
			SPAN_NOTICE("You attach \the [tool] to \the [src]."),
			range = 5
		)
		iv_bag = tool
		last_reagent_color = iv_bag.reagents.get_color()
		update_icon()
		return TRUE

	return ..()


/obj/structure/iv_stand/Process()
	if (!patient)
		return PROCESS_KILL
	if (!Adjacent(patient))
		RipDrip()
		return PROCESS_KILL
	if (!iv_bag)
		return
	if (SSobj.times_fired & 1)
		return
	if (!iv_bag.transfer_amount)
		return
	if (drip_mode == MODE_INJECT)
		if (!iv_bag.reagents.total_volume)
			if (prob(15))
				playsound(src, 'sound/effects/3beep.ogg', 50, TRUE)
				audible_message(
					SPAN_NOTICE("\The [src] pings."),
					hearing_distance = 5
				)
			return
		iv_bag.reagents.trans_to_mob(patient, iv_bag.transfer_amount, CHEM_BLOOD)
		update_icon()
		return
	if (drip_mode == MODE_EXTRACT)
		var/difference = clamp(iv_bag.volume - iv_bag.reagents.total_volume, 0, iv_bag.transfer_amount)
		if (!difference)
			if (prob(15))
				playsound(src, 'sound/effects/3beep.ogg', 50, TRUE)
				audible_message(
					SPAN_NOTICE("\The [src] pings."),
					hearing_distance = 5
				)
			return
		if (!patient.should_have_organ(BP_HEART))
			return
		if (patient.get_blood_volume() < BLOOD_VOLUME_SAFE)
			if (prob(30))
				playsound(src, 'sound/effects/3beep.ogg', 50, TRUE)
				audible_message(
					SPAN_NOTICE("\The [src] pings."),
					hearing_distance = 5
				)
		if (patient.take_blood(iv_bag, difference))
			update_icon()
		return


/obj/structure/iv_stand/attack_hand(mob/living/user)
	if (iv_bag)
		iv_bag.dropInto(loc)
		iv_bag = null
		update_icon()
		return
	if (patient)
		RemoveDrip(user)
		return
	return ..()


/obj/structure/iv_stand/attack_robot(mob/living/silicon/user)
	if (!Adjacent(user))
		return
	attack_hand(user)


/obj/structure/iv_stand/examine(mob/user, distance)
	. = ..()
	if (distance >= 2 && !isghost(user))
		return
	if (patient)
		to_chat(user, "\The [patient] is hooked up to it.")
	if (!iv_bag)
		to_chat(user, "It has no IV bag attached.")
		return
	var/volume = floor(iv_bag.reagents.total_volume)
	if (!volume)
		to_chat(user, "It has an empty [iv_bag] attached.")
		return
	to_chat(user, "It has \a [iv_bag] attached with [volume] units of liquid inside.")
	to_chat(user, {"\
		It is set to [drip_mode == MODE_INJECT ? "inject" : drip_mode == MODE_EXTRACT ? "extract" : ""] \
		[iv_bag.transfer_amount]u of fluid per cycle.\
	"})


/obj/structure/iv_stand/CheckDexterity(mob/living/user)
	return ishuman(user) || isrobot(user)


/obj/structure/iv_stand/proc/AttachDrip(mob/living/carbon/human/target, mob/living/user)
	if (patient)
		to_chat(user, SPAN_WARNING("\The [patient] is already hooked up to \the [src]."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] starts to hook up \the [target] to \the [src]."),
		SPAN_ITALIC("You start to hook up \the [target] to \the [src]."),
		range = 5
	)
	if (!user.do_skilled(3 SECONDS, SKILL_MEDICAL, target))
		return
	if (prob(user.skill_fail_chance(SKILL_MEDICAL, 67, SKILL_BASIC)))
		user.visible_message(
			SPAN_DANGER("\The [user] fishes for a vein on \the [target] and fails, stabbing them instead!"),
			SPAN_DANGER("You fish inexpertly for a vein on \the [target] and stab them instead!"),
			range = 5
		)
		target.apply_damage(rand(2, 6), DAMAGE_BRUTE, pick(BP_R_ARM, BP_L_ARM), damage_flags = DAMAGE_FLAG_SHARP, armor_pen = 100)
		return
	START_PROCESSING(SSobj, src)
	user.visible_message(
		SPAN_ITALIC("\The [user] successfully inserts \a [src]'s cannula into \the [target]."),
		SPAN_NOTICE("You successfully insert \the [src]'s cannula into \the [target]."),
		range = 1
	)
	patient = target
	update_icon()


/obj/structure/iv_stand/proc/RemoveDrip(mob/living/user)
	if (!patient)
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] starts unhooking \the [patient] from \a [src]."),
		SPAN_ITALIC("You start extracting \the [src]'s cannula from \the [patient]."),
		range = 5
	)
	if (!user.do_skilled(1.5 SECONDS, SKILL_MEDICAL, patient))
		return
	if (!user.skill_check(SKILL_MEDICAL, SKILL_BASIC))
		RipDrip(user)
		return
	STOP_PROCESSING(SSobj, src)
	user.visible_message(
		SPAN_WARNING("\The [user] extracts \the [src]'s cannula from \the [patient]."),
		SPAN_NOTICE("You successfully unhook \the [patient] from \the [src]."),
		range = 1
	)
	patient = null
	update_icon()


/obj/structure/iv_stand/proc/RipDrip(mob/living/user)
	if (!patient)
		return
	STOP_PROCESSING(SSobj, src)
	patient.visible_message(
		SPAN_WARNING("\The cannula from \a [src] is ripped out of \the [patient][user ? " by \the [user]" : ""]!"),
		SPAN_DANGER("\The cannula from \the [src] is ripped out of you[user ? " by \the [user]": ""]!"),
		range = 5
	)
	patient.custom_pain(power = 20)
	patient.apply_damage(rand(1, 3), DAMAGE_BRUTE, pick(BP_R_ARM, BP_L_ARM), damage_flags = DAMAGE_FLAG_SHARP, armor_pen = 100)
	patient = null
	update_icon()


/obj/structure/iv_stand/verb/TransferAmountVerb()
	set name = "Set IV Bag Rate"
	set category = "Object"
	set src in range(1)
	var/mob/living/user = usr
	if (!istype(user))
		return
	if (!Adjacent(user) || user.incapacitated())
		to_chat(user, SPAN_WARNING("You're in no condition to do that."))
		return
	if (!iv_bag)
		to_chat(user, SPAN_WARNING("\The [src] does not have an attached IV bag."))
		return
	iv_bag.UpdateTransferAmount(user, src)


/obj/structure/iv_stand/verb/RemoveDripVerb()
	set category = "Object"
	set name = "Detach Stand IV Drip"
	set src in range(1)
	var/mob/living/user = usr
	if (!istype(user))
		return
	if (!patient)
		to_chat(user, SPAN_WARNING("\The [src] is not hooked up to anyone."))
		return
	if (!Adjacent(user) || user.incapacitated())
		to_chat(user, SPAN_WARNING("You're in no condition do that."))
	RemoveDrip(user)


/obj/structure/iv_stand/verb/ToggleModeVerb()
	set category = "Object"
	set name = "Toggle Stand IV Mode"
	set src in view(1)
	var/mob/living/user = usr
	if (!istype(user))
		return
	if (!Adjacent(user) || user.incapacitated())
		to_chat(user, SPAN_WARNING("You're in no condition to do that."))
		return
	var/action_word
	switch (drip_mode)
		if (MODE_EXTRACT)
			action_word = "inject"
			drip_mode = MODE_INJECT
		else
			action_word = "extract"
			drip_mode = MODE_EXTRACT
	user.visible_message(
		SPAN_ITALIC("\The [user] adjusts \a [src] to [action_word] fluids."),
		SPAN_ITALIC("You adjust \the [src] to [action_word] fluids."),
		range = 3
	)
