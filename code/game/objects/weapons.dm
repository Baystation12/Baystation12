/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"
	var/parry_projectiles = 0

/obj/item/weapon/Bump(mob/M as mob)
	spawn(0)
		..()
	return

/obj/item/weapon/handle_shield(var/mob/user, var/damage, var/atom/dam_source = null, var/mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	var/obj/item/damage_source = dam_source
	if(isnull(damage_source))
		return 0
	if(istype(damage_source,/obj/item/projectile) && !parry_projectiles)
		return 0
	//Checks done, Parrycode starts here.//
	if(attacker && istype(attacker,/mob/living) && damage < 5 && (attacker.a_intent == "help" || attacker.a_intent == "grab")) //We don't need to block helpful actions. (Or grabs)
		return 0
	var/parry_chance_divisor = 1
	var/force_half_damage = 0
	var/obj/item/weapon/gun/this_weapon = src
	if(istype(this_weapon) && this_weapon.one_hand_penalty == -1 && !this_weapon.is_held_twohanded(user))//Ensure big twohanded guns are worse at parrying when not twohanded.
		parry_chance_divisor = 2
	if(!prob((BASE_WEAPON_PARRYCHANCE * (w_class - 1))/parry_chance_divisor)) //Do our base parrychance calculation.
		return 0
	else if (attacker)
		visible_message("<span class = 'danger'>[user] parries [attacker]'s [damage_source.name] with their [src.name]</span>")
		playsound(loc, hitsound, 50, 1, -1)
		if(istype(damage_source,/obj/item))
			playsound(loc, damage_source.hitsound, 50, 1, -1)
	else
		visible_message("<span class = 'danger'>[user] deflects [damage_source] with their [src]!</span>")
		playsound(loc, hitsound, 50, 1, -1)

	var/obj/item/item_to_disintegrate
	var/mob/living/mob_holding_disintegrated

	//Grab a set of references to the weapon and person being disintegrated.
	if(istype(damage_source,/obj/item/projectile))
		item_to_disintegrate = damage_source
		mob_holding_disintegrated = null
	else if(parry_slice_objects && !damage_source.parry_slice_objects && !damage_source.unacidable)
		item_to_disintegrate = damage_source
		mob_holding_disintegrated = attacker
	else if(damage_source.parry_slice_objects && !unacidable)
		item_to_disintegrate = src
		mob_holding_disintegrated = user

	if(isnull(item_to_disintegrate))
		return 1

	if(!isnull(item_to_disintegrate) && istype(item_to_disintegrate,/obj/item/weapon/gun) && !prob(BASE_PARRY_PLASMA_DESTROY))
		force_half_damage = 1

	if(force_half_damage)
		to_chat(user,"<span class = 'warning'>[src] fails to fully deflect [attacker]'s attack!</span>")
		var/orig_force = item_to_disintegrate.force
		item_to_disintegrate.force /= 2
		spawn(2)
			item_to_disintegrate.force = orig_force
		return 0
	if(damage_source && !mob_holding_disintegrated)
		visible_message("<span class = 'danger'>[user] slices [damage_source] in half!</span>")
	else
		visible_message("<span class = 'danger'>[item_to_disintegrate == damage_source ? "[user]" : "[attacker]"] cuts through [mob_holding_disintegrated]'s [item_to_disintegrate.name] with their [item_to_disintegrate == damage_source ? "[src.name]" : "[damage_source.name]"], rendering it useless!</span>")
	if(mob_holding_disintegrated)
		mob_holding_disintegrated.drop_from_inventory(item_to_disintegrate)
	new /obj/effect/decal/cleanable/ash (item_to_disintegrate.loc)
	new /obj/item/metalscrap (item_to_disintegrate.loc)
	qdel(item_to_disintegrate)

	return 1
