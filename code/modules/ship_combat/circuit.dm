#define BLUE 1
#define GREEN 2
#define RED 3
#define BLACK 4

#define PURPLE 5
#define AQUA 6
#define YELLOW 7
#define ORANGE 8
/obj/item/upgrade_module
	name = "circuit board"
	desc = "A circuit board used for machinery."

	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"

	var/list/internal_wiring = new/list(16)
	var/spawn_type = null

	var/resistance = 1

	New(var/obj/machinery/M)
		..()
		rewire()
		if(M && M.type)
			spawn_type = M.type

	examine(var/mob/user)
		..()
		user << "<span class='notice'>\The [src] has [get_efficiency(1,0,0)]% efficiency!</span>"

	proc/rewire(var/chance = 1)
		for(var/i=1 to internal_wiring.len)
			if(internal_wiring[i] == BLACK)
				chance++
				continue
			if(internal_wiring[i] == RED) continue
			internal_wiring[i] |= pick(125;BLUE, 150;GREEN, (2*chance);PURPLE, (2*chance);AQUA, 5;RED, (3*chance);YELLOW, (2*chance);BLACK, (2*chance);ORANGE)

	ex_act(severity)
		if(1.0)
			for(var/i=1 to internal_wiring.len)
				if(internal_wiring[i] == YELLOW)
					if(prob(100/resistance))
						internal_wiring[i] = RED
					break
				if(prob(50/resistance))
					internal_wiring[i] = BLACK
				else if(prob(80/resistance))
					internal_wiring[i] = RED
		if(2.0)
			for(var/i=1 to internal_wiring.len)
				if(internal_wiring[i] == YELLOW)
					if(prob(40/resistance))
						internal_wiring[i] = RED
					break
				if(prob(30/resistance))
					internal_wiring[i] = BLACK
				else if(prob(45/resistance))
					internal_wiring[i]= RED
		if(3.0)
			for(var/i=1 to internal_wiring.len)
				if(internal_wiring[i] == YELLOW)
					if(prob(5/resistance))
						internal_wiring[i] = RED
					break
				if(prob(30/resistance))
					internal_wiring[i] = RED

/*	emp_act(severity)
		if(1.0)
			for(var/i=1 to internal_wiring.len)
				if(prob(45/resistance))
					internal_wiring[i] = RED
				else if(prob(5/resistance))
					internal_wiring[i] = BLACK
		if(2.0)
			for(var/i=1 to internal_wiring.len)
				if(prob(30/resistance))
					internal_wiring[i] = RED
				else if(prob(2/resistance))
					internal_wiring[i] = BLACK
		if(3.0)
			for(var/i=1 to internal_wiring.len)
				if(prob(15/resistance))
					internal_wiring[i] = RED
		..()
*/
	proc/get_ratio()
		var/blues = 0
		var/greens = 0
		for(var/i=1 to internal_wiring.len)
			if(internal_wiring[i] == BLUE)
				blues++
			else if(internal_wiring[i] == GREEN)
				greens++
			else if(internal_wiring[i] == AQUA)
				blues++
				greens++
			else if(internal_wiring[i] == PURPLE)
				var/red = 0
				var/blue = 0
				if((i != 1 && internal_wiring[(i-1)] == RED) && (i != internal_wiring.len && internal_wiring[(i+1)] == RED))
					red = 1
				if((i != 1 && internal_wiring[(i-1)] == BLUE) && (i != internal_wiring.len && internal_wiring[(i+1)] == BLUE))
					blue = 1
				if(red && blue)
					blues += 4
					greens += 2
			else if(internal_wiring[i] == YELLOW)
				var/red = 0
				var/green = 0
				if((i != 1 && internal_wiring[(i-1)] == RED) && (i != internal_wiring.len && internal_wiring[(i+1)] == RED))
					red = 1
				if((i != 1 && internal_wiring[(i-1)] == GREEN) && (i != internal_wiring.len && internal_wiring[(i+1)] == GREEN))
					green = 1
				if(red && green)
					greens++
			else if(internal_wiring[i] == ORANGE)
				var/red = 0
				var/yellow = 0
				if((i != 1 && internal_wiring[(i-1)] == RED) && (i != internal_wiring.len && internal_wiring[(i+1)] == RED))
					red = 1
				if((i != 1 && internal_wiring[(i-1)] == YELLOW) && (i != internal_wiring.len && internal_wiring[(i+1)] == YELLOW))
					yellow = 1
				if(red && yellow)
					greens += 5
					blues += 2
				break

		return list(blues, greens)

	proc/get_efficiency()
		var/list/wires = get_ratio()
		var/efficiency = 0
		while(wires[1] > 0 && wires[2] > 0)
			wires[1] -= 1
			wires[2] -= 1
			efficiency += 12.5
		return efficiency

	proc/splice(var/obj/item/upgrade_module/splicer)
		for(var/i=1 to internal_wiring.len)
			if(internal_wiring[i] == RED && (splicer.internal_wiring[i] == BLUE || splicer.internal_wiring[i] == GREEN))
				internal_wiring[i] = splicer.internal_wiring[i]

	proc/transcribe(var/obj/item/upgrade_module/transcriber)
		var/list/transcribable = list(RED, PURPLE, AQUA, YELLOW, ORANGE)
		var/list/overwritten = list(BLUE, GREEN)
		for(var/i=1 to internal_wiring.len)
			if(transcriber.internal_wiring[i] in overwritten && src.internal_wiring[i] in transcribable)
				internal_wiring[i] = transcriber.internal_wiring[i]

	proc/overwrite(var/obj/item/upgrade_module/overwritter)
		for(var/i=1 to internal_wiring.len)
			internal_wiring[i] = overwritter.internal_wiring[i]

	proc/shift()
		var/list/newlist = list()
		for(var/i=1 to internal_wiring.len)
			if(i == internal_wiring.len)
				newlist[1] = internal_wiring[i]
			newlist[(i+1)] = internal_wiring[i]
		internal_wiring = newlist

	attackby(var/obj/item/I, var/mob/user)
		if(istype(I, /obj/item/upgrade_module))
			var/obj/item/secondary = user.get_inactive_hand()
			if(istype(secondary, /obj/item/weapon/screwdriver))
				user.visible_message("<span class='notice'>\The [user] begins splicing \the [I] into \the [src].</span>")
				if(do_after(user, 100))
					user.visible_message("<span class='notice'>\The [user] splices \the [I] into \the [src].</span>")
					splice(I)
			else if(istype(secondary, /obj/item/device/multitool))
				user.visible_message("<span class='notice'>\The [user] begins transcribing \the [I] into \the [src].</span>")
				if(do_after(user, 100))
					user.visible_message("<span class='notice'>\The [user] transcribes \the [I] into \the [src].</span>")
					transcribe(I)
			else if(istype(secondary, /obj/item/upgrade_module))
				user.visible_message("<span class='notice'>\The [user] begins comparing \the [I] and \the [src].</span>")
				if(do_after(user, 100))
					var/obj/item/upgrade_module/to_compare = secondary
					user.visible_message("<span class='notice'>\The [user] begins comparing \the [I] and \the [src].</span>")
					user << "<span class='notice'>\The [src.get_efficiency() > to_compare.get_efficiency() ? "[src]" : "[to_compare]"] is more efficient!</span>"
			else if(istype(secondary, /obj/item/stack/cable_coil))
				user.visible_message("<span class='notice'>\The [user] begins overwritting \the [src] with \the [I].</span>")
				if(do_after(user, 175))
					user.visible_message("<span class='notice'>\The [user] overwrites \the [src] with \the [I].</span>")
					overwrite(I)
			else
				user << "<span class='warning'>You require a screwdriver, multitool or second module in your hands!</span>"
		if(istype(I, /obj/item/weapon/crowbar))
			user.visible_message("<span class='notice'>\The [user] begins resetting \the [src] with \the [I]</span>")
			var/inp = input(user, "What square would you like to reset? (1-16, 0 for all)", "Reset") as num
			if(inp > 16 || inp < 0)
				user << "<span class='warning'>That is out of bounds!</span>"
				return
			if(do_after(user, 150))
				user.visible_message("<span class='notice'>\The [user] resets \the [src]!</span>")
				if(inp && inp < 17) internal_wiring[inp] = RED
				else
					for(var/i=1 to internal_wiring.len)
						internal_wiring[i] = RED
		if(istype(I, /obj/item/weapon/wrench))
			user.visible_message("<span class='notice'>\The [user] begins shifting the wiring on \the [src] with \the [I]</span>")
			if(do_after(user, 80))
				user.visible_message("<span class='notice'>\The [user] shifts the wiring on \the [src]!</span>")
				shift()


	attack_self(var/mob/user)
		for(var/i=1 to internal_wiring.len)
			var/string = "<span class='notice'>Square #[i] is </span>"
			if(internal_wiring[i] == RED)
				string += "<span class='danger'>RED</span>"
			else if(internal_wiring[i] == BLUE)
				string += "<span class='notice'><b>BLUE</b></span>"
			else if(internal_wiring[i] == GREEN)
				string += "<font color='#00FF00'><b>GREEN</b></font>"
			else if(internal_wiring[i] == BLACK)
				string += "<b>BLACK</b>"
			else if(internal_wiring[i] == AQUA)
				string += "<font color='#00ffff'><b>AQUA</b></font>"
			else if(internal_wiring[i] == PURPLE)
				string += "<font color='#800080'><b>PURPLE</b></font>"
			else if(internal_wiring[i] == YELLOW)
				string += "<font color='#afc50c'><b>YELLOW</b></font>"
			user << string
		user << "<span class='notice'>\The [src]'s efficiency is: [get_efficiency()]</span>"
		user << "<span class='notice'>\The [src] has a damage resistance of [resistance]!</span>"

/obj/machinery/proc/get_efficiency(var/positive = 1, var/decimal = 1, var/can_break = 0.5)
	if(positive == 1) // Direct number
		if(circuit_board)
			return !decimal ? circuit_board.get_efficiency() : (circuit_board.get_efficiency() * 0.01)
		else
			return 0
	else if(positive == 2) // 1(00)+efficiency
		if(circuit_board)
			return !decimal ? 100+circuit_board.get_efficiency() : (100+circuit_board.get_efficiency()) *0.01
		else
			return !decimal ? 100 : 1
	else if(positive == 0) // 1(00)-efficiency
		if(circuit_board)
			return !decimal ? 100-circuit_board.get_efficiency() : (100-circuit_board.get_efficiency()) * 0.01
		else
			return 0
	else if(positive == -1) // 1(00) + 1(00)-efficiency
		if(circuit_board)
			return !decimal ? 100+(100-circuit_board.get_efficiency()) : (100+(100-circuit_board.get_efficiency())) *0.01
		else
			return !decimal ? 200 : 2
	if(prob(can_break) && circuit_board)
		var/num = rand(1,12)
		circuit_board.internal_wiring[num] = pick(RED, 25;BLACK)
	return 0





