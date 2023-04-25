//Sound environment defines. Reverb preset for sounds played in an area, see sound datum reference for more.
#define GENERIC 0
#define PADDED_CELL 1
#define ROOM 2
#define BATHROOM 3
#define LIVINGROOM 4
#define STONEROOM 5
#define AUDITORIUM 6
#define CONCERT_HALL 7
#define CAVE 8
#define ARENA 9
#define HANGAR 10
#define CARPETED_HALLWAY 11
#define HALLWAY 12
#define STONE_CORRIDOR 13
#define ALLEY 14
#define FOREST 15
#define CITY 16
#define MOUNTAINS 17
#define QUARRY 18
#define PLAIN 19
#define PARKING_LOT 20
#define SEWER_PIPE 21
#define UNDERWATER 22
#define DRUGGED 23
#define DIZZY 24
#define PSYCHOTIC 25

#define STANDARD_STATION STONEROOM
#define LARGE_ENCLOSED HANGAR
#define SMALL_ENCLOSED BATHROOM
#define TUNNEL_ENCLOSED CAVE
#define LARGE_SOFTFLOOR CARPETED_HALLWAY
#define MEDIUM_SOFTFLOOR LIVINGROOM
#define SMALL_SOFTFLOOR ROOM
#define ASTEROID CAVE
#define SPACE UNDERWATER

GLOBAL_LIST_INIT(shatter_sound,list('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg'))
GLOBAL_LIST_INIT(explosion_sound,list('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg'))
GLOBAL_LIST_INIT(spark_sound,list('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg'))
GLOBAL_LIST_INIT(rustle_sound,list('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg'))
GLOBAL_LIST_INIT(punch_sound,list('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
GLOBAL_LIST_INIT(clown_sound,list('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg'))
GLOBAL_LIST_INIT(swing_hit_sound,list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'))
GLOBAL_LIST_INIT(hiss_sound,list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg'))
GLOBAL_LIST_INIT(page_sound,list('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg'))
GLOBAL_LIST_INIT(fracture_sound,list('sound/effects/bonebreak1.ogg','sound/effects/bonebreak2.ogg','sound/effects/bonebreak3.ogg','sound/effects/bonebreak4.ogg'))
GLOBAL_LIST_INIT(lighter_sound,list('sound/items/lighter1.ogg','sound/items/lighter2.ogg','sound/items/lighter3.ogg'))
GLOBAL_LIST_INIT(keyboard_sound,list('sound/machines/keyboard/keypress1.ogg','sound/machines/keyboard/keypress2.ogg','sound/machines/keyboard/keypress3.ogg','sound/machines/keyboard/keypress4.ogg'))
GLOBAL_LIST_INIT(keystroke_sound,list('sound/machines/keyboard/keystroke1.ogg','sound/machines/keyboard/keystroke2.ogg','sound/machines/keyboard/keystroke3.ogg','sound/machines/keyboard/keystroke4.ogg'))
GLOBAL_LIST_INIT(switch_sound,list('sound/machines/switch1.ogg','sound/machines/switch2.ogg','sound/machines/switch3.ogg','sound/machines/switch4.ogg'))
GLOBAL_LIST_INIT(button_sound,list('sound/machines/button1.ogg','sound/machines/button2.ogg','sound/machines/button3.ogg','sound/machines/button4.ogg'))
GLOBAL_LIST_INIT(chop_sound,list('sound/weapons/chop1.ogg','sound/weapons/chop2.ogg','sound/weapons/chop3.ogg'))
GLOBAL_LIST_INIT(glasscrack_sound,list('sound/effects/glass_crack1.ogg','sound/effects/glass_crack2.ogg','sound/effects/glass_crack3.ogg','sound/effects/glass_crack4.ogg'))
GLOBAL_LIST_INIT(tray_hit_sound,list('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg'))
GLOBAL_LIST_INIT(sword_pickup_sound,list('sound/items/pickup/sword1.ogg','sound/items/pickup/sword2.ogg','sound/items/pickup/sword3.ogg'))
GLOBAL_LIST_INIT(sword_drop_sound, list('sound/items/equip/sword1.ogg',	'sound/items/equip/sword2.ogg'))
GLOBAL_LIST_INIT(generic_drop_sound, list('sound/items/drop/generic1.ogg', 'sound/items/drop/generic2.ogg'))
GLOBAL_LIST_INIT(generic_pickup_sound, list('sound/items/pickup/generic1.ogg','sound/items/pickup/generic2.ogg','sound/items/pickup/generic3.ogg'))
GLOBAL_LIST_INIT(casing_drop_sound, list('sound/items/drop/casing1.ogg','sound/items/drop/casing2.ogg', 'sound/items/drop/casing3.ogg','sound/items/drop/casing4.ogg','sound/items/drop/casing5.ogg','sound/items/drop/casing6.ogg','sound/items/drop/casing7.ogg','sound/items/drop/casing8.ogg','sound/items/drop/casing9.ogg','sound/items/drop/casing10.ogg','sound/items/drop/casing11.ogg','sound/items/drop/casing12.ogg','sound/items/drop/casing13.ogg','sound/items/drop/casing15.ogg','sound/items/drop/casing16.ogg','sound/items/drop/casing17.ogg','sound/items/drop/casing18.ogg','sound/items/drop/casing19.ogg','sound/items/drop/casing20.ogg','sound/items/drop/casing21.ogg','sound/items/drop/casing22.ogg','sound/items/drop/casing23.ogg','sound/items/drop/casing24.ogg','sound/items/drop/casing25.ogg'))
GLOBAL_LIST_INIT(casing_drop_sound_shotgun, list('sound/items/drop/casing_shotgun1.ogg','sound/items/drop/casing_shotgun2.ogg','sound/items/drop/casing_shotgun3.ogg','sound/items/drop/casing_shotgun4.ogg','sound/items/drop/casing_shotgun5.ogg'))
GLOBAL_LIST_INIT(out_of_ammo, list('sound/weapons/empty/empty2.ogg','sound/weapons/empty/empty4.ogg','sound/weapons/empty/empty5.ogg'))
GLOBAL_LIST_INIT(out_of_ammo_revolver, list('sound/weapons/empty/empty_revolver.ogg','sound/weapons/empty/empty_revolver3.ogg'))
GLOBAL_LIST_INIT(out_of_ammo_rifle, list('sound/weapons/empty/empty_rifle1.ogg','sound/weapons/empty/empty_rifle2.ogg'))
GLOBAL_LIST_INIT(out_of_ammo_shotgun, list('sound/weapons/empty/empty_shotgun1.ogg'))
GLOBAL_LIST_INIT(metal_slide_reload, list('sound/weapons/reloads/pistol_metal_slide1.ogg','sound/weapons/reloads/pistol_metal_slide2.ogg','sound/weapons/reloads/pistol_metal_slide3.ogg','sound/weapons/reloads/pistol_metal_slide4.ogg','sound/weapons/reloads/pistol_metal_slide5.ogg','sound/weapons/reloads/pistol_metal_slide6.ogg'))
GLOBAL_LIST_INIT(polymer_slide_reload, list('sound/weapons/reloads/pistol_polymer_slide1.ogg','sound/weapons/reloads/pistol_polymer_slide2.ogg','sound/weapons/reloads/pistol_polymer_slide3.ogg'))
GLOBAL_LIST_INIT(rifle_slide_reload, list('sound/weapons/reloads/rifle_slide.ogg','sound/weapons/reloads/rifle_slide2.ogg','sound/weapons/reloads/rifle_slide3.ogg','sound/weapons/reloads/rifle_slide4.ogg','sound/weapons/reloads/rifle_slide5.ogg'))
GLOBAL_LIST_INIT(revolver_reload, list('sound/weapons/reloads/revolver_reload.ogg'))
GLOBAL_LIST_INIT(shotgun_pump, list('sound/weapons/reloads/shotgun_pump2.ogg','sound/weapons/reloads/shotgun_pump3.ogg','sound/weapons/reloads/shotgun_pump4.ogg','sound/weapons/reloads/shotgun_pump5.ogg','sound/weapons/reloads/shotgun_pump6.ogg'))
GLOBAL_LIST_INIT(shotgun_reload, list('sound/weapons/reloads/reload_shell.ogg','sound/weapons/reloads/reload_shell2.ogg','sound/weapons/reloads/reload_shell3.ogg','sound/weapons/reloads/reload_shell4.ogg'))
GLOBAL_LIST_INIT(heavy_machine_gun_reload, list('sound/weapons/reloads/hmg_reload1.ogg','sound/weapons/reloads/hmg_reload2.ogg','sound/weapons/reloads/hmg_reload3.ogg'))
GLOBAL_LIST_INIT(bodyfall_sound, list('packs/sierra-tweaks/sound/effects/bodyfall/bodyfall1.ogg','packs/sierra-tweaks/sound/effects/bodyfall/bodyfall2.ogg','packs/sierra-tweaks/sound/effects/bodyfall/bodyfall3.ogg','packs/sierra-tweaks/sound/effects/bodyfall/bodyfall4.ogg'))
GLOBAL_LIST_INIT(bodyfall_skrell_sound, list('packs/sierra-tweaks/sound/effects/bodyfall/bodyfall_skrell1.ogg','packs/sierra-tweaks/sound/effects/bodyfall/bodyfall_skrell2.ogg','packs/sierra-tweaks/sound/effects/bodyfall/bodyfall_skrell3.ogg','packs/sierra-tweaks/sound/effects/bodyfall/bodyfall_skrell4.ogg'))
GLOBAL_LIST_INIT(smash_sound,list('packs/infinity/sound/effects/gore/smash1.ogg','packs/infinity/sound/effects/gore/smash2.ogg','packs/infinity/sound/effects/gore/smash3.ogg','packs/infinity/sound/effects/gore/trauma1.ogg'))
GLOBAL_LIST_INIT(drinks_pickup_sound, list('packs/sierra-tweaks/sound/effects/glass_pickup.ogg','packs/sierra-tweaks/sound/effects/glass2_pickup.ogg','packs/sierra-tweaks/sound/effects/glass3_pickup.ogg','packs/sierra-tweaks/sound/effects/glass4_pickup.ogg','packs/sierra-tweaks/sound/effects/glass5_pickup.ogg','packs/sierra-tweaks/sound/effects/glass6_pickup.ogg'))
GLOBAL_LIST_INIT(drinks_drop_sound, list('packs/sierra-tweaks/sound/effects/glass_drop.ogg','packs/sierra-tweaks/sound/effects/glass2_drop.ogg','packs/sierra-tweaks/sound/effects/glass3_drop.ogg','packs/sierra-tweaks/sound/effects/glass4_drop.ogg','packs/sierra-tweaks/sound/effects/glass5_drop.ogg','packs/sierra-tweaks/sound/effects/glass6_drop.ogg'))
GLOBAL_LIST_INIT(tank_drop_sound, list('packs/sierra-tweaks/sound/effects/tank_drop.ogg','packs/sierra-tweaks/sound/effects/tank2_drop.ogg'))


/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, is_global, frequency, is_ambiance = 0)

	soundin = get_sfx(soundin) // same sound for everyone

	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return
	frequency = vary && isnull(frequency) ? get_rand_frequency() : frequency // Same frequency for everybody
	var/turf/turf_source = get_turf(source)

 	// Looping through the player list has the added bonus of working for mobs inside containers
	for (var/mob/M in GLOB.player_list)
		if(!M || !M.client)
			continue
		if(get_dist(M, turf_source) <= (world.view + extrarange) * 2)
			var/turf/T = get_turf(M)
			if(T && T.z == turf_source.z && (!is_ambiance || M.get_preference_value(/datum/client_preference/play_ambiance) == GLOB.PREF_YES))
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global, extrarange)

var/global/const/FALLOFF_SOUNDS = 0.5

/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff, is_global, extrarange)
	if(!src.client || ear_deaf > 0)	return
	var/sound/S = soundin
	if(!istype(S))
		soundin = get_sfx(soundin)
		S = sound(soundin)
		S.wait = 0 //No queue
		S.channel = 0 //Any channel
		S.volume = vol
		S.environment = -1
		if(frequency)
			S.frequency = frequency
		else if (vary)
			S.frequency = get_rand_frequency()

	//sound volume falloff with pressure
	var/pressure_factor = 1.0

	S.volume *= get_sound_volume_multiplier()

	var/turf/T = get_turf(src)
	// 3D sounds, the technology is here!
	if(isturf(turf_source))
		//sound volume falloff with distance
		var/distance = get_dist(T, turf_source)

		S.volume -= max(distance - (world.view + extrarange), 0) * 2 //multiplicative falloff to add on top of natural audio falloff.

		var/datum/gas_mixture/hearer_env = T.return_air()
		var/datum/gas_mixture/source_env = turf_source.return_air()

		if (hearer_env && source_env)
			var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())

			if (pressure < ONE_ATMOSPHERE)
				pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
		else //in space
			pressure_factor = 0

		if (distance <= 1)
			pressure_factor = max(pressure_factor, 0.15)	//hearing through contact

		S.volume *= pressure_factor

		if(istype(T,/turf/simulated) && istype(turf_source,/turf/simulated))
			var/turf/simulated/sim_source = turf_source
			var/turf/simulated/sim_destination = T
			if(sim_destination.zone != sim_source.zone)
				S.volume -= 30

		if (S.volume <= 0)
			return	//no volume means no sound

		var/dx = turf_source.x - T.x // Hearing from the right/left
		S.x = dx
		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = dz
		// The y value is for above your head, but there is no ceiling in 2d spessmens.
		S.y = 1
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	if(!is_global)

		if(istype(src,/mob/living))
			var/mob/living/carbon/M = src
			if (istype(M) && M.hallucination_power > 50 && M.chem_effects[CE_MIND] < 1)
				S.environment = PSYCHOTIC
			else if (M.druggy)
				S.environment = DRUGGED
			else if (M.drowsyness)
				S.environment = DIZZY
			else if (M.confused)
				S.environment = DIZZY
			else if (M.stat == UNCONSCIOUS)
				S.environment = UNDERWATER
			else if (T?.is_flooded(M.lying))
				S.environment = UNDERWATER
			else if (pressure_factor < 0.5)
				S.environment = SPACE
			else
				var/area/A = get_area(src)
				S.environment = A.sound_env

		else if (pressure_factor < 0.5)
			S.environment = SPACE
		else
			var/area/A = get_area(src)
			S.environment = A.sound_env

	sound_to(src, S)

/client/proc/playtitlemusic()
	if (get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_YES)
		sound_to(src, GLOB.using_map.lobby_track.get_sound())
		to_chat(src, GLOB.using_map.lobby_track.get_info())

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick(GLOB.shatter_sound)
			if ("explosion") soundin = pick(GLOB.explosion_sound)
			if ("sparks") soundin = pick(GLOB.spark_sound)
			if ("rustle") soundin = pick(GLOB.rustle_sound)
			if ("punch") soundin = pick(GLOB.punch_sound)
			if ("clownstep") soundin = pick(GLOB.clown_sound)
			if ("swing_hit") soundin = pick(GLOB.swing_hit_sound)
			if ("hiss") soundin = pick(GLOB.hiss_sound)
			if ("pageturn") soundin = pick(GLOB.page_sound)
			if ("fracture") soundin = pick(GLOB.fracture_sound)
			if ("light_bic") soundin = pick(GLOB.lighter_sound)
			if ("keyboard") soundin = pick(GLOB.keyboard_sound)
			if ("keystroke") soundin = pick(GLOB.keystroke_sound)
			if ("switch") soundin = pick(GLOB.switch_sound)
			if ("button") soundin = pick(GLOB.button_sound)
			if ("chop") soundin = pick(GLOB.chop_sound)
			if ("glasscrack") soundin = pick(GLOB.glasscrack_sound)
			if ("tray_hit") soundin = pick(GLOB.tray_hit_sound)
			if ("drop_sword") soundin = pick(GLOB.sword_drop_sound)
			if ("pickup_sword") soundin = pick(GLOB.sword_pickup_sound)
			if ("generic_drop") soundin = pick(GLOB.generic_drop_sound)
			if ("generic_pickup") soundin = pick(GLOB.generic_pickup_sound)
			if ("casing_drop_sound") soundin = pick(GLOB.casing_drop_sound)
			if ("casing_drop_sound_shotgun") soundin = pick(GLOB.casing_drop_sound_shotgun)
			if ("out_of_ammo") soundin = pick(GLOB.out_of_ammo)
			if ("out_of_ammo_revolver") soundin = pick(GLOB.out_of_ammo_revolver)
			if ("out_of_ammo_rifle") soundin = pick(GLOB.out_of_ammo_rifle)
			if ("out_of_ammo_shotgun") soundin = pick(GLOB.out_of_ammo_shotgun)
			if ("metal_slide_reload") soundin = pick(GLOB.metal_slide_reload)
			if ("polymer_slide_reload") soundin = pick(GLOB.polymer_slide_reload)
			if ("rifle_slide_reload") soundin = pick(GLOB.rifle_slide_reload)
			if ("revolver_reload") soundin = pick(GLOB.revolver_reload)
			if ("shotgun_pump") soundin = pick(GLOB.shotgun_pump)
			if ("shotgun_reload") soundin = pick(GLOB.shotgun_reload)
			if ("heavy_machine_gun_reload") soundin = pick(GLOB.heavy_machine_gun_reload)
			if ("bodyfall_sound") soundin = pick(GLOB.bodyfall_sound)
			if ("bodyfall_skrell_sound") soundin = pick(GLOB.bodyfall_skrell_sound)
			if ("smash_sound") soundin = pick(GLOB.smash_sound)
			if ("drinks_pickup_sound") soundin = pick(GLOB.drinks_pickup_sound)
			if ("drinks_drop_sound") soundin = pick(GLOB.drinks_drop_sound)
			if ("tank_drop_sound") soundin = pick(GLOB.tank_drop_sound)

	return soundin

/client/verb/stop_sounds()
	set name = "Stop All Sounds"
	set desc = "Stop all sounds that are currently playing on your client."
	set category = "OOC"

	sound_to(usr, sound(null))
