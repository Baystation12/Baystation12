/obj/structure/girder
	icon_state = "girder"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	w_class = ITEM_SIZE_NO_CONTAINER
	health_max = 100
	var/state = 0
	var/cover = 50 //how much cover the girder provides against projectiles.
	var/material/reinf_material
	var/reinforcing = 0

/obj/structure/girder/Initialize()
	set_extension(src, /datum/extension/penetration/simple, 100)
	. = ..()

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = FALSE
	health_max = 50
	cover = 25

/obj/structure/girder/bullet_act(obj/item/projectile/Proj)
	//Girders only provide partial cover. There's a chance that the projectiles will just pass through. (unless you are trying to shoot the girder)
	if(Proj.original != src && !prob(cover))
		return PROJECTILE_CONTINUE //pass through
	. = ..()

/obj/structure/girder/on_death()
	dismantle()

/obj/structure/girder/CanFluidPass(coming_from)
	return TRUE

/obj/structure/girder/proc/reset_girder()
	anchored = TRUE
	cover = initial(cover)
	revive_health()
	state = 0
	icon_state = initial(icon_state)
	reinforcing = 0
	if(reinf_material)
		reinforce_girder()

/obj/structure/girder/attackby(obj/item/W, mob/user)
	if (user.a_intent == I_HURT)
		..()
		return

	if(isWrench(W) && state == 0)
		if(anchored && !reinf_material)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("Now disassembling the girder..."))
			if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
				to_chat(user, SPAN_NOTICE("You dissasembled the girder!"))
				dismantle()
		else if(!anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("Now securing the girder..."))
			if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
				to_chat(user, SPAN_NOTICE("You secured the girder!"))
				reset_girder()
		return

	if(istype(W, /obj/item/gun/energy/plasmacutter) || istype(W, /obj/item/psychic_power/psiblade/master/grand/paramount))
		if(istype(W, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/cutter = W
			if(!cutter.slice(user))
				return
		playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("Now slicing apart the girder..."))
		if(do_after(user, (reinf_material ? 4 : 2) SECONDS, src, DO_PUBLIC_UNIQUE))
			to_chat(user, SPAN_NOTICE("You slice apart the girder!"))
			if(reinf_material)
				reinf_material.place_dismantled_product(get_turf(src))
			dismantle()
		return

	if(istype(W, /obj/item/pickaxe/diamonddrill))
		playsound(src.loc, 'sound/weapons/Genhit.ogg', 100, 1)
		if(do_after(user, (reinf_material ? 6 : 4) SECONDS, src, DO_PUBLIC_UNIQUE))
			to_chat(user, SPAN_NOTICE("You drill through the girder!"))
			if(reinf_material)
				reinf_material.place_dismantled_product(get_turf(src))
			dismantle()
		return

	if(isScrewdriver(W))
		if(state == 2)
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("Now unsecuring support struts..."))
			if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
				to_chat(user, SPAN_NOTICE("You unsecured the support struts!"))
				state = 1
		else if(anchored && !reinf_material)
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			reinforcing = !reinforcing
			to_chat(user, SPAN_NOTICE("\The [src] can now be [reinforcing? "reinforced" : "constructed"]!"))
		return

	if(isWirecutter(W) && state == 1)
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("Now removing support struts..."))
		if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
			to_chat(user, SPAN_NOTICE("You removed the support struts!"))

			if(reinf_material)
				reinf_material.place_dismantled_product(get_turf(src))
				reinf_material = null

			reset_girder()
		return

	if(isCrowbar(W) && state == 0 && anchored)
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("Now dislodging the girder..."))
		if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
			to_chat(user, SPAN_NOTICE("You dislodged the girder!"))
			icon_state = "displaced"
			anchored = FALSE
			set_max_health(50)
			cover = 25
		return

	if(istype(W, /obj/item/stack/material))
		if(reinforcing && !reinf_material)
			if(!reinforce_with_material(W, user))
				return ..()
		else
			if(!construct_wall(W, user))
				return ..()
		return

	..()

/obj/structure/girder/proc/construct_wall(obj/item/stack/material/S, mob/user)
	if(S.get_amount() < 2)
		to_chat(user, SPAN_NOTICE("There isn't enough material here to construct a wall."))
		return 0

	var/material/M = SSmaterials.get_material_by_name(S.default_type)
	if(!istype(M))
		return 0

	var/wall_fake
	add_hiddenprint(usr)

	if(M.integrity < 50)
		to_chat(user, SPAN_NOTICE("This material is too soft for use in wall construction."))
		return 0

	to_chat(user, SPAN_NOTICE("You begin adding the plating..."))

	if(!do_after(user,4 SECONDS, src, DO_REPAIR_CONSTRUCT) || !S.use(2))
		return 1 //once we've gotten this far don't call parent attackby()

	if(anchored)
		to_chat(user, SPAN_NOTICE("You added the plating!"))
	else
		to_chat(user, SPAN_NOTICE("You create a false wall! Push on it to open or close the passage."))
		wall_fake = 1

	var/turf/Tsrc = get_turf(src)
	Tsrc.ChangeTurf(/turf/simulated/wall)
	var/turf/simulated/wall/T = get_turf(src)
	T.set_material(M, reinf_material)
	if(wall_fake)
		T.can_open = 1
	T.add_hiddenprint(usr)
	qdel(src)
	return 1

/obj/structure/girder/proc/reinforce_with_material(obj/item/stack/material/S, mob/user) //if the verb is removed this can be renamed.
	if(reinf_material)
		to_chat(user, SPAN_NOTICE("\The [src] is already reinforced."))
		return 0

	if(S.get_amount() < 2)
		to_chat(user, SPAN_NOTICE("There isn't enough material here to reinforce the girder."))
		return 0

	var/material/M = S.material
	if(!istype(M) || M.integrity < 50)
		to_chat(user, "You cannot reinforce \the [src] with that; it is too soft.")
		return 0

	to_chat(user, SPAN_NOTICE("Now reinforcing..."))
	if (!do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT) || !S.use(2))
		return 1 //don't call parent attackby() past this point
	to_chat(user, SPAN_NOTICE("You added reinforcement!"))

	reinf_material = M
	reinforce_girder()
	return 1

/obj/structure/girder/proc/reinforce_girder()
	cover = 75
	set_max_health(500)
	state = 2
	icon_state = "reinforced"
	reinforcing = 0

/obj/structure/girder/proc/dismantle()
	new /obj/item/stack/material/steel(get_turf(src))
	qdel(src)

/obj/structure/girder/attack_hand(mob/user as mob)
	if (MUTATION_HULK in user.mutations)
		visible_message(SPAN_DANGER("[user] smashes [src] apart!"))
		dismantle()
		return
	return ..()

/obj/structure/girder/cult
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	health_max = 250
	cover = 70

/obj/structure/girder/cult/dismantle()
	qdel(src)

/obj/structure/girder/cult/attackby(obj/item/W as obj, mob/user as mob)
	if(isWrench(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("Now disassembling the girder..."))
		if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
			to_chat(user, SPAN_NOTICE("You dissasembled the girder!"))
			dismantle()

	else if(istype(W, /obj/item/gun/energy/plasmacutter) || istype(W, /obj/item/psychic_power/psiblade/master/grand/paramount))
		if(istype(W, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/cutter = W
			if(!cutter.slice(user))
				return
		playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("Now slicing apart the girder..."))
		if(do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			to_chat(user, SPAN_NOTICE("You slice apart the girder!"))
			dismantle()

	else if(istype(W, /obj/item/pickaxe/diamonddrill))
		playsound(src.loc, 'sound/weapons/Genhit.ogg', 100, 1)
		if(do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
			to_chat(user, SPAN_NOTICE("You drill through the girder!"))
			dismantle()
