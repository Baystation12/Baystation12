var/obj/nano_module/rcon/rcon

/mob/living/silicon/ai/proc/init_subsystems()
	rcon = new(src)

/mob/living/silicon/ai/proc/nano_rcon()
	set category = "AI Subystems"
	set name = "RCON"

	rcon.ui_interact(usr)
