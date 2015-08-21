var CertificatesImport = function() {
  'use strict';
  var button = document.getElementById('import-button');
  var box = document.getElementById('import-url');
  var result = document.getElementById('cert-body');
  var append_certs = function(keys) {
    result.value = keys.map(function(f) { return f.to_pem; }).join('\r\n');
  };
  var import_click = function(evt) {
    evt.preventDefault();
    var url = box.value;
    if (url !== '') {
      PublicKey.from_url(url).then(append_certs);
    }
    return false;
  };

  React.constructAndRenderComponentByID(CertImportBox, {}, 'import-box-attach');

  button.addEventListener('click', import_click);
};