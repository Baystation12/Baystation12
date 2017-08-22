/*******

I wrote this quick code on 1/9/17 to assist with getting Byond readable syllable lists for Bay12's "fake language generator" used in their language datums.

1. Load a text file with a list of common syllables from a language (there should be 1 syllable per line)
2. Format it into a list and export the resultant text to a new text file
3. Open the final text file manually and copy past in the resulting Byond code, or tweak it as needed.

This disclaimer is so I can get into good habits. Do what you want with the code because being a pirate is alright to me.
- Cael_Aislinn, Halostation, 12/5/17

*******/

/proc/load_language_syllables(var/filename_raw)
	var/filename_final = "languages/[filename_raw].txt"
	if(fexists(filename_final))
		fdel("languages/[filename_raw]_syllables.txt")
		var/list/syllables = file2list(filename_final)
		text2file(format_language_syllable_list(syllables), "languages/[filename_raw]_syllables.txt")

/proc/format_language_syllables(var/list/dolist)
	var/out = "list(\\\n"
	var/num_per_line = 5
	var/num_this_line = 0
	var/current_entry = 1
	for(var/entry in dolist)
		if(current_entry++ == dolist.len)
			out += "\"[lowertext(entry)]\")"
		else
			out += "\"[lowertext(entry)]\","
			if(num_this_line++ >= num_per_line)
				num_this_line = 0
				out += "\\\n"
	return out
