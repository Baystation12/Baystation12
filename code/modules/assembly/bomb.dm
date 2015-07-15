/obj/item/device/onetankbomb
	name = "single tank assembly"
	icon = 'icons/obj/tank.dmi'
	item_state = "assembly"
	throwforce = 5
	w_class = 3.0
	throw_speed = 2
	throw_range = 4
	flags = CONDUCT //Copied this from old code, so this may or may not be necessary
	var/obj/item/device/assembly_holder/bombassembly = null   //The first part of the bomb is an assembly holder, holding an igniter+some device
	var/obj/item/weapon/tank/bombtank = null //the second part of the bomb is a phoron tank

/obj/item/device/onetankbomb/examine(mob/user)
	..(user)
	user << "It's a [bombtank] with an igniter assembly stuck to it."
	user.examinate(bombtank)


/obj/item/device/onetankbomb/update_icon()
	if(bombtank)
		icon_state = bombtank.icon_state
	if(bombassembly)
		overlays += bombassembly.icon_state
		overlays += bombassembly.overlays
		overlays += "bomb_assembly"

/obj/item/device/onetankbomb/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/analyzer))
		bombtank.attackby(W, user)
		return
	if(istype(W, /obj/item/weapon/wrench))	//This is basically bomb assembly code inverted. apparently it works.
		user << "<span class='notice'>You disassemble [src].</span>"

		bombassembly.loc = user.loc
		bombassembly.master = null
		bombassembly = null

		bombtank.loc = user.loc
		bombtank.master = null
		bombtank = null

		qdel(src)
		return

	add_fingerprint(user)
	..()

/obj/item/device/onetankbomb/attack_self(mob/user as mob) //pressing the bomb accesses its assembly
	bombassembly.attack_self(user, 1)
	add_fingerprint(user)
	return

/obj/item/device/onetankbomb/receive_signal()	//This is mainly called by the sensor through sense() to the holder, and from the holder to here.
//	visible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
	sleep(10)
	if(!src)
		return

	var/location = src.loc
	var/obj/item/weapon/tank/tank = bombtank

	bombtank.master = null
	tank.loc = location
	bombtank = null

	qdel(src)

	tank.ignite()	//if its not a dud, boom (or not boom if you made shitty mix) the ignite proc is below, in this file

/obj/item/device/onetankbomb/HasProximity(atom/movable/AM as mob|obj)
	if(bombassembly)
		bombassembly.HasProximity(AM)

// ---------- Procs below are for tanks that are used exclusively in 1-tank bombs ----------

/obj/item/weapon/tank/proc/bomb_assemble(W,user)	//Bomb assembly proc. This turns assembly+tank into a bomb
	var/obj/item/device/assembly_holder/S = W
	var/mob/M = user
	if(!S.secured)										//Check if the assembly is secured
		return
	if(isigniter(S.a_left) == isigniter(S.a_right))		//Check if either part of the assembly has an igniter, but if both parts are igniters, then fuck it
		return

	var/obj/item/device/onetankbomb/R = new /obj/item/device/onetankbomb(loc)

	bombers += "[key_name(user)] created a single tank bomb from a[welded? " ":"n un"]welded tank. Temp: [bombtank.air_contents.temperature-T0C]"
	message_admins("[key_name_admin(user)] created a single tank bomb from a[welded? " ":"n un"]welded tank. Temp: [bombtank.air_contents.temperature-T0C]")


	M.drop_item()			//Remove the assembly from your hands
	M.remove_from_mob(src)	//Remove the tank from your character,in case you were holding it
	M.put_in_hands(R)		//Equips the bomb if possible, or puts it on the floor.

	R.bombassembly = S	//Tell the bomb about its assembly part
	S.master = R		//Tell the assembly about its new owner
	S.loc = R			//Move the assembly out of the fucking way

	R.bombtank = src	//Same for tank
	master = R
	loc = R
	R.update_icon()
	return

/obj/item/weapon/tank/proc/ignite()	//This happens when a bomb is told to explode

	var/hc = air_contents.heat_capacity()
	air_contents.temperature = ((air_contents.temperature*hc)+25000)/hc

	if(welded)
		var/datum/gas_mixture/removed = air_contents.remove(air_contents.total_moles)
		var/turf/simulated/T = get_turf(src)
		if(!T)
			return
		T.assume_air(removed)
	else if (air_contents.temperature > PHORON_MINIMUM_BURN_TEMPERATURE)
		air_contents.zburn(null, force_burn=1, no_check=0)

	src.loc = master.loc
	if (master)
		qdel(master)

//ideally depricated
/obj/item/weapon/tank/proc/release()	//This happens when the bomb is not welded. Tank contents are just spat out.
	var/datum/gas_mixture/removed = air_contents.remove(air_contents.total_moles)
	var/turf/simulated/T = get_turf(src)
	if(!T)
		return
	T.assume_air(removed)
	sleep(5)
	T.hotspot_expose(1000,100)