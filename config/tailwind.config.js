const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    /* Reactの部分のみ適用するようにする */
    // './public/*.html',
    // './app/helpers/**/*.rb',
    './app/javascript/**/*.{js,tsx}',
    // './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
