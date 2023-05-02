const { config, environment } = require('@rails/webpacker');
const webpack = require('webpack');

// Preact
environment.config.merge({
  resolve: {
    alias: {
      react: 'preact/compat',
      'react-dom/test-utils': 'preact/test-utils',
      'react-dom': 'preact/compat', // Must be below test-utils
    },
  },
})

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

module.exports = environment;