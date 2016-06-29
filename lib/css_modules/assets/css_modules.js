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
    //   var headerClassName = CSSModules.styleFor("homepage", "header")
    styleFor: function(moduleName, selectorName) {
      return transformName(moduleName) + "_" + selectorName;
    },
    // Returns a function for generating selectors inside this module
    //
    // Usage:
    //   var homepage = CSSModules.module("homepage")
    //   var headerClassName = homepage("header")
    //   var footerClassName = homepage("footer")
    module: function(moduleName) {
      var transformedName = transformName(moduleName);
      return function(selectorName) {
        return transformedName + "_" + selectorName;
      };
    },
  };

  return _CSSModules;
})();
