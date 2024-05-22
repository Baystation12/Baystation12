#define SETUP_SUBTYPE_SINGLETONS_BY_NAME(singleton_prototype, singletons_by_name) \
if(!singletons_by_name) \
{\
	singletons_by_name = list();\
	var/singletons_by_type = GET_SINGLETON_SUBTYPE_MAP(singleton_prototype);\
	for(var/singleton_type in singletons_by_type) \
	{\
		var##singleton_prototype/singleton_instance = singletons_by_type[singleton_type];\
		ADD_SORTED(singletons_by_name, singleton_instance.name, GLOBAL_PROC_REF(cmp_text_asc));\
		singletons_by_name[singleton_instance.name] = singleton_instance;\
	}\
}

/// Full Options Button.
#define FBTN(key, value, label, title, style) \
"[title ? "[title]: " : ""]<a href=\"?src=\ref[src];[key]=[value]\"[style ? " style=\"[style]\"" : ""]>[label]</a>"

/// Value-passing Styled Button.
#define VSBTN(key, value, label, style) FBTN(key, value, label, "", style)

/// Styled Titled Button.
#define STBTN(key, label, title, style) FBTN(key, 1, label, title, style)

/// Value-passing Titled Button.
#define VTBTN(key, value, label, title) FBTN(key, value, label, title, "")

/// Styled Button.
#define SBTN(key, label, style) FBTN(key, 1, label, "", style)

/// Value-passing Button.
#define VBTN(key, value, label) FBTN(key, value, label, "", "")

/// Titled Button.
#define TBTN(key, label, title) FBTN(key, 1, label, title, "")

/// Simple Button.
#define BTN(key, label) FBTN(key, 1, label, "", "")

#define COLOR_PREVIEW(color) \
"<table style=\"display: inline; font-size: 13px; color: [color]\" bgcolor=\"[color]\"><tr><td>__</td></tr></table>"

#define UI_FONT_GOOD(X) SPAN_COLOR("#55cc55", X)
#define UI_FONT_BAD(X) SPAN_COLOR("#cc5555", X)
