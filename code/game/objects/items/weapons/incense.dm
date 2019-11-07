/obj/item/weapon/flame/candle/incense
	name = "incense cone"
	desc = "An incense cone. It produces fragrant smoke when burned."
	icon_state = "incense1"

	available_colours = null
	icon_set = "incense"
	candle_max_bright = 0.1
	candle_inner_range = 0.1
	candle_outer_range = 1
	candle_falloff = 2

	var/scent
	var/list/incense_types = list(/decl/incense_type/rose,
								  /decl/incense_type/citrus,
								  /decl/incense_type/sage,
								  /decl/incense_type/frankincense,
								  /decl/incense_type/mint,
								  /decl/incense_type/champa,
								  /decl/incense_type/lavender)

/obj/item/weapon/flame/candle/incense/Initialize()
	. = ..()
	get_scent()

/obj/item/weapon/flame/candle/incense/proc/get_scent()
	var/incense_type = safepick(incense_types)
	if(incense_type)
		var/decl/incense_type/In = decls_repository.get_decl(incense_type)
		color = In.color
		scent = In.scent
	if(scent)
		desc += " This one smells of [scent]."
	update_icon()

/obj/item/weapon/storage/candle_box/incense
	name = "incense box"
	desc = "A pack of 'Tres' brand incense cones, in a variety of scents."
	icon_state = "incensebox"
	max_storage_space = 9

	startswith = list(/obj/item/weapon/flame/candle/incense = 9)

/decl/incense_type
	var/color
	var/scent 

/decl/incense_type/rose
	color = COLOR_RED
	scent = "a rose garden"

/decl/incense_type/citrus
	color = COLOR_ORANGE
	scent = "assorted citrus"

/decl/incense_type/sage
	color = COLOR_OFF_WHITE
	scent = "white sage"

/decl/incense_type/frankincense
	color = COLOR_AMBER
	scent = "frankincense"

/decl/incense_type/mint
	color = COLOR_PALE_BTL_GREEN
	scent = "crisp mint"

/decl/incense_type/champa
	color = COLOR_BLUE
	scent = "nag champa"

/decl/incense_type/lavender
	color = COLOR_PALE_PINK
	scent = "gentle lavender"
