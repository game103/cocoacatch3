class mochi.as2.MochiAd
{
    var clip, fadeout_start, fadeout_time, _parent, mc, started, _mochiad_bar, last_pcnt, server_control, fadeFunction, _mochiad_ctr, _url;
    function MochiAd()
    {
    } // End of the function
    static function getVersion()
    {
        return ("3.02 as2");
    } // End of the function
    static function showPreGameAd(options)
    {
        var _loc26 = {clip: _root, ad_timeout: 3000, fadeout_time: 250, regpt: "o", method: "showPreloaderAd", color: 16747008, background: 16777161, outline: 13994812, no_progress_bar: false, ad_started: function ()
        {
            clip.stop();
        }, ad_finished: function ()
        {
            clip.play();
        }, ad_failed: function ()
        {
            trace ("[MochiAd] Couldn\'t load an ad, make sure that your game\'s local security sandbox is configured for Access Network Only and that you are not using ad blocking software");
        }, ad_loaded: function (width, height)
        {
        }, ad_skipped: function ()
        {
        }, ad_progress: function (percent)
        {
        }};
        options = mochi.as2.MochiAd._parseOptions(options, _loc26);
        if ("c862232051e0a94e1c3609b3916ddb17".substr(0) == "dfeada81ac97cde83665f81c12da7def")
        {
            options.ad_started();
            options.ad_finished();
            return;
        } // end if
        var clip = options.clip;
        var _loc22 = 11000;
        var _loc25 = options.ad_timeout;
        delete options.ad_timeout;
        var fadeout_time = options.fadeout_time;
        delete options.fadeout_time;
        if (!mochi.as2.MochiAd.load(options))
        {
            options.ad_failed();
            options.ad_finished();
            return;
        } // end if
        options.ad_started();
        var mc = clip._mochiad;
        mc.onUnload = function ()
        {
            options.ad_finished();
        };
        var _loc14 = mochi.as2.MochiAd._getRes(options);
        var _loc4 = _loc14[0];
        var _loc13 = _loc14[1];
        mc._x = _loc4 * 0.500000;
        mc._y = _loc13 * 0.500000;
        var chk = mc.createEmptyMovieClip("_mochiad_wait", 3);
        chk._x = _loc4 * -0.500000;
        chk._y = _loc13 * -0.500000;
        var _loc6 = chk.createEmptyMovieClip("_mochiad_bar", 4);
        if (options.no_progress_bar)
        {
            _loc6._visible = false;
            delete options.no_progress_bar;
        }
        else
        {
            _loc6._x = 10;
            _loc6._y = _loc13 - 20;
        } // end else if
        var _loc21 = options.color;
        delete options.color;
        var _loc19 = options.background;
        delete options.background;
        var _loc23 = options.outline;
        delete options.outline;
        var _loc5 = _loc6.createEmptyMovieClip("_outline", 1);
        _loc5.beginFill(_loc19);
        _loc5.moveTo(0, 0);
        _loc5.lineTo(_loc4 - 20, 0);
        _loc5.lineTo(_loc4 - 20, 10);
        _loc5.lineTo(0, 10);
        _loc5.lineTo(0, 0);
        _loc5.endFill();
        var _loc3 = _loc6.createEmptyMovieClip("_inside", 2);
        _loc3.beginFill(_loc21);
        _loc3.moveTo(0, 0);
        _loc3.lineTo(_loc4 - 20, 0);
        _loc3.lineTo(_loc4 - 20, 10);
        _loc3.lineTo(0, 10);
        _loc3.lineTo(0, 0);
        _loc3.endFill();
        _loc3._xscale = 0;
        var _loc7 = _loc6.createEmptyMovieClip("_outline", 3);
        _loc7.lineStyle(0, _loc23, 100);
        _loc7.moveTo(0, 0);
        _loc7.lineTo(_loc4 - 20, 0);
        _loc7.lineTo(_loc4 - 20, 10);
        _loc7.lineTo(0, 10);
        _loc7.lineTo(0, 0);
        chk.ad_msec = _loc22;
        chk.ad_timeout = _loc25;
        chk.started = getTimer();
        chk.showing = false;
        chk.last_pcnt = 0;
        chk.fadeout_time = fadeout_time;
        chk.fadeFunction = function ()
        {
            var _loc2 = 100 * (1 - (getTimer() - fadeout_start) / fadeout_time);
            if (_loc2 > 0)
            {
                _parent._alpha = _loc2;
            }
            else
            {
                var _loc3 = _parent._parent;
                mochi.as2.MochiAd.unload(_loc3);
                delete this.onEnterFrame;
            } // end else if
        };
        mc.lc.regContLC = function (lc_name)
        {
            mc._containerLCName = lc_name;
        };
        var sendHostProgress = false;
        mc.lc.sendHostLoadProgress = function (lc_name)
        {
            sendHostProgress = true;
        };
        mc.lc.adLoaded = options.ad_loaded;
        mc.lc.adSkipped = options.ad_skipped;
        mc.lc.adjustProgress = function (msec)
        {
            var _loc2 = mc._mochiad_wait;
            _loc2.server_control = true;
            _loc2.started = getTimer();
            _loc2.ad_msec = msec;
        };
        mc.lc.rpc = function (callbackID, arg)
        {
            mochi.as2.MochiAd.rpc(clip, callbackID, arg);
        };
        mc.rpcTestFn = function (s)
        {
            trace ("[MOCHIAD rpcTestFn] " + s);
            return (s);
        };
        chk.onEnterFrame = function ()
        {
            var _loc6 = _parent._parent;
            var _loc11 = _parent._mochiad_ctr;
            var _loc5 = getTimer() - started;
            var _loc3 = false;
            var _loc4 = _loc6.getBytesTotal();
            var _loc8 = _loc6.getBytesLoaded();
            var _loc2 = 100 * _loc8 / _loc4;
            var _loc10 = 100 * _loc5 / chk.ad_msec;
            var _loc9 = _mochiad_bar._inside;
            var _loc13 = Math.min(100, Math.min(_loc2 || 0, _loc10));
            _loc13 = Math.max(last_pcnt, _loc13);
            last_pcnt = _loc13;
            _loc9._xscale = _loc13;
            options.ad_progress(_loc13);
            if (sendHostProgress)
            {
                mochi.as2.MochiAd.containerNotify(clip, {id: "hostLoadPcnt", pcnt: _loc2}, clip._mochiad._containerLCName);
                if (_loc2 == 100)
                {
                    sendHostProgress = false;
                } // end if
            } // end if
            if (!chk.showing)
            {
                var _loc7 = _loc11.getBytesTotal();
                if (_loc7 > 0 || typeof(_loc7) == "undefined")
                {
                    chk.showing = true;
                    chk.started = getTimer();
                }
                else if (_loc5 > chk.ad_timeout && _loc2 == 100)
                {
                    options.ad_failed();
                    _loc3 = true;
                } // end if
            } // end else if
            if (_loc5 > chk.ad_msec)
            {
                _loc3 = true;
            } // end if
            if (_loc4 > 0 && _loc8 >= _loc4 && _loc3)
            {
                if (server_control)
                {
                    delete this.onEnterFrame;
                }
                else
                {
                    fadeout_start = getTimer();
                    onEnterFrame = chk.fadeFunction;
                } // end if
            } // end else if
        };
    } // End of the function
    static function showClickAwayAd(options)
    {
        var _loc9 = {clip: _root, ad_timeout: 2000, fadeout_time: 250, regpt: "o", method: "showClickAwayAd", res: "300x250", no_bg: true, ad_started: function ()
        {
        }, ad_finished: function ()
        {
        }, ad_loaded: function (width, height)
        {
        }, ad_failed: function ()
        {
            trace ("[MochiAd] Couldn\'t load an ad, make sure that your game\'s local security sandbox is configured for Access Network Only and that you are not using ad blocking software");
        }, ad_skipped: function ()
        {
        }};
        options = mochi.as2.MochiAd._parseOptions(options, _loc9);
        var clip = options.clip;
        var _loc8 = options.ad_timeout;
        delete options.ad_timeout;
        if (!mochi.as2.MochiAd.load(options))
        {
            options.ad_failed();
            options.ad_finished();
            return;
        } // end if
        options.ad_started();
        var mc = clip._mochiad;
        mc.onUnload = function ()
        {
            options.ad_finished();
        };
        var _loc4 = mochi.as2.MochiAd._getRes(options);
        var _loc10 = _loc4[0];
        var _loc7 = _loc4[1];
        mc._x = _loc10 * 0.500000;
        mc._y = _loc7 * 0.500000;
        var chk = mc.createEmptyMovieClip("_mochiad_wait", 3);
        chk.ad_timeout = _loc8;
        chk.started = getTimer();
        chk.showing = false;
        mc.lc.adLoaded = options.ad_loaded;
        mc.lc.adSkipped = options.ad_skipped;
        mc.lc.rpc = function (callbackID, arg)
        {
            mochi.as2.MochiAd.rpc(clip, callbackID, arg);
        };
        mc.rpcTestFn = function (s)
        {
            trace ("[MOCHIAD rpcTestFn] " + s);
            return (s);
        };
        var _loc20 = false;
        mc.lc.regContLC = function (lc_name)
        {
            mc._containerLCName = lc_name;
        };
        chk.onEnterFrame = function ()
        {
            var _loc5 = _parent._mochiad_ctr;
            var _loc4 = getTimer() - started;
            var _loc2 = false;
            if (!chk.showing)
            {
                var _loc3 = _loc5.getBytesTotal();
                if (_loc3 > 0 || typeof(_loc3) == "undefined")
                {
                    _loc2 = true;
                    chk.showing = true;
                    chk.started = getTimer();
                }
                else if (_loc4 > chk.ad_timeout)
                {
                    options.ad_failed();
                    _loc2 = true;
                } // end if
            } // end else if
            if (_loc2)
            {
                delete this.onEnterFrame;
            } // end if
        };
    } // End of the function
    static function showInterLevelAd(options)
    {
        var _loc13 = {clip: _root, ad_timeout: 2000, fadeout_time: 250, regpt: "o", method: "showTimedAd", ad_started: function ()
        {
            clip.stop();
        }, ad_finished: function ()
        {
            clip.play();
        }, ad_failed: function ()
        {
            trace ("[MochiAd] Couldn\'t load an ad, make sure that your game\'s local security sandbox is configured for Access Network Only and that you are not using ad blocking software");
        }, ad_loaded: function (width, height)
        {
        }, ad_skipped: function ()
        {
        }};
        options = mochi.as2.MochiAd._parseOptions(options, _loc13);
        var clip = options.clip;
        var _loc10 = 11000;
        var _loc12 = options.ad_timeout;
        delete options.ad_timeout;
        var fadeout_time = options.fadeout_time;
        delete options.fadeout_time;
        if (!mochi.as2.MochiAd.load(options))
        {
            options.ad_failed();
            options.ad_finished();
            return;
        } // end if
        options.ad_started();
        var mc = clip._mochiad;
        mc.onUnload = function ()
        {
            options.ad_finished();
        };
        var _loc5 = mochi.as2.MochiAd._getRes(options);
        var _loc14 = _loc5[0];
        var _loc11 = _loc5[1];
        mc._x = _loc14 * 0.500000;
        mc._y = _loc11 * 0.500000;
        var chk = mc.createEmptyMovieClip("_mochiad_wait", 3);
        chk.ad_msec = _loc10;
        chk.ad_timeout = _loc12;
        chk.started = getTimer();
        chk.showing = false;
        chk.fadeout_time = fadeout_time;
        chk.fadeFunction = function ()
        {
            var _loc2 = 100 * (1 - (getTimer() - fadeout_start) / fadeout_time);
            if (_loc2 > 0)
            {
                _parent._alpha = _loc2;
            }
            else
            {
                var _loc3 = _parent._parent;
                mochi.as2.MochiAd.unload(_loc3);
                delete this.onEnterFrame;
            } // end else if
        };
        mc.lc.adLoaded = options.ad_loaded;
        mc.lc.adSkipped = options.ad_skipped;
        mc.lc.adjustProgress = function (msec)
        {
            var _loc2 = mc._mochiad_wait;
            _loc2.server_control = true;
            _loc2.started = getTimer();
            _loc2.ad_msec = msec - 250;
        };
        mc.lc.rpc = function (callbackID, arg)
        {
            mochi.as2.MochiAd.rpc(clip, callbackID, arg);
        };
        mc.rpcTestFn = function (s)
        {
            trace ("[MOCHIAD rpcTestFn] " + s);
            return (s);
        };
        chk.onEnterFrame = function ()
        {
            var _loc5 = _parent._mochiad_ctr;
            var _loc4 = getTimer() - started;
            var _loc2 = false;
            if (!chk.showing)
            {
                var _loc3 = _loc5.getBytesTotal();
                if (_loc3 > 0 || typeof(_loc3) == "undefined")
                {
                    chk.showing = true;
                    chk.started = getTimer();
                }
                else if (_loc4 > chk.ad_timeout)
                {
                    options.ad_failed();
                    _loc2 = true;
                } // end if
            } // end else if
            if (_loc4 > chk.ad_msec)
            {
                _loc2 = true;
            } // end if
            if (_loc2)
            {
                if (server_control)
                {
                    delete this.onEnterFrame;
                }
                else
                {
                    fadeout_start = getTimer();
                    onEnterFrame = fadeFunction;
                } // end if
            } // end else if
        };
    } // End of the function
    static function showPreloaderAd(options)
    {
        trace ("[MochiAd] DEPRECATED: showPreloaderAd was renamed to showPreGameAd in 2.0");
        mochi.as2.MochiAd.showPreGameAd(options);
    } // End of the function
    static function showTimedAd(options)
    {
        trace ("[MochiAd] DEPRECATED: showTimedAd was renamed to showInterLevelAd in 2.0");
        mochi.as2.MochiAd.showInterLevelAd(options);
    } // End of the function
    static function _allowDomains(server)
    {
        var _loc1 = server.split("/")[2].split(":")[0];
        if (System.security)
        {
            if (System.security.allowDomain)
            {
                System.security.allowDomain("*");
                System.security.allowDomain(_loc1);
            } // end if
            if (System.security.allowInsecureDomain)
            {
                System.security.allowInsecureDomain("*");
                System.security.allowInsecureDomain(_loc1);
            } // end if
        } // end if
        return (_loc1);
    } // End of the function
    static function load(options)
    {
        var _loc13 = {clip: _root, server: "http://x.mochiads.com/srv/1/", method: "load", depth: 10333, id: "_UNKNOWN_"};
        options = mochi.as2.MochiAd._parseOptions(options, _loc13);
        options.swfv = options.clip.getSWFVersion() || 6;
        options.mav = mochi.as2.MochiAd.getVersion();
        var _loc7 = options.clip;
        if (!mochi.as2.MochiAd._isNetworkAvailable())
        {
            return (null);
        } // end if
        if (_loc7._mochiad_loaded)
        {
            return (null);
        } // end if
        var _loc12 = options.depth;
        delete options.depth;
        var _loc6 = _loc7.createEmptyMovieClip("_mochiad", _loc12);
        var _loc11 = mochi.as2.MochiAd._getRes(options);
        options.res = _loc11[0] + "x" + _loc11[1];
        options.server = options.server + options.id;
        delete options.id;
        _loc7._mochiad_loaded = true;
        if (_loc7._url.indexOf("http") != 0)
        {
            trace ("[MochiAd] NOTE: Security Sandbox Violation errors below are normal");
        } // end if
        var _loc4 = _loc6.createEmptyMovieClip("_mochiad_ctr", 1);
        for (var _loc8 in options)
        {
            _loc4[_loc8] = options[_loc8];
        } // end of for...in
        var _loc10 = _loc4.server;
        delete _loc4.server;
        var _loc14 = mochi.as2.MochiAd._allowDomains(_loc10);
        _loc6.onEnterFrame = function ()
        {
            if (_mochiad_ctr._url != _url)
            {
                function onEnterFrame()
                {
                    if (!_mochiad_ctr)
                    {
                        delete this.onEnterFrame;
                        mochi.as2.MochiAd.unload(_parent);
                    } // end if
                } // End of the function
            } // end if
        };
        var _loc5 = new Object();
        var _loc9 = ["", Math.floor(new Date().getTime()), random(999999)].join("_");
        _loc5.mc = _loc6;
        _loc5.name = _loc9;
        _loc5.hostname = _loc14;
        _loc5.allowDomain = function (d)
        {
            return (true);
        };
        _loc5.allowInsecureDomain = _loc5.allowDomain;
        _loc5.connect(_loc9);
        _loc6.lc = _loc5;
        _loc4.lc = _loc9;
        _loc4.st = getTimer();
        _loc4.loadMovie(_loc10 + ".swf", "POST");
        return (_loc6);
    } // End of the function
    static function unload(clip)
    {
        if (typeof(clip) == "undefined")
        {
            clip = _root;
        } // end if
        if (clip.clip && clip.clip._mochiad)
        {
            clip = clip.clip;
        } // end if
        if (!clip._mochiad)
        {
            return (false);
        } // end if
        mochi.as2.MochiAd.containerNotify(clip, {id: "unload"}, clip._mochiad._containerLCName);
        clip._mochiad.removeMovieClip();
        delete clip._mochiad_loaded;
        delete clip._mochiad;
        return (true);
    } // End of the function
    static function _isNetworkAvailable()
    {
        if (System.security)
        {
            var _loc1 = System.security;
            if (_loc1.sandboxType == "localWithFile")
            {
                return (false);
            } // end if
        } // end if
        return (true);
    } // End of the function
    static function _getRes(options)
    {
        var _loc3 = options.clip.getBounds();
        var _loc2 = 0;
        var _loc1 = 0;
        if (typeof(options.res) != "undefined")
        {
            var _loc4 = options.res.split("x");
            _loc2 = parseFloat(_loc4[0]);
            _loc1 = parseFloat(_loc4[1]);
        }
        else
        {
            _loc2 = _loc3.xMax - _loc3.xMin;
            _loc1 = _loc3.yMax - _loc3.yMin;
        } // end else if
        if (_loc2 == 0 || _loc1 == 0)
        {
            _loc2 = Stage.width;
            _loc1 = Stage.height;
        } // end if
        return ([_loc2, _loc1]);
    } // End of the function
    static function _parseOptions(options, defaults)
    {
        var _loc4 = {};
        for (var _loc8 in defaults)
        {
            _loc4[_loc8] = defaults[_loc8];
        } // end of for...in
        if (options)
        {
            for (var _loc8 in options)
            {
                _loc4[_loc8] = options[_loc8];
            } // end of for...in
        } // end if
        if (_root.mochiad_options)
        {
            var _loc5 = _root.mochiad_options.split("&");
            for (var _loc2 = 0; _loc2 < _loc5.length; ++_loc2)
            {
                var _loc3 = _loc5[_loc2].split("=");
                _loc4[unescape(_loc3[0])] = unescape(_loc3[1]);
            } // end of for
        } // end if
        if (_loc4.id == "test")
        {
            trace ("[MochiAd] WARNING: Using the MochiAds test identifier, make sure to use the code from your dashboard, not this example!");
        } // end if
        return (_loc4);
    } // End of the function
    static function rpc(clip, callbackID, arg)
    {
        switch (arg.id)
        {
            case "setValue":
            {
                mochi.as2.MochiAd.setValue(clip, arg.objectName, arg.value);
                break;
            } 
            case "getValue":
            {
                var _loc4 = mochi.as2.MochiAd.getValue(clip, arg.objectName);
                mochi.as2.MochiAd.containerRpcResult(clip, callbackID, _loc4, clip._mochiad._containerLCName);
                break;
            } 
            case "runMethod":
            {
                var _loc3 = mochi.as2.MochiAd.runMethod(clip, arg.method, arg.args);
                mochi.as2.MochiAd.containerRpcResult(clip, callbackID, _loc3, clip._mochiad._containerLCName);
                break;
            } 
            default:
            {
                trace ("[mochiads rpc] unknown rpc id: " + arg.id);
            } 
        } // End of switch
    } // End of the function
    static function setValue(base, objectName, value)
    {
        var _loc2 = objectName.split(".");
        var _loc1;
        for (var _loc1 = 0; _loc1 < _loc2.length - 1; ++_loc1)
        {
            if (base[_loc2[_loc1]] == undefined || base[_loc2[_loc1]] == null)
            {
                return;
            } // end if
            base = base[_loc2[_loc1]];
        } // end of for
        base[_loc2[_loc1]] = value;
    } // End of the function
    static function getValue(base, objectName)
    {
        var _loc2 = objectName.split(".");
        var _loc1;
        for (var _loc1 = 0; _loc1 < _loc2.length - 1; ++_loc1)
        {
            if (base[_loc2[_loc1]] == undefined || base[_loc2[_loc1]] == null)
            {
                return;
            } // end if
            base = base[_loc2[_loc1]];
        } // end of for
        return (base[_loc2[_loc1]]);
    } // End of the function
    static function runMethod(base, methodName, argsArray)
    {
        var _loc2 = methodName.split(".");
        var _loc1;
        for (var _loc1 = 0; _loc1 < _loc2.length - 1; ++_loc1)
        {
            if (base[_loc2[_loc1]] == undefined || base[_loc2[_loc1]] == null)
            {
                return;
            } // end if
            base = base[_loc2[_loc1]];
        } // end of for
        if (typeof(base[_loc2[_loc1]]) == "function")
        {
            return (base[_loc2[_loc1]].apply(base, argsArray));
        }
        else
        {
            return;
        } // end else if
    } // End of the function
    static function containerNotify(clip, args, lcName)
    {
        var _loc1 = clip._mochiad._mochiad_ctr.ad.app;
        if (_loc1.notify)
        {
            _loc1.notify(args);
        }
        else
        {
            new LocalConnection().send(lcName, "notify", args);
        } // end else if
    } // End of the function
    static function containerRpcResult(clip, callbackID, val, lcName)
    {
        var _loc1 = clip._mochiad._mochiad_ctr.ad.app;
        if (_loc1.rpcResult)
        {
            _loc1.rpcResult(callbackID, val);
        }
        else
        {
            new LocalConnection().send(lcName, "rpcResult", callbackID, val);
        } // end else if
    } // End of the function
} // End of Class
