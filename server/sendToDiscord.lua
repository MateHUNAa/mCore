ESX = exports["es_extended"]:getSharedObject()

function sendMessage(webhook, name, message)
    if not webhook then
        print('[ERROR]: No webhook provided Invoke: ' .. GetInvokingResource())
        return
    end

    if not message then
        invoke = GetInvokingResource()
        print('[ERROR]: No message provided Invoker: ' .. invoke)
        return
    end

    if not name then
        invoke = GetInvokingResource()
        print('[ERROR]: No name provided Invoke: ' .. invoke)
        return
    end


    PerformHttpRequest(webhook, function(Error, Content, Head)
    end, 'POST', json.encode({ username = name, content = message }), { ['Content-Type'] = 'application/json' })
end

exports("sendMessage", sendMessage)

function sendEmbed(Webhook, name, embed)
    if not Webhook then
        print('[ERROR]: Sending embed no Webhook provided or Invalid webhook invoker: ' .. GetInvokingResource())
        return
    end

    if not name then
        print('[ERROR]: No name or embed provided Invoke : ' .. GetInvokingResource())
        return
    end

    if not embed then
        print('[ERROR]: No embed provided Invoke : ' .. GetInvokingResource())
        return
    end


    PerformHttpRequest(Webhook,
        function(err, text, headers) end, 'POST',
        json.encode({ username = name, embeds = embed }), { ['Content-Type'] = 'application/json' })
end

exports("sendEmbed", sendEmbed)

RegisterNetEvent('mateExports:hidden:log', function(msg, code)
    if code ~= 'ASD1' then
        return log('[MateHUN]: Invalid log call ! Invoke: ' .. GetInvokingResource())
    end
    print(msg)
end)

function log(msg)
    if not msg then
        invoke = GetInvokingResource()
        print('[ERROR]: No log message provided Invoker: ' .. invoke)

        return
    end
    print(msg)
end

exports("log", log)
