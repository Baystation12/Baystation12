/*Auras are simple: They are simple overriders for use_weapon, bullet_act, damage procs, etc. They also tick after their respective mob.
They should be used for undeterminate mob effects, like for instance a toggle-able forcefield, or indestructability as long as you don't move.
They should also be used for when you want to effect the ENTIRE mob, like having an armor buff or showering candy everytime you walk.
*/

/obj/aura
	var/mob/living/user

/obj/aura/New(mob/living/target)
	..()
	if(target)
		added_to(target)
		user.add_aura(src)

/obj/aura/Destroy()
	if(user)
		user.remove_aura(src)
		removed()
	return ..()

/obj/aura/proc/added_to(mob/living/target)
	user = target

/obj/aura/proc/removed()
	user = null

/**
 * Called during the associated mob's life checks.
 *
 * Called by `/mob/living/proc/aura_check()` when `type` == `AURA_TYPE_LIFE`.
 *
 * Returns bitfield (Any of `AURA_*`). See `code\__defines\mobs.dm`.
 */
/obj/aura/proc/aura_check_life()
	return EMPTY_BITFIELD

/**
 * Called when the associated mob is attacked with a weapon.
 *
 * Called by `/mob/living/proc/aura_check()` when `type` == `AURA_TYPE_WEAPON`.
 *
 * **Parameters**:
 * - `weapon` - Item used to attack the mob.
 * - `attacker` - The attacking mob.
 * - `click_params` - List of click parameters.
 *
 * Returns bitfield (Any of `AURA_*`). See `code\__defines\mobs.dm`.
 */
/obj/aura/proc/aura_check_weapon(obj/item/weapon, mob/attacker, click_params)
	return EMPTY_BITFIELD

/// Called after a succesfull weapon hit on the owner
/obj/aura/proc/aura_post_weapon(obj/item/weapon, mob/attacker, click_params, damage_dealt)
	return EMPTY_BITFIELD

/**
 * Called when the associated mob is impacted by a projectile.
 *
 * Called by `/mob/living/proc/aura_check()` when `type` == `AURA_TYPE_BULLET`.
 *
 * **Parameters**:
 * - `proj` - The impacting projectile
 * - `def_zone` - Body part target zone that was impacted
 *
 * Returns bitfield (Any of `AURA_*`). See `code\__defines\mobs.dm`.
 */
/obj/aura/proc/aura_check_bullet(obj/item/projectile/proj, def_zone)
	return EMPTY_BITFIELD

/// Called after a succesfull bullet hit on the owner
/obj/aura/proc/aura_post_bullet(obj/item/projectile/proj , def_zone, damage_dealt)
	return EMPTY_BITFIELD

/**
 * Called when the associated mob is hit by a thrown atom.
 *
 * Called by `/mob/living/proc/aura_check()` when `type` == `AURA_TYPE_THROWN`.
 *
 * **Parameters**:
 * - `thrown_atom` - The atom impacting the mob.
 * - `thrown_datum` - The thrownthing datum associated with the thrown atom.
 *
 * Returns bitfield (Any of `AURA_*`). See `code\__defines\mobs.dm`.
 */
/obj/aura/proc/aura_check_thrown(atom/movable/thrown_atom, datum/thrownthing/thrown_datum)
	return EMPTY_BITFIELD

/// Calle after something thrown hits the owner
/obj/aura/proc/aura_post_thrown(atom/movable/thrown_atom, datum/thrownthing/thrown_datum, damage_dealt)
	return EMPTY_BITFIELD

/obj/aura/debug
	var/returning = EMPTY_BITFIELD

/obj/aura/debug/aura_check_weapon(obj/item/weapon, mob/attacker, click_params)
	log_debug("Aura Check Weapon for \ref[src]: [weapon], [attacker]")
	return returning

/obj/aura/debug/aura_check_bullet(obj/item/projectile/proj, def_zone)
	log_debug("Aura Check Bullet for \ref[src]: [proj], [def_zone]")
	return returning

/obj/aura/debug/aura_check_life()
	log_debug("Aura Check Life for \ref[src]")
	return returning

/obj/aura/debug/aura_check_thrown(atom/movable/thrown_atom, datum/thrownthing/thrown_datum)
	log_debug("Aura Check Thrown for \ref[src]: [thrown_atom], [thrown_datum.speed]")
	return returning
