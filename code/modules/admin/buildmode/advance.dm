/datum/build_mode/advanced
	name = "Advanced"
	icon_state = "buildmode2"
	var/build_type

/datum/build_mode/advanced/Help()
	to_chat(user, "<span class='notice'>***********************************************************</span>")
	to_chat(user, "<span class='notice'>Left Click                       = Create objects</span>")
	to_chat(user, "<span class='notice'>Right Click                      = Delete objects</span>")
	to_chat(user, "<span class='notice'>Left Click + Ctrl                = Capture object type</span>")
	to_chat(user, "<span class='notice'>Middle Click                     = Capture object type</span>")
	to_chat(user, "<span class='notice'>Right Click on Build Mode Button = Select object type</span>")
	to_chat(user, "")
	to_chat(user, "<span class='notice'>Use the directional button in the upper left corner to</span>")
	to_chat(user, "<span class='notice'>change the direction of built objects.</span>")
	to_chat(user, "<span class='notice'>***********************************************************</span>")

/datum/build_mode/advanced/Configurate()
	SetBuildType(select_subpath(build_type || /obj/structure/closet))

/datum/build_mode/advanced/OnClick(var/atom/A, var/list/parameters)
	if(parameters["left"] && !parameters["ctrl"])
		if(ispath(build_type,/turf))
			var/turf/T = get_turf(A)
			T.ChangeTurf(build_type)
		else if(ispath(build_type))
			var/atom/new_atom = new build_type (get_turf(A))
			new_atom.set_dir(host.dir)
			Log("Created - [log_info_line(new_atom)]")
		else
			to_chat(user, "<span>Select a type to construct.</span>")
	else if(parameters["right"])
		Log("Deleted - [log_info_line(A)]")
		qdel(A)
	else if((parameters["left"] && parameters["ctrl"]) || parameters["middle"])
		SetBuildType(A.type)

/datum/build_mode/advanced/proc/SetBuildType(var/atom_type)
	if(!atom_type || atom_type == build_type)
		return

	if(ispath(atom_type, /atom))
		build_type = atom_type
		to_chat(user, "<span class='notice'>Will now construct instances of the type [atom_type].</span>")
	else
		to_chat(user, "<span class='warning'>Cannot construct instances of type [atom_type].</span>")
