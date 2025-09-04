/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './layouts/**/*.html',
    './assets/**/*.{js,css}',
    '../../content/**/*.{html,md}',
    '../../layouts/**/*.html',
  ],
  theme: {
    extend: {
      colors: {
        'cooklang-orange': '#E15A29',
        'cooklang-blue': '#00AAFF',
        'cooklang-dark': '#212529',
        'cooklang-gray': {
          50: '#f8f9fa',
          100: '#e9ecef',
          200: '#dee2e6',
          300: '#ced4da',
          400: '#adb5bd',
          500: '#6c757d',
          600: '#495057',
          700: '#343a40',
          800: '#212529',
          900: '#161718',
        },
      },
      fontFamily: {
        'sans': ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
        'serif': ['Lora', 'Georgia', 'serif'],
        'mono': ['JetBrains Mono', 'Monaco', 'monospace'],
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            color: theme('colors.cooklang-gray.700'),
            a: {
              color: theme('colors.cooklang-orange'),
              '&:hover': {
                color: theme('colors.cooklang-blue'),
              },
            },
            h1: {
              color: theme('colors.cooklang-gray.900'),
            },
            h2: {
              color: theme('colors.cooklang-gray.800'),
            },
            h3: {
              color: theme('colors.cooklang-gray.800'),
            },
            h4: {
              color: theme('colors.cooklang-gray.700'),
            },
            code: {
              color: theme('colors.cooklang-orange'),
              backgroundColor: theme('colors.orange.50'),
              padding: '0.25rem 0.375rem',
              borderRadius: '0.25rem',
              fontWeight: '400',
            },
            'code::before': {
              content: '""',
            },
            'code::after': {
              content: '""',
            },
            pre: {
              backgroundColor: theme('colors.cooklang-gray.900'),
              color: theme('colors.cooklang-gray.100'),
            },
          },
        },
      }),
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}