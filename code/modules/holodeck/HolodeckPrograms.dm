var/global/list/holodeck_programs = list(
	"emptycourt" 		= new/datum/holodeck_program(/area/holodeck/source_emptycourt, list('sound/music/THUNDERDOME.ogg')),
	"boxingcourt" 		= new/datum/holodeck_program(/area/holodeck/source_boxingcourt, list('sound/music/THUNDERDOME.ogg')),
	"basketball" 		= new/datum/holodeck_program(/area/holodeck/source_basketball, list('sound/music/THUNDERDOME.ogg')),
	"thunderdomecourt"	= new/datum/holodeck_program(/area/holodeck/source_thunderdomecourt, list('sound/music/THUNDERDOME.ogg')),
	"beach" 			= new/datum/holodeck_program(/area/holodeck/source_beach),
	"desert" 			= new/datum/holodeck_program(/area/holodeck/source_desert,
													list(
														'sound/effects/wind/wind_2_1.ogg',
											 			'sound/effects/wind/wind_2_2.ogg',
											 			'sound/effects/wind/wind_3_1.ogg',
											 			'sound/effects/wind/wind_4_1.ogg',
											 			'sound/effects/wind/wind_4_2.ogg',
											 			'sound/effects/wind/wind_5_1.ogg'
												 		)
		 											),
	"snowfield" 		= new/datum/holodeck_program(/area/holodeck/source_snowfield,
													list(
														'sound/effects/wind/wind_2_1.ogg',
											 			'sound/effects/wind/wind_2_2.ogg',
											 			'sound/effects/wind/wind_3_1.ogg',
											 			'sound/effects/wind/wind_4_1.ogg',
											 			'sound/effects/wind/wind_4_2.ogg',
											 			'sound/effects/wind/wind_5_1.ogg'
												 		)
		 											),
	"space" 			= new/datum/holodeck_program(/area/holodeck/source_space,
													list(
														'sound/ambience/ambispace.ogg',
														'sound/music/main.ogg',
														'sound/music/space.ogg',
														'sound/music/traitor.ogg',
														)
													),
	"picnicarea" 		= new/datum/holodeck_program(/area/holodeck/source_picnicarea, list('sound/music/title2.ogg')),
	"theatre" 			= new/datum/holodeck_program(/area/holodeck/source_theatre),
	"meetinghall" 		= new/datum/holodeck_program(/area/holodeck/source_meetinghall),
	"courtroom" 		= new/datum/holodeck_program(/area/holodeck/source_courtroom, list('sound/music/traitor.ogg')),
	"burntest" 			= new/datum/holodeck_program(/area/holodeck/source_burntest, list()),
	"wildlifecarp" 		= new/datum/holodeck_program(/area/holodeck/source_wildlife, list()),
	"turnoff" 			= new/datum/holodeck_program(/area/holodeck/source_plating, list())
	)

/datum/holodeck_program
	var/target
	var/list/ambience = null

/datum/holodeck_program/New(var/target, var/list/ambience = null)
	src.target = target
	src.ambience = ambience
