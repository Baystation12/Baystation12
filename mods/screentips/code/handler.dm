/client/MouseEntered(atom/hoverOn)
	. = ..()

	if (GAME_STATE <= RUNLEVEL_SETUP || !screentip.show)
		return

	screen |= screentip
	screentip.set_text(hoverOn.name)
