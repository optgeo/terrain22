require 'json'

while gets
  f = JSON.parse($_.strip)
  props = f['properties']
  sinks = props['a.Sinks']
  f['properties'] = {}
  f['properties']['terrain22'] = case props['b.GCLUSTER15']
    when 2
      1
    when 3
      2
    when 13
      3
    when 12
      4
    when 5
      5
    when 4
      6
    when 14
      7
    when 10
      8
    when 11
      sinks == 0.0 ? 9 : 10
    when 7
      sinks == 0.0 ? 11 : 12
    when 8
      sinks == 0.0 ? 13 : 14
    when 9
      sinks == 0.0 ? 15 : 16
    when 6
      sinks == 0.0 ? 17 : 18
    when 1
      sinks == 0.0 ? 19 : 20
    when 15
      sinks == 0.0 ? 21 : 22
    else
      nil
  end  
  print "#{JSON.dump(f)}\n"
end

