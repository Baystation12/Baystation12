//Place holder until I can think of a universal method of doing this.
/obj/item/device/assembly_holder/var/painted = 0
/obj/item/device/assembly_holder/proc/get_type()
	if(painted) return
	if(implantable)
		name = "spikey device"
		desc = "A weird, wire-covered contraption with a giant spike coming out of it."
		icon_state = "implant"
		item_state = "assembly"
		return
/*	for(var/obj/item/device/assembly/A in connected_devices)

		if(istype(A, /obj/item/device/assembly/chute))
			name = "modified disposal chute"
			desc = "It looks like a giant hole in the ground."
			icon_state = "chute"
			item_state = "assembly"
		if(istype(A, /obj/item/device/assembly/explosive/strong))
			name = "modified large explosive"
			desc = "This looks like it'll hurt..Alot."
			icon_state = "bomb"
			item_state = "assembly"
		else if(istype(A, /obj/item/device/assembly/mousetrap) || istype(A, /obj/item/device/assembly/infra))
			name = "modified trip mine"
			desc = "..O-oh."
			icon_state = "mine"
			item_state = "assembly"
		else if(istype(A, /obj/item/device/assembly/powersink))
			name = "modified power sink"
			desc = "It looks like it's glowing slightly.."
			icon_state = "powersink0"
			var/obj/item/device/assembly/powersink/P = A
			if(P.mode == 2)
				icon_state = "powersink1"
		else if(istype(A, /obj/item/device/assembly/flash))
			name = "modified flash"
			desc = "Used for blinding and being an asshole."
			icon_state = "flash"
			item_state = "flashtool"
		else if(istype(A, /obj/item/device/assembly/explosive/emexplosive))
			name = "modified emp grenade"
			desc = "A strange device glowing slightly blue. Hmm."
			icon_state = "emp"
			item_state = "empgrenade"
		else if(istype(A, /obj/item/device/assembly/explosive/flash))
			name = "modified flashbang"
			desc = "A bang that makes a flash. Or is it a flash that makes a bang?"
			icon_state = "flashbang"
			item_state = "flashbang"
		else if(istype(A, /obj/item/device/assembly/chem_mixer))
			name = "modified chemgrenade"
			desc = "A chemical grenade."
			icon_state = "chemg"
			item_state = "chemg"
		else if(istype(A, /obj/item/device/assembly/igniter) || istype(A, /obj/item/device/assembly/explosive))
			name = "modified explosive"
			desc = "An explosive! You can almost hear a quiet ticking.."
			icon_state = "grenade"
			item_state = "grenade"
		else if(istype(A, /obj/item/device/assembly/shocker))
			name = "modified shock device"
			desc = "Shocking!"
			icon_state = "shocker"
			item_state = "baton"
		else if(istype(A, /obj/item/device/assembly/syringe))
			name = "spikey device"
			desc = "A weird, wire-covered contraption with a giant spike coming out of it."
			icon_state = "implant"
			item_state = "syringe_0"
		else if(istype(A, /obj/item/device/assembly/meter) || istype(A, /obj/item/device/assembly/power_metre))
			name = "modified meter"
			desc = "A modified meter. For measuring."
			icon_state = "meter"
		else
			continue
		break
*/
/obj/item/device/assembly_holder/proc/paint_assembly(var/mob/user, var/obj/item/weapon/reagent_containers/glass/paint/paint)
	var/list/choices = list()
	switch(paint.icon_state)
		if("paint_red")
			choices = list("flash", "vest", "toolbox")
		if("paint_green")
			choices = list("gift", "green cap", "id-card")
		if("paint_black")
			choices = list("backpack", "whiskey", "shoes")
		if("paint_white")
			choices = list("first-aid-kit", "bottle", "paper")
		if("paint_blue")
			choices = list("rofflewaffles", "flashlight", "pill")
		if("paint_purple")
			choices = list("plumphelmet", "donut", "pen")
		if("paint_yellow")
			choices = list("banana-peel", "cake", "wet-floor-sign", "toy")
	var/inp = input(user, "What would you like \the [src] to look like?", "[src]") in choices
	icon_state = "p_[inp]"
	name = inp
	painted = 1
