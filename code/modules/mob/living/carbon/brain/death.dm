/mob/living/carbon/brain/death(gibbed)
	if(!gibbed && container)//If not gibbed but in a container.
		for(var/mob/O in viewers(container, null))
			O.show_message(text("\red <B>[]'s MMI flatlines!</B>", src), 1, "\red You hear something flatline.", 2)
		container.icon_state = "mmi_dead"
	stat = 2

	if(blind)
		blind.layer = 0
	sight |= SEE_TURFS
	sight |= SEE_MOBS
	sight |= SEE_OBJS

	see_in_dark = 8
	see_invisible = 2

	var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch
	store_memory("Time of death: [tod]", 0)

	if (key)
		spawn(50)
			if(key && stat == 2)
				src << "You are now dead. If you cannot ghost at this point, relog into the game."
				verbs += /mob/proc/ghost
	return ..(gibbed)