# Development

To start this website locally you will need to have Hugo installed. If you don’t already have Hugo installed please follow the official [installation guide](https://gohugo.io/getting-started/installing/).

### Check Hugo version (Hugo 0.51+ Extended is required) 

The site  uses [Hugo Pipes](https://gohugo.io/hugo-pipes/) to compile SCSS and minify assets. Please make sure you have the **Hugo Extended** version installed. If you are not using the extended version this theme will not not compile.

To check your version of Hugo, run:

```
hugo version
```

This will output the currently installed version of Hugo. Make sure you see `/extended` after the version number, for example `Hugo Static Site Generator v0.51/extended darwin/amd64 BuildDate: unknown` You do not need to use version v0.51 specifically, you can use any version of Hugo above 0.51. It just needs to have the `/extended` part

### Run Hugo

For local development run Hugo’s built-in local server which will watch changes made and update the content in browser:

```
hugo server
```

Now enter [`localhost:1313`](http://localhost:1313/)ess bar of your browser.
