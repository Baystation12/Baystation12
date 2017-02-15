var/list/aspect_datums = list()     // Raw datums, no index.
var/list/aspects_by_name = list()   // Assoc, aspect.name -> aspect.
var/list/aspect_categories = list() // Containers for ease of printing data.
var/list/aspect_icons = list()      // List of aspect icons for forwarding to the client.

/datum/aspect_category
	var/category = ""
	var/list/aspects = list()

/datum/aspect_category/New(var/newcategory)
	..()
	category = newcategory

/proc/populate_aspects(var/rebuild)

	// Purge and remake for whatever reason.
	if(rebuild)
		for(var/aspect_category in aspect_categories)
			var/datum/aspect_category/AC = aspect_categories[aspect_category]
			AC.aspects.Cut()
			qdel(AC)
		aspect_categories.Cut()
		aspects_by_name.Cut()
		for(var/decl/aspect/A in aspect_datums)
			qdel(A)
		aspect_datums.Cut()

	// Already been called! Go home!
	if(aspect_datums.len)
		return

	// Create them all.
	for(var/aspect_type in (typesof(/decl/aspect)-/decl/aspect))
		var/decl/aspect/A = new aspect_type
		aspect_datums += A
		aspects_by_name[A.name] = A
		var/datum/aspect_category/AC = aspect_categories[A.category]
		if(!istype(AC))
			AC = new(A.category)
			aspect_categories[A.category] = AC
		AC.aspects += A
		//aspect_icons += A.use_icon

	// Update their parent/children variables.
	for(var/decl/aspect/A in aspect_datums)
		if(!A.parent_name)
			continue
		A.parent = aspects_by_name[A.parent_name]
		if(!A.parent)
			log_debug("ASPECT BUG: [A.parent_name] has no entry in aspects_by_name ([aspects_by_name[A.parent_name]])")
			continue
		A.parent.children |= A
