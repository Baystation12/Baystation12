/datum/unit_test/research_designs_shall_be_unique
	name = "UNIQUENESS: Research Designs Shall Be Unique"

/datum/unit_test/research_designs_shall_be_unique/start_test()
	var/list/ids = list()
	var/list/build_paths = list()

	for(var/design_type in subtypesof(/datum/design))
		var/datum/design/design = design_type
		if(initial(design.id) == "id")
			continue

		group_by(ids, initial(design.id), design)
		group_by(build_paths, initial(design.build_path), design)

	var/number_of_issues = number_of_issues(ids, "IDs")
	number_of_issues += number_of_issues(build_paths, "Build Paths")

	if(number_of_issues)
		fail("[number_of_issues] issues with research designs found.")
	else
		pass("All research designs are unique.")

	return 1

/datum/unit_test/player_preferences_shall_have_unique_key
	name = "UNIQUENESS: Player Preferences Shall Be Unique"

/datum/unit_test/player_preferences_shall_have_unique_key/start_test()
	var/list/preference_keys = list()

	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp
		group_by(preference_keys, client_pref.key, client_pref)

	var/number_of_issues = number_of_issues(preference_keys, "Keys")
	if(number_of_issues)
		fail("[number_of_issues] issues with player preferences found.")
	else
		pass("All player preferences have unique keys.")
	return 1

/datum/unit_test/access_datums_shall_be_unique
	name = "UNIQUENESS: Access Datums Shall Be Unique"

/datum/unit_test/access_datums_shall_be_unique/start_test()
	var/list/access_ids = list()
	var/list/access_descs = list()

	for(var/a in get_all_access_datums())
		var/datum/access/access = a
		group_by(access_ids, num2text(access.id), access)
		group_by(access_descs, access.desc, access)

	var/number_of_issues = number_of_issues(access_ids, "Ids")
	number_of_issues += number_of_issues(access_descs, "Descriptions")
	if(number_of_issues)
		fail("[number_of_issues] issue\s with access datums found.")
	else
		pass("All access datums are unique.")
	return 1

/datum/unit_test/outfit_datums_shall_have_unique_names
	name = "UNIQUENESS: Outfit Datums Shall Have Unique Names"

/datum/unit_test/outfit_datums_shall_have_unique_names/start_test()
	var/list/outfits_by_name = list()

	for(var/a in outfits())
		var/decl/hierarchy/outfit/outfit = a
		group_by(outfits_by_name, outfit.name, outfit.type)

	var/number_of_issues = number_of_issues(outfits_by_name, "Names")
	if(number_of_issues)
		fail("[number_of_issues] issue\s with outfit datums found.")
	else
		pass("All outfit datums have unique names.")
	return 1

/datum/unit_test/languages_shall_have_unique_names
	name = "UNIQUENESS: Languages Shall Have Unique Names"

/datum/unit_test/languages_shall_have_unique_names/start_test()
	var/list/languages_by_name = list()

	for(var/lt in subtypesof(/datum/language))
		var/datum/language/l = lt
		group_by(languages_by_name, initial(l.name), lt)

	var/number_of_issues = number_of_issues(languages_by_name, "Language Names")
	if(number_of_issues)
		fail("[number_of_issues] issue\s with language datums found.")
	else
		pass("All languages datums have unique names.")
	return 1

/datum/unit_test/languages_shall_have_no_or_unique_keys
	name = "UNIQUENESS: Languages Shall Have No or Unique Keys"

/datum/unit_test/languages_shall_have_no_or_unique_keys/start_test()
	var/list/languages_by_key = list()

	for(var/lt in subtypesof(/datum/language))
		var/datum/language/l = lt
		var/language_key = initial(l.key)
		if(!language_key)
			continue

		group_by(languages_by_key, language_key, lt)

	var/number_of_issues = number_of_issues(languages_by_key, "Language Keys")
	if(number_of_issues)
		fail("[number_of_issues] issue\s with language datums found.")
	else
		pass("All languages datums have unique keys.")
	return 1

/datum/unit_test/outfit_backpacks_shall_have_unique_names
	name = "UNIQUENESS: Outfit Backpacks Shall Have Unique Names"

/datum/unit_test/outfit_backpacks_shall_have_unique_names/start_test()
	var/list/backpacks_by_name = list()

	var/bos = decls_repository.get_decls_of_subtype(/decl/backpack_outfit)
	for(var/bo in bos)
		var/decl/backpack_outfit/backpack_outfit = bos[bo]
		group_by(backpacks_by_name, backpack_outfit.name, backpack_outfit)

	var/number_of_issues = number_of_issues(backpacks_by_name, "Outfit Backpack Names")
	if(number_of_issues)
		fail("[number_of_issues] outfit backpacks\s found.")
	else
		pass("All outfit backpacks have unique names.")
	return 1


/datum/unit_test/proc/number_of_issues(var/list/entries, var/type, var/feedback = /decl/noi_feedback)
	var/issues = 0
	for(var/key in entries)
		var/list/values = entries[key]
		if(values.len > 1)
			var/decl/noi_feedback/noif = decls_repository.get_decl(feedback)
			noif.print(src, type, key, values)
			issues++

	return issues

/decl/noi_feedback/proc/priv_print(var/datum/unit_test/ut, var/type, var/key, var/output_text)
	ut.log_bad("[type] - [key] - The following entries have the same value: [output_text]")

/decl/noi_feedback/proc/print(var/datum/unit_test/ut, var/type, var/key, var/list/entries)
	priv_print(ut, type, key, english_list(entries))

/decl/noi_feedback/detailed/print(var/datum/unit_test/ut, var/type, var/key, var/list/entries)
	var/list/pretty_print = list()
	pretty_print += ""
	for(var/entry in entries)
		pretty_print += log_info_line(entry)
	priv_print(ut, type, key, jointext(pretty_print, "\n"))
