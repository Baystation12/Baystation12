/datum/wifi/receiver/button
	var/obj/parent

/datum/wifi/receiver/button/proc/activate(mob/living/user)


/datum/wifi/sender/button/proc/activate(mob/living/user)
	for(var/datum/wifi/receiver/button/B in connected_devices)
		B.activate(user)

//-------------------------------
// Emitter
//-------------------------------
/datum/wifi/receiver/button/emitter/New(var/new_id, var/obj/machinery/power/emitter/E)
	id = new_id
	if(istype(E))
		parent = E
	..()

/datum/wifi/receiver/button/emitter/activate(mob/living/user)
	..()
	var/obj/machinery/power/emitter/E = parent
	E.activate(user)

//-------------------------------
// Crematorium
//-------------------------------
/datum/wifi/receiver/button/crematorium/New(var/new_id, var/obj/structure/crematorium/C)
	id = new_id
	if(istype(C))
		parent = C
	..()

/datum/wifi/receiver/button/crematorium/activate(mob/living/user)
	..()
	var/obj/structure/crematorium/C = parent
	C.cremate(user)
