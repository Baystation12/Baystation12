var/all_clothing = subtypesof(/obj/item/clothing)

/obj/machinery/uniform_printer
	name = "uniform printer"
	desc = "This is a uniform printer. It prints uniforms."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdapainter"
	idle_power_usage = 2
	active_power_usage = 300
	var/obj/item/weapon/card/id/loaded = null

/obj/machinery/uniform_printer/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(loaded || !W || !user)
		return 0
	if(istype(W, /obj/item/weapon/card/id))
		user.remove_from_mob(W)
		loaded = W
		loaded.loc = src
		to_chat(user, "You insert the [loaded] into the [src].")
	else
		to_chat(user, "The [W] doesn't fit!")

/obj/machinery/uniform_printer/attack_hand(mob/user as mob)
	var/choice = input("What do you want to do with \the [src]?") as null|anything in list("eject ID", "print") //No idea how to make a proper UI --Cirra
	if(!choice)
		return
	if(choice == "eject ID")
		if(loaded)
			user.put_in_hands(loaded)
			loaded = null
		else
			to_chat(user, "There is no ID in the [src].")
			return
	if(choice == "print")
		if(loaded)
			var/list/user_access = list(loaded.access)
			world << user_access //D
			var/datum/mil_branch/user_branch = null
			for(var/datum/data/record/t in data_core.general)
				if(t.fields["name"] == loaded.registered_name)
					user_branch = mil_branches.get_branch(t.fields["mil_branch"])
					world << user_branch //D
					break
			var/list/available_clothing = list()
			for(var/obj/item/clothing/C in all_clothing)
				if((!C.required_access) && (!C.required_branch))
					continue
				var/correct = 0
				var/required = 0
				if(C.required_access)
					required++
					for(var/i in C.required_access)
						if(i in user_access)
							correct++
							break
				if(C.required_branch)
					required++
					if(C.required_branch == user_branch)
						correct++
				if(correct == required)
					available_clothing.Add(C)
					world << "added [C]"
			var/choice2 = input("What would you like to print?") as null|anything in available_clothing
			if(!choice2)
				return
			var/obj/item/clothing/output = new choice2(src)
			user.put_in_hands(output)
		else
			to_chat(user, "There is no ID in the [src].")
			return
