(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? factory() :
	typeof define === 'function' && define.amd ? define(factory) :
	(factory());
}(this, (function () { 'use strict';

var classCallCheck = function (instance, Constructor) {
  if (!(instance instanceof Constructor)) {
    throw new TypeError("Cannot call a class as a function");
  }
};

var createClass = function () {
  function defineProperties(target, props) {
    for (var i = 0; i < props.length; i++) {
      var descriptor = props[i];
      descriptor.enumerable = descriptor.enumerable || false;
      descriptor.configurable = true;
      if ("value" in descriptor) descriptor.writable = true;
      Object.defineProperty(target, descriptor.key, descriptor);
    }
  }

  return function (Constructor, protoProps, staticProps) {
    if (protoProps) defineProperties(Constructor.prototype, protoProps);
    if (staticProps) defineProperties(Constructor, staticProps);
    return Constructor;
  };
}();

function connectWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge);
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady', function () {
            callback(WebViewJavascriptBridge);
        }, false);
    }
}

if (!window.jsbridge_inited) {
    connectWebViewJavascriptBridge(function (bridge) {
        bridge.init(function (message, responseCallback) {
            //bridge初始化
        });

        bridge.registerHandler("JSKey", function (data, responseCallback) {
            //native通过"JSKey"关键字找到对应的handler
            //data是native传过来的数据
            //responseCallback 是native与js通信的回调，若responseCallback不为空，直接responseCallback(responseData)即可
            responseCallback("js responseCallback");
        });
    });

    window.jsbridge_inited = true;
}

function callHandler(code, handler_arg, args) {
    if (!window.WebViewJavascriptBridge) {
        console.error("not found WebViewJavascriptBridge from window");
        return;
    }

    WebViewJavascriptBridge.callHandler(code, handler_arg, function (responseData) {
        // succ
        if (responseData) {
                                                  if (args.success) {
                                        typeof args.success == "function" & args.success(responseData);
                                        }
        } else {
            // fail
                                        if (args.fail) {
                                        typeof args.fail == "function" & args.fail(responseData);
                                        }
         
        }
        if (args.complete) {
            typeof args.complete == "function" & args.complete(responseData);
        }
    });
}

var JsBridge = function () {
    function JsBridge(options) {
        classCallCheck(this, JsBridge);
    }

    createClass(JsBridge, [{
        key: "scanQrcode",
        value: function scanQrcode(args) {
            callHandler('ghaier_scanQrcode', '', args);
        }
    }, {
        key: "choosePhoto",
        value: function choosePhoto(args) {
            callHandler('ghaier_choosePhoto', '', args);
        }
    }, {
        key: "takePhoto",
        value: function takePhoto(args) {
            callHandler('ghaier_takePhoto', '', args);
        }
    }, {
        key: "accessLocation",
        value: function accessLocation(args) {
            callHandler('ghaier_accessLocation', '', args);
        }
    }, {
        key: "readContacts",
        value: function readContacts(args) {
            callHandler('ghaier_readContacts', '', args);
        }
    }]);
    return JsBridge;
}();

var Request = function () {
    function Request(options) {
        classCallCheck(this, Request);

        console.log(options);
    }

    createClass(Request, [{
        key: "request",
        value: function request(args) {
            console.log("send request: " + args.method + " " + args.url);
        }
    }]);
    return Request;
}();

var GHaier = Object.assign(JsBridge, Request);

function main() {
    window.ghaier = new GHaier();
}
main();

})));
