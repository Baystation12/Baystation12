
/obj/effect/flora/snow
	name = "grass"
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowgrass1bb"

/obj/effect/flora/snow/New()
	..()
	var/suffix = pick(\
		"1bb",\
		"2bb",\
		"3bb",\
		"1gb",\
		"2gb",\
		"3gb",\
		"all1",\
		"all2",\
		"all3"\
		)
	icon_state = "snowgrass[suffix]"

/obj/effect/flora/snow/snowygrass
	icon_state = "snowgrass"

/obj/effect/flora/snow/snowygrass/New()
	..()
	var/suffix = pick(\
		"2",\
		"3",\
		"_n",\
		"_s",\
		"_e",\
		"_w",\
		"_nw",\
		"_ne",\
		"_se",\
		"_sw",\
		"_nws",\
		"_swe",\
		"_nes",\
		"_esw"\
		)
	icon_state = "snowgrass[suffix]"

/obj/effect/flora/snow/snowbush
	name = "bush"
	icon_state = "snowbush1"

/obj/effect/flora/snow/snowbush/New()
	..()
	icon_state = "snowbush[rand(1,6)]"
