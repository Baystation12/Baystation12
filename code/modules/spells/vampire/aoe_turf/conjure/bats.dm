// Summons bats.
/mob/living/carbon/human/proc/vampire_bats()
	name = "Summon Bats (60)"
	desc = "You tear open the Veil for just a moment, in order to summon a pair of bats to assist you in combat."
	blood_cost = 60
	charge_max = 2 MINUTES


	var/list/locs = list()

	for (var/direction in GLOB.alldirs)
		if (locs.len == 2)
			break

		var/turf/T = get_step(src, direction)
		if (AStar(src.loc, T, /turf/proc/AdjacentTurfs, /turf/proc/Distance, 1))
			locs += T

	var/list/spawned = list()
	if (locs.len)
		for (var/turf/to_spawn in locs)
			spawned += new /mob/living/simple_animal/hostile/scarybat(to_spawn, src)

		if (spawned.len != 2)
			spawned += new /mob/living/simple_animal/hostile/scarybat(src.loc, src)
	else
		spawned += new /mob/living/simple_animal/hostile/scarybat(src.loc, src)
		spawned += new /mob/living/simple_animal/hostile/scarybat(src.loc, src)

	if (!spawned.len)
		return

	for (var/mob/living/simple_animal/hostile/scarybat/bat in spawned)
		LAZYADD(bat.friends, src)

		if (vampire.thralls.len)
			LAZYADD(bat.friends, vampire.thralls)

	log_and_message_admins("summoned bats.")
