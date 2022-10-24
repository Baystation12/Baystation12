/obj/item/flame/candle/scented/incense
	name = "incense cone"
	desc = "An incense cone. It produces fragrant smoke when burned."
	icon_state = "incense1"

	available_colours = null
	icon_set = "incense"
	candle_max_bright = 0.1
	candle_inner_range = 0.1
	candle_outer_range = 1
	candle_falloff = 2

	scent_types = list(/singleton/scent_type/rose,
					   /singleton/scent_type/citrus,
					   /singleton/scent_type/sage,
					   /singleton/scent_type/frankincense,
					   /singleton/scent_type/mint,
					   /singleton/scent_type/champa,
					   /singleton/scent_type/lavender,
					   /singleton/scent_type/sandalwood)

/obj/item/storage/candle_box/incense
	name = "incense box"
	desc = "A pack of 'Tres' brand incense cones, in a variety of scents."
	icon_state = "incensebox"
	max_storage_space = 9

	startswith = list(/obj/item/flame/candle/scented/incense = 9)
