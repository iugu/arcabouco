app.debug "Starting WebApp Framework"

app.module_load = (name) ->
  app._bootstrap_list[name] = false

app.module_ready = (name) ->
  app._bootstrap_list[name] = true

app.load_modules = ->
  for module,status of app._bootstrap_list
    return if status == false

  app.debug 'Loaded modules: '
  for name of app._bootstrap_list
    app.debug ' - ' + name

  clearInterval app._bootstrap_list_loader
  delete app._bootstrap_list
  delete app._bootstrap_list_loader

  if app.main
    app.main()

app.boot = ->
  app.debug "Booting started..."
  app.debug 'Detected capabilities: ' + document.documentElement.className + ' ' + navigator.oscpu + ' ' + navigator.platform + navigator.userAgent
  app.debug 'Detected language: ' + detectLanguage()

  if app.document_domain
    document.domain = app.document_domain

  app._bootstrap_list_loader = setInterval( app.load_modules, 250 )
  app.load_modules()
