/obj/item/storage/slide_projector
	name = "slide projector"
	desc = "A handy device capable of showing an enlarged projection of whatever you can fit inside."
	icon = 'icons/obj/projector.dmi'
	icon_state = "projector0"
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_SMALL)
	use_sound = 'sound/effects/storage/toolbox.ogg'
	var/static/list/projection_types = list(
		/obj/item/photo = /obj/effect/projection/photo,
		/obj/item/paper = /obj/effect/projection/paper,
		/obj/item = /obj/effect/projection
	)
	var/obj/item/current_slide
	var/obj/effect/projection/projection

/obj/item/storage/slide_projector/Destroy()
	current_slide = null
	stop_projecting()
	. = ..()

/obj/item/storage/slide_projector/on_update_icon()
	icon_state = "projector[!!projection]"

/obj/item/storage/slide_projector/get_mechanics_info()
	. = ..()
	. += "Use in hand to open the interface."

/obj/item/storage/slide_projector/remove_from_storage(obj/item/W, atom/new_location, var/NoUpdate = 0)
	. = ..()
	if(. && W == current_slide)
		set_slide(length(contents) ? contents[1] : null)

/obj/item/storage/slide_projector/handle_item_insertion(var/obj/item/W, var/prevent_warning = 0, var/NoUpdate = 0)
	. = ..()
	if(. && !current_slide)
		set_slide(W)

/obj/item/storage/slide_projector/on_item_pre_deletion(obj/item/W)
	if(W == current_slide)
		set_slide(null)
	
/obj/item/storage/slide_projector/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!current_slide)
		to_chat(user, SPAN_WARNING("\The [src] does not have a slide loaded."))
		return
	project_at(get_turf(target))

/obj/item/storage/slide_projector/MouseDrop(atom/over)
	if(!CanPhysicallyInteract(usr))
		return

	. = ..()

	if(over == usr)
		interact(usr)
		return

	var/turf/T = get_turf(over)
	if(istype(T))
		afterattack(over, usr)

/obj/item/storage/slide_projector/proc/set_slide(obj/item/new_slide)
	current_slide = new_slide
	playsound(loc, 'sound/machines/slide_change.ogg', 50)
	if(projection)
		project_at(get_turf(projection))

/obj/item/storage/slide_projector/proc/check_projections()
	if(!projection)
		return
	if(!(projection in view(7,get_turf(src))))
		stop_projecting()

/obj/item/storage/slide_projector/proc/stop_projecting()
	if(projection)
		QDEL_NULL(projection)
	GLOB.moved_event.unregister(src, src, .proc/check_projections)
	set_light(0)
	update_icon()
	
/obj/item/storage/slide_projector/proc/project_at(turf/target)
	stop_projecting()
	if(!current_slide)
		return
	if(!(target in view(7,get_turf(src))))
		return
	var/projection_type
	for(var/T in projection_types)
		if(istype(current_slide, T))
			projection_type = projection_types[T]
			break
	projection = new projection_type(target)
	projection.set_source(current_slide)
	GLOB.moved_event.register(src, src, .proc/check_projections)
	set_light(0.1, 0.1, 1, 2, COLOR_WHITE) //Bit of light
	update_icon()

/obj/item/storage/slide_projector/attack_self(mob/user)
	interact(user)

/obj/item/storage/slide_projector/interact(mob/user)	
	var/data = list()
	if(projection)
		data += "<a href='?src=\ref[src];stop_projector=1'>Disable projector</a>"
	else
		data += "Projector inactive"
	
	var/table = list("<table><tr><th>#</th><th>SLIDE</th><th>SHOW</th></tr>")
	var/i = 1
	for(var/obj/item/I in contents)
		table += "<tr><td>#[i]</td>"
		if(I == current_slide)
			table += "<td><b>[I.name]</b></td><td>SHOWING</td>"
		else
			table += "<td>[I.name]</td><td><a href='?src=\ref[src];set_active=[i]'>SHOW</a></td>"
		table += "</tr>"
		i++
	table += "</table>"
	data += jointext(table,null)
	var/datum/browser/popup = new(user, "slides\ref[src]", "Slide Projector")
	popup.set_content(jointext(data, "<br>"))
	popup.open()

/obj/item/storage/slide_projector/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	. = ..()
	if(.)
		return
	if(href_list["stop_projector"])
		if(!projection)
			return TOPIC_HANDLED
		stop_projecting()
		. = TOPIC_REFRESH

	if(href_list["set_active"])
		var/index = text2num(href_list["set_active"])
		if(index < 1 || index > contents.len)
			return TOPIC_HANDLED
		set_slide(contents[index])
		. = TOPIC_REFRESH
	
	if(. == TOPIC_REFRESH)
		interact(user)

/obj/effect/projection
	name = "projected slide"
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	anchored = TRUE
	simulated = FALSE
	blend_mode = BLEND_ADD
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	alpha = 100
	var/weakref/source

/obj/effect/projection/Initialize()
	. = ..()
	set_light(0.1, 0.1, 1, 2, COLOR_WHITE) //Makes turning off the lights not invalidate projection

/obj/effect/projection/on_update_icon()
	filters = filter(type="drop_shadow", color = COLOR_WHITE, size = 4, offset = 1,x = 0, y = 0)
	project_icon()

/obj/effect/projection/proc/project_icon()
	var/obj/item/I = source.resolve()
	if(!istype(I))
		qdel(src)
		return
	overlays.Cut()
	var/mutable_appearance/MA = new(I)
	MA.plane = FLOAT_PLANE
	MA.layer = FLOAT_LAYER
	MA.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_ALPHA
	MA.alpha = 170
	MA.pixel_x = 0
	MA.pixel_y = 0
	overlays |= MA

/obj/effect/projection/proc/set_source(obj/item/I)
	source = weakref(I)
	desc = "It's currently showing \the [I]."
	update_icon()

/obj/effect/projection/examine(mob/user, distance)
	. = ..()
	var/obj/item/slide = source.resolve()
	if(!istype(slide))
		qdel(src)
		return
	return slide.examine(user, 1)

/obj/effect/projection/photo
	alpha = 170

/obj/effect/projection/photo/project_icon()
	var/obj/item/photo/slide = source.resolve()
	if(!istype(slide))
		qdel(src)
		return
	icon = slide.img
	transform = matrix()
	transform *= 1 / slide.photo_size
	pixel_x = -32 * round(slide.photo_size/2)
	pixel_y = -32 * round(slide.photo_size/2)

/obj/effect/projection/paper
	alpha = 140

/obj/effect/projection/paper/project_icon()
	var/obj/item/paper/P = source.resolve()
	if(!istype(P))
		qdel(src)
		return
	overlays.Cut()
	if(P.info)
		icon_state = "text[rand(1,3)]"
