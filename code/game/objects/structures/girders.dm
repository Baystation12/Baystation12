/obj/structure/girder
	icon_state = "girder"
	anchored = 1
	density = 1
	layer = 2
	var/state = 0
	var/health = 200
	var/cover = 50 //how much cover the girder provides against projectiles.
	var/material/reinf_material

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = 0
	health = 50
	cover = 25

/obj/structure/girder/attack_generic(var/mob/user, var/damage, var/attack_message = "smashes apart", var/wallbreaker)
	if(!damage || !wallbreaker)
		return 0
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	spawn(1) dismantle()
	return 1

/obj/structure/girder/bullet_act(var/obj/item/projectile/Proj)
	//Girders only provide partial cover. There's a chance that the projectiles will just pass through. (unless you are trying to shoot the girder)
	if(Proj.original != src && !prob(cover))
		return PROJECTILE_CONTINUE //pass through

	//Tasers and the like should not damage girders.
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	var/damage = Proj.damage
	if(!istype(Proj, /obj/item/projectile/beam))
		damage *= 0.4 //non beams do reduced damage

	health -= damage
	..()
	if(health <= 0)
		dismantle()

	return

/obj/structure/girder/proc/reset_girder()
	cover = initial(cover)
	health = min(health,initial(health))
	state = 0
	icon_state = initial(icon_state)
	if(reinf_material)
		reinforce_girder()

/obj/structure/girder/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench) && state == 0)
		if(anchored && !reinf_material)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			user << "<span class='notice'>Now disassembling the girder...</span>"
			if(do_after(user,40))
				if(!src) return
				user << "<span class='notice'>You dissasembled the girder!</span>"
				dismantle()
		else if(!anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			user << "<span class='notice'>Now securing the girder...</span>"
			if(get_turf(user, 40))
				user << "<span class='notice'>You secured the girder!</span>"
				reset_girder()

	else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		user << "<span class='notice'>Now slicing apart the girder...</span>"
		if(do_after(user,30))
			if(!src) return
			user << "<span class='notice'>You slice apart the girder!</span>"
			dismantle()

	else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		user << "<span class='notice'>You drill through the girder!</span>"
		dismantle()

	else if(istype(W, /obj/item/weapon/screwdriver) && state == 2)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		user << "<span class='notice'>Now unsecuring support struts...</span>"
		if(do_after(user,40))
			if(!src) return
			user << "<span class='notice'>You unsecured the support struts!</span>"
			state = 1

	else if(istype(W, /obj/item/weapon/wirecutters) && state == 1)
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user << "<span class='notice'>Now removing support struts...</span>"
		if(do_after(user,40))
			if(!src) return
			user << "<span class='notice'>You removed the support struts!</span>"
			reinf_material.place_dismantled_product(get_turf(src))
			reinf_material = null
			reset_girder()

	else if(istype(W, /obj/item/weapon/crowbar) && state == 0 && anchored)
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		user << "<span class='notice'>Now dislodging the girder...</span>"
		if(do_after(user, 40))
			if(!src) return
			user << "<span class='notice'>You dislodged the girder!</span>"
			icon_state = "displaced"
			anchored = 0
			health = 50
			cover = 25

	else if(istype(W, /obj/item/stack/material))

		var/obj/item/stack/material/S = W
		if(S.get_amount() < 2)
			return ..()

		var/material/M = name_to_material[S.default_type]
		if(!istype(M))
			return ..()

		var/wall_fake
		add_hiddenprint(usr)

		if(M.integrity < 50)
			user << "<span class='notice'>This material is too soft for use in wall construction.</span>"
			return

		user << "<span class='notice'>You begin adding the plating...</span>"

		if(!do_after(user,40) || !S.use(2))
			return

		if(anchored)
			user << "<span class='notice'>You added the plating!</span>"
		else
			user << "<span class='notice'>You create a false wall! Push on it to open or close the passage.</span>"
			wall_fake = 1

		var/turf/Tsrc = get_turf(src)
		Tsrc.ChangeTurf(/turf/simulated/wall)
		var/turf/simulated/wall/T = get_turf(src)
		T.set_material(M, reinf_material)
		if(wall_fake)
			T.can_open = 1
		T.add_hiddenprint(usr)
		qdel(src)
		return

	else if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
			user.drop_item()
			P.loc = src.loc
			user << "<span class='notice'>You fit the pipe into the [src]!"
	else
		..()

/obj/structure/girder/proc/reinforce_girder()
	cover = reinf_material.hardness
	health = 500
	state = 2
	icon_state = "reinforced"

/obj/structure/girder/verb/reinforce_with_material()
	set name = "Reinforce girder"
	set desc = "Reinforce a girder with metal."
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user) || !(user.l_hand || user.r_hand))
		return

	if(reinf_material)
		user << "\The [src] is already reinforced."
		return

	var/obj/item/stack/material/S = user.l_hand
	if(!istype(S))
		S = user.r_hand
	if(!istype(S))
		user << "You cannot plate \the [src] with that."
		return

	if(S.get_amount() < 2)
		user << "There is not enough material here to reinforce the girder."
		return

	var/material/M = name_to_material[S.default_type]
	if(!istype(M) || M.integrity < 50)
		user << "You cannot reinforce \the [src] with that; it is too soft."
		return

	user << "<span class='notice'>Now reinforcing...</span>"
	if (!do_after(user,40) || !S.use(2))
		return
	user << "<span class='notice'>You added reinforcement!</span>"

	reinf_material = M
	reinforce_girder()


/obj/structure/girder/proc/dismantle()
	new /obj/item/stack/material/steel(get_turf(src))
	qdel(src)

/obj/structure/girder/attack_hand(mob/user as mob)
	if (HULK in user.mutations)
		visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
		dismantle()
		return
	return ..()

/obj/structure/girder/blob_act()
	if(prob(40))
		qdel(src)


/obj/structure/girder/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(30))
				dismantle()
			return
		if(3.0)
			if (prob(5))
				dismantle()
			return
		else
	return

/obj/structure/girder/cult
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	health = 250
	cover = 70

/obj/structure/girder/cult/dismantle()
	new /obj/effect/decal/remains/human(get_turf(src))
	qdel(src)

/obj/structure/girder/cult/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		user << "<span class='notice'>Now disassembling the girder...</span>"
		if(do_after(user,40))
			user << "<span class='notice'>You dissasembled the girder!</span>"
			dismantle()

	else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		user << "<span class='notice'>Now slicing apart the girder..."
		if(do_after(user,30))
			user << "<span class='notice'>You slice apart the girder!</span>"
		dismantle()

	else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		user << "<span class='notice'>You drill through the girder!</span>"
		new /obj/effect/decal/remains/human(get_turf(src))
		dismantle()
