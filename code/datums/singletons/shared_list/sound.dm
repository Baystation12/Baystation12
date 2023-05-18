/singleton/shared_list/sound
	abstract_type = /singleton/shared_list/sound


/// Play a sound from the backing list according to key using the same parameters as playsound().
/singleton/shared_list/sound/proc/Play(key, atom/source, volume, vary_pitch, extra_range, falloff, is_global, frequency, ambient)
	playsound(source, list[key], volume, vary_pitch, extra_range, falloff, is_global, ambient)


/// Play a sound from the backing list chosen by pick() using the same parameters as playsound().
/singleton/shared_list/sound/proc/PlayPick(atom/source, volume, vary_pitch, extra_range, falloff, is_global, frequency, ambient)
	playsound(source, pick(list), volume, vary_pitch, extra_range, falloff, is_global, ambient)


/// Play a sound from the backing list chosen by pickweight() using the same parameters as playsound().
/singleton/shared_list/sound/proc/PlayPickWeight(atom/source, volume, vary_pitch, extra_range, falloff, is_global, frequency, ambient)
	playsound(source, pickweight(list), volume, vary_pitch, extra_range, falloff, is_global, ambient)
