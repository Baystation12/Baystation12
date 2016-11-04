/datum/technomancer/spell/chain_lightning
	name = "Chain Lightning"
	desc = "This dangerous function shoots lightning that will strike someone, then bounce to a nearby person.  Be careful that \
	it does not bounce to you.  The lighting prefers to bounce to people with the least resistance to electricity.  It will \
	strike up to four targets, including yourself if conditions allow it to occur."
	cost = 150
	obj_path = /obj/item/weapon/spell/projectile/chain_lightning
	ability_icon_state = "tech_chain_lightning"
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/projectile/chain_lightning
	name = "chain lightning"
	icon_state = "chain_lightning"
	desc = "Fun for the whole security team!  Just don't kill yourself in the process.."
	cast_methods = CAST_RANGED
	aspect = ASPECT_SHOCK
	spell_projectile = /obj/item/projectile/beam/chain_lightning
	energy_cost_per_shot = 3000
	instability_per_shot = 10
	cooldown = 20
	fire_sound = 'sound/weapons/blaster.ogg'

/obj/item/projectile/beam/chain_lightning
	name = "lightning"
	icon_state = "lightning"
	nodamage = 1
	damage_type = HALLOSS

	muzzle_type = /obj/effect/projectile/lightning/muzzle
	tracer_type = /obj/effect/projectile/lightning/tracer
	impact_type = /obj/effect/projectile/lightning/impact

	var/bounces = 3				//How many times it 'chains'.  Note that the first hit is not counted as it counts /bounces/.
	var/list/hit_mobs = list() 	//Mobs which were already hit.
	var/power = 20				//How hard it will hit for with electrocute_act(), decreases with each bounce.

/obj/item/projectile/beam/chain_lightning/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	//First we shock the guy we just hit.
	if(ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_CHEST))
		H.electrocute_act(power, src, H.get_siemens_coefficient_organ(affected), affected)
	else
		target_mob.electrocute_act(power, src, 1.0, BP_CHEST)
	hit_mobs |= target_mob

	//Each bounce reduces the damage of the bolt.
	power = power * 0.80
	if(bounces)
		//All possible targets.
		var/list/potential_targets = view(target_mob, 3)

		//Filtered targets, so we don't hit the same person twice.
		var/list/filtered_targets = list()
		for(var/mob/living/L in potential_targets)
			if(L in hit_mobs)
				continue
			filtered_targets |= L

		var/mob/living/new_target = null
		var/siemens_comparison = 0

		for(var/mob/living/carbon/human/H in filtered_targets)
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_CHEST))
			var/their_siemens = H.get_siemens_coefficient_organ(affected)
			if(their_siemens > siemens_comparison) //We want as conductive as possible, so higher is better.
				new_target = H
				siemens_comparison = their_siemens

		if(new_target)
			var/turf/curloc = get_turf(target_mob)
			curloc.visible_message("<span class='danger'>\The [src] bounces to \the [new_target]!</span>")
			redirect(new_target.x, new_target.y, curloc, firer)
			bounces--

			return 0
	return 1



