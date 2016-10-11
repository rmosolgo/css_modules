var CSSModules = (function() {
  // This function has to match CSSModules::Rewrite in Ruby
  function transformName(moduleName) {
    var opaqueString = btoa(moduleName).replace(/[^a-zA-Z0-9]/g, "")
    return opaqueString + "_" + moduleName;
  };

  var _CSSModules = {
    // Returns a selector for `selectorName` inside `moduleName`
    //
    // Usage:
    //   var headerClassName = CSSModules.styleFor("homepage", ".header")
    styleFor: function(moduleName, selectorName) {
      var transformedModuleName = transformName(moduleName);
      return transformedModuleName + "_" + selectorName;
    },

    // Returns a function for generating selectors inside this module
    //
    // Usage:
    //   // Create a module factory function:
    //   var homepage = CSSModules.module("homepage")
    //
    //   // Pass in a class name to transform:
    //   var headerClassName = homepage("header")
    //   var headerHtml = "<header class='" + headerClassName + "' />"
    //
    //   // or an ID:
    //   var footerID = homepage("footer")
    //   var footerHtml = "<footer id='" + footerID + "'/>"
    //   // Add the `#` yourself to make a selection:
    //   var footerSelection = $("#" + footerID)
    module: function(moduleName) {
      var transformedName = transformName(moduleName);
      return function(selectorName) {
        return transformedName + "_" + selectorName;
      };
    },
  };

  return _CSSModules;
})();
