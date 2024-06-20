/obj/structure/roller_bed
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_stance = BUCKLE_FORCE_PRONE

	/// A shared list of pixel offsets for roller beds to move their buckled mobs by.
	var/static/list/roller_bed_buckle_pixel_shift = list(0, 0, 6)

	/// The IV bag currently attached to this roller bed, if any.
	var/obj/item/reagent_containers/ivbag/iv_bag

	/// Whether the IV bag is currently in active use with the buckled mob.
	var/drip_active = FALSE

	/// The color of the last reagent mix placed on the roller bed.
	var/last_reagent_color = "#ffffff"


/obj/structure/roller_bed/Destroy()
	buckle_pixel_shift = null
	if (istype(iv_bag))
		QDEL_NULL(iv_bag)
	return ..()


/obj/structure/roller_bed/Initialize()
	. = ..()
	buckle_pixel_shift = roller_bed_buckle_pixel_shift
	if (ispath(iv_bag))
		iv_bag = new iv_bag (src)
	update_icon()


/obj/structure/roller_bed/on_update_icon()
	if (density)
		icon_state = "up"
	else
		icon_state = "down"
	ClearOverlays()
	if (!iv_bag)
		return
	var/image/drip_overlay = image(icon, icon_state = "drip[drip_active]")
	if (density)
		drip_overlay.pixel_y += 6
	AddOverlays(drip_overlay)
	var/image/filling_overlay = image(icon, icon_state = "filling0")
	if (density)
		filling_overlay.pixel_y += 6
	var/percent_full = Round(Percent(iv_bag.reagents.total_volume, iv_bag.volume, 0))
	switch (percent_full)
		if (15 to 35)
			filling_overlay.icon_state = "filling25"
		if (36 to 65)
			filling_overlay.icon_state = "filling50"
		if (66 to 85)
			filling_overlay.icon_state = "filling75"
		if (86 to INFINITY)
			filling_overlay.icon_state = "filling100"
	filling_overlay.color = last_reagent_color
	AddOverlays(filling_overlay)
	if (percent_full < 25)
		var/image/light_overlay = image(icon, icon_state = "light_low")
		light_overlay.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		light_overlay.layer = ABOVE_LIGHTING_LAYER
		if (density)
			light_overlay.pixel_y += 6
		AddOverlays(light_overlay)


/obj/structure/roller_bed/examine(mob/user, distance)
	. = ..()
	if (distance >= 2 && !isghost(user))
		return
	if (drip_active)
		to_chat(user, "\The [buckled_mob] is hooked up to it.")
	if (!iv_bag)
		to_chat(user, "It has no IV bag attached.")
		return
	var/volume = floor(iv_bag.reagents.total_volume)
	if (!volume)
		to_chat(user, "It has an empty [iv_bag.name] attached.")
		return
	to_chat(user, "It has \a [iv_bag] attached with [volume] units of liquid inside.")
	to_chat(user, "It is set to inject [iv_bag.transfer_amount]u of fluid per cycle.")


/obj/structure/roller_bed/CanPass(atom/movable/movable, turf/target, height, air_group)
	if (ismovable(movable) && movable.checkpass(PASS_FLAG_TABLE))
		return TRUE
	else
		return ..()


/obj/structure/roller_bed/use_grab(obj/item/grab/grab, list/click_params)
	// Buckle victim
	if (!AttemptBuckle(grab.affecting, grab.assailant))
		return TRUE
	qdel(grab)
	return TRUE


/obj/structure/roller_bed/use_tool(obj/item/tool, mob/user, list/click_params)
	// IV Bag - Attach bag
	if (istype(tool, /obj/item/reagent_containers/ivbag))
		if (iv_bag)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [iv_bag] attached")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		iv_bag = tool
		last_reagent_color = iv_bag.reagents.get_color()
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] hangs \a [tool] from \the [src]."),
			SPAN_NOTICE("You hang \the [tool] from \the [src]."),
		)
		return TRUE

	return ..()


/obj/structure/roller_bed/post_buckle_mob(mob/living/target)
	. = ..()
	if (target == buckled_mob)
		set_density(TRUE)
		mouse_opacity = MOUSE_OPACITY_PRIORITY
		update_icon()
	else
		set_density(FALSE)
		mouse_opacity = MOUSE_OPACITY_NORMAL
		if (drip_active)
			RipDrip()
		update_icon()


/obj/structure/roller_bed/Process()
	if (!drip_active || !buckled_mob || !iv_bag)
		return PROCESS_KILL
	if (SSobj.times_fired & 1)
		return
	if (!iv_bag.transfer_amount)
		return
	if (!iv_bag.reagents.total_volume)
		if (prob(15))
			playsound(src, 'sound/effects/3beep.ogg', 50, TRUE)
			audible_message(
				SPAN_NOTICE("\The [src] pings."),
				hearing_distance = 5
			)
		return
	iv_bag.reagents.trans_to_mob(buckled_mob, iv_bag.transfer_amount, CHEM_BLOOD)
	update_icon()


/obj/structure/roller_bed/attack_hand(mob/living/user)
	if (iv_bag)
		if (drip_active)
			RemoveDrip(user)
		else
			RemoveBag(user)
	else if (buckled_mob)
		AttemptUnbuckle(user)
	else
		..()


/obj/structure/roller_bed/MouseDrop(atom/over_atom)
	if (!usr)
		return
	if (!over_atom)
		return
	if (!Adjacent(usr) || !over_atom.Adjacent(usr))
		return
	if (usr == over_atom && CheckDexterity(usr) || !ismob(over_atom))
		FoldBed(usr)
		return
	if (isliving(over_atom))
		MouseDrop_T(over_atom, usr)
	else
		over_atom.MouseDrop_T(src, usr)


/obj/structure/roller_bed/MouseDrop_T(atom/dropped, mob/living/user)
	if (src == dropped && user.canClick())
		user.ClickOn(src)
		return
	if (!buckled_mob)
		if (isliving(dropped))
			AttemptBuckle(dropped, user)
			return
		FoldBed(user)
		return
	if (buckled_mob == dropped)
		if (iv_bag)
			if (drip_active)
				RemoveDrip(user)
			else
				AttachDrip(buckled_mob, user)
			return
		to_chat(user, SPAN_WARNING("\The [src] has no IV bag attached."))


/obj/structure/roller_bed/CheckDexterity(mob/living/user)
	return ishuman(user) || isrobot(user)


/obj/structure/roller_bed/proc/FoldBed(mob/living/user)
	if (buckled_mob)
		to_chat(user, SPAN_WARNING("\The [buckled_mob] is on \the [src]. Remove them first."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] begins folding \a [src]."),
		SPAN_ITALIC("You begin folding \the [src]."),
		range = 5
	)
	if (!do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE | DO_BAR_OVER_USER) || density)
		return
	if (iv_bag)
		iv_bag.dropInto(loc)
		iv_bag = null
	new /obj/item/roller_bed (loc)
	qdel(src)


/obj/structure/roller_bed/proc/RemoveBag(mob/living/user)
	user.visible_message(
		SPAN_ITALIC("\The [user] removes \a [iv_bag] from \a [src]."),
		SPAN_ITALIC("You remove \the [iv_bag] from \the [src]."),
		range = 5
	)
	drip_active = FALSE
	iv_bag.dropInto(loc)
	iv_bag = null
	update_icon()


/obj/structure/roller_bed/proc/RemoveDrip(mob/living/user)
	if (!drip_active)
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] starts unhooking \the [buckled_mob] from \a [src]."),
		SPAN_ITALIC("You start extracting \the [src]'s cannula from \the [buckled_mob]."),
		range = 5
	)
	if (!user.do_skilled(1.5 SECONDS, SKILL_MEDICAL, buckled_mob))
		return
	if (!user.skill_check(SKILL_MEDICAL, SKILL_BASIC))
		RipDrip(user)
		return
	STOP_PROCESSING(SSobj, src)
	user.visible_message(
		SPAN_WARNING("\The [user] extracts \the [src]'s cannula from \the [buckled_mob]."),
		SPAN_NOTICE("You successfully unhook \the [buckled_mob] from \the [src]."),
		range = 1
	)
	drip_active = FALSE
	update_icon()


/obj/structure/roller_bed/proc/RipDrip(mob/living/user)
	if (!buckled_mob)
		return
	STOP_PROCESSING(SSobj, src)
	buckled_mob.visible_message(
		SPAN_WARNING("\The cannula from \a [src] is ripped out of \the [buckled_mob][user ? " by \the [user]" : ""]!"),
		SPAN_DANGER("\The cannula from \the [src] is ripped out of you[user ? " by \the [user]": ""]!"),
		range = 5
	)
	var/mob/living/carbon/human/human = buckled_mob
	if (istype(human))
		human.custom_pain(power = 20)
	buckled_mob.apply_damage(rand(1, 3), DAMAGE_BRUTE, pick(BP_R_ARM, BP_L_ARM), damage_flags = DAMAGE_FLAG_SHARP, armor_pen = 100)
	drip_active = FALSE
	update_icon()


/obj/structure/roller_bed/proc/AttachDrip(mob/living/carbon/human/target, mob/living/user)
	user.visible_message(
		SPAN_ITALIC("\The [user] starts to hook up \the [target] to \the [src]."),
		SPAN_ITALIC("You start to hook up \the [target] to \the [src]."),
		range = 5
	)
	if (!user.do_skilled(3 SECONDS, SKILL_MEDICAL, target))
		return
	if (prob(user.skill_fail_chance(SKILL_MEDICAL, 50, SKILL_BASIC)))
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
	drip_active = TRUE
	update_icon()


/obj/structure/roller_bed/verb/TransferAmountVerb()
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


/obj/structure/roller_bed/verb/RemoveDripVerb()
	set category = "Object"
	set name = "Detach Bed IV Drip"
	set src in range(1)
	var/mob/living/user = usr
	if (!istype(user))
		return
	if (!drip_active)
		to_chat(user, SPAN_WARNING("\The [src] is not hooked up to anyone."))
		return
	if (!Adjacent(user) || user.incapacitated())
		to_chat(user, SPAN_WARNING("You're in no condition do that."))
	RemoveDrip(user)


/obj/structure/roller_bed/nanoblood
	iv_bag = /obj/item/reagent_containers/ivbag/nanoblood


/obj/structure/roller_bed/human_oneg
	iv_bag = /obj/item/reagent_containers/ivbag/blood/human/oneg


/obj/structure/roller_bed/skrell_oneg
	iv_bag = /obj/item/reagent_containers/ivbag/blood/skrell/oneg


/obj/structure/roller_bed/unathi_oneg
	iv_bag = /obj/item/reagent_containers/ivbag/blood/unathi/oneg


/obj/structure/roller_bed/vox_oneg
	iv_bag = /obj/item/reagent_containers/ivbag/blood/vox/oneg


/obj/item/roller_bed
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "item"
	item_state = "rbed"
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_LARGE


/obj/item/roller_bed/attack_self(mob/living/user)
	if (!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You don't have enough space to set up \the [src]."))
		return
	CreateStructure(user, user.loc, TRUE)


/obj/item/roller_bed/proc/CreateStructure(mob/living/user, atom/target, unequip)
	if (user)
		if (unequip && !user.unEquip(src, target))
			return
		user.visible_message(
			SPAN_ITALIC("\The [user] starts setting up \a [src]."),
			SPAN_ITALIC("You start setting up \the [src]."),
			range = 5
		)
	var/obj/structure/roller_bed/roller = new (target)
	if (user)
		roller.add_fingerprint(user)
	qdel(src)


/obj/item/robot_rack/roller_bed
	name = "roller bed rack"
	desc = "A rack for carrying collapsed roller beds."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "item"
	object_type = /obj/item/roller_bed
	interact_type = /obj/structure/roller_bed


/obj/item/robot_rack/roller_bed/resolve_attackby(atom/target, mob/living/user, click_params)
	if (!target.Adjacent(user))
		return TRUE
	if (user.incapacitated())
		to_chat(user, SPAN_WARNING("You're in no condition to do that."))
		return TRUE
	if (!length(held))
		if (istype(target, object_type))
			user.visible_message(
				SPAN_ITALIC("\The [user] scoops \a [target] into their [name]."),
				SPAN_ITALIC("You scoop \the [target] into your [name]."),
				SPAN_ITALIC("You hear metal clattering on metal.")
			)
			contents += target
			held += target
		else if (istype(target, interact_type))
			target.MouseDrop(src, over_loc = get_turf(target))
		return TRUE
	if (istype(target, object_type))
		to_chat(user, SPAN_WARNING("You already have \a [target] in your [name]."))
		return TRUE
	if (!isturf(target))
		return
	if (target.density)
		return
	var/blocking = target.turf_is_crowded()
	if (blocking && !ismob(blocking))
		to_chat(user, SPAN_WARNING("\The [blocking] is in the way."))
		return TRUE
	var/obj/item/roller_bed/roller = pop(held)
	roller.dropInto(target)
	roller.CreateStructure(user, target, FALSE)
	return TRUE
