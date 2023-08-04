/obj/item/device/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 100)
	throwforce = 2
	throw_speed = 3
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 1)

	var/secured = 1
	var/list/attached_overlays = null
	var/obj/item/device/assembly_holder/holder = null
	var/cooldown = 0//To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

	var/const/WIRE_RECEIVE = 1			//Allows Pulsed(0) to call Activate()
	var/const/WIRE_PULSE = 2				//Allows Pulse(0) to act on the holder
	var/const/WIRE_PULSE_SPECIAL = 4		//Allows Pulse(0) to act on the holders special assembly
	var/const/WIRE_RADIO_RECEIVE = 8		//Allows Pulsed(1) to call Activate()
	var/const/WIRE_RADIO_PULSE = 16		//Allows Pulse(1) to send a radio message

/obj/item/device/assembly/proc/activate()									//What the device does when turned on
	return

/obj/item/device/assembly/proc/pulsed(radio = 0)						//Called when another assembly acts on this one, radio will determine where it came from for wire calcs
	return

/obj/item/device/assembly/proc/pulse(radio = 0)						//Called when this device attempts to act on another device, radio determines if it was sent via radio or direct
	return

/obj/item/device/assembly/proc/set_secure(make_secure = FALSE)								//Code that has to happen when the assembly is un\secured goes here
	return

/obj/item/device/assembly/proc/attach_assembly(obj/A, mob/user)	//Called when an assembly is attacked by another
	return

/obj/item/device/assembly/proc/process_cooldown()							//Called via spawn(10) to have it count down the cooldown var
	return

/obj/item/device/assembly/proc/holder_movement()							//Called when the holder is moved
	return

/obj/item/device/assembly/interact(mob/user as mob)					//Called when attack_self is called
	return


/obj/item/device/assembly/process_cooldown()
	cooldown--
	if(cooldown <= 0)	return 0
	spawn(10)
		process_cooldown()
	return 1


/obj/item/device/assembly/pulsed(radio = 0)
	if(holder && (wires & WIRE_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return 1


/obj/item/device/assembly/pulse(radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
//		if(radio && (wires & WIRE_RADIO_PULSE))
		//Not sure what goes here quite yet send signal?
	return 1


/obj/item/device/assembly/activate()
	if(!secured || (cooldown > 0))	return 0
	cooldown = 2
	spawn(10)
		process_cooldown()
	return 1


/obj/item/device/assembly/set_secure(make_secure)
	if (make_secure == secured)
		return
	else
		secured = make_secure
		update_icon()
	return secured


/obj/item/device/assembly/use_tool(obj/item/tool, mob/user, list/click_params)
	// Assembly - Attach assembly
	if (isassembly(tool))
		if (!user.canUnEquip(tool))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		if (!user.canUnEquip(src))
			FEEDBACK_UNEQUIP_FAILURE(user, src)
			return TRUE
		if (secured)
			USE_FEEDBACK_FAILURE("\The [src] is not ready to be modified or attached.")
			return TRUE
		var/obj/item/device/assembly/assembly = tool
		if (assembly.secured)
			USE_FEEDBACK_FAILURE("\The [tool] is not ready to be modified or attached.")
			return TRUE
		user.unEquip(src)
		user.unEquip(tool)
		holder = new /obj/item/device/assembly_holder(get_turf(src))
		forceMove(holder)
		transfer_fingerprints_to(holder)
		assembly.holder = holder
		tool.forceMove(holder)
		tool.transfer_fingerprints_to(holder)
		holder.a_left = src
		holder.a_right = tool
		holder.SetName("[name]-[tool.name] assembly")
		holder.update_icon()
		user.put_in_hands(holder)
		set_secure(TRUE)
		assembly.set_secure(TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] attaches \a [tool] to \a [src]."),
			SPAN_NOTICE("You attach \the [tool] to \the [src]."),
			range = 3
		)
		return TRUE

	// Screwdriver - Toggle secured
	if (isScrewdriver(tool))
		set_secure(!secured)
		user.visible_message(
			SPAN_NOTICE("\The [user] adjusts \a [src] with \a [tool]."),
			SPAN_NOTICE("You adjust \the [src] with \the [tool]. It [secured ? "is now ready to use" : "can now be taken apart"].")
		)
		return TRUE

	return ..()


/obj/item/device/assembly/Process()
	return PROCESS_KILL


/obj/item/device/assembly/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 || loc == user)
		if(secured)
			to_chat(user, "\The [src] is ready!")
		else
			to_chat(user, "\The [src] can be attached!")


/obj/item/device/assembly/attack_self(mob/user as mob)
	if(!user)	return 0
	user.set_machine(src)
	interact(user)
	return 1

/obj/item/device/assembly/interact(mob/user as mob)
	return //HTML MENU FOR WIRES GOES HERE

/obj/item/device/assembly/nano_host()
	if(istype(loc, /obj/item/device/assembly_holder))
		return loc.nano_host()
	return ..()

/*
	var/small_icon_state = null//If this obj will go inside the assembly use this for icons
	var/list/small_icon_state_overlays = null//Same here
	var/obj/holder = null
	var/cooldown = 0//To prevent spam

	proc
		Activate()//Called when this assembly is pulsed by another one
		Process_cooldown()//Call this via spawn(10) to have it count down the cooldown var
		Attach_Holder(var/obj/H, var/mob/user)//Called when an assembly holder attempts to attach, sets src's loc in here


	Activate()
		if(cooldown > 0)
			return 0
		cooldown = 2
		spawn(10)
			Process_cooldown()
		//Rest of code here
		return 0


	Process_cooldown()
		cooldown--
		if(cooldown <= 0)	return 0
		spawn(10)
			Process_cooldown()
		return 1


	Attach_Holder(var/obj/H, var/mob/user)
		if(!H)	return 0
		if(!H.IsAssemblyHolder())	return 0
		//Remember to have it set its loc somewhere in here


*/
