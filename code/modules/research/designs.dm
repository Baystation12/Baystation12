/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a  to denote that they aren't reagents.
The currently supporting non-reagent materials:

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).

*/
//Note: More then one of these can be added to a design.

/datum/design						//Datum for object designs, used in construction
	var/name = null					//Name of the created object. If null it will be 'guessed' from build_path if possible.
	var/desc = null					//Description of the created object. If null it will use group_desc and name where applicable.
	var/item_name = null			//An item name before it is modified by various name-modifying procs
	var/id = "id"					//ID of the created object for easy refernece. Alphanumeric, lower-case, no symbols.
	var/list/req_tech = list()		//IDs of that techs the object originated from and the minimum level requirements.
	var/build_type = null			//Flag as to what kind machine the design is built in. See defines.
	var/list/materials = list()		//List of materials. Format: "id" = amount.
	var/list/chemicals = list()		//List of chemicals.
	var/build_path = null			//The path of the object that gets created.
	var/time = 10					//How many ticks it requires to build
	var/category = null 			//Primarily used for Mech Fabricators, but can be used for anything
	var/sort_string = "ZZZZZ"		//Sorting order

	var/list/category_items = "Misc" //"Stock Parts", "Bluespace", "Data", "Engineering", "Medical", "Surgery",
	//"Mining", "Robotics", "Weapons", "Misc", "Device", "PDA", "RIG", "Machine Boards", "Console Boards",
	//"Engineering Boards", "Mecha Boards", "Module Boards"

/datum/design/New()
	..()
	item_name = name
	AssembleDesignInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo()
	AssembleDesignName()
	AssembleDesignDesc()
	return

/datum/design/proc/AssembleDesignName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name
	return

/datum/design/proc/AssembleDesignDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "Allows for the construction of \a [item_name]."
	return

//Returns a new instance of the item for this design
//This is to allow additional initialization to be performed, including possibly additional contructor arguments.
/datum/design/proc/Fabricate(var/newloc, var/fabricator)
	return new build_path(newloc)

/datum/design/item
	build_type = PROTOLATHE

/datum/design/item/hud
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	category_items = "Misc"

/datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/synthstorage
	category_items = "Robotics"

/datum/design/item/biostorage
	category_items = "Robotics"

/datum/design/item/tool
	category_items = "Misc"

/datum/design/prefab
	name = "Device"
	desc = "A blueprint made from a design built here."
	materials = list(DEFAULT_WALL_MATERIAL = 200)
	id = "prefab"
	build_type = PROTOLATHE
	sort_string = "ZAAAA"
	var/decl/prefab/ic_assembly/fabrication
	var/global/count = 0

/datum/design/prefab/New(var/research, var/fab)
	if(fab)
		fabrication = fab
		materials = list(DEFAULT_WALL_MATERIAL = fabrication.metal_amount)
		build_path = /obj/item/device/electronic_assembly //put this here so that the default made one doesn't show up in protolathe list
		id = "prefab[++count]"
	sort_string = "Z"
	var/cur_count = count
	while(cur_count > 25)
		sort_string += ascii2text(cur_count%25+65)
		cur_count = (cur_count - cur_count%25)/25
	sort_string += ascii2text(cur_count + 65)
	while(length(sort_string) < 5)
		sort_string += "A"
	..()

/datum/design/prefab/AssembleDesignName()
	..()
	if(fabrication)
		name = "Device [fabrication.assembly_name]"

/datum/design/prefab/Fabricate(var/newloc)
	if(!fabrication)
		return
	var/obj/O = fabrication.create(newloc)
	for(var/obj/item/integrated_circuit/circ in O.contents)
		circ.removable = 0
	return O

/*
CIRCUITS BELOW
*/

/datum/design/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	materials = list("glass" = 2000)
	chemicals = list(/datum/reagent/acid = 20)
	time = 5


/datum/design/circuit/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/weapon/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			name = "Machine circuit design ([item_name])"
			category_items = "Machine Boards"
		else if(initial(C.board_type) == "computer")
			name = "Computer circuit design ([item_name])"
			category_items = "Console Boards"
		else
			name = "Circuit design ([item_name])"

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."
