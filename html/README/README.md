# HTML Readme

If you do not care about platforms other than windows you are completely free to target IE11 and can avoid using template.html and the polyfills supplied in lib/.

In order to be linux and mac compatible you can only make use of browser features that Internet Explorer 8 supports. This is because BYOND is deeply dependent on embedded IE which, through wine, is only emulated up to IE8. This means using strict HTML 4.01 and avoiding newer CSS and JS features- and yes, "newer" does in fact mean painfully old.

The lib/ directory provides some selected polyfills for common tasks:

- __json2__ provides the JSON object and related behavior.
  (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON)

- __excanvas__ provides the <canvas> tag and PART of the 2D rendering context.
  (https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D)

- __es6-promise__ provides the Promise object and related behavior.
  (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)

- __fetch-ie8__ provides an implementation of the Fetch API backed by XHR. Requires es6-promise.
  (https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch)

Including all of the polyfills all of the time is unlikely to be necessary for your circumstances. Many document display tasks require no JavaScript at all.
