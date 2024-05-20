/obj/aura/regenerating/human/unathi/toggle()
	..()
	toggle_blocked_until = max(world.time + 2 MINUTES, toggle_blocked_until)
