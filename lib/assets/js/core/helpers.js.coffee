@getMousePos = ( event ) ->
  if TOUCH_SUPPORT
    touch = event.originalEvent.touches[0] || event.originalEvent.changedTouches[0]
    cur_x = touch.pageX
    cur_y = touch.pageY
  else
    cur_x = event.clientX
    cur_y = event.clientY
  return { x: cur_x, y: cur_y }

@distanceFrom = ( x, y, x0, y0 ) ->
  Math.sqrt((x -= x0) * x + (y -= y0) * y)

@detectLanguage = ->
  language = window.navigator.userLanguage || window.navigator.language
  language = language.toLowerCase().replace('-','').replace('_','')
