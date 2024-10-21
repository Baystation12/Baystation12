/obj/item/projectile/beam/lasertag
	name = "lasertag beam"
	icon_state = "lasertag"
	damage = 0
	no_attack_log = TRUE
	damage_type = DAMAGE_BURN

	muzzle_type = /obj/projectile/laser/blue/muzzle
	tracer_type = /obj/projectile/laser/blue/tracer
	impact_type = /obj/projectile/laser/blue/impact

	/// String. Human readable name of the team color.
	var/team_name


/obj/item/projectile/beam/lasertag/on_hit(atom/target, blocked, def_zone)
	. = TRUE
	if (!ishuman(target))
		return
	var/mob/living/carbon/human/human = target
	if (!istype(human.wear_suit, /obj/item/clothing/suit/lasertag))
		return
	var/obj/item/clothing/suit/lasertag/armor = human.wear_suit
	if (team_name == armor.team_name)
		return
	human.Weaken(5)


/obj/projectile/laser/lasertag/set_color(color)
	..()
	set_light(l_color = color)


/obj/projectile/laser/lasertag/tracer
	icon_state = "beam_blue"


/obj/projectile/laser/lasertag/muzzle
	icon_state = "muzzle_blue"


/obj/projectile/laser/lasertag/impact
	icon_state = "impact_blue"
