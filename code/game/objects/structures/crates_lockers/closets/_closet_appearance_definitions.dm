/obj/structure/closet/debug/Initialize(var/maploading, var/newappearance)
	closet_appearance = newappearance
	. = ..()

/decl/closet_appearance
	var/color = COLOR_GRAY40
	var/decals = list(
		"upper_vent",
		"lower_vent"
	)
	var/list/extra_decals
	var/icon/icon
	var/base_icon =  'icons/obj/closets/bases/closet.dmi'
	var/decal_icon = 'icons/obj/closets/decals/closet.dmi'
	var/can_lock = FALSE

/decl/closet_appearance/New()
	// Build our colour and decal lists.
	if(LAZYLEN(extra_decals))
		if(!decals)
			decals = list()
		for(var/thing in extra_decals)
			decals[thing] = extra_decals[thing]
	for(var/thing in decals)
		if(isnull(decals[thing]))
			decals[thing] = color

	// Declare storage vars for icons.
	var/icon/open_icon
	var/icon/closed_emagged_icon
	var/icon/closed_emagged_welded_icon
	var/icon/closed_locked_icon
	var/icon/closed_locked_welded_icon
	var/icon/closed_unlocked_icon
	var/icon/closed_unlocked_welded_icon

	// Create open icon.
	var/icon/new_icon = new
	open_icon = icon(base_icon, "base")
	open_icon.Blend(icon(base_icon, "open"), ICON_OVERLAY)
	open_icon.Blend(color, BLEND_ADD)
	open_icon.Blend(icon(base_icon, "interior"), ICON_OVERLAY)
	if(decal_icon)
		for(var/thing in decals)
			var/icon/this_decal_icon = icon(decal_icon, "[thing]_open")
			this_decal_icon.Blend(decals[thing], BLEND_ADD)
			open_icon.Blend(this_decal_icon, ICON_OVERLAY)

	// Generate basic closed icons.
	closed_emagged_icon = icon(base_icon, "base")
	if(can_lock)
		closed_emagged_icon.Blend(icon(base_icon, "lock"), ICON_OVERLAY)
	closed_emagged_icon.Blend(color, BLEND_ADD)
	if(decal_icon)
		for(var/thing in decals)
			var/icon/this_decal_icon = icon(decal_icon, thing)
			this_decal_icon.Blend(decals[thing], BLEND_ADD)
			closed_emagged_icon.Blend(this_decal_icon, ICON_OVERLAY)
	closed_locked_icon =   icon(closed_emagged_icon)
	closed_unlocked_icon = icon(closed_emagged_icon)

	// Add lock lights.
	if(can_lock)
		var/icon/light = icon(base_icon, "light")
		light.Blend(COLOR_RED, BLEND_ADD)
		closed_locked_icon.Blend(light, ICON_OVERLAY)
		light = icon(base_icon, "light")
		light.Blend(COLOR_LIME, BLEND_ADD)
		closed_unlocked_icon.Blend(light, ICON_OVERLAY)

	// Add welded states.
	var/icon/welded = icon(base_icon, "welded")
	closed_locked_welded_icon =   icon(closed_locked_icon)
	closed_unlocked_welded_icon = icon(closed_unlocked_icon)
	closed_emagged_welded_icon =  icon(closed_emagged_icon)
	closed_locked_welded_icon.Blend(welded, ICON_OVERLAY)
	closed_unlocked_welded_icon.Blend(welded, ICON_OVERLAY)
	closed_emagged_welded_icon.Blend(welded, ICON_OVERLAY)

	// Finish up emagged icons.
	var/icon/sparks = icon(base_icon, "sparks")
	closed_emagged_icon.Blend(sparks, ICON_OVERLAY)
	closed_emagged_welded_icon.Blend(sparks, ICON_OVERLAY)

	// Insert our bevy of icons into the final icon file.
	new_icon.Insert(open_icon,                   "open")
	new_icon.Insert(closed_emagged_icon,         "closed_emagged")
	new_icon.Insert(closed_emagged_welded_icon,  "closed_emagged_welded")
	new_icon.Insert(closed_locked_icon,          "closed_locked")
	new_icon.Insert(closed_locked_welded_icon,   "closed_locked_welded")
	new_icon.Insert(closed_unlocked_icon,        "closed_unlocked")
	new_icon.Insert(closed_unlocked_welded_icon, "closed_unlocked_welded")

	// Set icon!
	icon = new_icon

/decl/closet_appearance/tactical
	color = COLOR_RED_GRAY
	extra_decals = list(
		"inset" = COLOR_GRAY
	)

/decl/closet_appearance/tactical/alt
	color = COLOR_PALE_BTL_GREEN

/decl/closet_appearance/wardrobe
	extra_decals = list(
		"stripe_horizontal" = COLOR_PALE_BLUE_GRAY,
		"stripe_w" = COLOR_GRAY
	)

/decl/closet_appearance/wardrobe/mixed
	extra_decals = list(
		"stripe_horizontal_upper" = COLOR_PURPLE_GRAY,
		"stripe_horizontal_lower" = COLOR_PALE_RED_GRAY,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/orange
	extra_decals = list(
		"stripe_horizontal" = COLOR_PALE_ORANGE,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/green
	extra_decals = list(
		"stripe_horizontal" = COLOR_GREEN_GRAY,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/grey
	extra_decals = list(
		"stripe_horizontal" = COLOR_GRAY,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/pink
	extra_decals = list(
		"stripe_horizontal" = COLOR_PALE_PINK,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/black
	extra_decals = list(
		"stripe_horizontal" = COLOR_GRAY20,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/yellow
	extra_decals = list(
		"stripe_horizontal" = COLOR_PALE_YELLOW,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/red
	extra_decals = list(
		"stripe_horizontal" = COLOR_RED_GRAY,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/white
	extra_decals = list(
		"stripe_horizontal" = COLOR_GRAY,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/bio
	color = COLOR_PALE_ORANGE
	decals = list(
		"l3" = COLOR_OFF_WHITE,
		"stripe_horizontal_narrow" = COLOR_ORANGE
	)
	extra_decals = list(
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/command
	extra_decals = list(
		"lower_half_solid" = COLOR_BLUE_GRAY,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/science
	extra_decals = list(
		"lower_half_solid" = COLOR_PALE_YELLOW,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/security
	extra_decals = list(
		"lower_half_solid" = COLOR_RED_GRAY,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/janitor
	color = COLOR_PURPLE
	decals = list(
		"l3" = COLOR_OFF_WHITE,
	)
	extra_decals = list(
		"stripe_horizontal_broad" = COLOR_ORANGE,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/virology
	extra_decals = list(
		"lower_half_solid" = COLOR_GREEN_GRAY,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet
	can_lock = TRUE

/decl/closet_appearance/secure_closet/engineering
	can_lock = TRUE
	color = COLOR_YELLOW_GRAY
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_BEASTY_BROWN,
		"stripe_vertical_left_partial" = COLOR_BEASTY_BROWN,
		"eng" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/electrical
	decals = list(
		"lower_vent"
	)
	extra_decals = list(
		"electric" = COLOR_BEASTY_BROWN,
		"vertical_stripe_simple" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/atmos
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_CYAN_BLUE,
		"stripe_vertical_mid_partial" = COLOR_CYAN_BLUE,
		"atmos" = COLOR_CYAN_BLUE
	)

/decl/closet_appearance/secure_closet/engineering/welding
	decals = list(
		"lower_vent"
	)
	extra_decals = list(
		"fire" = COLOR_BEASTY_BROWN,
		"vertical_stripe_simple" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/tools
	can_lock = FALSE
	decals = list(
		"lower_vent"
	)
	extra_decals = list(
		"tool" = COLOR_BEASTY_BROWN,
		"vertical_stripe_simple" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/tools/radiation
	extra_decals = list(
		"l2" = COLOR_BEASTY_BROWN,
		"rads" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/ce
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_CLOSET_GOLD,
		"stripe_vertical_mid_partial" = COLOR_CLOSET_GOLD,
		"eng_narrow" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/mining
	color = COLOR_WARM_YELLOW
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_mid_partial" = COLOR_BEASTY_BROWN,
		"stripe_vertical_left_partial" = COLOR_BEASTY_BROWN,
		"mining" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/mining/sec
	decals = list(
		"stripe_vertical_mid_partial" = COLOR_NT_RED,
		"stripe_vertical_left_partial" = COLOR_NT_RED,
		"mining" = COLOR_NT_RED
	)

/decl/closet_appearance/secure_closet/command
	color = COLOR_BLUE_GRAY
	decals = list(
		"lower_holes",
		"upper_holes"
	)
	extra_decals = list(
		"stripe_vertical_left_partial" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_partial" = COLOR_CLOSET_GOLD,
		"captain" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/command/hop
	color = COLOR_PALE_BLUE_GRAY
	extra_decals = list(
		"stripe_vertical_mid_partial" = COLOR_CLOSET_GOLD,
		"hop" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/cmo
	color = COLOR_BABY_BLUE
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"medcircle" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_partial" = COLOR_CLOSET_GOLD,
		"stripe_vertical_mid_partial" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/medical
	color = COLOR_OFF_WHITE
	decals = null
	extra_decals = list(
		"circle" = COLOR_BLUE_GRAY,
		"stripes_horizontal" = COLOR_BLUE_GRAY
	)

/decl/closet_appearance/secure_closet/medical/virology
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_BOTTLE_GREEN,
		"stripe_vertical_mid_partial" = COLOR_BOTTLE_GREEN,
		"viro" = COLOR_BOTTLE_GREEN
	)

/decl/closet_appearance/secure_closet/medical/alt
	extra_decals = list(
		"medcircle" =COLOR_BLUE_GRAY,
		"stripe_vertical_right_partial" = COLOR_BLUE_GRAY,
		"stripe_vertical_mid_partial" = COLOR_BLUE_GRAY
	)

/decl/closet_appearance/secure_closet/cargo
	color = COLOR_WARM_YELLOW
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"cargo" = COLOR_GRAY40,
		"stripe_vertical_left_partial" = COLOR_GRAY40,
		"stripe_vertical_mid_partial" = COLOR_GRAY40
	)

/decl/closet_appearance/secure_closet/cargo/qm
	extra_decals = list(
		"cargo" = COLOR_BEASTY_BROWN,
		"stripe_vertical_left_partial" = COLOR_BEASTY_BROWN,
		"stripe_vertical_mid_partial" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/security
	color = COLOR_NT_RED
	decals = list(
		"lower_holes"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_WARM_YELLOW,
		"security" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/secure_closet/security/warden
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"security" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/secure_closet/security/hos
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_WARM_YELLOW,
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_mid_full" =  COLOR_CLOSET_GOLD,
		"security" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/bomb
	color = COLOR_DARK_GREEN_GRAY
	decals = list(
		"l4" = COLOR_OFF_WHITE
	)
	extra_decals = list(
		"lower_half_solid" = COLOR_GREEN_GRAY
	)

/decl/closet_appearance/bomb/security
	extra_decals = list(
		"lower_half_solid" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/oxygen
	color = COLOR_LIGHT_CYAN
	decals = list(
		"lower_vent"
	)
	extra_decals = list(
		"oxy" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/oxygen/fire
	color = COLOR_RED_GRAY
	extra_decals = list(
		"extinguisher" = COLOR_OFF_WHITE,
		"vertical_stripe_simple" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/alien
	color = COLOR_PURPLE

/decl/closet_appearance/secure_closet/expedition
	color = COLOR_BLUE_GRAY
	decals = list(
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_PURPLE,
		"security" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/expedition/pathfinder
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"security" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/expedition/science
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_PURPLE,
		"research" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/rd
	color = COLOR_BOTTLE_GREEN
	decals = list(
		"lower_holes"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_GOLD,
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"research" = COLOR_GOLD
	)

/decl/closet_appearance/secure_closet/corporate
	color = COLOR_GREEN_GRAY
	decals = list(
		"lower_holes"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_GRAY80,
		"research" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet/hydroponics
	color = COLOR_GREEN_GRAY
	decals = list(
		"lower_side_vent",
		"upper_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_DARK_GREEN_GRAY,
		"stripe_vertical_mid_partial" = COLOR_DARK_GREEN_GRAY,
		"hydro" = COLOR_DARK_GREEN_GRAY
	)

/decl/closet_appearance/secure_closet/chaplain
	decals = list(
		"lower_side_vent",
		"upper_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_right_full" = COLOR_GRAY20,
		"stripe_vertical_mid_full" = COLOR_GRAY20
	)

/decl/closet_appearance/secure_closet/sol
	color = COLOR_BABY_BLUE
	decals = list(
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_BOTTLE_GREEN,
		"security" = COLOR_BOTTLE_GREEN
	)

/decl/closet_appearance/secure_closet/sol/two
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BOTTLE_GREEN,
		"stripe_vertical_right_full" = COLOR_BOTTLE_GREEN,
		"security" = COLOR_BOTTLE_GREEN
	)

/decl/closet_appearance/secure_closet/sol/two/dark
	color = COLOR_DARK_BLUE_GRAY

// Crates.
/decl/closet_appearance/crate
	decals = null
	extra_decals = null
	base_icon =  'icons/obj/closets/bases/crate.dmi'
	decal_icon = 'icons/obj/closets/decals/crate.dmi'
	color = COLOR_GRAY40

/decl/closet_appearance/crate/plastic
	color = COLOR_GRAY80

/decl/closet_appearance/crate/oxygen
	color = COLOR_CYAN_BLUE
	decals = list(
		"crate_stripes" = COLOR_OFF_WHITE,
		"crate_oxy" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/medical
	color = COLOR_GRAY80
	decals = list(
		"crate_stripe" = COLOR_WARM_YELLOW,
		"crate_cross" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/medical/trauma
	decals = list(
		"crate_stripe" = COLOR_NT_RED,
		"crate_cross" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/medical/oxygen
	decals = list(
		"crate_stripe" = COLOR_BABY_BLUE,
		"crate_cross" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/medical/toxins
	decals = list(
		"crate_stripe" = COLOR_GREEN_GRAY,
		"crate_cross" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/hydroponics
	decals = list(
		"crate_stripe_left" = COLOR_GREEN_GRAY,
		"crate_stripe_right" = COLOR_GREEN_GRAY
	)

/decl/closet_appearance/crate/radiation
	color = COLOR_BROWN_ORANGE
	extra_decals = list(
		"crate_radiation_left" = COLOR_WARM_YELLOW,
		"crate_radiation_right" = COLOR_WARM_YELLOW,
		"lid_stripes" = COLOR_NT_RED
	)

/decl/closet_appearance/crate/freezer
	color = COLOR_BABY_BLUE

/decl/closet_appearance/crate/secure
	can_lock = TRUE

/decl/closet_appearance/crate/secure/hazard
	color = COLOR_NT_RED
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_OFF_WHITE,
		"crate_stripe_right" = COLOR_OFF_WHITE,
		"toxin" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/weapon
	color = COLOR_GREEN_GRAY
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_OFF_WHITE,
		"crate_stripe_right" = COLOR_OFF_WHITE,
		"hazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/hydroponics
	extra_decals = list(
		"crate_stripe_left" = COLOR_GREEN_GRAY,
		"crate_stripe_right" = COLOR_GREEN_GRAY
	)

/decl/closet_appearance/crate/secure/shuttle
	extra_decals = list(
		"crate_stripe_left" = COLOR_YELLOW_GRAY,
		"crate_stripe_right" = COLOR_YELLOW_GRAY
	)

// Large crates.
/decl/closet_appearance/large_crate
	base_icon =  'icons/obj/closets/bases/large_crate.dmi'
	decal_icon = 'icons/obj/closets/decals/large_crate.dmi'
	decals = null
	extra_decals = null

/decl/closet_appearance/large_crate/critter
	decals = list(
		"airholes"
	)
	extra_decals = list(
		"oxy" = COLOR_WHITE
	)

/decl/closet_appearance/large_crate/hydroponics
	extra_decals = list(
		"stripes" = COLOR_GREEN_GRAY,
		"text" = COLOR_GREEN_GRAY
	)

/decl/closet_appearance/large_crate/secure
	can_lock = TRUE

/decl/closet_appearance/large_crate/secure/hazard
	color = COLOR_NT_RED
	decals = list(
		"crate_bracing"
	 )
	extra_decals = list(
		"marking" = COLOR_OFF_WHITE,
		"text_upper" = COLOR_OFF_WHITE
	)

// Cabinets.
/decl/closet_appearance/cabinet
	base_icon =  'icons/obj/closets/bases/cabinet.dmi'
	decal_icon = null
	color = WOOD_COLOR_RICH
	decals = null
	extra_decals = null

/decl/closet_appearance/cabinet/secure
	can_lock = TRUE

// Wall lockers.
/decl/closet_appearance/wall
	base_icon =  'icons/obj/closets/bases/wall.dmi'
	decal_icon = 'icons/obj/closets/decals/wall.dmi'
	decals = list(
		"vent"
	)
	extra_decals = null

/decl/closet_appearance/wall/emergency
	decals = null
	extra_decals = list(
		"glass" = COLOR_WHITE
	)

/decl/closet_appearance/wall/medical
	decals = null
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"stripe_outer" = COLOR_BLUE_GRAY,
		"stripe_inner" = COLOR_OFF_WHITE,
		"cross" = COLOR_BLUE_GRAY
	)

/decl/closet_appearance/wall/shipping
	color = COLOR_WARM_YELLOW
	decals = null
	extra_decals = list(
		"stripes" = COLOR_BEASTY_BROWN,
		"glass" = COLOR_WHITE
	)

/decl/closet_appearance/wall/hydrant
	color = COLOR_NT_RED
	decals = null
	extra_decals = list(
		"stripes" = COLOR_OFF_WHITE,
		"glass" = COLOR_WHITE
	)

// Carts
/decl/closet_appearance/cart
	color = COLOR_GRAY20
	base_icon =  'icons/obj/closets/bases/cart.dmi'
	decal_icon = 'icons/obj/closets/decals/cart.dmi'
	decals = null
	extra_decals = null

/decl/closet_appearance/cart/trash
	color = COLOR_BOTTLE_GREEN

/decl/closet_appearance/cart/biohazard
	can_lock = TRUE
	decals = list(
		"biohazard" = COLOR_GRAY80
	)

/decl/closet_appearance/cart/biohazard/alt
	color = COLOR_SURGERY_BLUE
	decals = list(
		"biohazard" = COLOR_RED_GRAY
	)