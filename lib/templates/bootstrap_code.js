app.bootstraping = false;
app.bootstraped = false;

function _getJSON(url,callback) {   
  var xobj = new XMLHttpRequest();
  xobj.overrideMimeType("application/json");
  xobj.open('GET', url, true);
  xobj.onreadystatechange = function () { if (xobj.readyState == 4 && xobj.status == "200") { callback(JSON.parse(xobj.responseText)); } };
  xobj.send(null);  
}

function _loadJS(src,onload)
{
  var js = document.createElement('script');
  js.type = 'text/javascript';
  js.src = '/app.assets/' + src;
  js.onload = onload;
  document.head.appendChild(js);
}

function _loadCSS(src)
{
  var css = document.createElement('link');
  css.rel = 'stylesheet';
  css.type = 'text/css';
  css.href = '/app.assets/' + src;
  document.head.appendChild(css);
}

function bootstrapApplication()
{
  if (app.bootstraping) return;
  if (app.bootstraped) return;

  app.bootstraping = true;

  if (app.enable_debug) console.log("DEBUG: Bootstrap Application. Manifest (" + app.assets_manifest + ")");
  _getJSON( app.assets_manifest, function(data) {
    _loadCSS( data.assets['app.vendor.css'] );
    _loadCSS( data.assets['app.css'] );
    _loadJS( data.assets['app.vendor.js'], function() {
      _loadJS( data.assets['app.js'], function() {
        app.boot();
        app.bootstraping = false;
        app.bootstraped = true;
        var el = document.getElementById('application_preload_layer');
        el.parentNode.removeChild(el);
      });
    });
  });
}

function updateApplicationDownloadProgress(progress)
{
  if (app.enable_debug) console.log("DEBUG: Detected new asset");
}

function refreshApplicationFiles()
{
  app.applicationCache.swapCache();
  if (app.bootstraped == false) {
    bootstrapApplication();
  }
  else {
    window.app.confirm('A new version of this application is available. Load it?', function() {
      window.location.reload();
    });
  }
}

appcache_frame = document.createElement('iframe');
appcache_frame.src = '/save_app';
appcache_frame.onload = function() {
  app.applicationCache = appcache_frame.contentWindow.applicationCache;

  app.applicationCache.addEventListener('noupdate', bootstrapApplication, false);
  app.applicationCache.addEventListener('cached', bootstrapApplication, false);
  app.applicationCache.addEventListener('updateready', refreshApplicationFiles, false);
  app.applicationCache.addEventListener('progress', function(e) { updateApplicationDownloadProgress(e); }, false);

  setInterval(function() {
    if (app.enable_debug) console.log("DEBUG: Checking for new assets");
    app.applicationCache.update();
    bootstrapApplication();
  }, 10*60*1000);
}
document.head.appendChild( appcache_frame );
