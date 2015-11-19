//-------------------------------
// Buttons
//-------------------------------
/datum/wifi/receiver/button/proc/activate(mob/living/user)

/datum/wifi/receiver/button/proc/deactivate(mob/living/user)

/datum/wifi/sender/button/proc/activate(mob/living/user)
	for(var/datum/wifi/receiver/button/B in connected_devices)
		B.activate(user)

/datum/wifi/sender/button/proc/deactivate(mob/living/user)
	for(var/datum/wifi/receiver/button/B in connected_devices)
		B.deactivate(user)

//-------------------------------
// Emitter
//-------------------------------
/datum/wifi/receiver/button/emitter/activate(mob/living/user)
	..()
	var/obj/machinery/power/emitter/E = parent
	if(istype(E) && !E.active)
		E.activate(user)	//if the emitter is not active, trigger the activate proc to toggle it
		
/datum/wifi/receiver/button/emitter/deactivate(mob/living/user)
	..()
	var/obj/machinery/power/emitter/E = parent
	if(istype(E) && E.active)
		E.activate(user)	//if the emitter is active, trigger the activate proc to toggle it

//-------------------------------
// Crematorium
//-------------------------------
/datum/wifi/receiver/button/crematorium/activate(mob/living/user)
	..()
	var/obj/structure/crematorium/C = parent
	if(istype(C))
		C.cremate(user)

//-------------------------------
// Mounted Flash
//-------------------------------
/datum/wifi/receiver/button/flasher/activate(mob/living/user)
	..()
	var/obj/machinery/flasher/F = parent
	if(istype(F))
		F.flash()

//-------------------------------
// Holosign
//-------------------------------
/datum/wifi/receiver/button/holosign/activate(mob/living/user)
	..()
	var/obj/machinery/holosign/H = parent
	if(istype(H) && !H.lit)
		H.toggle()

/datum/wifi/receiver/button/holosign/deactivate(mob/living/user)
	..()
	var/obj/machinery/holosign/H = parent
	if(istype(H) && H.lit)
		H.toggle()
