// Targeted teleportation, must be to a low-light tile.
/spell/hand/vampire/veilstep
	school = "vampirism"
	name = "Veil Step"
	desc = "For a moment, move through the Veil and emerge at a shadow of your choice."
	invokation = SpI_NONE
	blood_cost = 20
	charge_max = 30 SECONDS


/spell/hand/vampire/veilstep/cast_hand(var/turf/T, var/mob/user)
	if (!T || T.density || T.contains_dense_objects())
		to_chat(src, "<span class='warning'>You cannot do that.</span>")
		return

	var/datum/vampire/vampire = vampire_power(20, 1)
	if (!vampire)
		return

	if (!istype(loc, /turf))
		to_chat(src, "<span class='warning'>You cannot teleport out of your current location.</span>")
		return

	if (T.z != src.z || get_dist(T, get_turf(src)) > world.view)
		to_chat(src, "<span class='warning'>Your powers are not capable of taking you that far.</span>")
		return

	if (!T.dynamic_lighting || T.get_lumcount() > 0.1)
		// Too bright, cannot jump into.
		to_chat(src, "<span class='warning'>The destination is too bright.</span>")
		return

	vampire_phase_out(get_turf(loc))

	forceMove(T)

	vampire_phase_in(T)

	for (var/obj/item/grab/G in contents)
		if (G.affecting && (vampire.status & VAMP_FULLPOWER))
			G.affecting.vampire_phase_out(get_turf(G.affecting.loc))
			G.affecting.forceMove(locate(T.x + rand(-1,1), T.y + rand(-1,1), T.z))
			G.affecting.vampire_phase_in(get_turf(G.affecting.loc))
		else
			qdel(G)

	log_and_message_admins("activated veil step.")
	return ..()
