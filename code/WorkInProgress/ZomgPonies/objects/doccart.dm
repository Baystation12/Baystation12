/obj/structure/stool/bed/chair/ambulance
	name = "ambulance"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "docwagon"
	anchored = 1
	density = 1
/var/brightness = 4
/var/strobe = 0


/obj/structure/stool/bed/chair/ambulance/New()
	handle_rotation()


/obj/structure/stool/bed/chair/ambulance/examine()
	set src in usr
	usr << "\icon[src] This is a specially designed ambulance unit for Emergency Medical Personel"

/obj/structure/stool/bed/chair/janicart/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/key/ambulance))
		user << "Hold [W] in one of your hands while you drive this ambulance so noone steals it from you!."


/obj/structure/stool/bed/chair/ambulance/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle()
	if(istype(user.l_hand, /obj/item/key/ambulance) || istype(user.r_hand, /obj/item/key/ambulance))
		step(src, direction)
		update_mob()
		handle_rotation()
	else
		user << "<span class='notice'>You'll need the keys in one of your hands to drive this ambulance.</span>"

/obj/structure/stool/bed/chair/ambulance/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = loc

/obj/structure/stool/bed/chair/ambulance/buckle_mob(mob/M, mob/user)
	if(M != user || !ismob(M) || get_dist(src, user) > 1 || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon))
		return


	unbuckle()
	M.visible_message(\
		"<span class='notice'>[M] climbs onto the ambulance!</span>",\
		"<span class='notice'>You climb onto the ambulance!</span>")
	M.buckled = src
	M.loc = loc
	M.dir = dir
	M.update_canmove()
	buckled_mob = M
	update_mob()
	add_fingerprint(user)
	strobe = 1
	icon_state = "docwagon2"
	return
//Add red strobe effect call to this section


/obj/structure/stool/bed/chair/ambulance/unbuckle()
	if(buckled_mob)
		buckled_mob.pixel_x = 0
		buckled_mob.pixel_y = 0
	strobe = 0
	icon_state = "docwagon"
	..()

/obj/structure/stool/bed/chair/ambulance/handle_rotation()
	if(dir == SOUTH)
		layer = FLY_LAYER
	else
		layer = OBJ_LAYER

	if(buckled_mob)
		if(buckled_mob.loc != loc)
			buckled_mob.buckled = null //Temporary, so Move() succeeds.
			buckled_mob.buckled = src //Restoring

	update_mob()

/obj/structure/stool/bed/chair/ambulance/proc/update_mob()
	if(buckled_mob)
		buckled_mob.dir = dir
		switch(dir)
			if(SOUTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 7
			if(WEST)
				buckled_mob.pixel_x = 13
				buckled_mob.pixel_y = 7
			if(NORTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(EAST)
				buckled_mob.pixel_x = -13
				buckled_mob.pixel_y = 7

/obj/structure/stool/bed/chair/ambulance/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob)
		if(prob(65))
			return buckled_mob.bullet_act(Proj)
	visible_message("<span class='warning'>[Proj] ricochets off the ambulance!</span>")

/obj/item/key/ambulance
	name = "ambulance key"
	desc = "A keyring with a small steel key, and tag with a red cross on it."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keydoc"
	w_class = 1


	/*
/proc/ambulance/strobelight()
if (strobe)
	for ALLTURF(range(1,mob))
		icon = 'icons/turf/areas.dmi'
		icon_state = "red"
*/