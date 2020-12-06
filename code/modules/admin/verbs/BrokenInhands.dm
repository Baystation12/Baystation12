/proc/getbrokeninhands()
	var/icon/IL = new('icons/mob/onmob/items/lefthand.dmi')
	var/list/Lstates = IL.IconStates()
	var/icon/IR = new('icons/mob/onmob/items/righthand.dmi')
	var/list/Rstates = IR.IconStates()


	var/text
	for(var/A in typesof(/obj/item))
		var/obj/item/O = new A( locate(1,1,1) )
		if(!O) continue
		var/icon/J = new(O.icon)
		var/list/istates = J.IconStates()
		if(!Lstates.Find(O.icon_state) && !Lstates.Find(O.item_state))
			if(O.icon_state)
				text += "[O.type] is missing left hand icon called \"[O.icon_state]\".\n"
		if(!Rstates.Find(O.icon_state) && !Rstates.Find(O.item_state))
			if(O.icon_state)
				text += "[O.type] is missing right hand icon called \"[O.icon_state]\".\n"


		if(O.icon_state)
			if(!istates.Find(O.icon_state))
				text += "[O.type] is missing normal icon called \"[O.icon_state]\" in \"[O.icon]\".\n"
		//if(O.item_state)
		//	if(!istates.Find(O.item_state))
		//		text += "[O.type] MISSING NORMAL ICON CALLED\n\"[O.item_state]\" IN \"[O.icon]\"\n"
		//text+="\n"
		qdel(O)
	if(text)
		var/F = file("broken_icons.txt")
		fdel(F)
		F << text
		log_debug("Completeled successfully and written to [F]")



