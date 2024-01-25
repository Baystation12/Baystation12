/mob/living/silicon
	var/speech_sounds

/mob/living/silicon/ai
	speech_sounds = list(
		'mods/emote_panel/sound/robot_talk_heavy_1.ogg',
		'mods/emote_panel/sound/robot_talk_heavy_2.ogg',
		'mods/emote_panel/sound/robot_talk_heavy_3.ogg',
		'mods/emote_panel/sound/robot_talk_heavy_4.ogg'
	)

/mob/living/silicon/robot
	speech_sounds = list(
		'mods/emote_panel/sound/robot_talk_heavy_1.ogg',
		'mods/emote_panel/sound/robot_talk_heavy_2.ogg',
		'mods/emote_panel/sound/robot_talk_heavy_3.ogg',
		'mods/emote_panel/sound/robot_talk_heavy_4.ogg'
	)

/mob/living/silicon/robot/drone
	speech_sounds = list(
		'mods/emote_panel/sound/robot_talk_light_1.ogg',
		'mods/emote_panel/sound/robot_talk_light_2.ogg',
		'mods/emote_panel/sound/robot_talk_light_3.ogg',
		'mods/emote_panel/sound/robot_talk_light_4.ogg',
		'mods/emote_panel/sound/robot_talk_light_5.ogg'
	)

/mob/living/silicon/robot/flying
	speech_sounds = list(
		'mods/emote_panel/sound/robot_talk_light_1.ogg',
		'mods/emote_panel/sound/robot_talk_light_2.ogg',
		'mods/emote_panel/sound/robot_talk_light_3.ogg',
		'mods/emote_panel/sound/robot_talk_light_4.ogg',
		'mods/emote_panel/sound/robot_talk_light_5.ogg'
	)

/singleton/emote/audible/synth/do_extra(atom/user)
	if(emote_sound)
		playsound(user.loc, emote_sound, 50, 0)

/singleton/emote/audible/synth/scream
	key = "scream"
	emote_message_3p = "USER screams."
	emote_sound = 'mods/emote_panel/sound/scream_robot.ogg'
