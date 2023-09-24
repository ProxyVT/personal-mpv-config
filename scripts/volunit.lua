function print_dB(vol, f, ao)
   if vol <= 0 then
      vol = '-∞'
   else
      vol = f * math.log10(vol / 100)
      vol = string.format('%+.2f', math.floor(vol * 100 + 0.5) / 100)
   end
   mp.osd_message(string.format(ao:upper()..'Volume: %s dB%s', vol,
      mp.get_property_bool(ao..'mute') and ' (Muted)' or ''), 1)
end

function perform_dB(op, v, ao)
   local f, max
   if ao then
      ao = 'ao-'; f = 20; max = 100;
   else
      ao = ''   ; f = 60; max = mp.get_property_number('volume-max')
   end

   local vol = mp.get_property_number(ao..'volume')
   if op == 'add' then
      vol = vol * 10^(v / f)
   elseif op == 'set' then
      vol = (v == '-inf') and 0 or 10^(v / f + 2)
   elseif op == 'print' then
      return print_dB(vol, f, ao)
   end
   vol = math.min(vol, max)
   mp.commandv('osd-bar', 'set', ao..'volume', vol)
   print_dB(vol, f, ao)
end
mp.register_script_message('dB', perform_dB)
