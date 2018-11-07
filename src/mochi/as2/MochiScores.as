class mochi.as2.MochiScores
{
    static var boardID, onError;
    function MochiScores()
    {
    } // End of the function
    static function setBoardID(boardID)
    {
        mochi.as2.MochiServices.warnID(boardID, true);
        mochi.as2.MochiScores.boardID = boardID;
        mochi.as2.MochiServices.send("scores_setBoardID", {boardID: boardID});
    } // End of the function
    static function showLeaderboard(options)
    {
        if (options.clip == null || options.clip == undefined)
        {
            options.clip = mochi.as2.MochiServices.clip;
        } // end if
        if (options.clip != mochi.as2.MochiServices.__get__clip() || mochi.as2.MochiServices.__get__childClip()._target == undefined)
        {
            mochi.as2.MochiServices.disconnect();
            trace ("WARNING!  This application is attempting to connect to MochiServices inside a showLeaderboard call!");
            trace ("make sure MochiServices.connect is called as early in the application runtime as possible.");
            mochi.as2.MochiServices.connect(mochi.as2.MochiServices.__get__id(), options.clip);
        } // end if
        delete options.clip;
        if (options.name != null)
        {
            if (typeof(options.name) == "object")
            {
                if (options.name.text != undefined)
                {
                    options.name = options.name.text;
                } // end if
            } // end if
        } // end if
        if (options.score != null)
        {
            if (options.score instanceof TextField)
            {
                if (options.score.text != undefined)
                {
                    options.score = options.score.text;
                } // end if
            }
            else if (options.score instanceof mochi.as2.MochiDigits)
            {
                options.score = options.score.value;
            } // end else if
            var _loc1 = Number(options.score);
            if (isNaN(_loc1))
            {
                trace ("ERROR: Submitted score \'" + options.score + "\' will be rejected, score is \'Not a Number\'");
            }
            else if (_loc1 == Number.NEGATIVE_INFINITY || _loc1 == Number.POSITIVE_INFINITY)
            {
                trace ("ERROR: Submitted score \'" + options.score + "\' will be rejected, score is an infinite");
            }
            else
            {
                if (Math.floor(_loc1) != _loc1)
                {
                    trace ("WARNING: Submitted score \'" + options.score + "\' will be truncated");
                } // end if
                options.score = _loc1;
            } // end else if
        } // end else if
        if (options.onDisplay != null)
        {
            options.onDisplay();
        }
        else
        {
            mochi.as2.MochiServices.__get__clip().stop();
        } // end else if
        if (options.onClose != null)
        {
            onClose = options.onClose;
        }
        else
        {
            static function onClose()
            {
                mochi.as2.MochiServices.__get__clip().play();
            } // End of the function
        } // end else if
        if (options.onError != null)
        {
            onError = options.onError;
        }
        else
        {
            onError = mochi.as2.MochiScores.onClose;
        } // end else if
        if (options.boardID == null)
        {
            if (mochi.as2.MochiScores.boardID != null)
            {
                options.boardID = mochi.as2.MochiScores.boardID;
            } // end if
        } // end if
        mochi.as2.MochiServices.warnID(options.boardID, true);
        trace ("[MochiScores] NOTE: Security Sandbox Violation errors below are normal");
        mochi.as2.MochiServices.send("scores_showLeaderboard", {options: options}, null, mochi.as2.MochiScores.doClose);
    } // End of the function
    static function closeLeaderboard()
    {
        mochi.as2.MochiServices.send("scores_closeLeaderboard");
    } // End of the function
    static function getPlayerInfo(callbackObj, callbackMethod)
    {
        mochi.as2.MochiServices.send("scores_getPlayerInfo", null, callbackObj, callbackMethod);
    } // End of the function
    static function submit(score, name, callbackObj, callbackMethod)
    {
        score = Number(score);
        if (isNaN(score))
        {
            trace ("ERROR: Submitted score \'" + String(score) + "\' will be rejected, score is \'Not a Number\'");
        }
        else if (score == Number.NEGATIVE_INFINITY || score == Number.POSITIVE_INFINITY)
        {
            trace ("ERROR: Submitted score \'" + String(score) + "\' will be rejected, score is an infinite");
        }
        else
        {
            if (Math.floor(score) != score)
            {
                trace ("WARNING: Submitted score \'" + String(score) + "\' will be truncated");
            } // end if
            score = Number(score);
        } // end else if
        mochi.as2.MochiServices.send("scores_submit", {score: score, name: name}, callbackObj, callbackMethod);
    } // End of the function
    static function requestList(callbackObj, callbackMethod)
    {
        mochi.as2.MochiServices.send("scores_requestList", null, callbackObj, callbackMethod);
    } // End of the function
    static function scoresArrayToObjects(scores)
    {
        var _loc5 = {};
        var _loc1;
        var _loc4;
        var _loc2;
        var _loc6;
        for (var _loc8 in scores)
        {
            if (typeof(scores[_loc8]) == "object")
            {
                if (scores[_loc8].cols != null && scores[_loc8].rows != null)
                {
                    _loc5[_loc8] = [];
                    _loc2 = scores[_loc8];
                    for (var _loc4 = 0; _loc4 < _loc2.rows.length; ++_loc4)
                    {
                        _loc6 = {};
                        for (var _loc1 = 0; _loc1 < _loc2.cols.length; ++_loc1)
                        {
                            _loc6[_loc2.cols[_loc1]] = _loc2.rows[_loc4][_loc1];
                        } // end of for
                        _loc5[_loc8].push(_loc6);
                    } // end of for
                }
                else
                {
                    _loc5[_loc8] = {};
                    for (var _loc7 in scores[_loc8])
                    {
                        _loc5[_loc8][_loc7] = scores[_loc8][_loc7];
                    } // end of for...in
                } // end else if
                continue;
            } // end if
            _loc5[_loc8] = scores[_loc8];
        } // end of for...in
        return (_loc5);
    } // End of the function
    static function doClose(args)
    {
        if (args.error == true)
        {
            if (args.errorCode == undefined)
            {
                args.errorCode = "IOError";
            } // end if
            mochi.as2.MochiScores.onError.apply(null, [args.errorCode]);
        }
        else
        {
            mochi.as2.MochiScores.onClose.apply();
        } // end else if
    } // End of the function
} // End of Class
