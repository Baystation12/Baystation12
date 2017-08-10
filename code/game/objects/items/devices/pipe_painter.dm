/obj/item/device/pipe_painter
	name = "pipe painter"
	icon = 'icons/obj/device.dmi'
	icon_state = "pipainter"
	item_state = "flight"
	desc = "A long, slender device consisting of a pigment synthesizer, dual applicators, and a small battery, all hooked up to a long extendable rod."
	description_info = "Use the pipe painter to specify which color you'd like to apply to pipes. Click on exposed piping to alter its hue."
	description_fluff = "Though by no means a modern miracle, synthesized pigments have revolutionized the electrical engineering industry, making time-consuming painting and color coding jobs an effortless non-issue."
	var/list/modes
	var/mode

/obj/item/device/pipe_painter/New()
	..()
	modes = new()
	for(var/C in pipe_colors)
		modes += "[C]"
	mode = pick(modes)

/obj/item/device/pipe_painter/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if(!istype(A,/obj/machinery/atmospherics/pipe) || istype(A,/obj/machinery/atmospherics/pipe/tank) || istype(A,/obj/machinery/atmospherics/pipe/vent) || istype(A,/obj/machinery/atmospherics/pipe/simple/heat_exchanging) || !in_range(user, A))
		return
	var/obj/machinery/atmospherics/pipe/P = A

	P.change_color(pipe_colors[mode])

/obj/item/device/pipe_painter/attack_self(mob/user as mob)
	mode = input("Which colour do you want to use?", "Pipe painter", mode) in modes

/obj/item/device/pipe_painter/examine(mob/user)
	. = ..(user)
	to_chat(user, "It is in [mode] mode.")
