
var/global/list/interface_languages = list("main", "ru_RU")

/client/verb/change_language()
	set name = "Change Language"
	set category = "Preferences"

	var/lang_new = input(usr, "Select a language form list") in interface_languages
	if(!lang_new)
		return
	prefs.interface_lang = lang_new
	prefs.save_preferences()
	usr << "[prefs.interface_lang] was saved"

proc/LangPath(var/path, var/lang = "main")
	var/P = "/datum/lang/[lang][path]"						//All lang datums has the same form
	if(text2path(P))										//if we have needed datum, just return it
		return text2path(P)
	var/counter = 0
	var/position = 1
	while(position > 0)										//else, trying to find amount of / in path
		counter++
		position = findtext(P, "/", position+1)
	if(counter < 4)											//if it less than 4, path arg is empty or has wrong form
		return 0
	for(counter; counter > 4; counter--)					//when we have counter == 4, we are in /atom path
		position = 0										//and if previos ispath() check failed, we shouldn`t go deeper
		for(var/i=0; i<counter; i++)						//we should find last / position
			position = findtext(P, "/", position+1)
		P = copytext(P, 1, position)						//then kill the child
		if(text2path(P))									//and check is parent alive
			return text2path(P)
	return 0

proc/translation(var/obj, var/v = null, var/isProc = 0, var/procArgs = null)
	if(!obj || !obj:vars)									//vars is default for any class in byond
		return 0											//so it`s true for classes, but not for num/string/image/file/etc, and also null

	if(!v)
		v = "name"											//calling without var arg will always return translated name
		isProc = 0											//even if other args are
	if(!((isProc && hascall(obj, v)) || (!isProc && v in obj:vars)))
		return 0											//checking vars and procs in original class

	var/result = null
	var/P = null
	P = LangPath(obj:type, usr.client.prefs.interface_lang)	//checking lang path
	if(!P)
		P = LangPath(obj:type)								//if something wrong, checking basic eng path
		if(!P)
			if(isProc)										//proc without lang path couldn`t return anything good
				log_admin("Translation error in [obj:type] [v]. Couldn`t find main and [usr.client.prefs.interface_lang] path.")
				message_admins("Translation error in [obj:type] [v]. Couldn`t find main and [usr.client.prefs.interface_lang] path.", 1)
				return "Translation module error, please, contact administration!"
			else											//instead of proc, var can has basic eng value
				return obj:vars[v]							//so just return default

	P = new P(obj)											//after all, creating lang obj

															//we can translate vars and proc/verb
	if(isProc)												//it can be used for easier translation of browser windows and funcs like examine()
		if(hascall(P, v) && call(P, v)(procArgs))			//so, if datum has such proc and it return something, return it
			result = call(P, v)(procArgs)
			del(P)
			return result
		else												//else, trying to find basic eng form
			del(P)
			P = LangPath(obj:type)
			if(!P)
				log_admin("Translation error in [obj:type] [v]: [usr.client.prefs.interface_lang] has no such verb or returns null and main path didn`t exist.")
				message_admins("Translation error in [obj:type] [v]: [usr.client.prefs.interface_lang] has no such verb or returns null and main path didn`t exist.", 1)
				return "Translation module error, please, contact administration!"
			P = new P(obj)
			if(hascall(P, v) && call(P, v)(procArgs))		//same check for eng proc
				result = call(P, v)(procArgs)
				del(P)
				return result
			else
				del(P)
				log_admin("Translation error in [obj:type] [v]: [usr.client.prefs.interface_lang] and main has no such verb or returns null.")
				message_admins("Translation module error in [obj:type]:[v]: [usr.client.prefs.interface_lang] and main has no such verb or returns null.", 1)
				return "Translation module error, please, contact administration!"
	else													//as was written before, instead of proc, var can has basic eng value"
		if((v in P:vars) && P:GetVar(v))					//so we should use it if have neither translation, nor parental value
			result = P:GetVar(v)
			del(P)
			return result
		else												//if needed lang path has no such translation, we`ll take basic eng path
			del(P)
			P = LangPath(obj:type)
			if(!P)											//if didn`t exist, just using object basic eng arg value
				del(P)
				return obj:vars[v]
			P = new P(obj)
			if((v in P:vars) && P:GetVar(v))
				result = P:GetVar(v)
				del(P)
				return result
			else											//same if no var or value
				del(P)
				return obj:vars[v]