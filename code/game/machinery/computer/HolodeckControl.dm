var/global/list/holodeck_programs = list(
	"emptycourt" = /area/holodeck/source_emptycourt,		\
	"boxingcourt" =	/area/holodeck/source_boxingcourt,	\
	"basketball" =	/area/holodeck/source_basketball,	\
	"thunderdomecourt" =	/area/holodeck/source_thunderdomecourt,	\
	"beach" =	/area/holodeck/source_beach,	\
	"desert" =	/area/holodeck/source_desert,	\
	"space" =	/area/holodeck/source_space,	\
	"picnicarea" = /area/holodeck/source_picnicarea,	\
	"snowfield" =	/area/holodeck/source_snowfield,	\
	"theatre" =	/area/holodeck/source_theatre,	\
	"meetinghall" =	/area/holodeck/source_meetinghall,	\
	"burntest" = 	/area/holodeck/source_burntest,	\
	"wildlifecarp" = 	/area/holodeck/source_wildlife,	\
	"turnoff" = 	/area/holodeck/source_plating	\
	)

/obj/machinery/computer/HolodeckControl
	name = "Holodeck Control Computer"
	desc = "A computer used to control a nearby holodeck."
	icon_state = "holocontrol"
	var/area/linkedholodeck = null
	var/area/target = null
	var/active = 0
	var/list/holographic_items = list()
	var/damaged = 0
	var/last_change = 0
	var/list/supported_programs = list( \
	"Empty Court" = "emptycourt", \
	"Boxing Court"="boxingcourt",	\
	"Basketball Court" = "basketball",	\
	"Thunderdome Court" = "thunderdomecourt",	\
	"Beach" = "beach",	\
	"Desert" = "desert",	\
	"Space" = "space",	\
	"Picnic Area" = "picnicarea",	\
	"Snow Field" = "snowfield",	\
	"Theatre" = "theatre",	\
	"Meeting Hall" = "meetinghall"	\
	)
	var/list/restricted_programs = list("Atmospheric Burn Simulation" = "burntest", "ildlife Simulation" = "wildlifecarp")

	attack_ai(var/mob/user as mob)
		return src.attack_hand(user)

	attack_paw(var/mob/user as mob)
		return

	attack_hand(var/mob/user as mob)

		if(..())
			return
		user.set_machine(src)
		var/dat

		dat += "<B>Holodeck Control System</B><BR>"
		dat += "<HR>Current Loaded Programs:<BR>"
		for(var/prog in supported_programs)
			dat += "<A href='?src=\ref[src];program=[supported_programs[prog]]'>(([prog]))</A><BR>"

		dat += "Please ensure that only holographic weapons are used in the holodeck if a combat simulation has been loaded.<BR>"

		if(issilicon(user))
			if(emagged)
				dat += "<A href='?src=\ref[src];AIoverride=1'>(<font color=green>Re-Enable Safety Protocols?</font>)</A><BR>"
			else
				dat += "<A href='?src=\ref[src];AIoverride=1'>(<font color=red>Override Safety Protocols?</font>)</A><BR>"

		if(emagged)
			for(var/prog in restricted_programs)
				dat += "<A href='?src=\ref[src];program=[restricted_programs[prog]]'>(<font color=red>Begin [prog]</font>)</A><BR>"
				dat += "Ensure the holodeck is empty before testing.<BR>"
				dat += "<BR>"
			dat += "Safety Protocols are <font color=red> DISABLED </font><BR>"
		else
			dat += "Safety Protocols are <font color=green> ENABLED </font><BR>"

		user << browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")

		return


	Topic(href, href_list)
		if(..())
			return
		if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
			usr.set_machine(src)

			if(href_list["program"])
				var/prog = href_list["program"]
				if(prog in holodeck_programs)
					target = locate(holodeck_programs[prog])
					if(target)
						loadProgram(target)

			else if(href_list["AIoverride"])
				if(!issilicon(usr))	return
				emagged = !emagged
				if(emagged)
					message_admins("[key_name_admin(usr)] overrode the holodeck's safeties")
					log_game("[key_name(usr)] overrided the holodeck's safeties")
				else
					message_admins("[key_name_admin(usr)] restored the holodeck's safeties")
					log_game("[key_name(usr)] restored the holodeck's safeties")

			src.add_fingerprint(usr)
		src.updateUsrDialog()
		return


/obj/machinery/computer/HolodeckControl/attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
	if(istype(D, /obj/item/weapon/card/emag) && !emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		user << "\blue You vastly increase projector power and override the safety and security protocols."
		user << "Warning.  Automatic shutoff and derezing protocols have been corrupted.  Please call Nanotrasen maintenance and do not use the simulator."
		log_game("[key_name(usr)] emagged the Holodeck Control Computer")
	src.updateUsrDialog()
	return

/obj/machinery/computer/HolodeckControl/New()
	..()
	linkedholodeck = locate(/area/holodeck/alphadeck)
	//if(linkedholodeck)
	//	target = locate(/area/holodeck/source_emptycourt)
	//	if(target)
	//		loadProgram(target)

//This could all be done better, but it works for now.
/obj/machinery/computer/HolodeckControl/Del()
	emergencyShutdown()
	..()

/obj/machinery/computer/HolodeckControl/meteorhit(var/obj/O as obj)
	emergencyShutdown()
	..()


/obj/machinery/computer/HolodeckControl/emp_act(severity)
	emergencyShutdown()
	..()


/obj/machinery/computer/HolodeckControl/ex_act(severity)
	emergencyShutdown()
	..()


/obj/machinery/computer/HolodeckControl/blob_act()
	emergencyShutdown()
	..()

/obj/machinery/computer/HolodeckControl/process()
	for(var/item in holographic_items) // do this first, to make sure people don't take items out when power is down.
		if(!(get_turf(item) in linkedholodeck))
			derez(item, 0)

	if(!..())
		return
	if(active)

		if(!checkInteg(linkedholodeck))
			damaged = 1
			target = locate(/area/holodeck/source_plating)
			if(target)
				loadProgram(target)
			active = 0
			for(var/mob/M in range(10,src))
				M.show_message("The holodeck overloads!")


			for(var/turf/T in linkedholodeck)
				if(prob(30))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
				T.ex_act(3)
				T.hotspot_expose(1000,500,1)

/obj/machinery/computer/HolodeckControl/proc/derez(var/obj/obj , var/silent = 1)
	holographic_items.Remove(obj)

	if(obj == null)
		return

	if(isobj(obj))
		var/mob/M = obj.loc
		if(ismob(M))
			M.u_equip(obj)
			M.update_icons()	//so their overlays update

	if(!silent)
		var/obj/oldobj = obj
		visible_message("The [oldobj.name] fades away!")
	del(obj)

/obj/machinery/computer/HolodeckControl/proc/checkInteg(var/area/A)
	for(var/turf/T in A)
		if(istype(T, /turf/space))
			return 0

	return 1

/obj/machinery/computer/HolodeckControl/proc/togglePower(var/toggleOn = 0)

	if(toggleOn)
		var/area/targetsource = locate(/area/holodeck/source_emptycourt)
		holographic_items = targetsource.copy_contents_to(linkedholodeck)

		spawn(30)
			for(var/obj/effect/landmark/L in linkedholodeck)
				if(L.name=="Atmospheric Test Start")
					spawn(20)
						var/turf/T = get_turf(L)
						var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
						s.set_up(2, 1, T)
						s.start()
						if(T)
							T.temperature = 5000
							T.hotspot_expose(50000,50000,1)

		active = 1
	else
		for(var/item in holographic_items)
			derez(item)
		var/area/targetsource = locate(/area/holodeck/source_plating)
		targetsource.copy_contents_to(linkedholodeck , 1)
		active = 0


/obj/machinery/computer/HolodeckControl/proc/loadProgram(var/area/A)

	if(world.time < (last_change + 25))
		if(world.time < (last_change + 15))//To prevent super-spam clicking, reduced process size and annoyance -Sieve
			return
		for(var/mob/M in range(3,src))
			M.show_message("\b ERROR. Recalibrating projection apparatus.")
			last_change = world.time
			return

	last_change = world.time
	active = 1

	for(var/item in holographic_items)
		derez(item)

	for(var/obj/effect/decal/cleanable/blood/B in linkedholodeck)
		del(B)

	for(var/mob/living/simple_animal/hostile/carp/C in linkedholodeck)
		del(C)

	holographic_items = A.copy_contents_to(linkedholodeck , 1)

	if(emagged)
		for(var/obj/item/weapon/holo/esword/H in linkedholodeck)
			H.damtype = BRUTE

	spawn(30)
		for(var/obj/effect/landmark/L in linkedholodeck)
			if(L.name=="Atmospheric Test Start")
				spawn(20)
					var/turf/T = get_turf(L)
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
					if(T)
						T.temperature = 5000
						T.hotspot_expose(50000,50000,1)
			if(L.name=="Holocarp Spawn")
				new /mob/living/simple_animal/hostile/carp(L.loc)


/obj/machinery/computer/HolodeckControl/proc/emergencyShutdown()
	//Get rid of any items
	for(var/item in holographic_items)
		derez(item)
	//Turn it back to the regular non-holographic room
	target = locate(/area/holodeck/source_plating)
	if(target)
		loadProgram(target)

	var/area/targetsource = locate(/area/holodeck/source_plating)
	targetsource.copy_contents_to(linkedholodeck , 1)
	active = 0







// Holographic Items!

/turf/simulated/floor/holofloor/
	thermal_conductivity = 0

/turf/simulated/floor/holofloor/grass
	name = "Lush Grass"
	icon_state = "grass1"
	floor_tile = new/obj/item/stack/tile/grass

	New()
		floor_tile.New() //I guess New() isn't run on objects spawned without the definition of a turf to house them, ah well.
		icon_state = "grass[pick("1","2","3","4")]"
		..()
		spawn(4)
			update_icon()
			for(var/direction in cardinal)
				if(istype(get_step(src,direction),/turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src,direction)
					FF.update_icon() //so siding get updated properly

/turf/simulated/floor/holofloor/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return
	// HOLOFLOOR DOES NOT GIVE A FUCK










/obj/structure/table/holotable
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'icons/obj/structures.dmi'
	icon_state = "table"
	density = 1
	anchored = 1.0
	layer = 2.8
	throwpass = 1	//You can throw objects over this, despite it's density.


/obj/structure/table/holotable/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/structure/table/holotable/attack_animal(mob/living/user as mob) //Removed code for larva since it doesn't work. Previous code is now a larva ability. /N
	return attack_hand(user)

/obj/structure/table/holotable/attack_hand(mob/user as mob)
	return // HOLOTABLE DOES NOT GIVE A FUCK


/obj/structure/table/holotable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(G.state<2)
			user << "\red You need a better grip to do that!"
			return
		G.affecting.loc = src.loc
		G.affecting.Weaken(5)
		visible_message("\red [G.assailant] puts [G.affecting] on the table.")
		del(W)
		return

	if (istype(W, /obj/item/weapon/wrench))
		user << "It's a holotable!  There are no bolts!"
		return

	if(isrobot(user))
		return

	..()

/obj/structure/table/holotable/wood
	name = "table"
	desc = "A square piece of wood standing on four wooden legs. It can not move."
	icon = 'icons/obj/structures.dmi'
	icon_state = "wood_table"

/obj/structure/holostool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	anchored = 1.0
	flags = FPRINT
	pressure_resistance = 15


/obj/item/clothing/gloves/boxing/hologlove
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"

/obj/structure/holowindow
	name = "reinforced window"
	icon = 'icons/obj/structures.dmi'
	icon_state = "rwindow"
	desc = "A window."
	density = 1
	layer = 3.2//Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER


/obj/structure/holowindow/Del()
	..()

/obj/item/weapon/holo
	damtype = HALLOSS

/obj/item/weapon/holo/esword
	desc = "May the force be within you. Sorta."
	icon_state = "sword0"
	force = 3.0
	throw_speed = 1
	throw_range = 5
	throwforce = 0
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD
	var/active = 0

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
		user << "\blue [src] is now active."
	else
		force = 3
		icon_state = "sword0"
		w_class = 2
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		user << "\blue [src] can now be concealed."

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
			user << "\red You need a better grip to do that!"
			return
		G.affecting.loc = src.loc
		G.affecting.Weaken(5)
		visible_message("\red [G.assailant] dunks [G.affecting] into the [src]!", 3)
		del(W)
		return
	else if (istype(W, /obj/item) && get_dist(src,user)<2)
		user.drop_item(src)
		visible_message("\blue [user] dunks [W] into the [src]!", 3)
		return

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(50))
			I.loc = src.loc
			visible_message("\blue Swish! \the [I] lands in \the [src].", 3)
		else
			visible_message("\red \the [I] bounces off of \the [src]'s rim!", 3)
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

/obj/machinery/readybutton/attack_paw(mob/user as mob)
	user << "You are too primitive to use this device."
	return

/obj/machinery/readybutton/New()
	..()


/obj/machinery/readybutton/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user << "The device is a solid button, there's nothing you can do with it!"

/obj/machinery/readybutton/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		user << "This device is not powered."
		return

	currentarea = get_area(src.loc)
	if(!currentarea)
		del(src)

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

	for(var/obj/structure/holowindow/W in currentarea)
		del(W)

	for(var/mob/M in currentarea)
		M << "FIGHT!"

//Holorack

/obj/structure/rack/holorack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"

/obj/structure/rack/holorack/attack_hand(mob/user as mob)
	return

/obj/structure/rack/holorack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		user << "It's a holorack!  You can't unwrench it!"
		return