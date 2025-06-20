<a href="https://idx.google.com/new?template=https://github.com/fatim4h/idx-win">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://cdn.idx.dev/btn/open_light_32.svg">
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://cdn.idx.dev/btn/open_dark_32.svg">
    <img
      height="32"
      alt="Open in IDX"
      src="https://cdn.idx.dev/btn/open_purple_32.svg">
  </picture>
</a>

```
https://idx.google.com/new?template=https://github.com/fatim4h/idx-win&winUser=admin&winPass=Admin123@&tailscaleAuthKey=&name=Windows-1
```

## GitHub Pages - IDX Form

A modern, responsive form interface is available on the `gh-pages` branch under the `/site` folder. The form allows users to select their operating system and launch IDX in a new window.

### Features

- Modern, responsive UI built with Tailwind CSS
- Interactive OS selection cards for:
  - Windows
  - Windows ARM
  - Mac
- Automatic new window opening for form submissions
- Smooth animations and transitions
- Mobile-friendly design

### Local Development

To view the form locally:
1. Checkout the `gh-pages` branch
2. Navigate to the `/site` directory
3. Open `index.html` in your browser

### Implementation Details

- Built with HTML5, Tailwind CSS, and vanilla JavaScript
- Uses Inter font from Google Fonts for modern typography
- Implements error handling for form submissions
- Responsive design that works on all device sizes
- OS selection automatically updates the target URL

