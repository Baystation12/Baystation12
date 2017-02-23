/obj/item/weapon/gun/attackby(obj/item/I as obj, mob/user as mob)
	var/weldingToolDelay = 10 SECONDS

	if(istype(I, /obj/item/weapon/weldingtool)) // Best quality tool, full erasure
		var/obj/item/weapon/weldingtool/tool = I // Recasts
		if(!tool.isOn()) //
			to_chat(user, "You need to turn the welding tool on before trying to do that.")
		else
			to_chat(user, "You start erasing the serial number from [name]")
			if(do_after(user, weldingToolDelay))
				to_chat(user, "You erased the serial number from [name]")
				serial_number = "<i>gibberish</i>"

/obj/item/weapon/gun/proc/generate_serial()
  // ARMORY AREA
	// var/armoryArea = /area/constructionsite // change here
	// var/currentArea = get_area(src)
  // to_world(currentArea)
	return random_id(gunSerialRepo, 10000, 99999)
