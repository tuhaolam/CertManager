var CertificatesImport = function() {
  'use strict';
  var button = document.getElementById('import-button');
  var box = document.getElementById('import-url');
  var result = document.getElementById('cert-body');
  var append_certs = function(keys) {
    var array = [];
    // ?!
    keys.forEach(function(f) {
      f.to_pem().done(function(g) {
        array.push(g);
      });
    });
    result.value = array.join('\r\n');
  };
  var import_click = function(evt) {
    evt.preventDefault();
    var url = box.value;
    if (url !== '') {
      Certificate.from_url(url).then(append_certs);
    }
    return false;
  };

  button.addEventListener('click', import_click);
};