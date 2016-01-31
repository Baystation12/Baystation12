
var/global/list/interface_languages = list("main", "ru_RU")

/datum/var/is_instance = 0

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
	var/P = "/datum/lang/[lang][path]"					//All lang datums has the same form
	if(text2path(P))									//if we have needed datum, just return it
		return text2path(P)
	var/counter = 0
	var/position = 1
	while(position > 0)									//else, trying to find amount of / in path
		counter++
		position = findtext(P, "/", position+1)
	if(counter < 4)										//if it less than 4, path arg is empty or has wrong form
		return 0
	for(counter; counter > 4; counter--)				//when we have counter == 4, we are in /atom path
		position = 0									//and if previos ispath() check failed, we shouldn`t go deeper
		for(var/i=0; i<counter; i++)					//we should find last / position
			position = findtext(P, "/", position+1)
		P = copytext(P, 1, position)					//then kill the child
		if(text2path(P))								//and check is parent alive
			return text2path(P)
	return 0

proc/translation(var/obj, var/v = null, var/procArgs = null, var/language = null)
	if(!obj || !obj:vars)								//vars is default for any class in byond
		return 0										//so it`s true for classes, but not for num/string/image/file/etc, and also null

	if(!v)
		v = "name"										//calling without var arg will always return translated name

	var/result = null
	var/P = null										//language arg uses only if we should force language, for example, in remaked visible_message()
	var/lang = language ? language : usr.client.prefs.interface_lang

	P = LangPath(obj:type, lang)						//checking lang path
	if(!P)
		P = LangPath(obj:type)							//if something wrong, checking basic eng path
		if(!P)
			if(v in obj:vars)							//var can has basic eng value, so just return default
				return obj:vars[v]
			else										//but proc without lang path couldn`t return anything good
				log_admin("Translation error in [obj:type] [v]. Couldn`t find main and [lang] path.")
				message_admins("Translation error in [obj:type] [v]. Couldn`t find main and [lang] path.", 1)
				return "Translation module error, please, contact administration!"

	P = new P(obj)										//after all, creating lang obj
														//we can translate vars and proc/verb
	if(hascall(P, v) && call(P, v)(procArgs))			//it can be used for easier translation of browser windows and funcs like examine()
		result = call(P, v)(procArgs)					//so, if datum has such proc and it return something, return it
	else if((v in P:vars) && P:GetVar(v))				//else, trying to get var value, if exists
		result = P:GetVar(v)							//GetVar() proc uses for inner needs, but there it isn`t necessary
	else
		del(P)
		P = LangPath(obj:type)							//else, trying to find basic eng form
		if(!P)
			if(v in obj:vars)
				result = obj:vars[v]
			else
				log_admin("Translation error in [obj:type] [v]: [lang] has no such verb or returns null and main path didn`t exist.")
				message_admins("Translation error in [obj:type] [v]: [lang] has no such verb or returns null and main path didn`t exist.", 1)
				result = "Translation module error, please, contact administration!"
		else
			P = new P(obj)
			if(hascall(P, v) && call(P, v)(procArgs))	//and do everything as in previous part
				result = call(P, v)(procArgs)
			else if((v in P:vars) && P:GetVar(v))
				result = P:GetVar(v)
			else if(v in obj:vars)						//if still didn`t exist, just using object basic var value or return error
				result = obj:vars[v]
			else
				log_admin("Translation error in [obj:type] [v]: [lang] and main has no result or returns null.")
				message_admins("Translation module error in [obj:type]:[v]: [lang] and main has no result or returns null.", 1)
				result = "Translation module error, please, contact administration!"
	del(P)
	return sanitize_local(result)