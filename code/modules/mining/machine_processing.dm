#define ORE_PROC_GOLD 1
#define ORE_PROC_SILVER 2
#define ORE_PROC_DIAMOND 4
#define ORE_PROC_GLASS 8
#define ORE_PROC_PHORON 16
#define ORE_PROC_URANIUM 32
#define ORE_PROC_IRON 64
#define ORE_PROC_CLOWN 128

/**********************Mineral processing unit console**************************/

/obj/machinery/mineral/processing_unit_console
	name = "production machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 1
	anchored = 1
	var/obj/machinery/mineral/processing_unit/machine = null
	var/machinedir = EAST

/obj/machinery/mineral/processing_unit_console/New()
	..()
	spawn(7)
		src.machine = locate(/obj/machinery/mineral/processing_unit, get_step(src, machinedir))
		if (machine)
			machine.CONSOLE = src
		else
			del(src)

/obj/machinery/mineral/processing_unit_console/process()
	updateDialog()

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/processing_unit_console/interact(mob/user)
	user.set_machine(src)

	var/dat = "<b>Smelter control console</b><br><br>"
	//iron
	if(machine.ore_iron || machine.ore_glass || machine.ore_phoron || machine.ore_uranium || machine.ore_gold || machine.ore_silver || machine.ore_diamond || machine.ore_clown || machine.ore_adamantine)
		if(machine.ore_iron)
			if (machine.selected & ORE_PROC_IRON)
				dat += text("<A href='?src=\ref[src];sel_iron=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_iron=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Iron: [machine.ore_iron]<br>")
		else
			machine.selected &= ~ORE_PROC_IRON

		//sand - glass
		if(machine.ore_glass)
			if (machine.selected & ORE_PROC_GLASS)
				dat += text("<A href='?src=\ref[src];sel_glass=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_glass=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Sand: [machine.ore_glass]<br>")
		else
			machine.selected &= ~ORE_PROC_GLASS

		//phoron
		if(machine.ore_phoron)
			if (machine.selected & ORE_PROC_PHORON)
				dat += text("<A href='?src=\ref[src];sel_phoron=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_phoron=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Phoron: [machine.ore_phoron]<br>")
		else
			machine.selected &= ~ORE_PROC_PHORON

		//uranium
		if(machine.ore_uranium)
			if (machine.selected & ORE_PROC_URANIUM)
				dat += text("<A href='?src=\ref[src];sel_uranium=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_uranium=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Uranium: [machine.ore_uranium]<br>")
		else
			machine.selected &= ~ORE_PROC_URANIUM

		//gold
		if(machine.ore_gold)
			if (machine.selected & ORE_PROC_GOLD)
				dat += text("<A href='?src=\ref[src];sel_gold=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_gold=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Gold: [machine.ore_gold]<br>")
		else
			machine.selected &= ~ORE_PROC_GOLD

		//silver
		if(machine.ore_silver)
			if (machine.selected & ORE_PROC_SILVER)
				dat += text("<A href='?src=\ref[src];sel_silver=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_silver=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Silver: [machine.ore_silver]<br>")
		else
			machine.selected &= ~ORE_PROC_SILVER

		//diamond
		if(machine.ore_diamond)
			if (machine.selected & ORE_PROC_DIAMOND)
				dat += text("<A href='?src=\ref[src];sel_diamond=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_diamond=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Diamond: [machine.ore_diamond]<br>")
		else
			machine.selected &= ~ORE_PROC_DIAMOND

		//bananium
		if(machine.ore_clown)
			if (machine.selected & ORE_PROC_CLOWN)
				dat += text("<A href='?src=\ref[src];sel_clown=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_clown=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Bananium: [machine.ore_clown]<br>")
		else
			machine.selected &= ~ORE_PROC_CLOWN

		//On or off
		dat += text("Machine is currently ")
		if (machine.on==1)
			dat += text("<A href='?src=\ref[src];set_on=off'>On</A> ")
		else
			dat += text("<A href='?src=\ref[src];set_on=on'>Off</A> ")
	else
		dat+="---No Materials Loaded---"


	user << browse("[dat]", "window=console_processing_unit")
	onclose(user, "console_processing_unit")


/obj/machinery/mineral/processing_unit_console/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["sel_iron"])
		if (href_list["sel_iron"] == "yes")
			machine.selected |= ORE_PROC_IRON
		else
			machine.selected &= ~ORE_PROC_IRON
	if(href_list["sel_glass"])
		if (href_list["sel_glass"] == "yes")
			machine.selected |= ORE_PROC_GLASS
		else
			machine.selected &= ~ORE_PROC_GLASS
	if(href_list["sel_phoron"])
		if (href_list["sel_phoron"] == "yes")
			machine.selected |= ORE_PROC_PHORON
		else
			machine.selected &= ~ORE_PROC_PHORON
	if(href_list["sel_uranium"])
		if (href_list["sel_uranium"] == "yes")
			machine.selected |= ORE_PROC_URANIUM
		else
			machine.selected &= ~ORE_PROC_URANIUM
	if(href_list["sel_gold"])
		if (href_list["sel_gold"] == "yes")
			machine.selected |= ORE_PROC_GOLD
		else
			machine.selected &= ~ORE_PROC_GOLD
	if(href_list["sel_silver"])
		if (href_list["sel_silver"] == "yes")
			machine.selected |= ORE_PROC_SILVER
		else
			machine.selected &= ~ORE_PROC_SILVER
	if(href_list["sel_diamond"])
		if (href_list["sel_diamond"] == "yes")
			machine.selected |= ORE_PROC_DIAMOND
		else
			machine.selected &= ~ORE_PROC_DIAMOND
	if(href_list["sel_clown"])
		if (href_list["sel_clown"] == "yes")
			machine.selected |= ORE_PROC_CLOWN
		else
			machine.selected &= ~ORE_PROC_CLOWN

	if(href_list["set_on"])
		if (href_list["set_on"] == "on")
			machine.on = 1
		else
			machine.on = 0
	src.updateUsrDialog()
	return

/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "furnace"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	density = 1
	anchored = 1.0
	luminosity = 3					//Big fire with window, yeah it puts out a little light.
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/obj/machinery/mineral/CONSOLE = null
	var/ore_gold = 0;
	var/ore_silver = 0;
	var/ore_diamond = 0;
	var/ore_glass = 0;
	var/ore_phoron = 0;
	var/ore_uranium = 0;
	var/ore_iron = 0;
	var/ore_clown = 0;
	var/ore_adamantine = 0;
	var/selected = 0
/*
	var/selected_gold = 0
	var/selected_silver = 0
	var/selected_diamond = 0
	var/selected_glass = 0
	var/selected_plasma = 0
	var/selected_uranium = 0
	var/selected_iron = 0
	var/selected_clown = 0
*/
	var/on = 0 //0 = off, 1 =... oh you know!


/obj/machinery/mineral/processing_unit/New()
	..()
	spawn( 5 )
		for (var/dir in cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if(src.input) break
		for (var/dir in cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		processing_objects.Add(src)
		return
	return

/obj/machinery/mineral/processing_unit/process()
	if (src.output && src.input)
		var/i
		for (i = 0; i < 10; i++)
			if (on)



				if (selected == ORE_PROC_GLASS)
					if (ore_glass > 0)
						ore_glass--;
						new /obj/item/stack/sheet/glass(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_GLASS + ORE_PROC_IRON)
					if (ore_glass > 0 && ore_iron > 0)
						ore_glass--;
						ore_iron--;
						new /obj/item/stack/sheet/rglass(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_GOLD)
					if (ore_gold > 0)
						ore_gold--;
						new /obj/item/stack/sheet/mineral/gold(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_SILVER)
					if (ore_silver > 0)
						ore_silver--;
						new /obj/item/stack/sheet/mineral/silver(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_DIAMOND)
					if (ore_diamond > 0)
						ore_diamond--;
						new /obj/item/stack/sheet/mineral/diamond(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_PHORON)
					if (ore_phoron > 0)
						ore_phoron--;
						new /obj/item/stack/sheet/mineral/phoron(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_URANIUM)
					if (ore_uranium > 0)
						ore_uranium--;
						new /obj/item/stack/sheet/mineral/uranium(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_IRON)
					if (ore_iron > 0)
						ore_iron--;
						new /obj/item/stack/sheet/metal(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_IRON + ORE_PROC_PHORON)
					if (ore_iron > 0 && ore_phoron > 0)
						ore_iron--;
						ore_phoron--;
						new /obj/item/stack/sheet/plasteel(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_CLOWN)
					if (ore_clown > 0)
						ore_clown--;
						new /obj/item/stack/sheet/mineral/clown(output.loc)
					else
						on = 0
					continue
			/*
				if (selected == ORE_PROC_GLASS + ORE_PROC_PHORON)
					if (ore_glass > 0 && ore_plasma > 0)
						ore_glass--;
						ore_plasma--;
						new /obj/item/stack/sheet/glass/plasmaglass(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_GLASS + ORE_PROC_IRON + ORE_PROC_PHORON)
					if (ore_glass > 0 && ore_plasma > 0 && ore_iron > 0)
						ore_glass--;
						ore_iron--;
						ore_plasma--;
						new /obj/item/stack/sheet/glass/plasmarglass(output.loc)
					else
						on = 0
					continue
			*/


				if (selected == ORE_PROC_URANIUM + ORE_PROC_DIAMOND)
					if (ore_uranium >= 2 && ore_diamond >= 1)
						ore_uranium -= 2
						ore_diamond -= 1
						new /obj/item/stack/sheet/mineral/adamantine(output.loc)
					else
						on = 0
					continue
				if (selected == ORE_PROC_SILVER + ORE_PROC_PHORON)
					if (ore_silver >= 1 && ore_phoron >= 3)
						ore_silver -= 1
						ore_phoron -= 3
						new /obj/item/stack/sheet/mineral/mythril(output.loc)
					else
						on = 0
					continue



				//if a non valid combination is selected

				var/b = 1 //this part checks if all required ores are available

				if (!selected)
					b = 0

				if (selected & ORE_PROC_GOLD)
					if (ore_gold <= 0)
						b = 0
				if (selected & ORE_PROC_SILVER)
					if (ore_silver <= 0)
						b = 0
				if (selected & ORE_PROC_DIAMOND)
					if (ore_diamond <= 0)
						b = 0
				if (selected & ORE_PROC_URANIUM)
					if (ore_uranium <= 0)
						b = 0
				if (selected & ORE_PROC_PHORON)
					if (ore_phoron <= 0)
						b = 0
				if (selected & ORE_PROC_IRON)
					if (ore_iron <= 0)
						b = 0
				if (selected & ORE_PROC_GLASS)
					if (ore_glass <= 0)
						b = 0
				if (selected & ORE_PROC_CLOWN)
					if (ore_clown <= 0)
						b = 0

				if (b) //if they are, deduct one from each, produce slag and shut the machine off
					if (selected & ORE_PROC_GOLD)
						ore_gold--
					if (selected & ORE_PROC_SILVER)
						ore_silver--
					if (selected & ORE_PROC_DIAMOND)
						ore_diamond--
					if (selected & ORE_PROC_URANIUM)
						ore_uranium--
					if (selected & ORE_PROC_PHORON)
						ore_phoron--
					if (selected & ORE_PROC_IRON)
						ore_iron--
					if (selected & ORE_PROC_CLOWN)
						ore_clown--
					new /obj/item/weapon/ore/slag(output.loc)
					on = 0
				else
					on = 0
					break
				break
			else
				break
		for (i = 0; i < 10; i++)
			var/obj/item/O
			O = locate(/obj/item, input.loc)
			if (O)
				if (istype(O,/obj/item/weapon/ore/iron))
					ore_iron++;
					O.loc = null
					//del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/glass))
					ore_glass++;
					O.loc = null
					//del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/diamond))
					ore_diamond++;
					O.loc = null
					//del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/phoron))
					ore_phoron++
					O.loc = null
					//del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/gold))
					ore_gold++
					O.loc = null
					//del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/silver))
					ore_silver++
					O.loc = null
					//del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/uranium))
					ore_uranium++
					O.loc = null
					//del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/clown))
					ore_clown++
					O.loc = null
					//del(O)
					continue
				O.loc = src.output.loc
			else
				break
	return
