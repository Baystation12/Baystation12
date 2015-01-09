//PACMAN variant that can run on the small plasma tanks.
/obj/machinery/power/port_gen/bullshit
	name = "Bullistics Uncertainty Large Latice Stringtheory Hyperspacial Integrity Transcoder"
	desc = "B.U.L.L.S.H.I.T. spits out a lot of energy from another dimension, or that's what the guys in R&D tell us."
	power_gen = 45000000
	active = 0

/obj/machinery/power/port_gen/bullshit/examine(mob/user)
	..(user)
	user << "\blue No one within 2 lightyears knows how to build or work on this, hopefully it doesn't break down.  The manual is literally \"Push the button\""
	if(!active) user << "\red It has a red light, that can't be good."

/obj/machinery/power/port_gen/bullshit/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/weapon/card/emag))
		var/obj/item/weapon/card/emag/E = O
		if(E.uses)
			E.uses--
		else
			return
		emagged = 1
		//You shouldn't have done that.
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.delayed_satisfaction(1800) // Fun starts in about 3 minutes.	
			user << "Nothing happens..."	 // MUAHAHAHAHAHAHA
		else
			user.gib()
		
	else if(!active)
		if(istype(O, /obj/item/weapon/wrench))
			anchored = !anchored
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			if(anchored)
				user << "\blue You secure the generator to the floor."
			else
				user << "\blue You unsecure the generator from the floor."
				makepowernets()
		else if(istype(O, /obj/item/weapon/screwdriver))
			open = !open
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			user << "The screw spins freely, that did nothing."
		else if(istype(O, /obj/item/weapon/crowbar))
			user << "You get the feeling you shouldn't do that again."

/obj/machinery/power/port_gen/bullshit/process()
	add_avail(power_gen)

/obj/machinery/power/port_gen/bullshit/attack_hand(mob/user as mob)
	..()
	if (!anchored)
		user << "You hear the machine spin up but then sadly spins back down, is this thing sentient?"
		return

	toggle_it(user)

/obj/machinery/power/port_gen/bullshit/attack_ai(mob/user as mob)
	toggle_it(user)

/obj/machinery/power/port_gen/bullshit/proc/toggle_it(mob/user as mob)
	active = !active
	user << "You think you just turned it [active ? "on" : "off"]."
