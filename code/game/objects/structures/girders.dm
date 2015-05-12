/obj/structure/girder
	icon_state = "girder"
	anchored = 1
	density = 1
	layer = 2
	var/state = 0
	var/health = 200
	var/cover = 50 //how much cover the girder provides against projectiles.

/obj/structure/girder/attack_generic(var/mob/user, var/damage, var/attack_message = "smashes apart", var/wallbreaker)
	if(!damage || !wallbreaker)
		return 0
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	spawn(1) dismantle()
	return 1

/obj/structure/girder/bullet_act(var/obj/item/projectile/Proj)
	//Girders only provide partial cover. There's a chance that the projectiles will just pass through. (unless you are trying to shoot the girder)
	if(Proj.original != src && !prob(cover))
		return -1 //pass through

	//Tasers and the like should not damage girders.
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	var/damage = Proj.damage
	if(!istype(Proj, /obj/item/projectile/beam))
		damage *= 0.4 //non beams do reduced damage

	health -= damage
	..()
	if(health <= 0)
		new /obj/item/stack/sheet/metal(get_turf(src))
		qdel(src)

	return

/obj/structure/girder/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench) && state == 0)
		if(anchored && !istype(src,/obj/structure/girder/displaced))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			user << "\blue Now disassembling the girder"
			if(do_after(user,40))
				if(!src) return
				user << "\blue You dissasembled the girder!"
				dismantle()
		else if(!anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			user << "\blue Now securing the girder"
			if(get_turf(user, 40))
				user << "\blue You secured the girder!"
				new/obj/structure/girder( src.loc )
				qdel(src)

	else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		user << "\blue Now slicing apart the girder"
		if(do_after(user,30))
			if(!src) return
			user << "\blue You slice apart the girder!"
			dismantle()

	else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		user << "\blue You drill through the girder!"
		dismantle()

	else if(istype(W, /obj/item/weapon/screwdriver) && state == 2 && istype(src,/obj/structure/girder/reinforced))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		user << "\blue Now unsecuring support struts"
		if(do_after(user,40))
			if(!src) return
			user << "\blue You unsecured the support struts!"
			state = 1

	else if(istype(W, /obj/item/weapon/wirecutters) && istype(src,/obj/structure/girder/reinforced) && state == 1)
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user << "\blue Now removing support struts"
		if(do_after(user,40))
			if(!src) return
			user << "\blue You removed the support struts!"
			new/obj/structure/girder( src.loc )
			qdel(src)

	else if(istype(W, /obj/item/weapon/crowbar) && state == 0 && anchored )
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		user << "\blue Now dislodging the girder"
		if(do_after(user, 40))
			if(!src) return
			user << "\blue You dislodged the girder!"
			new/obj/structure/girder/displaced( src.loc )
			qdel(src)

	else if(istype(W, /obj/item/stack/sheet))

		var/obj/item/stack/sheet/S = W
		switch(S.type)

			if(/obj/item/stack/sheet/metal, /obj/item/stack/sheet/metal/cyborg)
				if(!anchored)
					if(S.use(2))
						user << "<span class='notice'>You create a false wall! Push on it to open or close the passage.</span>"
						new /obj/structure/falsewall (src.loc)
						qdel(src)
				else
					if(S.get_amount() < 2) return ..()
					user << "<span class='notice'>Now adding plating...</span>"
					if (do_after(user,40))
						if (S.use(2))
							user << "<span class='notice'>You added the plating!</span>"
							var/turf/Tsrc = get_turf(src)
							Tsrc.ChangeTurf(/turf/simulated/wall)
							for(var/turf/simulated/wall/X in Tsrc.loc)
								if(X)	X.add_hiddenprint(usr)
							qdel(src)
					return

			if(/obj/item/stack/sheet/plasteel, /obj/item/stack/sheet/plasteel/cyborg)
				if(!anchored)
					if(S.use(2))
						user << "\blue You create a false wall! Push on it to open or close the passage."
						new /obj/structure/falserwall (src.loc)
						qdel(src)
				else
					if (src.icon_state == "reinforced") //I cant believe someone would actually write this line of code...
						if(S.get_amount() < 1) return ..()
						user << "<span class='notice'>Now finalising reinforced wall.</span>"
						if(do_after(user, 50))
							if (S.use(1))
								user << "<span class='notice'>Wall fully reinforced!</span>"
								var/turf/Tsrc = get_turf(src)
								Tsrc.ChangeTurf(/turf/simulated/wall/r_wall)
								for(var/turf/simulated/wall/r_wall/X in Tsrc.loc)
									if(X)	X.add_hiddenprint(usr)
								qdel(src)
						return
					else
						if(S.get_amount() < 1) return ..()
						user << "<span class='notice'>Now reinforcing girders...</span>"
						if (do_after(user,60))
							if(S.use(1))
								user << "<span class='notice'>Girders reinforced!</span>"
								new/obj/structure/girder/reinforced( src.loc )
								qdel(src)
						return

		if(S.sheettype)
			var/M = S.sheettype
			// Ugly hack, will suffice for now. Need to fix it upstream as well, may rewrite mineral walls. ~Z
			if(M in list("mhydrogen","osmium","tritium","platinum","iron"))
				user << "You cannot plate the girder in that material."
				return
			if(!anchored)
				if(S.amount < 2) return
				S.use(2)
				user << "\blue You create a false wall! Push on it to open or close the passage."
				var/F = text2path("/obj/structure/falsewall/[M]")
				new F (src.loc)
				qdel(src)
			else
				if(S.amount < 2) return ..()
				user << "\blue Now adding plating..."
				if (do_after(user,40))
					if(!src || !S || S.amount < 2) return
					S.use(2)
					user << "\blue You added the plating!"
					var/turf/Tsrc = get_turf(src)
					Tsrc.ChangeTurf(text2path("/turf/simulated/wall/mineral/[M]"))
					for(var/turf/simulated/wall/mineral/X in Tsrc.loc)
						if(X)	X.add_hiddenprint(usr)
					qdel(src)
				return

		add_hiddenprint(usr)

	else if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
			user.drop_item()
			P.loc = src.loc
			user << "\blue You fit the pipe into the [src]!"
	else
		..()

/obj/structure/girder/proc/dismantle()
	new /obj/item/stack/sheet/metal(get_turf(src))
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
				var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
				new remains(loc)
				qdel(src)
			return
		if(3.0)
			if (prob(5))
				var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
				new remains(loc)
				qdel(src)
			return
		else
	return

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = 0
	health = 50
	cover = 25

/obj/structure/girder/reinforced
	icon_state = "reinforced"
	state = 2
	health = 500
	cover = 80

/obj/structure/cultgirder
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	anchored = 1
	density = 1
	layer = 2
	var/health = 250
	var/cover = 70

/obj/structure/cultgirder/attack_generic(var/mob/user, var/damage, var/attack_message = "smashes apart", var/wallbreaker)
	if(!damage || !wallbreaker)
		return 0
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	dismantle()
	return 1

/obj/structure/cultgirder/proc/dismantle()
	new /obj/effect/decal/remains/human(get_turf(src))
	qdel(src)

/obj/structure/cultgirder/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		user << "\blue Now disassembling the girder"
		if(do_after(user,40))
			user << "\blue You dissasembled the girder!"
			dismantle()

	else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		user << "\blue Now slicing apart the girder"
		if(do_after(user,30))
			user << "\blue You slice apart the girder!"
		dismantle()

	else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		user << "\blue You drill through the girder!"
		new /obj/effect/decal/remains/human(get_turf(src))
		dismantle()

/obj/structure/cultgirder/blob_act()
	if(prob(40))
		dismantle()

/obj/structure/cultgirder/bullet_act(var/obj/item/projectile/Proj) //No beam check- How else will you destroy the cult girder with silver bullets?????
	//Girders only provide partial cover. There's a chance that the projectiles will just pass through. (unless you are trying to shoot the girder)
	if(Proj.original != src && !prob(cover))
		return -1 //pass through

	//Tasers and the like should not damage cultgirders.
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	health -= Proj.damage
	..()
	if(health <= 0)
		dismantle()
	return

/obj/structure/cultgirder/ex_act(severity)
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
