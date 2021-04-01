// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import Mirador from 'mirador/dist/es/src/index.js';

require('../direct_uploads');

Rails.start()
Turbolinks.start()
ActiveStorage.start()

$(document).on('ready turbolinks:load', function(event) {
  if ($('#mirador').length > 0) {
    Mirador.viewer({
      id: 'mirador'
    });
  }
});
// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);
