--ws2812.init()
--ws2812.write(string.char(12, 0, 0, 0, 12, 0, 0, 0, 12))


function updatebuffer()

    for j = 1, buffer:size() do
        g, r, b = buffer:get(j)
        buffer:set(j, g*0.999, r*0.999, b*0.999)
    end

  if((buffer:power() * 20 / 255) < 500) then
    i = i + 1
    --if  ((i%buffer:size()) == 0) then
        --gg, rr, bb = node.random(64), node.random(64), node.random(64)
    --end
     gg, rr, bb = 24, 64, 0 
     if (node.random(128)) == 1 then gg, rr, bb = 128, 0, 0 end
     if (node.random(128)) == 1 then gg, rr, bb = 0, 0, 128 end
     if (node.random(128)) == 1 then gg, rr, bb = 128, 128, 128 end
    --if (node.random(8)) == 1 then buffer:set(node.random(60), node.random(128), node.random(128), node.random(128)) end
    if (node.random(6)) == 1 then
        buffer:set(node.random(60), gg, rr, bb)
        
    end
    --if (node.random(1)) == 1 then buffer:set(node.random(60), 255, 255, 255) end
    --if (node.random(1)) == 1 then buffer:set(i % buffer:size() + 1, node.random(64), node.random(64), node.random(64)) end
    --buffer:set(i % buffer:size() + 1, gg, rr, bb)
    --if (node.random(1)) == 1 then buffer:set(i % buffer:size() + 1, 255, 255, 255) end
  end
  ws2812.write(buffer)
end


function tick()
    i = i + 1
    --if (i % 512) == 0 then fg, fr, fb = fr, fb, fg end
    
    if semaphore > 0 then
        semaphore = 0
        for k = 1, LEDMAX do
        --for k = 1, 3 do
            
            g1, r1, b1 = buf1:get(k)
            g2, r2, b2 = buf2:get(k)
            step, steps, ttl = buf3:get(k)
            g = ((g2 - g1) * step / steps) + g1
            r = ((r2 - r1) * step / steps) + r1
            b = ((b2 - b1) * step / steps) + b1
            step = step + 1
            if step > steps then
                step = 0
                steps = node.random(40, 48)
                ttl = ttl - 1
                buf1:set(k, g2, r2, b2)
                buf2:set(k, fg * node.random(128), fr * node.random(128), fb * node.random(128))
                --buf2:set(k, 0, node.random(128), node.random(32))
                if ttl < 1 then 
                    buf2:set(k, 0, 0, 0)
                    ttl = 1
                    if node.random(16) == 1 then
                        ttl = node.random(2, 4)
                    end
                end
                
            end
            buf3:set(k, step, steps, ttl)
            buffer:set(k, g, r, b)
        end
        ws2812.write(buffer)
        semaphore = 1
    end
end

function init()
    LEDMAX = 60
    ws2812.init()
    buffer = ws2812.newBuffer(LEDMAX, 3)
    buf1 = ws2812.newBuffer(LEDMAX, 3)
    buf2 = ws2812.newBuffer(LEDMAX, 3)
    buf3 = ws2812.newBuffer(LEDMAX, 3)
    buf1:fill(0, 0, 0)
    buf2:fill(64, 64, 64)
    buf3:fill(0, 96, 1)
    i = 0
    buffer:fill(0, 0, 0); 
    gg, rr, bb = 0, 0, 0
    --fg, fr, fb = 0.2, 1, 0.2
    fg, fr, fb = 1, 1, 1
    semaphore = 1
    
end

function main()
    if timer1 then timer1:unregister() end

    init()
    
    timer1 = tmr.create()
    --timer1:alarm(40, 1, updatebuffer )
    timer1:alarm(40, 1, tick)
end



main()
