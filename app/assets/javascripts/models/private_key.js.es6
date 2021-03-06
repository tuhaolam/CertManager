class PrivateKey extends CertificatePart {
  constructor(opts) {
    super({opts: opts, show_url: Routes.private_key_path});
  }
  static _from_expanded(blob) {
    return new PrivateKey(blob);
  }

  static analyze(input) {
    return Ajax.post(Routes.analyze_private_key_path(), {
      acceptType: 'application/json',
      contentType: 'application/x-pem',
      data: input
    }).then(this._from_expanded);
  }
}