require"good_lua"
math_randomseed(os.date("%H")+os.date("%M")*os.date("%S"))
love_graphics.setDefaultFilter("nearest","nearest",0)
love_graphics.setLineStyle("rough")

local screen_x=0
local screen_y=0
local screen_scale=1
local screen_shake=0
local screen_canvas=love_graphics.newCanvas()
local screen_width=screen_canvas:getWidth()
local screen_height=screen_canvas:getHeight()

-- load :]



-- cool variables

local DEBUG_YOOOOOOOOOOOOOOOOOOOOOOOOOOO=true
local time=5000
local score=0

local mouse_x,mouse_y=love_mouse.getPosition()
local mouse_prev_x,mouse_prev_y=mouse_x,mouse_y
local mouse_prev_prev_x,mouse_prev_prev_y=mouse_prev_x,mouse_prev_y
local mouse_dir=0
local mouse_SPEEEEEEEED=0
local mouse_prev_SPEEEEEEEED=mouse_SPEEEEEEEED

local ray_offset=0
local ray_length=6
local ray_timer=-10
local ray_fuck_x=0
local ray_fuck_y=0
local ray_fuck_dir=0

local coin_x=math_random(5,195)
local coin_y=math_random(5,195)
local coin_hit=false

-- functions

local xyrad=function(x,y,x2,y2)
  x,y=x2-x,y2-y
  return math_atan2(y,x)
end

local radxy=function(rad,len)
  return math_cos(rad)*len,math_sin(rad)*len
end

-- your mother

function LOAD(arg)
  for i,cmd in ipairs(arg) do
    if cmd=="-debug" then DEBUG_YOOOOOOOOOOOOOOOOOOOOOOOOOOO=true end
  end
  love_graphics.setBackgroundColor(.3,.4,.4)
end



function UPDATE(dt)
  local dt60=dt*60
  
  ray_timer=ray_timer-1*dt60
  ray_offset=ray_offset+.3*dt60
  ray_offset=math_fmod(ray_offset,ray_length*2+1)
  time=time-1*dt60
  
  if ray_timer<0 then ray_timer=0 end
  
  mouse_prev_prev_x,mouse_prev_prev_y=mouse_prev_x,mouse_prev_y
  mouse_prev_x,mouse_prev_y=mouse_x,mouse_y
  mouse_x=love_mouse.getX()/screen_scale+screen_x-(love_graphics.getWidth()/screen_scale/2-screen_width/2)
  mouse_y=love_mouse.getY()/screen_scale+screen_y-(love_graphics.getHeight()/screen_scale/2-screen_height/2)
  mouse_prev_SPEEEEEEEED=mouse_SPEEEEEEEED
  mouse_SPEEEEEEEED=math_dist(mouse_prev_x,mouse_prev_y,mouse_x,mouse_y)
  local mouse_prev_dir=mouse_dir
  -- mouse_dir=math_lerp(mouse_dir,xyrad(mouse_prev_x,mouse_prev_y,mouse_x,mouse_y),.2)
  if mouse_prev_x~=mouse_x or mouse_prev_y~=mouse_y then
    if math_dist(mouse_prev_x,mouse_prev_y,mouse_x,mouse_y)>2 then
      mouse_dir=xyrad(mouse_prev_x,mouse_prev_y,mouse_x,mouse_y)
    else
      mouse_dir=xyrad(mouse_prev_prev_x,mouse_prev_prev_y,mouse_x,mouse_y)
    end
  end
  -- mouse_dir=math_rad_lerp(mouse_prev_dir,mouse_dir,.5)
  -- if mouse_dir==0 and mouse_prev_dir~=0 then mouse_dir=mouse_pre  v_dir end
  -- if love_mouse.isDown(1) then print(mouse_SPEEEEEEEED) end
  
  if mouse_SPEEEEEEEED-mouse_prev_SPEEEEEEEED>4 then
    ray_timer=10
    ray_fuck_x=mouse_x
    ray_fuck_y=mouse_y
    ray_fuck_dir=mouse_dir
  end
  
end



function DRAW(dt)
  if time>0 then
  -- shiny
  
  love_graphics.setLineWidth(2)
  love_graphics.setColor(1,.8,0.0,1)
  love_graphics.circle("fill",coin_x,coin_y,5)
  love_graphics.setColor(.8,.6,0.0,1)
  love_graphics.circle("line",coin_x,coin_y,5)
  
  -- ray
  local ray_thing=3+ray_offset
  local ray_start_x,ray_start_y=radxy(mouse_dir,ray_thing)
  local ray_end_x,ray_end_y=radxy(mouse_dir,ray_thing+ray_length)
  
  love_graphics.setColor(1.0,0.2,0.1,.7)
  love_graphics.setLineWidth(2)
  coin_hit=false
  for i=1,50 do
    love_graphics.line(ray_start_x+mouse_x,ray_start_y+mouse_y,ray_end_x+mouse_x,ray_end_y+mouse_y)
    ray_thing=ray_thing+ray_length*2
    ray_start_x,ray_start_y=radxy(mouse_dir,ray_thing)
    ray_end_x,ray_end_y=radxy(mouse_dir,ray_thing+ray_length)
  end
  
  for i=1,500 do
    local ex,wy=radxy(ray_fuck_dir,i)
    if math_abs(math_dist(ex+mouse_x,wy+mouse_y,coin_x,coin_y))<10 then coin_hit=true break end
  end
  
  love_graphics.setColor(1.0,0.1,0.0,1)
  love_graphics.setLineWidth(ray_timer)
  love_graphics.line(ray_fuck_x,ray_fuck_y,radxy(ray_fuck_dir,500))
  if coin_hit then coin_x=math_random(5,195) coin_y=math_random(5,195) score=score+1 end
  
  -- ui
  love_graphics.setColor(1,1,1,1)
  love_graphics.print("time: "..math_floor(time))
  love_graphics.print("score: "..score,0,20)
  end
  
  -- mouse
  local mouse2_x,mouse2_y=radxy(xyrad(mouse_x,mouse_y,mouse_prev_x,mouse_prev_y),math_dist(mouse_x,mouse_y,mouse_prev_x,mouse_prev_y)*1.5)
  mouse2_x,mouse2_y=mouse_x+mouse2_x,mouse_y+mouse2_y
  
  love_graphics.setColor(0,0,0,1)
  love_graphics.setLineWidth(16)
  love_graphics.circle("fill",mouse2_x,mouse2_y,8)
  love_graphics.line(mouse2_x,mouse2_y,mouse_x,mouse_y)
  love_graphics.circle("fill",mouse_x,mouse_y,8)
  
  love_graphics.setColor(1,1,1,1)
  love_graphics.setLineWidth(12)
  love_graphics.circle("fill",mouse2_x,mouse2_y,6)
  love_graphics.line(mouse2_x,mouse2_y,mouse_x,mouse_y)
  love_graphics.circle("fill",mouse_x,mouse_y,6)
  
  if time<0 then love_graphics.print(score.."!!!!!") end
end

-- is a cool woman :]

function love.keypressed(key,scancode,isrepeat)
end

function love.resize(w,h)
  if love_graphics.getWidth()/(screen_width*screen_scale)<love_graphics.getHeight()/(screen_height*screen_scale) then
    screen_scale=love_graphics.getWidth()/(screen_width)
  else
    screen_scale=love_graphics.getHeight()/(screen_height)
  end
end

function love.run()
  LOAD(love.arg.parseGameArguments(arg),arg)
  
  -- We don't want the first frame's dt to include time taken by LOAD.
  if love.timer then love.timer.step() end
  
  local dt=0
  
  -- Main loop time.
  return function()
    -- Process events.
    if love.event then
      love.event.pump()
      for name,a,b,c,d,e,f in love.event.poll() do
        if name=="quit" then
          if not love.quit or not love.quit() then
            return a or 0
          end
        end
        love.handlers[name](a,b,c,d,e,f)
      end
    end
    
    -- Update dt, as we'll be passing it to update
    if love.timer then dt=love.timer.step() end
    
    -- Call update and draw
    UPDATE(dt) -- will pass 0 if love.timer is disabled
    
    if love_graphics and love_graphics.isActive() then
      love_graphics.clear(0,0,0)
      
      love_graphics.setCanvas(screen_canvas)
      love_graphics.clear(love_graphics.getBackgroundColor())
      
      love_graphics.push()
      love_graphics.origin()
      local shake=math_floor(math_random(-screen_shake,screen_shake))
      love_graphics.translate(-screen_x+shake,-screen_y+shake)
      
      DRAW(dt)
      love_graphics.setColor(1.0,1,1,1)
      
      love_graphics.pop()
      love_graphics.push()
      love_graphics.origin()
      love_graphics.scale(screen_scale,screen_scale)
      
      love_graphics.setCanvas()
      love_graphics.draw(screen_canvas,love_graphics.getWidth()/screen_scale/2-screen_width/2,love_graphics.getHeight()/screen_scale/2-screen_height/2)
      
      love_graphics.pop()
      
      love_graphics.present()
    end
    
    if love.timer then love.timer.sleep(0.001) end
  end
end
