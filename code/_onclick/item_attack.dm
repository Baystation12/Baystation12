/*
=== Item Click Call Sequences ===
These are the default click code call sequences used when clicking on stuff with an item.

Atoms:

mob/ClickOn() calls the item's resolve_attackby() proc.
item/resolve_attackby() calls the target atom's use_tool() proc.

Mobs:

item/use_weapon() generates attack logs, determines miss chance, sets click cooldown and calls the apply_hit_effect() proc. If you override this, consider whether you need to set a click cooldown, play attack animations, and generate logs yourself.
use_weapon also call resolve_item_attack() and do mob-type specific stuff (like determining hit/miss, handling shields, etc).

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
 * This passes down to `use_before()`, `use_weapon()`, `use_tool()`, and then use_after() in that order,
 * depending on item flags and user's intent.
 * use_grab() is run in an override of resolve_attackby() processed at the grab's level, and is not part of this chain.
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
	atom.pre_use_item(src, user, click_params)
	var/use_call

	use_call = "use"
	. = use_before(atom, user, click_params)
	if (!. && (user.a_intent == I_HURT || user.a_intent == I_DISARM))
		use_call = "weapon"
		. = atom.use_weapon(src, user, click_params)
	if (!.)
		use_call = "tool"
		. = atom.use_tool(src, user, click_params)
	if (!.)
		use_call = "use"
		. = use_after(atom, user, click_params)
	if (!.)
		use_call = null
	atom.post_use_item(src, user, ., use_call, click_params)


/**
 * Handler for operations to occur before running the chain of use_* procs. Always called.
 *
 * By default, this does nothing.
 *
 * **Parameters**:
 * - `tool` - The item being used.
 * - `user` - The mob performing the interaction.
 * - `click_params` - List of click parameters.
 *
 * Has no return value.
 */
/atom/proc/pre_use_item(obj/item/tool, mob/living/user, click_params)
	return


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


/// Whether or not an item interaction is possible. Checked before any use calls.
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


/turf/simulated/floor/can_use_item(obj/item/tool, mob/living/user, click_params)
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
	if (isturf(target.loc) && !Adjacent(target))
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
		if (HAS_FLAGS(flags, SANITY_CHECK_TOOL_IN_HAND))
			var/active = get_active_hand()
			if (istype(active, /obj/item/gripper))
				var/obj/item/gripper/gripper = active
				active = gripper.wrapped
			if (active != tool)
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
		if (!aura_check(AURA_TYPE_WEAPON, weapon, user))
			return TRUE
		var/damage_flags = weapon.damage_flags()
		var/weapon_mention
		if (weapon.attack_message_name())
			weapon_mention = " with [weapon.attack_message_name()]"
		var/attack_verb = "[pick(weapon.attack_verb)]"

		if (!can_damage_health(weapon.force, weapon.damtype, damage_flags))
			playsound(src, weapon.hitsound, 50, TRUE)
			user.visible_message(
				SPAN_WARNING("\The [user] hit \the [src] [weapon_mention], but it bounced off!"),
				SPAN_WARNING("You hit \the [src] [weapon_mention], but it bounced off!"),
				exclude_mobs = list(src)
			)
			show_message(
				SPAN_WARNING("\The [user] hit you [weapon_mention], but it bounced off!"),
				VISIBLE_MESSAGE,
				SPAN_WARNING("You felt something bounce off you harmlessly.")
			)
			return TRUE

		var/hit_zone = resolve_item_attack(weapon, user, user.zone_sel? user.zone_sel.selecting : ran_zone())
		if (!hit_zone)
			return TRUE

		playsound(src, weapon.hitsound, 75, TRUE)
		user.visible_message(
			SPAN_DANGER("\The [user] [attack_verb] \the [src] [weapon_mention]"),
			SPAN_DANGER("You [attack_verb] \the [src] [weapon_mention]!"),
			exclude_mobs = list(src)
		)
		show_message(
			SPAN_DANGER("\The [user] [attack_verb] you [weapon_mention]!"),
			VISIBLE_MESSAGE,
			SPAN_DANGER("You feel something hit you!")
		)

		if (!weapon.no_attack_log)
			admin_attack_log(
				user,
				src,
				"Attacked using \a [weapon] (DAMTYE: [uppertext(weapon.damtype)])",
				"Was attacked with \a [weapon] (DAMTYE: [uppertext(weapon.damtype)])",
				"used \a [weapon] (DAMTYE: [uppertext(weapon.damtype)]) to attack"
			)

		var/datum/attack_result/result = hit_zone
		if (istype(result))
			if (result.hit_zone)
				var/mob/living/victim = result.attackee ? result.attackee : src
				weapon.apply_hit_effect(victim, user, result.hit_zone)
				return TRUE
		if (hit_zone)
			weapon.apply_hit_effect(src, user, hit_zone)
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

	if (length(auras))
		for (var/obj/aura/web/web in auras)
			web.remove_webbing(user)
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
 * Called when the item is in the active hand and another atom is clicked and `resolve_attackby()` returns FALSE. This is generally called by `ClickOn()`.
 * Works on ranged targets, unlike resolve_attackby()
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
 * Use it for item-level behavior you don't necessarily want running before use_tool/use_weapon.
 * You will need to use type checks on atom/target on overrides; or else this will be called on anything you click.
 *
 * **Parameters**:
 * - `target` - The atom that was clicked on.
 * - `user` - The mob clicking on the target.
 * - `click_parameters` - List of click parameters. See BYOND's `Click()` documentation.
 *
 * Returns boolean to indicate whether the use call was handled or not.
 */
/obj/item/proc/use_after(atom/target, mob/living/user, click_parameters)
	return FALSE


/**
 * Called when a mob is clicked while the item is in the active hand. This is usually called first by the mob's `resolve_attackby()` proc.
 * Use this to set item-level overrides that you want running first. If you have an override you don't want running before use_tool and use_weapon, put it in use_after().
 * You will need to use type checks on atom/target on overrides; or else this will be called on anything you click.
 * If returns FALSE, the rest of the resolve_attackby() chain is called.
 *
 * **Parameters**:
 * - `target` - The atom that was clicked.
 * - `user` - The mob that clicked the target.
 * * - `click_parameters` - List of click parameters. See BYOND's `Click()` documentation.
 */
/obj/item/proc/use_before(atom/target, mob/living/user, click_parameters)
	return FALSE


/**
 * Called when a weapon is used to make a successful melee attack on a mob. Generally called by the target's `use_weapon()` proc.
 * Overriden to apply special effects like electrical shocks from stun batons/defib paddles.
 *
 * **Parameters**:
 * - `target` - The mob struck with the weapon.
 * - `user` - The mob using the weapon.
 * - `hit_zone` - The mob targeting zone that should be struck with the weapon.
 *
 * Returns boolean to indicate whether or not damage was dealt.
 */
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	var/power = force
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
		speed = item.attack_cooldown + item.w_class
	return speed


/datum/attack_result
	var/hit_zone = 0
	var/mob/living/attackee
