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
/obj/item/proc/attack_self(mob/user)
	return


/**
 * Called when the item is in the active hand and another atom is clicked. This is generally called by `ClickOn()`.
 *
 * This passes down to `attack()`, `use_user()`, `use_grab()`, `use_weapon()`, `use_tool()`, and `attackby()`, in that order, depending on item
 * flags and user's intent.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked.
 * - `user` - The mob using the item.
 * - `click_params` - List of click parameters. See BYOND's `CLick()` documentation.
 *
 * Returns boolean to indicate whether the attack call was handled or not.
 */
/obj/item/proc/resolve_attackby(atom/A, mob/user, click_params)
	if(!(item_flags & ITEM_FLAG_NO_PRINT))
		add_fingerprint(user)
	if ((item_flags & ITEM_FLAG_TRY_ATTACK) && attack(A, user))
		return TRUE
	if (A == user)
		. = user.use_user(src, click_params)
	if (!. && user.a_intent == I_HURT)
		. = A.use_weapon(src, user, click_params)
	if (!.)
		. = A.use_tool(src, user, click_params)
	if (!.)
		return A.attackby(src, user, click_params)


/**
 * Interaction handler for using an item on yourself. This is called and the result checked before the other `use_*`
 * interaction procs are called, regardless of user intent.
 *
 * **Parameters**:
 * - `tool` - The item being used by the mob.
 * - `click_params` - List of click parameters.
 *
 * Returns boolean to indicate whether the attack call was handled or not. If `FALSE`, the next `use_*` proc in the
 * resolve chain will be called.
 */
/mob/proc/use_user(obj/item/tool, list/click_params = list())
	SHOULD_CALL_PARENT(TRUE)
	return FALSE


/mob/living/carbon/human/use_user(obj/item/tool, list/click_params)
	// Devouring
	if (zone_sel.selecting == BP_MOUTH && can_devour(tool, silent = TRUE))
		var/obj/item/blocked = check_mouth_coverage()
		if (blocked)
			to_chat(src, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		if (devour(tool))
			return TRUE

	return ..()


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
/atom/proc/use_weapon(obj/item/weapon, mob/user, list/click_params = list())
	SHOULD_CALL_PARENT(TRUE)
	// Standardized damage
	if (weapon.force > 0 && get_max_health() && !HAS_FLAGS(weapon.item_flags, ITEM_FLAG_NO_BLUDGEON))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)
		var/damage_flags = weapon.damage_flags()
		if (!can_damage_health(weapon.force, weapon.damtype, damage_flags))
			playsound(src, damage_hitsound, 50)
			user.visible_message(
				SPAN_WARNING("\The [user] hits \the [src] with \a [weapon], but it bounces off!"),
				SPAN_WARNING("You hit \the [src] with \the [weapon], but it bounces off!")
			)
			return TRUE
		playsound(src, damage_hitsound, 75)
		user.visible_message(
			SPAN_DANGER("\The [user] hits \the [src] with \a [weapon]!"),
			SPAN_DANGER("You hit \the [src] with \the [weapon]!")
		)
		damage_health(weapon.force, weapon.damtype, damage_flags, skip_can_damage_check = TRUE)
		return TRUE

	return FALSE


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
/atom/proc/use_tool(obj/item/tool, mob/user, list/click_params = list())
	SHOULD_CALL_PARENT(TRUE)
	return FALSE


/mob/living/use_tool(obj/item/tool, mob/user, list/click_params)
	// Surgery is handled by the tool
	if (can_operate(src, user) && tool.do_surgery(src, user))
		return TRUE

	return ..()


/**
 * DEPRECATED - USE THE `use_*()` PROCS INSTEAD.
 *
 * Called when this atom is clicked on while another item is in the active hand. This is generally called by this item's `resolve_attackby()` proc.
 *
 * **Parameters**:
 * - `W` - The item that was in the active hand when `src` was clicked.
 * - `user` - The mob using the item.
 * - `click_params` - List of click parameters. See BYOND's `CLick()` documentation.
 *
 * Returns boolean to indicate whether the attack call was handled or not.
 */
/atom/proc/attackby(obj/item/W, mob/user, click_params)
	return FALSE


/mob/living/attackby(obj/item/W, mob/user, click_params)
	// Legacy mob attack code is handled by the weapon
	if (W.attack(src, user, user.zone_sel ? user.zone_sel.selecting : ran_zone()))
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
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return


/datum/attack_result
	var/hit_zone = 0
	var/mob/living/attackee = null


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
/obj/item/proc/attack(mob/living/M, mob/living/user, target_zone, animate = TRUE)
	if(!force || (item_flags & ITEM_FLAG_NO_BLUDGEON))
		return 0
	if(M == user && user.a_intent != I_HURT)
		return 0
	if (user.a_intent == I_HELP && !attack_ignore_harm_check)
		return FALSE

	/////////////////////////

	if(!no_attack_log)
		admin_attack_log(user, M, "Attacked using \a [src] (DAMTYE: [uppertext(damtype)])", "Was attacked with \a [src] (DAMTYE: [uppertext(damtype)])", "used \a [src] (DAMTYE: [uppertext(damtype)]) to attack")
	/////////////////////////
	user.setClickCooldown(attack_cooldown + w_class)
	if(animate)
		user.do_attack_animation(M)
	if(!M.aura_check(AURA_TYPE_WEAPON, src, user))
		return 0

	var/hit_zone = M.resolve_item_attack(src, user, target_zone)

	var/datum/attack_result/AR = hit_zone
	if(istype(AR))
		if(AR.hit_zone)
			apply_hit_effect(AR.attackee ? AR.attackee : M, user, AR.hit_zone)
		return 1
	if(hit_zone)
		apply_hit_effect(M, user, hit_zone)

	return 1


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
	if(hitsound)
		playsound(loc, hitsound, 50, 1, -1)

	var/power = force
	if(MUTATION_HULK in user.mutations)
		power *= 2
	return target.hit_with_weapon(src, user, power, hit_zone)


/**
 * Used to get how fast a mob should attack, and influences click delay.
 * This is just for inheritance.
 *
 * **Parameters**:
 * - `W` - The item being used in the attack, if any.
 *
 * Returns a number indicating the determined attack cooldown/speed.
 */
/mob/proc/get_attack_speed(obj/item/W)
	return DEFAULT_ATTACK_COOLDOWN


/mob/living/get_attack_speed(obj/item/W)
	var/speed = base_attack_cooldown
	if(istype(W))
		speed = W.attack_cooldown

	return speed
