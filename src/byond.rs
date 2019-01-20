// heavily inspired by /tg/station rust-g
use std::borrow::Cow;
use std::cell::RefCell;
use std::ffi::{CStr, CString};
use std::slice;

use std::os::raw::{c_char, c_int};

static EMPTY_STRING: &[c_char; 1] = &[0];

thread_local! {
    static RETURN_STRING: RefCell<CString> = RefCell::new(CString::default());
}

pub fn parse_args<'a>(argc: c_int, argv: *const *const c_char) -> Vec<Cow<'a, str>> {
    unsafe {
        slice::from_raw_parts(argv, argc as usize)
            .into_iter()
            .map(|ptr| CStr::from_ptr(*ptr))
            .map(|cstr| cstr.to_string_lossy())
            .collect()
    }
}

pub fn byond_return<F, S>(inner: F) -> *const c_char
where
    F: FnOnce() -> Option<S>,
    S: Into<Vec<u8>>,
    {
    match inner() {
        Some(s) => RETURN_STRING.with(|cell| {
            let cs = CString::new(s).expect("null in returned string");
            cell.replace(cs);
            cell.borrow().as_ptr() as *const c_char
        }),
        None => EMPTY_STRING as *const c_char,
    }
}

#[macro_export]
macro_rules! byond_fn {
    ($name:ident() $body:block) => {
        #[no_mangle]
        pub unsafe extern "C" fn $name(
            _argc: ::std::os::raw::c_int, _argv: *const *const ::std::os::raw::c_char
        ) -> *const ::std::os::raw::c_char {
            $crate::byond::byond_return(|| $body)
        }
    };

    ($name:ident($($arg:ident),*) $body:block) => {
        #[no_mangle]
        pub unsafe extern "C" fn $name(
            _argc: ::std::os::raw::c_int, _argv: *const *const ::std::os::raw::c_char
        ) -> *const ::std::os::raw::c_char {
            let __args = $crate::byond::parse_args(_argc, _argv);

            let mut __argn = 0;
            $(
                let $arg = &__args[__argn];
                __argn += 1;
            )*

            $crate::byond::byond_return(|| $body)
        }
    };

    ($name:ident($argname:ident...) $body:block) => {
        #[no_mangle]
        pub unsafe extern "C" fn $name(
            _argc: ::std::os::raw::c_int, _argv: *const *const ::std::os::raw::c_char
        ) -> *const ::std::os::raw::c_char {
            let $argname = $crate::byond::parse_args(_argc, _argv);

            $crate::byond::byond_return(|| $body)
        }
    };
}
