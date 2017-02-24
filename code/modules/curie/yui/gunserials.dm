/obj/item/weapon/gun/attackby(obj/item/I as obj, mob/user as mob)
	var/weldingToolDelay = 10 SECONDS
	var/drillDelay			 = 20 SECONDS
	var/crowbarDelay 		 = 30 SECONDS

	if(istype(I, /obj/item/weapon/weldingtool)) // Best quality tool, full erasure
		var/obj/item/weapon/weldingtool/tool = I // Recasts
		if(!tool.isOn()) //
			to_chat(user, "You need to turn the welding tool on before trying to do that.")
		else
			to_chat(user, "You start erasing the serial number from [name]")
			if(do_after(user, weldingToolDelay))
				to_chat(user, "You melted the serial number from [name]")
				serial_number = "seems to have been molten down"
				return 1

	else if(istype(I, /obj/item/weapon/crowbar))
		to_chat(user, "You start beating the shit out of the serial number from [name]")
		if(do_after(user, crowbarDelay))
			to_chat(user, "You battered the serial number from [name]")
			serial_number = "seems to have been battered to gibberish"
			return 1

	else if(istype(I, /obj/item/weapon/surgicaldrill))
		to_chat(user, "You start beating the shit out of the serial number from [name]")
		if(do_after(user, drillDelay))
			to_chat(user, "You drilled the serial number from [name]")
			serial_number = "seems to have been precisely carved out"
			return 1

/obj/item/weapon/gun/proc/generate_serial()
  // ARMORY AREA
	// var/armoryArea = /area/constructionsite // change here
	// var/currentArea = get_area(src)
  // to_world(currentArea)
	return "is " + num2text(random_id("gun_serials", 10000, 99999))
