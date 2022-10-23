#define SETUP_SUBTYPE_DECLS_BY_NAME(decl_prototype, decls_by_name) \
if(!decls_by_name) \
{\
	decls_by_name = list();\
	var/decls_by_type = Singletons.get_decls_of_subtype(decl_prototype);\
	for(var/decl_type in decls_by_type) \
	{\
		var##decl_prototype/decl_instance = decls_by_type[decl_type];\
		ADD_SORTED(decls_by_name, decl_instance.name, /proc/cmp_text_asc);\
		decls_by_name[decl_instance.name] = decl_instance;\
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
