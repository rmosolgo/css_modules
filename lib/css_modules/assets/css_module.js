// Usage:
//
// - Call with a module name + selector name to get a transformed (opaque) selector
//
//   ```js
//   CSSModule("events_index", "header")
//   // => "..." (some opaque string that matches the stylesheet)
//   ```
//
// - Call with a module name to get a function for modulizing selectors
//
//   ```js
//   var eventsModule = CSSModule("events_index")
//   var headerSelector = eventsModule("header")
//   var footerSelector = eventsModule("footer")
//   ```
//
// This behavior has to match `CSSModules::Rewrite` in Ruby
// so that generated selectors match.
function CSSModule(moduleName, selectorName) {
  // This matches `Rewrite`:
  var opaqueString = btoa(moduleName).replace(/[^a-zA-Z0-9]/g, "")
  var transformedModuleName = opaqueString + "_" + moduleName;
  if (selectorName) {
    return transformedModuleName + "_" + selectorName;
  } else {
    return function(selectorName) {
      return transformedModuleName + "_" + selectorName;
    };
  }
};
