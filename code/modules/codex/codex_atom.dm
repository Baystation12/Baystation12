/atom/proc/get_codex_value()
	return src

/atom/examine(var/mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	. = ..()
	if(user.can_use_codex() && SScodex.get_codex_entry(get_codex_value()))
		to_chat(user, "<span class='notice'>The codex has <b><a href='?src=\ref[SScodex];show_examined_info=\ref[src];show_to=\ref[user]'>relevant information</a></b> available.</span>")
