/obj/item/device/electronic_assembly
	name = "electronic assembly"
	desc = "It's a case, for building electronics with."
	w_class = 2
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_small"
	var/max_components = 10
	var/max_complexity = 30
	var/opened = 0

/obj/item/device/electronic_assembly/medium
	name = "electronic mechanism"
	icon_state = "setup_medium"
	w_class = 3
	max_components = 20
	max_complexity = 50

/obj/item/device/electronic_assembly/large
	name = "electronic machine"
	icon_state = "setup"
	w_class = 4
	max_components = 30
	max_complexity = 60

/obj/item/device/electronic_assembly/update_icon()
	if(opened)
		icon_state = initial(icon_state) + "-open"
	else
		icon_state = initial(icon_state)

/obj/item/device/electronic_assembly/examine(mob/user)
	..()
	if(user.Adjacent(src))
		if(!opened)
			for(var/obj/item/integrated_circuit/output/screen/S in contents)
				if(S.stuff_to_display)
					to_chat(user, "There's a little screen labeled '[S.name]', which displays '[S.stuff_to_display]'.")
		else
			var/obj/item/integrated_circuit/IC = input(user, "Which circuit do you want to examine?", "Examination") as null|anything in contents
			if(IC && CanInteract(user, physical_state))
				IC.examine(user)

/obj/item/device/electronic_assembly/CanUseTopic()
	if(!opened)
		return STATUS_CLOSE
	return ..()

/obj/item/device/electronic_assembly/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/integrated_circuit))
		if(!opened)
			to_chat(user, "<span class='warning'>\The [src] isn't opened, so you can't put anything inside.  Try using a crowbar.</span>")
			return 0
		var/obj/item/integrated_circuit/IC = I
		var/total_parts = 0
		var/total_complexity = 0
		for(var/obj/item/integrated_circuit/part in contents)
			total_parts++
			total_complexity = total_complexity + part.complexity

		if( (total_parts + 1) >= max_components)
			to_chat(user, "<span class='warning'>You can't seem to add this [IC.name], since there's no more room.</span>")
			return 0
		if( (total_complexity + IC.complexity) >= max_complexity)
			to_chat(user, "<span class='warning'>You can't seem to add this [IC.name], since this setup's too complicated for the case.</span>")
			return 0

		to_chat(user, "<span class='notice'>You slide \the [IC] inside \the [src].</span>")
		user.drop_item()
		IC.forceMove(src)
		playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(!opened)
			to_chat(user, "<span class='warning'>\The [src] isn't opened, so you can't remove anything inside.  Try using a crowbar.</span>")
			return 0
		if(!contents.len)
			to_chat(user, "<span class='warning'>There's nothing inside this to remove!</span>")
			return 0
		var/obj/item/integrated_circuit/option = input("What do you want to remove?", "Component Removal") as null|anything in contents
		if(option  && CanInteract(user, physical_state))
			option.disconnect_all()
			option.forceMove(get_turf(src))
			playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You pop \the [option] out of the case, and slide it out.</span>")
	if(istype(I, /obj/item/weapon/crowbar))
		playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
		opened = !opened
		to_chat(user, "<span class='notice'>You [opened ? "opened" : "closed"] \the [src].</span>")
		update_icon()
	if(istype(I, /obj/item/device/integrated_electronics/wirer))
		if(opened)
			var/obj/item/integrated_circuit/IC = input(user, "Which circuit do you want to examine?", "Examination") as null|anything in contents
			if(IC && CanInteract(user, physical_state))
				IC.examine(user)
		else
			to_chat(user, "<span class='warning'>\The [src] isn't opened, so you can't fiddle with the internal components.  \
			Try using a crowbar.</span>")

/obj/item/device/electronic_assembly/attack_self(mob/user)
	var/list/available_inputs = list()
	for(var/obj/item/integrated_circuit/input/input in contents)
		if(input.can_be_asked_input)
			available_inputs.Add(input)
	var/obj/item/integrated_circuit/input/choice = input(user, "What do you want to interact with?", "Interaction") as null|anything in available_inputs
	if(choice && CanInteract(user, physical_state))
		choice.ask_for_input(user)

/obj/item/device/electronic_assembly/emp_act(severity)
	..()
	for(var/atom/movable/AM in contents)
		AM.emp_act(severity)
