/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"

/obj/item/weapon/Bump(mob/M as mob)
	spawn(0)
		..()
	return

/obj/item/weapon/handle_shield(var/mob/user, var/damage, var/atom/dam_source = null, var/mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	var/obj/item/damage_source = dam_source
	if(!attacker)
		return 0
	if(istype(damage_source,/obj/item/projectile))
		return 0
	//Checks done, Parrycode starts here.//
	if(attacker.a_intent == "help") //We don't need to block helpful actions.
		return 0
	var/parry_chance_divisor = 1
	var/obj/item/weapon/gun/this_weapon = src
	if(istype(this_weapon) && this_weapon.one_hand_penalty == -1 && !this_weapon.is_held_twohanded(user))//Ensure big twohanded guns are worse at parrying when not twohanded.
		parry_chance_divisor = 2
	if(!prob((BASE_WEAPON_PARRYCHANCE * (w_class - 1))/parry_chance_divisor)) //Do our base parrychance calculation.
		return 0
	if(!damage_source || damage_source == attacker)
		visible_message("<span class = 'danger'>[user] counters [attacker]'s unarmed attack with their [src.name]!</span>")
		attack(attacker,user,pick("l_arm","r_arm","chest"))
		return 1
	else
		visible_message("<span class = 'danger'>[user] parries [attacker]'s [damage_source.name] with their [src.name]</span>")
		playsound(loc, hitsound, 50, 1, -1)
		playsound(loc, damage_source.hitsound, 50, 1, -1)

	var/obj/item/item_to_disintegrate
	var/mob/living/mob_holding_disintegrated

	//Grab a set of references to the weapon and person being disintegrated.
	if(istype(src,/obj/item/weapon/melee/energy/elite_sword) && !istype(damage_source,/obj/item/weapon/melee/energy/elite_sword))
		item_to_disintegrate = damage_source
		mob_holding_disintegrated = attacker
	if(istype(damage_source,/obj/item/weapon/melee/energy/elite_sword) && !istype(src,/obj/item/weapon/melee/energy/elite_sword))
		item_to_disintegrate = src
		mob_holding_disintegrated = user

	if(isnull(item_to_disintegrate) || isnull(mob_holding_disintegrated))
		return 1

	if(istype(item_to_disintegrate,/obj/item/weapon/gun) && !prob(BASE_PARRY_PLASMA_DESTROY))
		visible_message("<span class = 'danger'>[item_to_disintegrate == damage_source ? "[user]":"[attacker]" ]</span>")
		return 1

	visible_message("<span class = 'danger'>[item_to_disintegrate == damage_source ? "[user]" : "[attacker]"] cuts through [mob_holding_disintegrated]'s [item_to_disintegrate.name] with their [item_to_disintegrate == damage_source ? "[src.name]" : "[damage_source.name]"], rendering it useless!</span>")
	mob_holding_disintegrated.drop_from_inventory(item_to_disintegrate)
	new /obj/effect/decal/cleanable/ash (item_to_disintegrate.loc)
	new /obj/item/metalscrap (item_to_disintegrate.loc)
	qdel(item_to_disintegrate)

	return 1
