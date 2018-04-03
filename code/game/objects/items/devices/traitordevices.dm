/*

Miscellaneous traitor devices

BATTERER


*/

/*

The Batterer, like a flashbang but 50% chance to knock people over. Can be either very
effective or pretty fucking useless.

*/

/obj/item/device/batterer
	name = "mind batterer"
	desc = "A strange device with twin antennas."
	icon_state = "batterer"
	throwforce = 5
	w_class = ITEM_SIZE_TINY
	throw_speed = 4
	throw_range = 10
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 3, TECH_ILLEGAL = 3)

	var/times_used = 0 //Number of times it's been used.
	var/max_uses = 2

/obj/item/device/batterer/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if(!user) 	return
	if(times_used >= max_uses)
		to_chat(user, "<span class='warning'>The mind batterer has been burnt out!</span>")
		return

	var/list/stun_victims = list()
	for(var/mob/living/carbon/human/M in orange(10, user))
		stun_victims += M
		spawn()
			if(prob(50))
				M.Weaken(rand(10,20))
				if(prob(25))
					M.Stun(rand(5,10))
				to_chat(M, "<span class='danger'>You feel a tremendous, paralyzing wave flood your mind.</span>")
			else
				to_chat(M, "<span class='danger'>You feel a sudden, electric jolt travel through your head.</span>")

	admin_attacker_log_many_victims(user, stun_victims, "Used \a [src] to attempt to knockdown their victim.", "Was subject to a knockdown attempt.", ", using \a [src], attempted to knockdown")

	playsound(src.loc, 'sound/misc/interference.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You trigger [src].</span>")
	times_used += 1
	if(times_used >= max_uses)
		icon_state = "battererburnt"
