class mochi.as2.MochiServices
{
    var isLoading, startTime, waitInterval, _callbacks, onEnterFrame;
    static var _id, _container, _clip, _sendChannelName, __get__comChannelName, _listenChannel, __get__isNetworkAvailable, _loader, _loaderListener, _sendChannel, __set__comChannelName, __get__childClip, __get__clip, __get__connected, __get__id;
    function MochiServices()
    {
    } // End of the function
    static function get id()
    {
        return (mochi.as2.MochiServices._id);
    } // End of the function
    static function get clip()
    {
        return (mochi.as2.MochiServices._container);
    } // End of the function
    static function get childClip()
    {
        return (mochi.as2.MochiServices._clip);
    } // End of the function
    static function getVersion()
    {
        return ("3.02 as2");
    } // End of the function
    static function allowDomains(server)
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
    static function get isNetworkAvailable()
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
    static function set comChannelName(val)
    {
        if (val != undefined)
        {
            if (val.length > 3)
            {
                _sendChannelName = val + "_fromgame";
                mochi.as2.MochiServices.initComChannels();
            } // end if
        } // end if
        //return (mochi.as2.MochiServices.comChannelName());
        null;
    } // End of the function
    static function get connected()
    {
        return (mochi.as2.MochiServices._connected);
    } // End of the function
    static function connect(id, clip, onError)
    {
        mochi.as2.MochiServices.warnID(id, false);
        if (!mochi.as2.MochiServices._connected && mochi.as2.MochiServices._clip == undefined)
        {
            trace ("MochiServices Connecting...");
            _connecting = true;
            mochi.as2.MochiServices.init(id, clip);
        } // end if
        if (onError != undefined)
        {
            mochi.as2.MochiServices.onError = onError;
        }
        else if (mochi.as2.MochiServices.onError == undefined)
        {
            static function onError(errorCode)
            {
                trace (errorCode);
            } // End of the function
        } // end else if
    } // End of the function
    static function disconnect()
    {
        if (mochi.as2.MochiServices._connected || mochi.as2.MochiServices._connecting)
        {
            _connecting = _connected = false;
            mochi.as2.MochiServices.flush(true);
            if (mochi.as2.MochiServices._clip != undefined)
            {
                mochi.as2.MochiServices._clip.removeMovieClip();
                delete mochi.as2.MochiServices._clip;
            } // end if
            mochi.as2.MochiServices._listenChannel.close();
        } // end if
    } // End of the function
    static function init(id, clip)
    {
        _id = id;
        if (clip != undefined)
        {
            _container = clip;
        }
        else
        {
            _container = _root;
        } // end else if
        mochi.as2.MochiServices.loadCommunicator(id, mochi.as2.MochiServices._container);
    } // End of the function
    static function loadCommunicator(id, clip)
    {
        var _loc3 = "_mochiservices_com_" + id;
        if (mochi.as2.MochiServices._clip != null)
        {
            return (mochi.as2.MochiServices._clip);
        } // end if
        if (!mochi.as2.MochiServices.__get__isNetworkAvailable())
        {
            return (null);
        } // end if
        if (mochi.as2.MochiServices.urlOptions().servicesURL != undefined)
        {
            _servicesURL = mochi.as2.MochiServices.urlOptions().servicesURL;
        } // end if
        mochi.as2.MochiServices.allowDomains(mochi.as2.MochiServices._servicesURL);
        _clip = clip.createEmptyMovieClip(_loc3, 10336, false);
        _listenChannelName = mochi.as2.MochiServices._listenChannelName + (Math.floor(new Date().getTime()) + "_" + Math.floor(Math.random() * 99999));
        mochi.as2.MochiServices.listen();
        _loader = new MovieClipLoader();
        if (mochi.as2.MochiServices._loaderListener.waitInterval != null)
        {
            clearInterval(mochi.as2.MochiServices._loaderListener.waitInterval);
        } // end if
        _loaderListener = {};
        mochi.as2.MochiServices._loaderListener.onLoadError = function (target_mc, errorCode, httpStatus)
        {
            trace ("MochiServices could not load.");
            mochi.as2.MochiServices.disconnect();
            mochi.as2.MochiServices.onError.apply(null, [errorCode]);
        };
        mochi.as2.MochiServices._loaderListener.onLoadStart = function (target_mc)
        {
            isLoading = true;
        };
        mochi.as2.MochiServices._loaderListener.startTime = getTimer();
        mochi.as2.MochiServices._loaderListener.wait = function ()
        {
            if (getTimer() - startTime > 10000)
            {
                if (!isLoading)
                {
                    mochi.as2.MochiServices.disconnect();
                    mochi.as2.MochiServices.onError.apply(null, ["IOError"]);
                } // end if
                clearInterval(waitInterval);
            } // end if
        };
        mochi.as2.MochiServices._loaderListener.waitInterval = setInterval(mochi.as2.MochiServices._loaderListener, "wait", 1000);
        mochi.as2.MochiServices._loader.addListener(mochi.as2.MochiServices._loaderListener);
        mochi.as2.MochiServices._loader.loadClip(mochi.as2.MochiServices._servicesURL + "?listenLC=" + mochi.as2.MochiServices._listenChannelName + "&mochiad_options=" + escape(_root.mochiad_options), mochi.as2.MochiServices._clip);
        _sendChannel = new LocalConnection();
        mochi.as2.MochiServices._sendChannel._queue = [];
        return (mochi.as2.MochiServices._clip);
    } // End of the function
    static function onStatus(infoObject)
    {
        switch (infoObject.level)
        {
            case "error":
            {
                _connected = false;
                mochi.as2.MochiServices._listenChannel.connect(mochi.as2.MochiServices._listenChannelName);
                break;
            } 
        } // End of switch
    } // End of the function
    static function listen()
    {
        _listenChannel = new LocalConnection();
        mochi.as2.MochiServices._listenChannel.handshake = function (args)
        {
            mochi.as2.MochiServices.__set__comChannelName(args.newChannel);
        };
        mochi.as2.MochiServices._listenChannel.allowDomain = function (d)
        {
            return (true);
        };
        mochi.as2.MochiServices._listenChannel.allowInsecureDomain = mochi.as2.MochiServices._listenChannel.allowDomain;
        mochi.as2.MochiServices._listenChannel._nextcallbackID = 0;
        mochi.as2.MochiServices._listenChannel._callbacks = {};
        mochi.as2.MochiServices._listenChannel.connect(mochi.as2.MochiServices._listenChannelName);
        trace ("Waiting for MochiAds services to connect...");
    } // End of the function
    static function initComChannels()
    {
        if (!mochi.as2.MochiServices._connected)
        {
            mochi.as2.MochiServices._sendChannel.onStatus = function (infoObject)
            {
                mochi.as2.MochiServices.onStatus(infoObject);
            };
            mochi.as2.MochiServices._sendChannel.send(mochi.as2.MochiServices._sendChannelName, "onReceive", {methodName: "handshakeDone"});
            mochi.as2.MochiServices._sendChannel.send(mochi.as2.MochiServices._sendChannelName, "onReceive", {methodName: "registerGame", id: mochi.as2.MochiServices._id, clip: mochi.as2.MochiServices._clip, version: getVersion()});
            mochi.as2.MochiServices._listenChannel.onStatus = function (infoObject)
            {
                mochi.as2.MochiServices.onStatus(infoObject);
            };
            mochi.as2.MochiServices._listenChannel.onReceive = function (pkg)
            {
                var _loc5 = pkg.callbackID;
                var _loc4 = _callbacks[_loc5];
                if (!_loc4)
                {
                    return;
                } // end if
                var _loc2 = _loc4.callbackMethod;
                var _loc3 = _loc4.callbackObject;
                if (_loc3 && typeof(_loc2) == "string")
                {
                    _loc2 = _loc3[_loc2];
                } // end if
                if (_loc2 != undefined)
                {
                    _loc2.apply(_loc3, pkg.args);
                } // end if
                delete _callbacks[_loc5];
            };
            mochi.as2.MochiServices._listenChannel.onError = function ()
            {
                mochi.as2.MochiServices.onError.apply(null, ["IOError"]);
            };
            trace ("connected!");
            _connecting = false;
            _connected = true;
            while (mochi.as2.MochiServices._sendChannel._queue.length > 0)
            {
                mochi.as2.MochiServices._sendChannel.send(mochi.as2.MochiServices._sendChannelName, "onReceive", mochi.as2.MochiServices._sendChannel._queue.shift());
            } // end while
        } // end if
    } // End of the function
    static function flush(error)
    {
        var _loc1;
        var _loc2;
        while (mochi.as2.MochiServices._sendChannel._queue.length > 0)
        {
            _loc1 = mochi.as2.MochiServices._sendChannel._queue.shift();
            false;
            if (_loc1.callbackID != null)
            {
                _loc2 = mochi.as2.MochiServices._listenChannel._callbacks[_loc1.callbackID];
            } // end if
            delete mochi.as2.MochiServices._listenChannel._callbacks[_loc1.callbackID];
            if (error)
            {
                mochi.as2.MochiServices.handleError(_loc1.args, _loc2.callbackObject, _loc2.callbackMethod);
            } // end if
        } // end while
    } // End of the function
    static function handleError(args, callbackObject, callbackMethod)
    {
        if (args != null)
        {
            if (args.onError != null)
            {
                args.onError.apply(null, ["NotConnected"]);
            } // end if
            if (args.options != null && args.options.onError != null)
            {
                args.options.onError.apply(null, ["NotConnected"]);
            } // end if
        } // end if
        if (callbackMethod != null)
        {
            args = {};
            args.error = true;
            args.errorCode = "NotConnected";
            if (callbackObject != null && typeof(callbackMethod) == "string")
            {
                callbackObject[callbackMethod](args);
            }
            else if (callbackMethod != null)
            {
                callbackMethod.apply(args);
            } // end if
        } // end else if
    } // End of the function
    static function send(methodName, args, callbackObject, callbackMethod)
    {
        if (mochi.as2.MochiServices._connected)
        {
            mochi.as2.MochiServices._sendChannel.send(mochi.as2.MochiServices._sendChannelName, "onReceive", {methodName: methodName, args: args, callbackID: mochi.as2.MochiServices._listenChannel._nextcallbackID});
        }
        else if (mochi.as2.MochiServices._clip == undefined || !mochi.as2.MochiServices._connecting)
        {
            mochi.as2.MochiServices.onError.apply(null, ["NotConnected"]);
            mochi.as2.MochiServices.handleError(args, callbackObject, callbackMethod);
            mochi.as2.MochiServices.flush(true);
            return;
        }
        else
        {
            mochi.as2.MochiServices._sendChannel._queue.push({methodName: methodName, args: args, callbackID: mochi.as2.MochiServices._listenChannel._nextcallbackID});
        } // end else if
        mochi.as2.MochiServices._listenChannel._callbacks[mochi.as2.MochiServices._listenChannel._nextcallbackID] = {callbackObject: callbackObject, callbackMethod: callbackMethod};
        ++mochi.as2.MochiServices._listenChannel._nextcallbackID;
    } // End of the function
    static function urlOptions()
    {
        var _loc5 = {};
        if (_root.mochiad_options)
        {
            var _loc4 = _root.mochiad_options.split("&");
            for (var _loc2 = 0; _loc2 < _loc4.length; ++_loc2)
            {
                var _loc3 = _loc4[_loc2].split("=");
                _loc5[unescape(_loc3[0])] = unescape(_loc3[1]);
            } // end of for
        } // end if
        return (_loc5);
    } // End of the function
    static function warnID(bid, leaderboard)
    {
        bid = bid.toLowerCase();
        if (bid.length != 16)
        {
            trace ("WARNING: " + (leaderboard ? ("board") : ("game")) + " ID is not the appropriate length");
            return;
        }
        else if (bid == "1e113c7239048b3f")
        {
            if (leaderboard)
            {
                trace ("WARNING: Using testing board ID");
            }
            else
            {
                trace ("WARNING: Using testing board ID as game ID");
            } // end else if
            return;
        }
        else if (bid == "84993a1de4031cd8")
        {
            if (leaderboard)
            {
                trace ("WARNING: Using testing game ID as board ID");
            }
            else
            {
                trace ("WARNING: Using testing game ID");
            } // end else if
            return;
        } // end else if
        for (var _loc1 = 0; _loc1 < bid.length; ++_loc1)
        {
            switch (bid.charAt(_loc1))
            {
                case "0":
                case "1":
                case "2":
                case "3":
                case "4":
                case "5":
                case "6":
                case "7":
                case "8":
                case "9":
                case "a":
                case "b":
                case "c":
                case "d":
                case "e":
                case "f":
                {
                    break;
                } 
                default:
                {
                    trace ("WARNING: Board ID contains illegal characters: " + bid);
                    return;
                } 
            } // End of switch
        } // end of for
    } // End of the function
    static function addLinkEvent(url, burl, btn, onClick)
    {
        var timeout = 1500;
        var t0 = getTimer();
        var _loc2 = new Object();
        _loc2.mav = getVersion();
        _loc2.swfv = btn.getSWFVersion() || 6;
        _loc2.swfurl = btn._url;
        _loc2.fv = System.capabilities.version;
        _loc2.os = System.capabilities.os;
        _loc2.lang = System.capabilities.language;
        _loc2.scres = System.capabilities.screenResolutionX + "x" + System.capabilities.screenResolutionY;
        var s = "?";
        var _loc3 = 0;
        for (var _loc6 in _loc2)
        {
            if (_loc3 != 0)
            {
                s = s + "&";
            } // end if
            ++_loc3;
            s = s + _loc6 + "=" + escape(_loc2[_loc6]);
        } // end of for...in
        if (!(mochi.as2.MochiServices.netupAttempted || mochi.as2.MochiServices._connected))
        {
            var ping = btn.createEmptyMovieClip("ping", 777);
            var _loc7 = btn.createEmptyMovieClip("nettest", 778);
            netupAttempted = true;
            ping.loadMovie("http://x.mochiads.com/linkping.swf?t=" + getTimer());
            _loc7.onEnterFrame = function ()
            {
                if (ping._totalframes > 0 && ping._totalframes == ping._framesloaded)
                {
                    delete this.onEnterFrame;
                }
                else if (getTimer() - t0 > timeout)
                {
                    delete this.onEnterFrame;
                    netup = false;
                } // end else if
            };
        } // end if
        var _loc4 = btn.createEmptyMovieClip("clk", 1001);
        _loc4._alpha = 0;
        _loc4.beginFill(1044735);
        _loc4.moveTo(0, 0);
        _loc4.lineTo(0, btn._height);
        _loc4.lineTo(btn._width, btn._height);
        _loc4.lineTo(btn._width, 0);
        _loc4.lineTo(0, 0);
        _loc4.endFill();
        _loc4.onRelease = function ()
        {
            if (mochi.as2.MochiServices.netup)
            {
                getURL(url + s, "_blank");
            }
            else
            {
                getURL(burl, "_blank");
            } // end else if
            if (onClick != undefined)
            {
                onClick();
            } // end if
        };
    } // End of the function
    static var _servicesURL = "http://www.mochiads.com/static/lib/services/services.swf";
    static var _listenChannelName = "__ms_";
    static var _connecting = false;
    static var _connected = false;
    static var netup = true;
    static var netupAttempted = false;
} // End of Class
