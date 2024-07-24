/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.

/*
 * Twohanded
 */
/obj/item/material/twohanded
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = null
	var/unwieldsound = null
	var/base_icon
	var/base_name
	var/unwielded_force_divisor = 0.25
	var/wielded_parry_bonus = 20

/obj/item/material/twohanded/update_twohanding()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
	else
		wielded = 0
		force = force_unwielded
	update_icon()
	..()

/obj/item/material/twohanded/update_force()
	..()
	base_name = name
	force_unwielded = round(force*unwielded_force_divisor)
	force_wielded = force
	force = force_unwielded


/obj/item/material/twohanded/New()
	..()
	update_icon()

/obj/item/material/twohanded/get_parry_chance(mob/user, mob/attacker)
	. = ..()
	if(wielded)
		. += wielded_parry_bonus

/obj/item/material/twohanded/on_update_icon()
	..()
	icon_state = "[base_icon][wielded]"
	item_state_slots[slot_l_hand_str] = icon_state
	item_state_slots[slot_r_hand_str] = icon_state
	item_state_slots[slot_back_str] = base_icon

/*
 * Fireaxe
 */
/obj/item/material/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "fireaxe0"
	base_icon = "fireaxe"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"

	max_force = 60	//for wielded
	force_multiplier = 0.6
	unwielded_force_divisor = 0.3
	attack_cooldown_modifier = 6
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0
	worth_multiplier = 31
	base_parry_chance = 15

/obj/item/material/twohanded/fireaxe/use_before(atom/A, mob/living/user, click_parameters)
	if(!wielded || user.a_intent == I_HELP || !isobj(A))
		return FALSE

	if(istype(A,/obj/structure/window))
		var/obj/structure/window/W = A
		W.shatter()
		return TRUE

	if(istype(A,/obj/structure/grille))
		qdel(A)
		return TRUE

	if(istype(A,/obj/vine))
		var/obj/vine/P = A
		P.kill_health()
		return TRUE

/obj/item/material/twohanded/fireaxe/IsHatchet()
	return TRUE

//spears, bay edition
/obj/item/material/twohanded/spear
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	max_force = 30	//for wielded
	applies_material_colour = 0
	force_multiplier = 0.33 // 12/19 with hardness 60 (steel) or 10/16 with hardness 50 (glass)
	unwielded_force_divisor = 0.20
	thrown_force_multiplier = 1.5 // 20 when thrown with weight 15 (glass)
	throw_speed = 6
	sharp = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = MATERIAL_GLASS
	does_spin = FALSE
	worth_multiplier = 7
	base_parry_chance = 30


/obj/item/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "metalbat0"
	base_icon = "metalbat"
	item_state = "metalbat"
	w_class = ITEM_SIZE_LARGE
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	default_material = MATERIAL_MAPLE
	max_force = 30	//for wielded
	force_multiplier = 1.1           // 22 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.7 // 15 when unwielded based on above.
	attack_cooldown_modifier = 1
	melee_accuracy_bonus = -10
	base_parry_chance = 30

/obj/item/material/twohanded/baseballbat/proc/deflect(mob/user, atom/target, atom/movable/item, range, speed)
	item.throw_at(target, range, speed, user, TRUE)

/obj/item/material/twohanded/baseballbat/handle_shield(mob/user, damage, atom/damage_source, mob/attacker, def_zone, attack_text)
	var/atom/movable/AM = damage_source
	var/datum/thrownthing/TT = SSthrowing.processing[damage_source]

	if(istype(AM) && TT && (!attacker || (attacker && get_dist(user, attacker) > 1)) && !user.incapacitated() && is_held_twohanded(user))

		var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
		if(check_shield_arc(user, bad_arc, damage_source, attacker))
			if(!prob(user.skill_fail_chance(SKILL_HAULING, 50, SKILL_EXPERIENCED)))
				. = TRUE
				//You hit it!
				playsound(src, pick('sound/items/baseball/baseball_hit_01.wav', 'sound/items/baseball/baseball_hit_02.wav'), 75, 1)
				var/home_run = prob(25)
				if(home_run)
					playsound(src, 'sound/items/baseball/play_ball.wav', 75)
					visible_message(SPAN_NOTICE("\The [user] strikes the incoming [AM] with full force! It's a home run!"))
				else
					visible_message(SPAN_NOTICE("\The [user] hits the incoming [AM], sending it flying back!"))

				user.do_windup_animation(attacker, attack_cooldown)

				addtimer(new Callback(src, .proc/deflect, user, attacker, AM, home_run ? TT.maxrange * 2 : TT.maxrange, home_run ? TT.speed * 2 : TT.speed), 0)

			else
				playsound(src, 'sound/items/baseball/swing_woosh.wav', 75, 1)
				visible_message(SPAN_NOTICE("\The [user] tries to hit the icoming [AM] but misses!"))
				user.do_windup_animation(attacker, attack_cooldown)
				return FALSE //Strike!
		else
			return FALSE

	else
		return ..()

/obj/item/material/twohanded/baseballbat/use_before(obj/O, mob/living/user, click_parameters)
	if(!istype(O))
		return FALSE

	if(is_held_twohanded(user) && !O.anchored && isturf(O.loc) && O.w_class <= ITEM_SIZE_SMALL)
		if(!prob(user.skill_fail_chance(SKILL_HAULING, 20, SKILL_EXPERIENCED)))
			var/skill = 0.25 + (user.get_skill_value(SKILL_HAULING) - SKILL_MIN)/(SKILL_MAX - SKILL_MIN)
			var/dist = O.throw_range * skill
			O.throw_at(get_ranged_target_turf(user, user.dir, dist), dist, O.throw_speed * skill, user, TRUE)
			visible_message(SPAN_NOTICE("\The [user] hits \the [O], sending it flying!"))
			playsound(src, pick('sound/items/baseball/baseball_hit_01.wav', 'sound/items/baseball/baseball_hit_02.wav'), 75, 1)
		else
			playsound(src, 'sound/items/baseball/swing_woosh.wav', 75, 1)
			visible_message(SPAN_NOTICE("\The [user] tries to bat \the [O] but misses!"))
		user.do_attack_animation(O)
		return TRUE

//Predefined materials go here.
/obj/item/material/twohanded/baseballbat/metal/New(newloc)
	..(newloc,MATERIAL_ALUMINIUM)

/obj/item/material/twohanded/baseballbat/uranium/New(newloc)
	..(newloc,MATERIAL_URANIUM)

/obj/item/material/twohanded/baseballbat/gold/New(newloc)
	..(newloc,MATERIAL_GOLD)

/obj/item/material/twohanded/baseballbat/platinum/New(newloc)
	..(newloc,MATERIAL_PLATINUM)

/obj/item/material/twohanded/baseballbat/diamond/New(newloc)
	..(newloc,MATERIAL_DIAMOND)
