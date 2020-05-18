/obj/item/weapon/flame/candle/scented/incense
	name = "incense cone"
	desc = "An incense cone. It produces fragrant smoke when burned."
	icon_state = "incense1"

	available_colours = null
	icon_set = "incense"
	candle_max_bright = 0.1
	candle_inner_range = 0.1
	candle_outer_range = 1
	candle_falloff = 2

	scent_types = list(/decl/scent_type/rose,
					   /decl/scent_type/citrus,
					   /decl/scent_type/sage,
					   /decl/scent_type/frankincense,
					   /decl/scent_type/mint,
					   /decl/scent_type/champa,
					   /decl/scent_type/lavender,
					   /decl/scent_type/sandalwood)

/obj/item/weapon/storage/candle_box/incense
	name = "incense box"
	desc = "A pack of 'Tres' brand incense cones, in a variety of scents."
	icon_state = "incensebox"
	max_storage_space = 9

	startswith = list(/obj/item/weapon/flame/candle/scented/incense = 9)