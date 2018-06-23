// The following procs are used to grab players for mobs produced by a seed (mostly for dionaea).
/datum/seed/proc/handle_living_product(var/mob/living/host)
	if(!host || !istype(host)) return

	var/datum/ghosttrap/plant/P = get_ghost_trap("living plant")
	P.request_player(host, "Someone is harvesting \a [display_name].", 15 SECONDS)

	spawn(15 SECONDS)
		if(!host.ckey && !host.client)
			host.death()  // This seems redundant, but a lot of mobs don't
			host.set_stat(DEAD) // handle death() properly. Better safe than etc.
			var/obj/item/seeds/S = new(get_turf(host))
			S.seed_type = name
			S.update_seed()
			host.visible_message("<span class='notice'>\The [host] is malformed and unable to survive. It expires pitifully, leaving behind \an [S].</span>")
