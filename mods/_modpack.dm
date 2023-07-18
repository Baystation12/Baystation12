/singleton/modpack
	/// A string name for the modpack. Used for looking up other modpacks in init.
	var/name
	/// A string desc for the modpack. Can be used for modpack verb list as description.
	var/desc
	/// A string with authors of this modpack.
	var/author

/singleton/modpack/proc/get_player_panel_options(mob/M)
	return

/singleton/modpack/proc/pre_initialize()
	if(!name)
		return "Modpack name is unset."

/singleton/modpack/proc/initialize()
	return

/singleton/modpack/proc/post_initialize()
  return
