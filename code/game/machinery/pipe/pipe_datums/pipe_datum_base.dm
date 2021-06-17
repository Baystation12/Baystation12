GLOBAL_LIST_EMPTY(all_pipe_datums_by_category)
GLOBAL_LIST_EMPTY(all_disposal_pipe_datums_by_category)

/proc/initialize_pipe_datum_category_list()
	var/list/categories = list(
		/datum/pipe/pipe_dispenser/simple,
		/datum/pipe/pipe_dispenser/supply,
		/datum/pipe/pipe_dispenser/scrubber,
		/datum/pipe/pipe_dispenser/fuel,
		/datum/pipe/pipe_dispenser/he,
		/datum/pipe/pipe_dispenser/device
		)
	for(var/category_type in categories)
		for(var/recipe_type in subtypesof(category_type))
			LAZYADD(GLOB.all_pipe_datums_by_category[category_type], new recipe_type())

	var/disposal_categories = list(
		/datum/pipe/disposal_dispenser/simple,
		/datum/pipe/disposal_dispenser/device)

	for(var/category_type in disposal_categories)
		for(var/recipe_type in subtypesof(category_type))
			LAZYADD(GLOB.all_disposal_pipe_datums_by_category[category_type], new recipe_type())


/datum/pipe
	var/name = "pipe"														//item's name
	var/desc = "a pipe"														//item description
	var/build_path = /obj/item/pipe											//path of the object that's being created
	var/category = "general"												//Allows for easy sorting in the menu.
	var/pipe_type                       									//What sort of pipe this is. Used by disposals currently.
	var/connect_types = CONNECT_TYPE_REGULAR								//what sort of connection this has
	var/pipe_color = PIPE_COLOR_WHITE										//what color the pipe should be by default
	var/build_icon_state = "simple"											//Which icon state to use when creating a new pipe item.
	var/build_icon = 'icons/obj/pipe-item.dmi'								//Which file the icon is located at.
	var/dir = SOUTH															//Direction the pipe faces
	var/colorable = TRUE													//Can this pipe be colored?
	var/constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden	//What's the final form of this item?
	var/pipe_class = PIPE_CLASS_BINARY										//The node classification for this item.
	var/rotate_class = PIPE_ROTATE_STANDARD                                 //How it behaves when rotated

//==========
//Procedures
//==========

/datum/pipe/New()
	..()
	AssemblePipeInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/pipe/proc/AssemblePipeInfo()
	AssemblePipeName()
	AssemblePipeDesc()

/datum/pipe/proc/AssemblePipeName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)

/datum/pipe/proc/AssemblePipeDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "\A [name]."

/datum/pipe/proc/Build(var/datum/pipe/D, var/loc, var/pipe_color = PIPE_COLOR_WHITE)
	if(D.build_path)
		var/obj/item/pipe/new_item = new build_path(loc)
		if(istype(new_item))
			if(D.connect_types != null)
				new_item.connect_types = D.connect_types
			new_item.pipe_class = D.pipe_class
			new_item.rotate_class = D.rotate_class
			new_item.constructed_path = D.constructed_path
		if(D.colorable)
			new_item.color = pipe_color
		else if (D.pipe_color != null)
			new_item.color = D.pipe_color
		new_item.SetName(D.name)
		new_item.desc = D.desc
		new_item.set_dir(D.dir)
		new_item.icon = D.build_icon
		new_item.icon_state = D.build_icon_state

/datum/pipe/disposal_dispenser/Build(var/datum/pipe/disposal_dispenser/D, var/loc, var/pipe_color = PIPE_COLOR_GREY)
	if(D.build_path)
		var/obj/structure/disposalconstruct/new_item = new build_path(loc)
		new_item.SetName(D.name)
		new_item.desc = D.desc
		new_item.set_dir(D.dir)
		new_item.icon = D.build_icon
		new_item.built_icon_state = D.build_icon_state
		new_item.set_density(1)
		new_item.turn = D.turn
		new_item.constructed_path = D.constructed_path
		new_item.update_icon()