
#define WATCHER_IDLE_ROBOHEAL -5
#define WATCHER_IDLE_ARMOURREPAIR 2

/mob/living/simple_animal/hostile/watcher
	name = "Watcher"
	desc = "A fragment of a Knight's personality. These provide support to troops, with light damage capabilities."
	faction = "Forerunner"
	icon = 'code/modules/halo/Forerunner/watcher.dmi'
	icon_state = "watcher_active"
	icon_living = "watcher_active"
	icon_dead = "watcher"
	universal_speak = 1
	universal_understand = 1
	response_harm = "batters"
	health = 150
	maxHealth = 150
	ranged = 1
	move_to_delay = 5
	resistance = 15
	speak_chance = 0
	pixel_x = -12
	speak = list()
	emote_see = list("rotates its flight-rings","scans its body for damage","scans the environment")
	emote_hear = list("buzzes")

	possible_weapons = list(/obj/item/weapon/gun/projectile/boltshot,/obj/item/weapon/gun/projectile/boltshot/shotgun_preload)
	possible_grenades = list(/obj/item/weapon/grenade/splinter)

	death_sounds = list('code/modules/halo/sounds/forerunner/sentDeath1.ogg','code/modules/halo/sounds/forerunner/sentDeath2.ogg','code/modules/halo/sounds/forerunner/sentDeath3.ogg','code/modules/halo/sounds/forerunner/sentDeath4.ogg')

/mob/living/simple_animal/hostile/watcher/Life()
	if(isturf(src.loc) || istype(src.loc,/obj/vehicles))
		if(!stat)
			if(stance == HOSTILE_STANCE_IDLE)
				var/did_something = 0
				for(var/mob/living/carbon/human/h in view(3,loc))
					for(var/obj/item/organ/o in h.internal_organs|h.organs)
						if(o.damage == 0)
							continue
						if(o.robotic)
							var/obj/item/organ/external/e = o
							if(istype(e))
								e.heal_damage(-WATCHER_IDLE_ROBOHEAL, -WATCHER_IDLE_ROBOHEAL, 1, 1)
							else
								o.take_damage(WATCHER_IDLE_ROBOHEAL,1)
							did_something = 1
					for(var/obj/item/clothing/c in h.contents)
						if(c.armor_thickness < c.armor_thickness_max)
							c.armor_thickness = min(c.armor_thickness + WATCHER_IDLE_ARMOURREPAIR,c.armor_thickness_max)
							did_something = 1
				if(did_something)
					visible_message("<span class = 'warning'>[src] pulses, repairing nearby electronics and armour</span>")

	. = ..()

/mob/living/simple_animal/hostile/watcher/doRoll(var/rolldir,var/roll_dist,var/roll_delay)
	var/turf/endpoint = null
	var/turf/step_to = loc
	for(var/i = 0,i < roll_dist,i++)
		step_to = get_step(step_to,rolldir)
		if(step_to.density == 0)
			endpoint = step_to
	if(endpoint && endpoint.density == 0)
		new /obj/effect/knightroll_tp(loc)
		new /obj/effect/knightroll_tp (endpoint)
		forceMove(endpoint)

/mob/living/simple_animal/hostile/watcher/death()
	new /obj/effect/knightroll_tp (loc)
	qdel(src)

