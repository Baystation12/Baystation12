//-------------------------------
// Buttons
//	Sender: intended to be used by buttons, when the button is pressed it will call activate() on all connected /button 
//			receivers.
//	Receiver: does whatever the subtype does. deactivate() by default calls activate(), so you will have to override in 
//			  it in a subtype if you want it to do something.
//-------------------------------
/datum/wifi/sender/button/activate(mob/living/user)
	for(var/datum/wifi/receiver/button/B in connected_devices)
		B.activate(user)

/datum/wifi/sender/button/deactivate(mob/living/user)
	for(var/datum/wifi/receiver/button/B in connected_devices)
		B.deactivate(user)

/datum/wifi/receiver/button/proc/activate(mob/living/user)

/datum/wifi/receiver/button/proc/deactivate(mob/living/user)
	activate(user)		//override this if you want deactivate to actually do something

//-------------------------------
// Doors
//	Sender: sends an open/close request to all connected /door receivers. Utilises spawn_sync to trigger all doors to 
//			open at approximately the same time. Waits until all doors have finished opening before returning.
//	Receiver: will try to open/close the parent door when activate/deactivate is called.
//-------------------------------

// Sender procs
/datum/wifi/sender/door/activate(var/command)
	if(!command)
		return

	var/datum/spawn_sync/S = new()

	for(var/datum/wifi/receiver/button/door/D in connected_devices)
		S.start_worker(D, command)
	S.wait_until_done()
	return

//Receiver procs
/datum/wifi/receiver/button/door/proc/open()
	var/obj/machinery/door/D = parent
	if(istype(D) && D.can_open())
		D.open()

/datum/wifi/receiver/button/door/proc/close()
	var/obj/machinery/door/D = parent
	if(istype(D) && D.can_close())
		D.close()

/datum/wifi/receiver/button/door/proc/lock()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.lock()

/datum/wifi/receiver/button/door/proc/unlock()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.unlock()

/datum/wifi/receiver/button/door/proc/enable_idscan()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.set_idscan(1)

/datum/wifi/receiver/button/door/proc/disable_idscan()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.set_idscan(0)

/datum/wifi/receiver/button/door/proc/enable_safeties()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.set_safeties(1)

/datum/wifi/receiver/button/door/proc/disable_safeties()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.set_safeties(0)

/datum/wifi/receiver/button/door/proc/electrify()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.electrify(-1)

/datum/wifi/receiver/button/door/proc/unelectrify()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.electrify(0)

//-------------------------------
// Emitter
// Activates/deactivates the parent emitter.
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
// Triggers cremate() on the parent /crematorium.
//-------------------------------
/datum/wifi/receiver/button/crematorium/activate(mob/living/user)
	..()
	var/obj/structure/crematorium/C = parent
	if(istype(C))
		C.cremate(user)

//-------------------------------
// Mounted Flash
// Triggers flash() on the parent /flasher.
//-------------------------------
/datum/wifi/receiver/button/flasher/activate(mob/living/user)
	..()
	var/obj/machinery/flasher/F = parent
	if(istype(F))
		F.flash()

//-------------------------------
// Holosign
// Turns the parent /holosign on/off.
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
// Turns the parent /igniter on/off.
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
// Triggers the parent /sparker to ignite().
//-------------------------------
/datum/wifi/receiver/button/sparker/activate(mob/living/user)
	..()
	var/obj/machinery/sparker/S = parent
	if(istype(S))
		S.ignite()

//-------------------------------
// Mass Driver
//	Sender: carries out a sequence of first opening all connected doors, then activating all connected mass drivers, 
//			then closes all connected doors. It will wait before continuing the sequence after opening/closing the doors.
//	Receiver: Triggers the parent mass dirver to activate.
//-------------------------------
/datum/wifi/sender/mass_driver/activate()
	var/datum/spawn_sync/S = new()

	//tell all doors to open
	for(var/datum/wifi/receiver/button/door/D in connected_devices)
		S.start_worker(D, "open")
	S.wait_until_done()
	S.reset()
	//tell all mass drivers to launch
	for(var/datum/wifi/receiver/button/mass_driver/M in connected_devices)
		spawn()
			M.activate()
	sleep(20)

	//tell all doors to close
	S.reset()
	for(var/datum/wifi/receiver/button/door/D in connected_devices)
		S.start_worker(D, "close")
	S.wait_until_done()
	return

/datum/wifi/receiver/button/mass_driver/activate(mob/living/user)
	..()
	var/obj/machinery/mass_driver/M = parent
	if(istype(M))
		M.drive()
