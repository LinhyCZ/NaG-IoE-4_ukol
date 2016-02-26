gpio0 = 3
gpio2 = 4
require('ds18b20')
ds18b20.setup(gpio2)
print("Temp: " .. ds18b20.read() .. "C")
gpio.mode(gpio0, gpio.OUTPUT)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<h1>NaG-IoE4</h1><h3>Weeee Woooo</h3>";
        buf = buf.."<p>GPIO0 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
        buf = buf.."<p>Teplota je: " .. ds18b20.read() .. "C</p>";
        local _on,_off = "",""
        if(_GET.pin == "ON1")then
              gpio.write(gpio0, gpio.LOW);
        elseif(_GET.pin == "OFF1")then
              gpio.write(gpio0, gpio.HIGH);
        end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)