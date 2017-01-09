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
		user.drop_from_inventory(W, src)
		loaded = W
		to_chat(user, "<span class='notice'>You insert the [loaded] into the [src].</span>")
	else
		to_chat(user, "<span class='notice'>The [W] doesn't fit!</span>")

/obj/machinery/uniform_printer/attack_hand(mob/user as mob)
	var/choice = input("What do you want to do with \the [src]?") as null|anything in list("eject ID", "print") //No idea how to make a proper UI --Cirra
	if(!choice)
		return
	if(choice == "eject ID")
		if(loaded)
			user.put_in_hands(loaded)
			loaded = null
		else
			to_chat(user, "<span class='notice'>There is no ID in the [src].</span>")
			return
	if(choice == "print")
		if(loaded)
			var/list/user_access = loaded.access
			world << json_encode(user_access) //D
			var/datum/mil_branch/user_branch = null
			for(var/datum/data/record/t in data_core.general)
				if(t.fields["name"] == loaded.registered_name)
					user_branch = mil_branches.get_branch(t.fields["mil_branch"])
					world << user_branch //D
					break
			world << "43"
			var/list/available_clothing = list()
			world << "44"
			for(var/thing in all_clothing)
				var/obj/item/clothing/C = thing
				world << "47 [C]"
				if((!length(initial(C.required_access))) && (!initial(C.required_branch)))
					continue
				var/correct = 0
				var/required = 0
				if(length(initial(C.required_access)))
					required++
					for(var/i in initial(C.required_access))
						if(i in user_access)
							correct++
							world << "57 correct"
							break
				if(initial(C.required_branch))
					required++
					if(initial(C.required_branch) == user_branch)
						correct++
						world << "63 correct"
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
