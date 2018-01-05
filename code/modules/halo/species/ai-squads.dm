
/mob/living/simple_animal/hostile/covenant //Could be moved later on if more mobs are added to summonable squads.
	var/mob/leader

/mob/living/simple_animal/hostile/covenant/Life() //All covie simplemobs should be able to act as followers.
	if(leader)
		if(target_mob)
			return ..()
		else
			walk_towards(src,leader,world.tick_lag,src.speed)
	return ..()

/mob/living/simple_animal/hostile/covenant/grunt //Can be replaced later on when proper simplemob grunts are implemented
	name = "Grunt"
	desc = "" //Need suggestions for a good description
	faction = "Covenant"
	icon = 'code/modules/halo/icons/Grunt.dmi'
	icon_state = "Grunt_mob"
	icon_living = "Grunt_mob"
	icon_dead = "Grunt_mob_dead"
	ranged = 1
	destroy_surroundings = 0
	projectiletype = /obj/item/projectile/covenant/plasmapistol
	projectilesound = 'code/modules/halo/sounds/haloplasmapistol.ogg'

/mob/living/carbon/human/covenant/sangheili/proc/grunts()
	set category = "Abilities"
	set name = "Summon Grunts"
	set desc = "Summon a small team of grunts to assist in your fight."

	if(world.time >= last_special)
		last_special = world.time + 1200
		new /datum/squads/grunt (src)

/datum/squads
	var/mob/living/leader
	var/insquad[0]

/datum/squads/New(var/source)
	leader = source
	make_squad()

/datum/squads/proc/make_squad()
	for(var/m in insquad)
		var/mob/living/simple_animal/hostile/covenant/h = new m (leader)
		h.loc = leader.loc
		h.leader = src.leader
		to_chat(leader,"GRUNTS SUMMONED")

/datum/squads/grunt
	insquad = list(
	/mob/living/simple_animal/hostile/covenant/grunt,
	/mob/living/simple_animal/hostile/covenant/grunt,
	/mob/living/simple_animal/hostile/covenant/grunt)
