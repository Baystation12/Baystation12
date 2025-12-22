
var/global/list/weighted_star_classes = list(
	/singleton/star_class/m_class = 68,
	/singleton/star_class/k_class = 12,
	/singleton/star_class/g_class = 8,
	/singleton/star_class/f_class = 5,
	/singleton/star_class/a_class = 4,
	/singleton/star_class/b_class = 2,
	/singleton/star_class/o_class = 1
)

/obj/overmap/visitable/star
	name = "star" //temp name, we randomly pick a class and scale size and such accordingly on init.
	icon_state = "star"
	anchored = TRUE

	scannable = TRUE
	randomize_start_pos = FALSE
	requires_contact = TRUE
	sensor_visibility = 80
	sector_flags = OVERMAP_SECTOR_KNOWN
	randomize_location = FALSE

	var/singleton/star_class/class //What class this star is.
	var/singleton/star_type/startype //What type it is (supergiant etc)
	var/star_luminosity
	var/star_scale
	var/image/skybox_image

/obj/overmap/visitable/star/Initialize()
	class = GET_SINGLETON(pickweight(weighted_star_classes))
	startype = GET_SINGLETON(pick(class.possible_types))

	name = "[GLOB.using_map.system_name], a [startype.denomination] [class.star_class] [startype.name]"
	desc = "\A [startype.denomination] [class.star_class] [startype.name]."

	. = ..()

	color = class.color
	star_luminosity = class.luminosity + startype.luminosity_bonus
	filters += filter(type="blur", size = 1)

	star_scale = frand(startype.scale_min, startype.scale_max)
	generate_star_image()

/obj/overmap/visitable/star/get_scan_data(mob/user)
	. = ..()
	var/list/extra_data = list("Solar radii: [star_scale]R☉.", "Solar mass: [star_scale * 2]M☉", "Luminosity: [star_luminosity]L☉")
	. += jointext(extra_data, "<br>")

/singleton/star_class
	var/star_class 						//What class the star is - this is used for the name.
	var/color 							//What color the star is, this is used to color it's light source and the star itself.
	var/luminosity = 0 					//We use this to adjust the amount of power solar panels generate, plus some other maths.
	var/extra_clouds = TRUE				//Skybox related.
	var/list/possible_types = list() 	//Some classes of star can't be certain types, so we define what they can be in a list that's picked from.

/singleton/star_class/m_class
	star_class = "M-Class"
	color = "#ff0000"
	luminosity = 0.4
	possible_types = list(/singleton/star_type/vi)

/singleton/star_class/k_class
	star_class = "K-Class"
	color = "#ffae00"
	luminosity = 0.5
	possible_types = list(/singleton/star_type/vi, /singleton/star_type/v, /singleton/star_type/iv, /singleton/star_type/iii, /singleton/star_type/ii)

/singleton/star_class/g_class
	star_class = "G-Class"
	color = "#ffcc00"
	luminosity = 0.7
	possible_types = list(/singleton/star_type/vi, /singleton/star_type/v, /singleton/star_type/iv, /singleton/star_type/iii, /singleton/star_type/ii, /singleton/star_type/ib)

/singleton/star_class/f_class
	star_class = "F-Class"
	color = "#fff9df"
	luminosity = 0.7
	extra_clouds = FALSE
	possible_types = list(/singleton/star_type/vii, /singleton/star_type/v, /singleton/star_type/iii, /singleton/star_type/ii, /singleton/star_type/ib)

/singleton/star_class/a_class
	star_class = "A-Class"
	color = "#bfd5ff"
	luminosity = 0.8
	extra_clouds = FALSE
	possible_types = list(/singleton/star_type/vii, /singleton/star_type/iii, /singleton/star_type/ii, /singleton/star_type/ib)

/singleton/star_class/b_class
	star_class = "B-Class"
	color = "#43a8fa"
	luminosity = 1.2
	extra_clouds = FALSE
	possible_types = list(/singleton/star_type/ii, /singleton/star_type/ib, /singleton/star_type/ia)

/singleton/star_class/o_class
	star_class = "O-Class"
	color = "#bfe2ff"
	luminosity = 1.5
	extra_clouds = FALSE
	possible_types = list(/singleton/star_type/ib, /singleton/star_type/ia)

/singleton/star_type
	var/name 				//Name of the type - refer to Yerkes Luminosity Classes
	var/denomination 		//The actual letter designation.
	var/scale_min = 1		//The smallest possible scale of the star, based on solar radii (size comparable to the Sun).
	var/scale_max = 1		//The largest possible scale of the star, based on solar radii (size comparable to the Sun).
	var/luminosity_bonus 	//Add a little bit to our luminosity depending on type.

/singleton/star_type/ia
	name = "luminous supergiant"
	denomination = "Type-Ia"
	luminosity_bonus = 1
	scale_min = 6.6
	scale_max = 8

/singleton/star_type/ib
	name = "less luminous supergiant"
	denomination = "Type-Ib"
	luminosity_bonus = 0.6
	scale_min = 3.4
	scale_max = 6.6

/singleton/star_type/ii
	name = "bright giant"
	denomination = "Type-II"
	luminosity_bonus = 0.5
	scale_min = 1.8
	scale_max = 3.4

/singleton/star_type/iii
	name = "giant"
	denomination = "Type-III"
	scale_min = 1.4
	scale_max = 1.8

/singleton/star_type/iv
	name = "subgiant"
	denomination = "Type-IV"
	scale_min = 1.04
	scale_max = 1.4

/singleton/star_type/v
	name = "main-sequence star"
	denomination = "Type-V"
	scale_min = 0.8
	scale_max = 1.04

/singleton/star_type/vi
	name = "dwarf"
	denomination = "Type-VI"
	scale_min = 0.45
	scale_max = 0.8

/singleton/star_type/vii
	name = "white dwarf"
	denomination = "Type-VII"
	scale_min = 0.25
	scale_max = 0.45
