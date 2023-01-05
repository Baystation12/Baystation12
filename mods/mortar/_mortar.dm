
//Coordinate obsfucator
//Used by the tactical binoculars and linked systems to prevent coords collection/prefiring
var/global/obfs_x = 0 //A number between -500 and 500
var/global/obfs_y = 0 //A number between -500 and 500

//Offuscate x for coord system
#define obfuscate_x(x) (x + obfs_x)

//Offuscate y for coord system
#define obfuscate_y(y) (y + obfs_y)

//Deoffuscate x for coord system
#define deobfuscate_x(x) (x - obfs_x)

//Deoffuscate y for coord system
#define deobfuscate_y(y) (y - obfs_y)


/world/New()
	. = ..()

	//Scramble the coords obsfucator
	obfs_x = rand(-500, 500) //A number between -100 and 100
	obfs_y = rand(-500, 500) //A number between -100 and 100

/singleton/modpack/mortar
	name = "Mortar's"
	author = "@Констебель Глист#2586"


/obj/structure/mortar
	name = "Mortar"
	desc = "Mortar"
	icon = 'mortar.dmi'
	icon_state = "mortar_m402"
	anchored = 1
	density = 1
	var/xinput
	var/yinput
	var/xdial
	var/ydial
	var/xoffset = 0
	var/yoffset = 0
	var/offset_per_turfs = 10 //Number of turfs to offset from target by 1
	var/firing = 0
	var/busy = 0
	var/fixed = 0 //If 1, mortar cannot be unarchored and moved.
	var/travel_time = 45
	var/max_shells = 1
	var/list/shells = new/list



/obj/structure/mortar/attack_hand(mob/user)
	if(busy)
		to_chat(user, "<span class='warning'>Someone else is currently using [src].</span>")
		return
	if(firing)
		to_chat(user, "<span class='warning'>[src]'s barrel is still steaming hot. Wait a few seconds and stop firing it.</span>")
		return
	add_fingerprint(user)


	var/choice = alert(user, "Would you like to set the mortar's target coordinates?","Mortar Dialing", "Target","Dial" , "Cancel")
	if (choice == "Cancel")
		return

	if (choice == "Target")
		var/temp_targ_x = input("Set longitude of strike.") as num
		if(xdial + deobfuscate_x(temp_targ_x) > world.maxx || xdial + deobfuscate_x(temp_targ_x) < 0)
			to_chat(user, "<span class='warning'>(You cannot aim at this coordinate, it is outside of the area of operations.</span>")
			return

		var/temp_targ_y = input("Set latitude of strike.") as num
		if(ydial + deobfuscate_y(temp_targ_y) > world.maxy || ydial + deobfuscate_y(temp_targ_y) < 0)
			to_chat(user, "<span class='warning'>(You cannot aim at this coordinate, it is outside of the area of operations.</span>")
			return

		var/turf/T = locate(deobfuscate_x(temp_targ_x) + xdial, deobfuscate_y(temp_targ_y) + ydial, z)
		if(get_dist(loc, T) < 10)
			to_chat(user, "<span class='warning'>(You cannot aim at this coordinate, it is too close to your mortar.</span>")
			return

		if(busy)
			to_chat(user, "<span class='warning'>(Someone else is currently using this mortar.</span>")
			return

		user.visible_message("<span class='notice'>([user] starts adjusting [src]'s firing angle and distance.</span>",
		"<span class='notice'>(You start adjusting [src]'s firing angle and distance to match the new coordinates.</span>")
		busy = 1

		if(do_after(user, 30, src))
			user.visible_message("<span class='notice'>([user] finishes adjusting [src]'s firing angle and distance.</span>",
			"<span class='notice'>(You finish adjusting [src]'s firing angle and distance to match the new coordinates.</span>")
			busy = 0
			xinput = deobfuscate_x(temp_targ_x)
			yinput = deobfuscate_y(temp_targ_y)
			var/offset_x_max = round(abs((xinput + xdial) - x)/offset_per_turfs) //Offset of mortar shot, grows by 1 every 20 tiles travelled
			var/offset_y_max = round(abs((yinput + ydial) - y)/offset_per_turfs)
			xoffset = rand(-offset_x_max, offset_x_max)
			yoffset = rand(-offset_y_max, offset_y_max)
		else
			busy = 0

	if (choice == "Dial")
		var/temp_dial_x = input("Set longitude adjustement from -10 to 10.") as num
		if(temp_dial_x + xinput > world.maxx || temp_dial_x + xinput < 0)
			user << "<span class='warning'>You cannot dial to this coordinate, it is outside of the area of operations.</span>"
			return

		if(temp_dial_x < -10 || temp_dial_x > 10)
			user << "<span class='warning'>You cannot dial to this coordinate, it is too far away. You need to set [src] up instead.</span>"
			return

		var/temp_dial_y = input("Set latitude adjustement from -10 to 10.") as num
		if(temp_dial_y + yinput > world.maxy || temp_dial_y + yinput < 0)
			user << "<span class='warning'>You cannot dial to this coordinate, it is outside of the area of operations.</span>"
			return

		var/turf/T = locate(xinput + temp_dial_x, yinput + temp_dial_y, z)
		if(get_dist(loc, T) < 10)
			user << "<span class='warning'>You cannot dial to this coordinate, it is too close to your mortar.</span>"
			return

		if(temp_dial_y < -10 || temp_dial_y > 10)
			user << "<span class='warning'>You cannot dial to this coordinate, it is too far away. You need to set [src] up instead.</span>"
			return

		if(busy)
			user << "<span class='warning'>Someone else is currently using this mortar.</span>"
			return
		user.visible_message("<span class='notice'>[user] starts dialing [src]'s firing angle and distance.</span>",
		"<span class='notice'>You start dialing [src]'s firing angle and distance to match the new coordinates.</span>")
		busy = 1

		if(do_after(user, 15, src))
			user.visible_message("<span class='notice'>[user] finishes dialing [src]'s firing angle and distance.</span>",
			"<span class='notice'>You finish dialing [src]'s firing angle and distance to match the new coordinates.</span>")
			busy = 0
			xdial = temp_dial_x
			ydial = temp_dial_y
		else
			busy = 0



/obj/structure/mortar/attackby(var/obj/item/O as obj, mob/user as mob)
/*
	if(busy)
		user << "<span class='warning'>Someone else is currently using [src].</span>"
		return

	if(z != 1)
		user << "<span class='warning'>You cannot fire [src] here.</span>"
		return

	if(xinput == 0 && yinput == 0) //Mortar wasn't set
		user << "<span class='warning'>[src] needs to be aimed first.</span>"
		return

	var/turf/T = locate(xinput + xdial + xoffset, yinput + ydial + yoffset, z)
	if(!isturf(T))
		user << "<span class='warning'>You cannot fire [src] to this target.</span>"
		return
*/

	var/turf/T = locate(xinput + xdial + xoffset, yinput + ydial + yoffset, z)
	if(!isturf(T))
		user << "<span class='warning'>You cannot fire [src] to this target.</span>"
		return


	if(firing)
		to_chat(user, "<span class='warning'>[src]'s barrel is still steaming hot. Wait a few seconds and stop firing it.</span>")
		return

	if(istype(O, /obj/item/mortar_shell))
		var/obj/item/mortar_shell/mortar_shell = O

		user.visible_message("<span class='notice'>[user] starts loading \a [mortar_shell.name] into [src].</span>",
		"<span class='notice'>You start loading \a [mortar_shell.name] into [src].</span>")
		playsound(loc, 'rpgreload.ogg', 50, 1)
		busy = 1

		if(do_after(user, 15, src))
			user.visible_message("<span class='notice'>[user] loads \a [mortar_shell.name] into [src].</span>",
			"<span class='notice'>You load \a [mortar_shell.name] into [src].</span>")
			visible_message("\icon[src] <span class='danger'>The [name] fires!</span>")
			user.drop_from_inventory(mortar_shell, src)
			playsound(loc, 'mortar_fire.ogg', 50, 1)
			busy = 0
			firing = 1
			flick(icon_state + "_fire", src)
			mortar_shell.forceMove(src)

			for(var/mob/M in range(7))
				shake_camera(M, 3, 1)
			spawn(travel_time) //What goes up
				playsound(T, 'mortar_falling.ogg', 50, 1)
				spawn(45) //Must go down //This should always be 45 ticks!
					mortar_shell.detonate(T)
					qdel(mortar_shell)
					firing = 0
		else
			busy = 0

//TODO change mortar fluff and desc
/obj/structure/mortar/fixed
	desc = "A manual, crew-operated mortar system intended to rain down 80mm goodness on anything it's aimed at. Uses manual targetting dials. Insert round to fire. This one is bolted and welded into the ground."
	fixed = 1

//The portable mortar item
/obj/item/mortar_kit
	name = "\improper M402 mortar portable kit"
	desc = "A manual, crew-operated mortar system intended to rain down 80mm goodness on anything it's aimed at. Needs to be set down first"
	icon = 'mortar.dmi'
	icon_state = "mortar_m402_carry"
	unacidable = 1
	w_class = 5

/obj/item/mortar_kit/attack_self(mob/user)
	user.visible_message("<span class='notice'>[user] starts deploying [src].",
	"<span class='notice'>You start deploying [src].")
	playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
	if(do_after(user, 40, src))
		user.visible_message("<span class='notice'>[user] deploys [src].",
		"<span class='notice'>You deploy [src].")
		playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
		var/obj/structure/mortar/M = new /obj/structure/mortar(get_turf(user))
		M.dir = user.dir
		del(src)


////////////////////////////////////////////////////////////////////////////////////////////
/////////////////Mortar Shell Values//////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/mortar_shell
	name = "\improper 80mm mortar shell"
	desc = "An unlabeled 80mm mortar shell, probably a casing."
	icon = 'mortar.dmi'
	icon_state = "mortar_ammo_cas"
	w_class = 5
	var/list/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment = 1)
	var/num_fragments = 5  //total number of fragments produced by the grenad
	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7 //leave as is, for some reason setting this higher makes the spread pattern have gaps close to the epicenter
	var/explosion_size = 4

/obj/item/mortar_shell/proc/detonate(var/turf/T)

	forceMove(T)

/obj/item/mortar_shell/he
	name = "\improper 80mm High Explosive mortar shell"
	desc = "An 80mm mortar shell, loaded with a Highly Explosive Charge."
	icon = 'mortar.dmi'
	icon_state = "mortar_ammo_he"
	spread_range = 0
	explosion_size = 8

/obj/item/mortar_shell/he/detonate(var/turf/T)
	explosion(T, explosion_size, EX_ACT_HEAVY)

/obj/item/mortar_shell/frag
	name = "\improper 80mm Fragmentation mortar shell"
	desc = "An 80mm mortar shell, loaded with a small charge surrounded by Deadly Metal Pellets."
	icon = 'mortar.dmi'
	icon_state = "mortar_ammo_he"
	fragment_types = list(/obj/item/projectile/bullet/pellet/fragment/mortar = 1)
	num_fragments = 190  //total number of fragments produced by the grenade
	spread_range = 8


/obj/item/projectile/bullet/pellet/fragment/mortar
	damage = 25
	agony = 20
	armor_penetration = 10


/obj/item/mortar_shell/frag/detonate(var/turf/T)

	explosion(T, explosion_size, EX_ACT_LIGHT)
	src.fragmentate(T, num_fragments, spread_range, fragment_types)


/obj/item/device/binoculars/rangefinder
	name = "Rangefinder"
	desc = "A Rangefinder, used to find Latitude and Longitude."
	icon_state = "binoculars"
	item_state = "binoculars"
	var/xcoord
	var/ycoord

/obj/item/device/binoculars/rangefinder/afterattack(atom/A, mob/living/user, adjacent, params)
	A = get_turf(A)
	xcoord = A.x
	ycoord = A.y
	xcoord = obfuscate_x(xcoord)
	ycoord = obfuscate_y(ycoord)
	if(do_after(user, 15, src))
		to_chat(user, "<span class='notice'> You Calculate some Coordinates with the [src] <b>X[xcoord]:Y[ycoord]</b>.</span>")
