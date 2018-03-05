/proc/create_noir_overlay(var/T)
	if(isatom(T))
		var/atom/A = T
		var/image/I = new
		I.appearance = A
		I.appearance_flags += NO_CLIENT_COLOR
		I.invisibility = INVISIBILITY_NOIRE
		A.overlays += I
	if(isImage(T))
		var/image/original = T
		var/image/I
		I.appearance_flags += NO_CLIENT_COLOR
		I.invisibility = INVISIBILITY_NOIRE
		original.overlays += I
