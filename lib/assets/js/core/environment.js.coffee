window.app = {}
@app = window.app
@app._routers = []
@app.routes = {}
@app.activeView = null
@app._features = {}
@app.ui = {}
@app.enable_debug = true
@app.domain = ''

@app.registerRouter = ( router ) ->
  this._routers.push router

# Backbone.old_sync = Backbone.sync
