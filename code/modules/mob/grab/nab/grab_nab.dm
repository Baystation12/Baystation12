/obj/item/grab/nab

	type_name = GRAB_NAB
	start_grab_name = NAB_PASSIVE

/obj/item/grab/nab/init()
	if(!(. = ..()))
		return
	assailant.unEquip(assailant.get_inactive_hand())
	visible_message("<span class='warning'>[assailant] has nabbed [affecting] passively!</span>")

/datum/grab/nab

	type_name = GRAB_NAB

	icon = 'icons/mob/screen1.dmi'

	stop_move = 1
	force_stand = 1
	reverse_facing = 1
	can_absorb = 1
	shield_assailant = 1
	point_blank_mult = 1
	same_tile = 1
	ladder_carry = 1
	force_danger = 1
	can_grab_self = 0

/datum/grab/nab/on_hit_grab(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	var/crush_damage = rand(8,14)

	affecting.visible_message("<span class='danger'>[assailant] begins crushing [affecting]!</span>")
	G.attacking = 1
	if(do_after(assailant, action_cooldown - 1, affecting, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		G.attacking = 0
		G.action_used()
		crush(G, crush_damage)
		return 1
	else
		G.attacking = 0
		affecting.visible_message("<span class='notice'>[assailant] stops crushing [affecting]!</span>")
		return 0

/datum/grab/nab/on_hit_harm(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	var/masticate_damage = rand(15,20)

	affecting.visible_message("<span class='danger'>[assailant] begins chewing on [affecting]!</span>")
	G.attacking = 1

	if(do_after(assailant, action_cooldown - 1, affecting, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		G.attacking = 0
		G.action_used()
		masticate(G, masticate_damage)
		return 1
	else
		G.attacking = 0
		affecting.visible_message("<span class='notice'>[assailant] stops chewing on [affecting].</span>")
		return 0

// This causes the assailant to crush the affecting mob. There is a chance that the crush will cause the
// forelimb spikes to dig into the affecting mob, doing extra damage and likely causing them to bleed.
/datum/grab/nab/proc/crush(var/obj/item/grab/G, var/attack_damage)
	var/obj/item/organ/external/damaging = G.get_targeted_organ()
	var/hit_zone = G.target_zone
	G.affecting.visible_message("<span class='danger'>[G.assailant] crushes [G.affecting]'s [damaging.name]!</span>")

	if(prob(30))
		var/hit_damage = max(attack_damage + 10, 15)
		G.affecting.apply_damage(hit_damage, DAMAGE_BRUTE, hit_zone, DAMAGE_FLAG_SHARP, used_weapon = "organic punctures")
		var/armor = 100 * G.affecting.get_blocked_ratio(hit_zone, DAMAGE_BRUTE, damage = hit_damage)
		G.affecting.apply_effect(attack_damage, EFFECT_PAIN, armor)
		G.affecting.visible_message("<span class='danger'>[G.assailant]'s spikes dig in painfully!</span>")
	else
		G.affecting.apply_damage(attack_damage, DAMAGE_BRUTE, hit_zone, used_weapon = "crushing")
	playsound(get_turf(G.assailant), 'sound/weapons/bite.ogg', 25, 1, -1)

	admin_attack_log(G.assailant, G.affecting, "Crushed their victim.", "Was crushed.", "crushed")

// This causes the assailant to chew on the affecting mob.
/datum/grab/nab/proc/masticate(var/obj/item/grab/G, var/attack_damage)
	var/hit_zone = G.assailant.zone_sel.selecting
	var/obj/item/organ/external/damaging = G.affecting.get_organ(hit_zone)

	G.affecting.apply_damage(attack_damage, DAMAGE_BRUTE, hit_zone, DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE, used_weapon = "mandibles")
	G.affecting.visible_message("<span class='danger'>[G.assailant] chews on [G.affecting]'s [damaging.name]!</span>")
	playsound(get_turf(G.assailant), 'sound/weapons/bite.ogg', 25, 1, -1)

	admin_attack_log(G.assailant, G.affecting, "Chews their victim.", "Was chewed.", "chewed")
