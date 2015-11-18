/datum/wifi/receiver/button
	var/obj/parent

/datum/wifi/receiver/button/New(var/new_id, var/obj/O)
	id = new_id
	if(istype(O))
		parent = O
	..()

/datum/wifi/receiver/button/Destroy()
	parent = null
	return ..()

/datum/wifi/receiver/button/proc/activate(mob/living/user)


/datum/wifi/sender/button/proc/activate(mob/living/user)
	for(var/datum/wifi/receiver/button/B in connected_devices)
		B.activate(user)

//-------------------------------
// Emitter
//-------------------------------
/datum/wifi/receiver/button/emitter/activate(mob/living/user)
	..()
	var/obj/machinery/power/emitter/E = parent
	if(istype(E))
		E.activate(user)

//-------------------------------
// Crematorium
//-------------------------------
/datum/wifi/receiver/button/crematorium/activate(mob/living/user)
	..()
	var/obj/structure/crematorium/C = parent
	if(istype(C))
		C.cremate(user)
