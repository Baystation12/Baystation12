/obj/structure/alien/node
	name = "alien weed node"
	desc = "Some kind of strange, pulsating structure."
	icon_state = "weednode"
	health = 100
	layer = ABOVE_OBJ_LAYER

/obj/structure/alien/node/New()
	..()
	processing_objects += src

/obj/structure/alien/node/Destroy()
	processing_objects -= src
	..()

/obj/structure/alien/node/process()
	if(locate(/obj/effect/plant) in loc)
		return
	new/obj/effect/plant(get_turf(src), plant_controller.seeds["xenomorph"], start_matured = 1)