//-------------------------------
// Doors
//-------------------------------
/datum/wifi/receiver/button/door/activate()
	var/obj/machinery/door/D = parent
	if(istype(D) && D.can_open())
		D.open()

/datum/wifi/receiver/button/door/deactivate()
	var/obj/machinery/door/D = parent
	if(istype(D) && D.can_close())
		D.close()

/datum/wifi/sender/door/proc/open()
	var/datum/spawn_sync/S = new()

	for(var/datum/wifi/receiver/button/door/D in connected_devices)
		S.open()
		spawn()
			try
				D.activate()
			catch
			
			S.close()
	S.finalize()

	while(S.check())
		sleep(1)
	return

/datum/wifi/sender/door/proc/close()
	var/datum/spawn_sync/S = new()

	for(var/datum/wifi/receiver/button/door/D in connected_devices)
		S.open()
		spawn()
			try
				D.deactivate()
			catch
			
			S.close()
	S.finalize()

	while(S.check())
		sleep(1)
	return


//-------------------------------
// Buttons
//-------------------------------
/datum/wifi/receiver/button/proc/activate(mob/living/user)

/datum/wifi/receiver/button/proc/deactivate(mob/living/user)
	activate(user)		//override this if you want deactivate to actually do something

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
	var/obj/machinery/holosign/H = parent
	if(istype(H) && H.lit)
		H.toggle()

//-------------------------------
// Igniter
//-------------------------------
/datum/wifi/receiver/button/igniter/activate(mob/living/user)
	..()
	var/obj/machinery/igniter/I = parent
	if(istype(I))
		if(!I.on)
			I.ignite()

/datum/wifi/receiver/button/igniter/deactivate(mob/living/user)
	if(istype(parent, /obj/machinery/igniter))
		var/obj/machinery/igniter/I = parent
		if(I.on)
			I.ignite()

//-------------------------------
// Sparker
//-------------------------------
/datum/wifi/receiver/button/sparker/activate(mob/living/user)
	..()
	var/obj/machinery/sparker/S = parent
	if(istype(S))
		S.ignite()

//-------------------------------
// Mass Driver Button
//-------------------------------
/datum/wifi/receiver/button/mass_driver/activate(mob/living/user)
	..()
	var/obj/machinery/mass_driver/M = parent
	if(istype(M))
		M.drive()

//-------------------------------
// Mass Driver Process
//-------------------------------
/datum/wifi/sender/mass_driver/proc/cycle()
	var/datum/spawn_sync/S = new()

	//tell all doors to open
	for(var/datum/wifi/receiver/button/door/D in connected_devices)
		S.open()
		spawn()
			try
				D.activate()
			catch
			
			S.close()
	S.finalize()

	//wait until they have all opened to continue
	while(S.check())
		sleep(1)

	//tell all mass drivers to launch
	for(var/datum/wifi/receiver/button/mass_driver/M in connected_devices)
		if(istype(M))
			spawn()
				M.activate()

	sleep(20)

	//tell all doors to close
	S.reset()
	for(var/datum/wifi/receiver/button/door/D in connected_devices)
		S.open()
		spawn()
			try
				D.deactivate()
			catch

			S.close()
	S.finalize()

	//wait until they have all closed to continue
	while(S.check())
		sleep(1)
	return
