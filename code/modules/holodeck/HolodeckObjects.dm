// Holographic Items!

// Holographic tables are in code/modules/tables/presets.dm
// Holographic racks are in code/modules/tables/rack.dm

/turf/simulated/floor/holofloor/
	thermal_conductivity = 0

/turf/simulated/floor/holofloor/grass
	name = "Lush Grass"
	icon_state = "grass1"
	floor_type = /obj/item/stack/tile/grass

	New()
		icon_state = "grass[pick("1","2","3","4")]"
		..()
		spawn(4)
			update_icon()
			for(var/direction in cardinal)
				if(istype(get_step(src,direction),/turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src,direction)
					FF.update_icon() //so siding get updated properly

/turf/simulated/floor/holofloor/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	icon_state = "0"

/turf/simulated/floor/holofloor/space/New()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

/turf/simulated/floor/holofloor/desert
	name = "desert sand"
	desc = "Uncomfortably gritty for a hologram."
	icon_state = "asteroid"

/turf/simulated/floor/holofloor/desert/New()
	..()
	if(prob(10))
		overlays += "asteroid[rand(0,9)]"

/turf/simulated/floor/holofloor/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return
	// HOLOFLOOR DOES NOT GIVE A FUCK

/obj/structure/holostool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_padded_preview"
	anchored = 1.0
	pressure_resistance = 15


/obj/item/clothing/gloves/boxing/hologlove
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"

/obj/structure/window/reinforced/holowindow/Destroy()
	..()

/obj/structure/window/reinforced/holowindow/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W)) return//I really wish I did not need this
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(istype(G.affecting,/mob/living))
			var/mob/living/M = G.affecting
			var/state = G.state
			qdel(W)	//gotta delete it here because if window breaks, it won't get deleted
			switch (state)
				if(1)
					M.visible_message("<span class='warning'>[user] slams [M] against \the [src]!</span>")
					M.apply_damage(7)
					hit(10)
				if(2)
					M.visible_message("<span class='danger'>[user] bashes [M] against \the [src]!</span>")
					if (prob(50))
						M.Weaken(1)
					M.apply_damage(10)
					hit(25)
				if(3)
					M.visible_message("<span class='danger'><big>[user] crushes [M] against \the [src]!</big></span>")
					M.Weaken(5)
					M.apply_damage(20)
					hit(50)
			return

	if(W.flags & NOBLUDGEON) return

	if(istype(W, /obj/item/weapon/screwdriver))
		user << ("<span class='notice'>It's a holowindow, you can't unfasten it!</span>")
	else if(istype(W, /obj/item/weapon/crowbar) && reinf && state <= 1)
		user << ("<span class='notice'>It's a holowindow, you can't pry it!</span>")
	else if(istype(W, /obj/item/weapon/wrench) && !anchored && (!state || !reinf))
		user << ("<span class='notice'>It's a holowindow, you can't dismantle it!</span>")
	else
		if(W.damtype == BRUTE || W.damtype == BURN)
			hit(W.force)
			if(health <= 7)
				anchored = 0
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/reinforced/holowindow/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	qdel(src)
	return

/obj/structure/window/reinforced/holowindow/disappearing/Destroy()
	..()

/obj/machinery/door/window/holowindoor/Destroy()
	..()

/obj/machinery/door/window/holowindoor/attackby(obj/item/weapon/I as obj, mob/user as mob)

	if (src.operating == 1)
		return

	if(src.density && istype(I, /obj/item/weapon) && !istype(I, /obj/item/weapon/card))
		var/aforce = I.force
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		visible_message("\red <B>[src] was hit by [I].</B>")
		if(I.damtype == BRUTE || I.damtype == BURN)
			take_damage(aforce)
		return

	src.add_fingerprint(user)
	if (!src.requiresID())
		user = null

	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()

	else if (src.density)
		flick(text("[]deny", src.base_state), src)

	return

/obj/machinery/door/window/holowindoor/shatter(var/display_message = 1)
	src.density = 0
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	qdel(src)

/obj/structure/bed/chair/holochair/Destroy()
	..()

/obj/structure/bed/chair/holochair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		user << ("<span class='notice'>It's a holochair, you can't dismantle it!</span>")
	return

/obj/item/weapon/holo
	damtype = HALLOSS
	no_attack_log = 1

/obj/item/weapon/holo/esword
	desc = "May the force be within you. Sorta."
	icon_state = "sword0"
	force = 3.0
	throw_speed = 1
	throw_range = 5
	throwforce = 0
	w_class = 2.0
	flags = NOSHIELD | NOBLOODY
	var/active = 0
	var/item_color

/obj/item/weapon/holo/esword/green
	New()
		item_color = "green"

/obj/item/weapon/holo/esword/red
	New()
		item_color = "red"

/obj/item/weapon/holo/esword/IsShield()
	if(active)
		return 1
	return 0

/obj/item/weapon/holo/esword/attack(target as mob, mob/user as mob)
	..()

/obj/item/weapon/holo/esword/New()
	item_color = pick("red","blue","green","purple")

/obj/item/weapon/holo/esword/attack_self(mob/living/user as mob)
	active = !active
	if (active)
		force = 30
		icon_state = "sword[item_color]"
		w_class = 4
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		user << "<span class='notice'>[src] is now active.</span>"
	else
		force = 3
		icon_state = "sword0"
		w_class = 2
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		user << "<span class='notice'>[src] can now be concealed.</span>"

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

//BASKETBALL OBJECTS

/obj/item/weapon/beach_ball/holoball
	icon = 'icons/obj/basketball.dmi'
	icon_state = "basketball"
	name = "basketball"
	item_state = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = 4 //Stops people from hiding it in their bags/pockets

/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!"
	icon = 'icons/obj/basketball.dmi'
	icon_state = "hoop"
	anchored = 1
	density = 1
	throwpass = 1

/obj/structure/holohoop/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(G.state<2)
			user << "<span class='warning'>You need a better grip to do that!</span>"
			return
		G.affecting.loc = src.loc
		G.affecting.Weaken(5)
		visible_message("<span class='warning'>[G.assailant] dunks [G.affecting] into the [src]!</span>", 3)
		qdel(W)
		return
	else if (istype(W, /obj/item) && get_dist(src,user)<2)
		user.drop_item(src.loc)
		visible_message("<span class='notice'>[user] dunks [W] into the [src]!</span>", 3)
		return

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(50))
			I.loc = src.loc
			visible_message("<span class='notice'>Swish! \the [I] lands in \the [src].</span>", 3)
		else
			visible_message("<span class='warning'>\The [I] bounces off of \the [src]'s rim!</span>", 3)
		return 0
	else
		return ..(mover, target, height, air_group)


/obj/machinery/readybutton
	name = "Ready Declaration Device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/machinery/readybutton/attack_ai(mob/user as mob)
	user << "The station AI is not to interact with these devices!"
	return

/obj/machinery/readybutton/New()
	..()


/obj/machinery/readybutton/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user << "The device is a solid button, there's nothing you can do with it!"

/obj/machinery/readybutton/attack_hand(mob/user as mob)

	if(user.stat || stat & (NOPOWER|BROKEN))
		user << "This device is not powered."
		return

	if(!user.IsAdvancedToolUser())
		return 0

	currentarea = get_area(src.loc)
	if(!currentarea)
		qdel(src)

	if(eventstarted)
		usr << "The event has already begun!"
		return

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()

/obj/machinery/readybutton/update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/window/reinforced/holowindow/disappearing/W in currentarea)
		qdel(W)

	for(var/mob/M in currentarea)
		M << "FIGHT!"

//Holocarp

/mob/living/simple_animal/hostile/carp/holodeck
	icon = 'icons/mob/AI.dmi'
	icon_state = "holo4"
	icon_living = "holo4"
	icon_dead = "holo4"
	alpha = 127
	icon_gib = null
	meat_amount = 0
	meat_type = null

/mob/living/simple_animal/hostile/carp/holodeck/New()
	..()
	set_light(2) //hologram lighting

/mob/living/simple_animal/hostile/carp/holodeck/proc/set_safety(var/safe)
	if (safe)
		faction = "neutral"
		melee_damage_lower = 0
		melee_damage_upper = 0
		environment_smash = 0
		destroy_surroundings = 0
	else
		faction = "carp"
		melee_damage_lower = initial(melee_damage_lower)
		melee_damage_upper = initial(melee_damage_upper)
		environment_smash = initial(environment_smash)
		destroy_surroundings = initial(destroy_surroundings)

/mob/living/simple_animal/hostile/carp/holodeck/gib()
	derez() //holograms can't gib

/mob/living/simple_animal/hostile/carp/holodeck/death()
	..()
	derez()

/mob/living/simple_animal/hostile/carp/holodeck/proc/derez()
	visible_message("<span class='notice'>\The [src] fades away!</span>")
	qdel(src)
