const { config, environment } = require('@rails/webpacker');
const webpack = require('webpack')

// WebpackerPwa
const WebpackerPwa = require('webpacker-pwa');
new WebpackerPwa(config, environment);

// jQuery
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

module.exports = environment