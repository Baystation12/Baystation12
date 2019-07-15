//Some procs for chat icons.
//Apparently icons can only be displayed in chat through the use of the \icon macro, which requires an atom to read from.
//This file is a series of workarounds to use this system

//This is a cache of dummy atoms which exist in nullspace and will be used only for drawing
GLOBAL_LIST_EMPTY(atom_chat_icons)


//To use:
// "\icon[typepath]" will print an icon for that type
/proc/chat_icon(var/needle)
	if (GLOB.atom_chat_icons[needle])
		//If a dummy already exists, we return that
		return GLOB.atom_chat_icons[needle]
	else
		//Create the source atom from the supplied type
		var/atom/newsource = new needle(null)
		var/atom/newdummy = new(null)
		//Copy its appearance onto a dummy atom
		newdummy.appearance = newsource.appearance
		qdel(newsource)

		//Cache the dummy
		GLOB.atom_chat_icons[needle] = newdummy
		return newdummy