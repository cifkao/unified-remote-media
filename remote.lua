
local keyboard = libs.keyboard;
local script = libs.script;

local last_volume = 0;

function get_volume()
	result = script.shell('amixer -c 0 get Master');
	volume = tonumber(string.match(result, '(%d+)%%'));
	return volume;
end

function set_volume(value)
	os.script(string.format("amixer -c 0 sset Master %d%%", math.round(value)));
end

function mute()
	last_volume = get_volume();
	set_volume(0);
end

function unmute()
	set_volume(last_volume);
	last_volume = 0;
end


--@help Lower system volume
actions.volume_down = function()
	volume = get_volume();
	if volume > 0 then
		last_volume = volume;
		set_volume(math.max(0, last_volume - 10));
	end
end

--@help Mute system volume
actions.volume_mute = function()
	volume = get_volume();
	if volume <= 0 then
		unmute();
	else
		mute();
	end
end

--@help Raise system volume
actions.volume_up = function()
	volume = get_volume();
	if volume <= 0 then
		unmute();
	else
		last_volume = volume;
		set_volume(math.min(100, last_volume + 10));
	end
end

--@help Previous track
actions.previous = function()
	keyboard.press("mediaprevious");
end

--@help Next track
actions.next = function()
	keyboard.press("medianext");
end

--@help Stop playback
actions.stop = function()
	keyboard.press("mediastop");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.press("mediaplaypause");
end
