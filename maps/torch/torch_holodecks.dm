
/datum/map/torch

	holodeck_programs = list(
		"emptycourt"       = new/datum/holodeck_program(/area/holodeck/source_emptycourt, list('sound/music/THUNDERDOME.ogg')),
		"boxingcourt"      = new/datum/holodeck_program(/area/holodeck/source_boxingcourt, list('sound/music/THUNDERDOME.ogg')),
		"basketball"       = new/datum/holodeck_program(/area/holodeck/source_basketball, list('sound/music/THUNDERDOME.ogg')),
		"thunderdomecourt" = new/datum/holodeck_program(/area/holodeck/source_thunderdomecourt, list('sound/music/THUNDERDOME.ogg')),
		"beach"            = new/datum/holodeck_program(/area/holodeck/source_beach, list('sound/music/europa/WildEncounters.ogg')),
		"desert"           = new/datum/holodeck_program(/area/holodeck/source_desert,
														list(
															'sound/effects/wind/wind_2_1.ogg',
											 				'sound/effects/wind/wind_2_2.ogg',
											 				'sound/effects/wind/wind_3_1.ogg',
											 				'sound/effects/wind/wind_4_1.ogg',
											 				'sound/effects/wind/wind_4_2.ogg',
											 				'sound/effects/wind/wind_5_1.ogg'
												 			)
		 												),
		"snowfield"        = new/datum/holodeck_program(/area/holodeck/source_snowfield,
														list(
															'sound/effects/wind/wind_2_1.ogg',
											 				'sound/effects/wind/wind_2_2.ogg',
											 				'sound/effects/wind/wind_3_1.ogg',
											 				'sound/effects/wind/wind_4_1.ogg',
											 				'sound/effects/wind/wind_4_2.ogg',
											 				'sound/effects/wind/wind_5_1.ogg'
												 			)
		 												),
		"space"            = new/datum/holodeck_program(/area/holodeck/source_space,
														list(
															'sound/ambience/ambispace.ogg',
															'sound/music/main.ogg',
															'sound/music/space.ogg',
															'sound/music/traitor.ogg',
															)
														),
		"picnicarea"       = new/datum/holodeck_program(/area/holodeck/source_picnicarea, list('sound/music/title2.ogg')),
		"theatre"          = new/datum/holodeck_program(/area/holodeck/source_theatre),
		"meetinghall"      = new/datum/holodeck_program(/area/holodeck/source_meetinghall),
		"courtroom"        = new/datum/holodeck_program(/area/holodeck/source_courtroom, list('sound/music/traitor.ogg')),
		"volleyball"        = new/datum/holodeck_program(/area/holodeck/source_volleyball, list('sound/music/THUNDERDOME.ogg')),
		"cafe"             = new/datum/holodeck_program(/area/holodeck/source_cafe),
		"wildlifecarp"     = new/datum/holodeck_program(/area/holodeck/source_wildlife, list()),
		"temple"           = new/datum/holodeck_program(/area/holodeck/source_temple),
		"plaza"            = new/datum/holodeck_program(/area/holodeck/source_plaza),
		"turnoff"          = new/datum/holodeck_program(/area/holodeck/source_plating, list())
	)

	holodeck_supported_programs = list(

		"TorchMainPrograms" = list(
			"Basketball Court"  = "basketball",
			"Beach"             = "beach",
			"Boxing Ring"       = "boxingcourt",
			"Cafe"              = "cafe",
			"Courtroom"         = "courtroom",
			"Desert"            = "desert",
			"Empty Court"       = "emptycourt",
			"Meeting Hall"      = "meetinghall",
			"Picnic Area"       = "picnicarea",
			"Snow Field"        = "snowfield",
			"Space"             = "space",
			"Theatre"           = "theatre",
			"Thunderdome Court" = "thunderdomecourt",
			"Volleyball Court"   = "volleyball",
			"Bathhouse"         = "temple",
			"Plaza"             = "plaza"
		)

	)

	holodeck_restricted_programs = list(

		"TorchMainPrograms" = list(
			"Wildlife Simulation" = "wildlifecarp"
		)

	)