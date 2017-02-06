
// Keep these two together, they *must* be defined on both
// If /client ever becomes /datum/client or similar, they can be merged
/datum/proc/get_view_variables_header()
	return "<b>[src]</b>"

/atom/get_view_variables_header()
	return {"
		<a href='?_src_=vars;datumedit=\ref[src];varnameedit=name'><b>[src]</b></a>
		<br><font size='1'>
		<a href='?_src_=vars;rotatedatum=\ref[src];rotatedir=left'><<</a>
		<a href='?_src_=vars;datumedit=\ref[src];varnameedit=dir'>[dir2text(dir)]</a>
		<a href='?_src_=vars;rotatedatum=\ref[src];rotatedir=right'>>></a>
		</font>
		"}

/mob/living/get_view_variables_header()
	return {"
		<a href='?_src_=vars;rename=\ref[src]'><b>[src]</b></a><font size='1'>
		<br><a href='?_src_=vars;rotatedatum=\ref[src];rotatedir=left'><<</a> <a href='?_src_=vars;datumedit=\ref[src];varnameedit=dir'>[dir2text(dir)]</a> <a href='?_src_=vars;rotatedatum=\ref[src];rotatedir=right'>>></a>
		<br><a href='?_src_=vars;datumedit=\ref[src];varnameedit=ckey'>[ckey ? ckey : "No ckey"]</a> / <a href='?_src_=vars;datumedit=\ref[src];varnameedit=real_name'>[real_name ? real_name : "No real name"]</a>
		<br>
		BRUTE:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=brute'>[getBruteLoss()]</a>
		FIRE:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=fire'>[getFireLoss()]</a>
		TOXIN:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=toxin'>[getToxLoss()]</a>
		OXY:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=oxygen'>[getOxyLoss()]</a>
		CLONE:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=clone'>[getCloneLoss()]</a>
		BRAIN:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=brain'>[getBrainLoss()]</a>
		</font>
		"}

// Same for these as for get_view_variables_header() above
/datum/proc/get_view_variables_options()
	return ""

/mob/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;mob_player_panel=\ref[src]'>Show player panel</option>
		<option>---</option>
		<option value='?_src_=vars;give_spell=\ref[src]'>Give Spell</option>
		<option value='?_src_=vars;give_disease2=\ref[src]'>Give Disease</option>
		<option value='?_src_=vars;give_disease=\ref[src]'>Give TG-style Disease</option>
		<option value='?_src_=vars;godmode=\ref[src]'>Toggle Godmode</option>
		<option value='?_src_=vars;build_mode=\ref[src]'>Toggle Build Mode</option>

		<option value='?_src_=vars;ninja=\ref[src]'>Make Space Ninja</option>
		<option value='?_src_=vars;make_skeleton=\ref[src]'>Make 2spooky</option>

		<option value='?_src_=vars;direct_control=\ref[src]'>Assume Direct Control</option>
		<option value='?_src_=vars;drop_everything=\ref[src]'>Drop Everything</option>

		<option value='?_src_=vars;regenerateicons=\ref[src]'>Regenerate Icons</option>
		<option value='?_src_=vars;addlanguage=\ref[src]'>Add Language</option>
		<option value='?_src_=vars;remlanguage=\ref[src]'>Remove Language</option>
		<option value='?_src_=vars;addorgan=\ref[src]'>Add Organ</option>
		<option value='?_src_=vars;remorgan=\ref[src]'>Remove Organ</option>

		<option value='?_src_=vars;fix_nano=\ref[src]'>Fix NanoUI</option>

		<option value='?_src_=vars;addverb=\ref[src]'>Add Verb</option>
		<option value='?_src_=vars;remverb=\ref[src]'>Remove Verb</option>
		<option>---</option>
		<option value='?_src_=vars;gib=\ref[src]'>Gib</option>
		<option value='?_src_=vars;explode=\ref[src]'>Trigger explosion</option>
		<option value='?_src_=vars;emp=\ref[src]'>Trigger EM pulse</option>
		"}

/mob/living/carbon/human/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;setspecies=\ref[src]'>Set Species</option>
		<option value='?_src_=vars;dressup=\ref[src]'>Dressup</option>
		<option value='?_src_=vars;makeai=\ref[src]'>Make AI</option>
		<option value='?_src_=vars;makerobot=\ref[src]'>Make cyborg</option>
		<option value='?_src_=vars;makemonkey=\ref[src]'>Make monkey</option>
		<option value='?_src_=vars;makealien=\ref[src]'>Make alien</option>
		<option value='?_src_=vars;makeslime=\ref[src]'>Make slime</option>
		"}

/obj/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;delthis=\ref[src]'>Delete instance</option>
		<option value='?_src_=vars;delall=\ref[src]'>Delete all of type</option>
		<option value='?_src_=vars;explode=\ref[src]'>Trigger explosion</option>
		<option value='?_src_=vars;emp=\ref[src]'>Trigger EM pulse</option>
		"}

/turf/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;explode=\ref[src]'>Trigger explosion</option>
		<option value='?_src_=vars;emp=\ref[src]'>Trigger EM pulse</option>
		"}

/datum/proc/get_variables()
	return vars

/datum/proc/get_variable_value(varname)
	return vars[varname]

/datum/proc/set_variable_value(varname, value)
	vars[varname] = value

/datum/proc/get_initial_variable_value(varname)
	return null // I don't see how this ever returned anything except null. Used to be: initial(D.vars[varname])

/datum/proc/make_view_variables_variable_entry(varname, value)
	return {"
			(<a href='?_src_=vars;datumedit=\ref[src];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;datumchange=\ref[src];varnamechange=[varname]'>C</a>)
			(<a href='?_src_=vars;datummass=\ref[src];varnamemass=[varname]'>M</a>)
			"}

// No mass editing of clients
/client/make_view_variables_variable_entry(varname, value)
	return {"
			(<a href='?_src_=vars;datumedit=\ref[src];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;datumchange=\ref[src];varnamechange=[varname]'>C</a>)
			"}

// These methods are all procs and don't use stored lists to avoid VV exploits

/datum/proc/VVlocked()
	return list("vars", "virus", "viruses", "cuffed")

/atom/movable/VVlocked()
	return ..() + list("bound_x", "bound_y", "step_x", "step_y")

/mob/VVlocked()
	return ..() + list("client")

/datum/proc/VVicon_edit_lock()
	return list()

/atom/VVicon_edit_lock()
	return ..() + list("icon", "icon_state", "overlays", "underlays")

/datum/proc/VVckey_edit()
	return list()

/mob/VVckey_edit()
	return list("key", "ckey")

/client/VVlocked()
	return list("vars", "holder", "mob")

/client/VVicon_edit_lock()
	return list()

/client/VVckey_edit()
	return list("key", "ckey")

/proc/forbidden_varedit_object_types()
 	return list(
		/datum/admins,						//Admins editing their own admin-power object? Yup, sounds like a good idea.,
		/obj/machinery/blackbox_recorder,	//Prevents people messing with feedback gathering,
		/datum/feedback_variable			//Prevents people messing with feedback gathering
	)
