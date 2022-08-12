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
	return A.attackby(src, user, click_params)


/**
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


/mob/living/attackby(obj/item/I, mob/user)
	if(!ismob(user))
		return 0
	if(can_operate(src,user) && I.do_surgery(src,user)) //Surgery
		return 1
	return I.attack(src, user, user.zone_sel ? user.zone_sel.selecting : ran_zone())


/mob/living/carbon/human/attackby(obj/item/I, mob/user)
	if(user == src && zone_sel.selecting == BP_MOUTH && can_devour(I, silent = TRUE))
		var/obj/item/blocked = src.check_mouth_coverage()
		if(blocked)
			to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		if(devour(I))
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
