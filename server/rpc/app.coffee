exports.actions = (req, res, ss) ->
    console.log req
    
    sendMsg: (who, msg) ->
        if (msg? and msg.length > 0)
            ss.publish.all 'incommingMessage', 
                who: who
                msg: msg
            res {status: 'success'}
        else
            res {status: 'failure'}
        
    sendAlert: () ->
        ss.publish.all 'systemAlert', 'The server is about to be shut down'