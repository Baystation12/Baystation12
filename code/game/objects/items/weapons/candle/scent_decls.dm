/singleton/scent_type
	var/color
	var/scent //this is for the desc, the actual scent goes in the datum
	var/scent_datum

/singleton/scent_type/rose
	color = COLOR_RED
	scent = "a rose garden"
	scent_datum = /datum/extension/scent/candle/rose

/singleton/scent_type/citrus
	color = COLOR_ORANGE
	scent = "assorted citrus"
	scent_datum = /datum/extension/scent/candle/citrus

/singleton/scent_type/sage
	color = COLOR_OFF_WHITE
	scent = "white sage"
	scent_datum = /datum/extension/scent/candle/sage

/singleton/scent_type/frankincense
	color = COLOR_AMBER
	scent = "frankincense"
	scent_datum = /datum/extension/scent/candle/frankincense

/singleton/scent_type/mint
	color = COLOR_PALE_BTL_GREEN
	scent = "crisp mint"
	scent_datum = /datum/extension/scent/candle/mint

/singleton/scent_type/champa
	color = COLOR_BLUE
	scent = "nag champa"
	scent_datum = /datum/extension/scent/candle/champa

/singleton/scent_type/lavender
	color = COLOR_PALE_PINK
	scent = "gentle lavender"
	scent_datum = /datum/extension/scent/candle/lavender

/singleton/scent_type/cinnamon
	color = COLOR_NT_RED
	scent = "spicy cinnamon"
	scent_datum = /datum/extension/scent/candle/cinnamon

/singleton/scent_type/vanilla
	color = WOOD_COLOR_PALE2
	scent = "gentle lavender"
	scent_datum = /datum/extension/scent/candle/vanilla

/singleton/scent_type/seabreeze
	color = COLOR_BLUE_GRAY
	scent = "a sea breeze"
	scent_datum = /datum/extension/scent/candle/seabreeze

/singleton/scent_type/sandalwood
	color = COLOR_YELLOW_GRAY
	scent = "sandalwood"
	scent_datum = /datum/extension/scent/candle/sandalwood
