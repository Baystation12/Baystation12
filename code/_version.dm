/* *
DM version compatibility macros & procs
*/

#if DM_VERSION < 513


#define islist(A) istype(A, /list)
#define ismovable(A) istype(A, /atom/movable)

#define arctan(X) arcsin((X) / sqrt(1 + (X) * (X)))

#define copytext_char(ARGS...) copytext(ARGS)
#define findlasttext_char(ARGS...) findlasttext(ARGS)
#define findlasttextEx_char(ARGS...) findlasttextEx(ARGS)
#define findtext_char(ARGS...) findtext(ARGS)
#define findtextEx_char(ARGS...) findtextEx(ARGS)
#define length_char(X) length(X)
#define nonspantext_char(ARGS...) nonspantext(ARGS)
#define replacetext_char(ARGS...) replacetext(ARGS)
#define replacetextEx_char(ARGS...) replacetextEx(ARGS)
#define spantext_char(ARGS...) spantext(ARGS)
#define splittext_char(ARGS...) splittext(ARGS)
#define text2ascii_char(ARGS...) text2ascii(ARGS)

#define regex_replace_char(RE, ARGS...) RE.Replace(ARGS)
#define regex_replace(RE, ARGS...) RE.Replace(ARGS)
#define regex_find_char(RE, ARGS...) RE.Find(ARGS)
#define regex_find(RE, ARGS...) RE.Find(ARGS)


#else //513+


#define regex_replace_char(RE, ARGS...) RE.Replace_char(ARGS)
#define regex_replace(RE, ARGS...) RE.Replace(ARGS)
#define regex_find_char(RE, ARGS...) RE.Find_char(ARGS)
#define regex_find(RE, ARGS...) RE.Find(ARGS)



#endif
