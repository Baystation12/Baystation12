/*
=== Item Click Call Sequences ===
These are the default click code call sequences used when clicking on stuff with an item.

Atoms:

mob/ClickOn() calls the item's resolve_attackby() proc.
item/resolve_attackby() calls the target atom's attackby() proc.

Mobs:

mob/living/attackby() after checking for surgery, calls the item's attack() proc.
item/attack() generates attack logs, sets click cooldown and calls the mob's attacked_with_item() proc. If you override this, consider whether you need to set a click cooldown, play attack animations, and generate logs yourself.
mob/attacked_with_item() should then do mob-type specific stuff (like determining hit/miss, handling shields, etc) and then possibly call the item's apply_hit_effect() proc to actually apply the effects of being hit.

Item Hit Effects:

item/apply_hit_effect() can be overriden to do whatever you want. However "standard" physical damage based weapons should make use of the target mob's hit_with_weapon() proc to
avoid code duplication. This includes items that may sometimes act as a standard weapon in addition to having other effects (e.g. stunbatons on harm intent).
*/


/**
 * Called when the item is in the active hand and clicked, or the `activate held object` verb is used.
 *
 * **Parameters**:
 * - `user` - The mob using the item.
 *
 * Should have no return value.
 */
/obj/item/proc/attack_self(mob/living/user)
	return


/**
 * Called when the item is in the active hand and another atom is clicked. This is generally called by `ClickOn()`.
 *
 * This passes down to `attack()`, `use_user()`, `use_grab()`, `use_weapon()`, `use_tool()`, `attackby()`, and
 * `use_on()`, in that order, depending on item flags and user's intent.
 *
 * **Parameters**:
 * - `atom` - The atom that was clicked.
 * - `user` - The mob using the item.
 * - `click_params` - List of click parameters. See BYOND's `CLick()` documentation.
 *
 * Returns boolean to indicate whether the attack call was handled or not.
 */
/obj/item/proc/resolve_attackby(atom/atom, mob/living/user, click_params)
	if (!atom.can_use_item(src, user, click_params))
		return FALSE
	if (atom.pre_use_item(src, user, click_params))
		return TRUE
	var/use_call
	if (HAS_FLAGS(item_flags, ITEM_FLAG_TRY_ATTACK))
		use_call = "on"
		. = use_on(atom, user, click_params)
		if (!. && attack(atom, user))
			use_call = "attack"
			. = TRUE
	if (!. && user.a_intent == I_HURT)
		use_call = "weapon"
		. = atom.use_weapon(src, user, click_params)
	if (!.)
		use_call = "tool"
		. = atom.use_tool(src, user, click_params)
	if (!.)
		use_call = "attackby"
		. = atom.attackby(src, user, click_params)
	if (!. && !HAS_FLAGS(item_flags, ITEM_FLAG_TRY_ATTACK))
		use_call = "on"
		. = use_on(atom, user, click_params)
	if (!.)
		use_call = null
	atom.post_use_item(src, user, ., use_call, click_params)


/**
 * Handler for operations to occur before running the chain of use_* procs. Always called.
 *
 * By default, this does nothing.
 *
 * Logic that returns `TRUE` should either perform an action or present a feedback message to the user.
 *
 * **Parameters**:
 * - `tool` - The item being used.
 * - `user` - The mob performing the interaction.
 * - `click_params` - List of click parameters.
 *
 * Returns boolean. Indicates whether or not the interaction should be considered handled at this stage.
 * If `TRUE`, halts `resolve_attackby()` and returns `TRUE` there as well.
 */
/atom/proc/pre_use_item(obj/item/tool, mob/living/user, click_params)
	return FALSE


/**
 * Handler for operations to occur after running the chain of use_* procs. Always called.
 *
 * By default, this adds fingerprints to the atom and tool.
 *
 * **Parameters**:
 * - `tool` - The item being used.
 * - `user` - The mob performing the interaction.
 * - `interaction_handled` (boolean) - Whether or not the use call was handled.
 * - `use_call` (string) - The use call proc that handled the interaction, or null.
 * - `click_params` - List of click parameters.
 *
 * Has no return value.
 */
/atom/proc/post_use_item(obj/item/tool, mob/living/user, interaction_handled, use_call, click_params)
	if (interaction_handled)
		if (!HAS_FLAGS(tool.item_flags, ITEM_FLAG_NO_PRINT))
			tool.add_fingerprint(user)
			add_fingerprint(user, tool = tool)


/**
 * Whether or not an item interaction is possible. Checked before any use calls.
 *
 * By default, this checks for `ATOM_FLAG_NO_TOOLS`.
 *
 * Logic that returns `FALSE` should either perform an action or present a feedback message to the user.
 *
 * Returns boolean. Indicates whether or not the interaction is permitted.
 * If `FALSE`, halts `resolve_attackby()` and returns `FALSE` there as well.
 */
/atom/proc/can_use_item(obj/item/tool, mob/living/user, click_params)
	// No Tools flag check
	if (HAS_FLAGS(atom_flags, ATOM_FLAG_NO_TOOLS))
		USE_FEEDBACK_FAILURE("\The [src] can't be interacted with.")
		return FALSE
	return TRUE


/obj/can_use_item(obj/item/tool, mob/living/user, click_params)
	. = ..()
	if (!.)
		return
	if (hides_under_flooring())
		var/turf/turf = get_turf(src)
		if (!turf.is_plating())
			USE_FEEDBACK_FAILURE("You must remove the plating before you can interact with \the [src].")
			return FALSE
		var/obj/structure/catwalk/catwalk = locate() in get_turf(src)
		if (catwalk)
			if (catwalk.plated_tile && !catwalk.hatch_open)
				USE_FEEDBACK_FAILURE("\The [catwalk]'s hatch needs to be opened before you can access \the [src].")
				return FALSE
			else if (!catwalk.plated_tile)
				USE_FEEDBACK_FAILURE("\The [catwalk] is blocking access to \the [src].")
				return FALSE


/turf/can_use_item(obj/item/tool, mob/living/user, click_params)
	. = ..()
	if (!.)
		return
	var/area/area = get_area(src)
	if (!area?.can_modify_area())
		USE_FEEDBACK_FAILURE("This area does not allow structural modifications.")
		return FALSE


/turf/can_use_item(obj/item/tool, mob/living/user, click_params)
	. = ..()
	if (!.)
		return
	var/obj/structure/catwalk/catwalk = locate() in src
	if (catwalk)
		if (catwalk.plated_tile && !catwalk.hatch_open)
			USE_FEEDBACK_FAILURE("\The [catwalk]'s hatch needs to be opened before you can access \the [src].")
			return FALSE
		else if (!catwalk.plated_tile)
			USE_FEEDBACK_FAILURE("\The [catwalk] is blocking access to \the [src].")
			return FALSE


/**
 * Validates the mob can perform general interactions. Primarily intended for use after inputs, sleeps, timers, etc to ensure the action can still be completed.
 *
 * **Parameters**:
 * - `target` - The atom being interacted with.
 * - `tool` - The item being used to interact. Optional. Defaults to `FALSE` to differentiate between a nulled reference and an empty parameter.
 * - `flags` (Bitflag, any of `SANITY_CHECK_*`, default `SANITY_CHECK_DEFAULT`) - Bitflags of additional settings. See `code\__defines\misc.dm`.
 *
 * Returns boolean.
 */
/mob/proc/use_sanity_check(atom/target, atom/tool = FALSE, flags = SANITY_CHECK_DEFAULT)
	// Deletion checks
	if (QDELETED(src))
		return FALSE
	var/silent = HAS_FLAGS(flags, SANITY_CHECK_SILENT)
	if (QDELETED(target))
		if (!silent)
			FEEDBACK_FAILURE(src, "[target ? "\The [target]" : "The object you were interacting with"] no longer exists.")
		return FALSE
	if (tool != FALSE && QDELETED(tool))
		if (!silent)
			FEEDBACK_FAILURE(src, "[tool ? "\The [tool]" : "The item you were using"] no longer exists.")
		return FALSE

	// Target checks
	if (!Adjacent(target))
		if (!silent)
			FEEDBACK_FAILURE(src, "You must remain next to \the [target].")
		return FALSE
	if (target.loc == src && HAS_FLAGS(flags, SANITY_CHECK_TARGET_UNEQUIP) && !canUnEquip(target))
		if (!silent)
			FEEDBACK_UNEQUIP_FAILURE(src, target)
		return FALSE
	if (HAS_FLAGS(flags, SANITY_CHECK_TOPIC_INTERACT) && !CanInteractWith(src, target, target.DefaultTopicState()))
		if (!silent)
			FEEDBACK_FAILURE(src, "You can't interact with \the [src].")
		return FALSE
	if (HAS_FLAGS(flags, SANITY_CHECK_TOPIC_PHYSICALLY_INTERACT) && !CanPhysicallyInteractWith(src, target))
		if (!silent)
			FEEDBACK_FAILURE(src, "You can't physically interact with \the [src].")
		return FALSE

	// Tool checks - Skip these if there is no tool
	if (!tool)
		return TRUE
	if (HAS_FLAGS(flags, SANITY_CHECK_BOTH_ADJACENT) && tool.loc != src && !tool.Adjacent(target))
		if (!silent)
			FEEDBACK_FAILURE(src, "\The [tool] must stay next to \the [target].")
		return FALSE

	// These checks only apply to items
	if (isitem(tool))
		if (HAS_FLAGS(flags, SANITY_CHECK_TOOL_UNEQUIP) && !canUnEquip(tool))
			if (!silent)
				FEEDBACK_UNEQUIP_FAILURE(src, tool)
			return FALSE
		if (HAS_FLAGS(flags, SANITY_CHECK_TOOL_IN_HAND) && get_active_hand() != tool)
			if (!silent)
				FEEDBACK_FAILURE(src, "\The [tool] must stay in your active hand.")
			return FALSE
	return TRUE


/**
 * Interaction handler for being clicked on with a grab. This is called regardless of user intent.
 *
 * **Parameters**:
 * - `grab` - The grab item being used.
 * - `click_params` - List of click parameters.
 *
 * Returns boolean to indicate whether the attack call was handled or not. If `FALSE`, the next `use_*` proc in the
 * resolve chain will be called.
 */
/atom/proc/use_grab(obj/item/grab/grab, list/click_params)
	return FALSE


/**
 * Interaction handler for using an item on this atom with harm intent. Generally, this is for attacking the atom.
 *
 * **Parameters**:
 * - `weapon` - The item being used on this atom.
 * - `user` - The mob interacting with this atom.
 * - `click_params` - List of click parameters.
 *
 * Returns boolean to indicate whether the attack call was handled or not. If `FALSE`, the next `use_*` proc in the
 * resolve chain will be called.
 */
/atom/proc/use_weapon(obj/item/weapon, mob/living/user, list/click_params)
	SHOULD_CALL_PARENT(TRUE)
	if (weapon.force > 0 && get_max_health() && !HAS_FLAGS(weapon.item_flags, ITEM_FLAG_NO_BLUDGEON))
		user.setClickCooldown(user.get_attack_speed(weapon))
		user.do_attack_animation(src)
		var/damage_flags = weapon.damage_flags()
		if (!can_damage_health(weapon.force, weapon.damtype, damage_flags))
			playsound(src, use_weapon_hitsound ? weapon.hitsound : damage_hitsound, 50, TRUE)
			user.visible_message(
				SPAN_WARNING("\The [user] hits \the [src] with \a [weapon], but it bounces off!"),
				SPAN_WARNING("You hit \the [src] with \the [weapon], but it bounces off!")
			)
			return TRUE
		playsound(src, use_weapon_hitsound ? weapon.hitsound : damage_hitsound, 75, TRUE)
		user.visible_message(
			SPAN_DANGER("\The [user] hits \the [src] with \a [weapon]!"),
			SPAN_DANGER("You hit \the [src] with \the [weapon]!")
		)
		damage_health(weapon.force, weapon.damtype, damage_flags, skip_can_damage_check = TRUE)
		return TRUE

	return FALSE


/mob/living/use_weapon(obj/item/weapon, mob/living/user, list/click_params)
	if (weapon.force > 0 && get_max_health() && !HAS_FLAGS(weapon.item_flags, ITEM_FLAG_NO_BLUDGEON))
		user.setClickCooldown(user.get_attack_speed(weapon))
		user.do_attack_animation(src)
		var/damage_flags = weapon.damage_flags()
		if (!can_damage_health(weapon.force, weapon.damtype, damage_flags))
			playsound(src, weapon.hitsound, 50, TRUE)
			user.visible_message(
				SPAN_WARNING("\The [user] hits \the [src] with \a [weapon], but it bounces off!"),
				SPAN_WARNING("You hit \the [src] with \the [weapon], but it bounces off!"),
				exclude_mobs = list(src)
			)
			show_message(
				SPAN_WARNING("\The [user] hits you with \a [weapon], but it bounces off!"),
				VISIBLE_MESSAGE,
				SPAN_WARNING("You feel something bounce off you harmlessly.")
			)
			return TRUE
		playsound(src, weapon.hitsound, 75, TRUE)
		user.visible_message(
			SPAN_DANGER("\The [user] hits \the [src] with \a [weapon]!"),
			SPAN_DANGER("You hit \the [src] with \the [weapon]!"),
			exclude_mobs = list(src)
		)
		show_message(
			SPAN_DANGER("\The [user] hits you with \a [weapon]!"),
			VISIBLE_MESSAGE,
			SPAN_DANGER("You feel something hit you!")
		)
		general_health_adjustment(weapon.force, weapon.damtype, damage_flags, user.zone_sel.selecting, weapon)
		return TRUE

	return ..()


/**
 * Interaction handler for using an item on this atom with a non-harm intent, or if `use_weapon()` did not resolve an
 * action. Generally, this is for any standard interactions with items.
 *
 * **Parameters**:
 * - `tool` - The item being used on this atom.
 * - `user` - The mob interacting with this atom.
 * - `click_params` - List of click parameters.
 *
 * Returns boolean to indicate whether the attack call was handled or not. If `FALSE`, the next `use_*` proc in the
 * resolve chain will be called.
 */
/atom/proc/use_tool(obj/item/tool, mob/living/user, list/click_params)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE


/mob/living/use_tool(obj/item/tool, mob/living/user, list/click_params)
	// Surgery is handled by the tool
	if (can_operate(src, user) && tool.do_surgery(src, user))
		return TRUE

	return ..()


/mob/living/carbon/human/use_tool(obj/item/tool, mob/user, list/click_params)
	// Anything on Self - Devour
	if (user == src && zone_sel.selecting == BP_MOUTH && can_devour(tool, silent = TRUE))
		var/obj/item/blocked = check_mouth_coverage()
		if (blocked)
			USE_FEEDBACK_FAILURE("\The [blocked] is in the way!")
			return TRUE
		devour(tool)
		return TRUE

	return ..()


/**
 * DEPRECATED - USE THE `use_*()` PROCS INSTEAD.
 *
 * Called when this atom is clicked on while another item is in the active hand. This is generally called by this item's `resolve_attackby()` proc.
 *
 * **Parameters**:
 * - `item` - The item that was in the active hand when `src` was clicked.
 * - `user` - The mob using the item.
 * - `click_params` - List of click parameters. See BYOND's `CLick()` documentation.
 *
 * Returns boolean to indicate whether the attack call was handled or not.
 */
/atom/proc/attackby(obj/item/item, mob/living/user, click_params)
	return FALSE


/mob/living/attackby(obj/item/item, mob/living/user, click_params)
	// Legacy mob attack code is handled by the weapon
	if (item.attack(src, user, user.zone_sel ? user.zone_sel.selecting : ran_zone()))
		return TRUE
	return ..()


/**
 * Called when the item is in the active hand and another atom is clicked and `resolve_attackby()` returns FALSE. This is generally called by `ClickOn()`.
 *
 * **Parameters**:
 * - `target` - The atom that was clicked on.
 * - `user` - The mob clicking on the target.
 * - `proximity_flag` (boolean) - TRUE is this was called on something adjacent to or in the inventory of `user`.
 * - `click_parameters` - List of click parameters. See BYOND's `CLick()` documentation.
 *
 * Should have no return value.
 */
/obj/item/proc/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	return


/**
 * Called when the item is in the active hand and another atom is clicked. This is generally called by the target's
 * `resolve_attackby()` proc.
 *
 * **Parameters**:
 * - `target` - The atom that was clicked on.
 * - `user` - The mob clicking on the target.
 * - `click_parameters` - List of click parameters. See BYOND's `Click()` documentation.
 *
 * Returns boolean to indicate whether the use call was handled or not.
 */
/obj/item/proc/use_on(atom/target, mob/user, click_parameters)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE


//I would prefer to rename this attack_as_weapon(), but that would involve touching hundreds of files.
/**
 * Called when a mob is clicked while the item is in the active hand and the interaction is not valid for surgery. Generally called by the mob's `attackby()` proc.
 *
 * **Parameters**:
 * - `M` - The mob that was clicked.
 * - `user` - The mob that clicked the target.
 * - `target_zone` - The mob targeting zone `user` had selected when clicking.
 * - `animate` (boolean) - Whether or not to show the attack animation.
 *
 * Returns boolean to indicate whether the item usage was successful or not.
 */
/obj/item/proc/attack(mob/living/subject, mob/living/user, target_zone, animate = TRUE)
	if (!force || (item_flags & ITEM_FLAG_NO_BLUDGEON))
		return FALSE
	if (subject == user && user.a_intent != I_HURT)
		return FALSE
	if (user.a_intent == I_HELP && !attack_ignore_harm_check)
		return FALSE
	if (!no_attack_log)
		admin_attack_log(user, subject, "Attacked using \a [src] (DAMTYE: [uppertext(damtype)])", "Was attacked with \a [src] (DAMTYE: [uppertext(damtype)])", "used \a [src] (DAMTYE: [uppertext(damtype)]) to attack")
	user.setClickCooldown(attack_cooldown + w_class)
	if (animate)
		user.do_attack_animation(subject)
	if (!subject.aura_check(AURA_TYPE_WEAPON, src, user))
		return FALSE
	var/hit_zone = subject.resolve_item_attack(src, user, target_zone)
	var/datum/attack_result/result = hit_zone
	if (istype(result))
		if (result.hit_zone)
			apply_hit_effect(result.attackee ? result.attackee : subject, user, result.hit_zone)
		return TRUE
	if (hit_zone)
		apply_hit_effect(subject, user, hit_zone)
	return TRUE


/**
 * Called when a weapon is used to make a successful melee attack on a mob. Generally called by the target's `attack()` proc.
 *
 * **Parameters**:
 * - `target` - The mob struck with the weapon.
 * - `user` - The mob using the weapon.
 * - `hit_zone` - The mob targeting zone that should be struck with the weapon.
 *
 * Returns boolean to indicate whether or not damage was dealt.
 */
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	if (hitsound)
		playsound(loc, hitsound, 50, TRUE, -1)
	var/power = force
	if (MUTATION_HULK in user.mutations)
		power *= 2
	return target.hit_with_weapon(src, user, power, hit_zone)


/**
 * Used to get how fast a mob should attack, and influences click delay.
 * This is just for inheritance.
 *
 * **Parameters**:
 * - `item` - The item being used in the attack, if any.
 *
 * Returns a number indicating the determined attack cooldown/speed.
 */
/mob/proc/get_attack_speed(obj/item/item)
	return DEFAULT_ATTACK_COOLDOWN


/mob/living/get_attack_speed(obj/item/item)
	var/speed = base_attack_cooldown
	if (istype(item))
		speed = item.attack_cooldown
	return speed


/datum/attack_result
	var/hit_zone = 0
	var/mob/living/attackee
