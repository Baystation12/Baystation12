/obj/machinery/monkeyrecycler
	name = "monkey recycler"
	desc = "A machine used for recycling dead monkeys into monkey cubes. It requires 5 monkeys per cube."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 50
	var/grinded = 0


/obj/machinery/monkeyrecycler/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_unfasten_wrench(user, O))
		return

	if (src.stat != 0) //NOPOWER etc
		return
	if (istype(O, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		var/grabbed = G.affecting
		if(istype(grabbed, /mob/living/carbon/monkey))
			var/mob/living/carbon/monkey/target = grabbed
			if(target.stat == 0)
				user << "<span class='danger'>The monkey is struggling far too much to put it in the recycler.</span>"
			else
				user.drop_item()
				del(target)
				user << "<span class='notice'>You stuff the monkey in the machine.</span>"
				playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
				use_power(500)
				src.grinded++
				user << "<span class='notice'>The machine now has [grinded] monkey\s worth of material stored.</span>"

		else
			user << "<span class='danger'>The machine only accepts monkeys!</span>"
	return

/obj/machinery/monkeyrecycler/attack_hand(var/mob/user as mob)
	if (src.stat != 0) //NOPOWER etc
		return
	if(grinded >= 5)
		user << "<span class='notice'>The machine hisses loudly as it condenses the grinded monkey meat. After a moment, it dispenses a brand new monkey cube.</span>"
		playsound(src.loc, 'sound/machines/hiss.ogg', 50, 1)
		grinded -= 5
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src.loc)
		user << "<span class='notice'>The machine's display flashes that it has [grinded] monkeys worth of material left.</span>"
	else
		user << "<span class='danger'>The machine needs at least 5 monkeys worth of material to produce a monkey cube. It only has [grinded].</span>"
	return
