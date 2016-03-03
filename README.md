# `<f-di>` [![Build Status](https://travis-ci.org/firmfirm/f-di.svg?branch=master)](https://travis-ci.org/firmfirm/f-di) [![Run tests](http://icons.iconarchive.com/icons/custom-icon-design/flatastic-9/24/Unit-completed-icon.png)](http://firmfirm.github.io/f-di/components/f-di/test/)

Declarative dependency injection for Polymer elements.

For a live demo see [component page](https://firmfirm.github.io/f-di/).

### f-di-config

`<f-di-config>` is an element to put your bindings into. Fires `'f-di-config-ready'` event when all bindings finish their initialization.

### f-di-bind

`<f-di-bind>` is an element to specify a binding from specified key to element tag name.

If there are multiple bindings with the same key, only the lastly initialized one will work.
This means that you can change dependency injection dynamically for newly imported elements.
However, it will NOT change elements that are already registered.

To make dependency injection trully dynamic you may also use Polymer's binding expressions to `key` and/or `to` properties.
If used inside `<f-di-config>` it will wait until both properties are available before firing ready event.

### f-di

`<f-di>` is a placeholder element, that does nothing. It's not even registered as a custom element.

Use `<f-di key="DependencyKey">` where you want dependecy injection to happen.

**Preconditions**:
  - Parent element must use `FBehaviors.DI` behavior.
  - Dependency with specified key is configured with `<f-di-bind>` prior to registering parent element.
  This means that you will have to do lazy-loading, as calling Polymer({...}) invokes the registration.

It will copy over all attributes that you put on `<f-di>`. All Polymer's effects (e.g. bindings, events) should work as if you put them on injected element.

### FBehaviors.DI

`FBehaviors.DI` is a Polymer behavior to enable dependency injections.

## Example

`...` means that there should be some more code that's irrelevant to this example.

### elements.html
```html
<dom-module id="my-app">
  <template>
    <f-di f-di-key="AuthProvider" some-auth-property="{{someAppProperty}}"></f-di>
...
<script>
Polymer({
  is: 'my-app',
  behaviors: [FBehaviors.DI],
  ...
});

Polymer({
  is: 'my-auth-provider',
  ...
});
</script>
```
### index.html
```html
<link rel="import" href="bower_components/f-di/f-di-config.html">

<script>
  // Lazy load application elements when DI has finished setup.
  // Your elements will then be registered with template that has
  // all <f-di> elements upgraded to elements specified in <f-di-bind>
  document.addEventListener('f-di-config-ready', function() {
    var link = document.createElement('link');
    link.setAttribute('rel', 'import');
    link.setAttribute('href', 'elements.html');
    this.querySelector('head').appendChild(link);
    // If you're planning to do any more <f-di-config> later,
    // you should probably `removeEventListener`.
  });
</script>

<f-di-config>
  <f-di-bind key="AuthProvider" to="my-auth-provider"></f-di-bind>
  <f-di-bind ...></f-di-bind>
</f-di-config>

<my-app></my-app>
```
## Dependencies

Element dependencies are managed via [Bower](http://bower.io/). You can
install that via:

    npm install -g bower

Then, go ahead and download the element's dependencies:

    bower install


## Playing With Your Element

If you wish to work on your element in isolation, we recommend that you use
[Polyserve](https://github.com/PolymerLabs/polyserve) to keep your element's
bower dependencies in line. You can install it via:

    npm install -g polyserve

And you can run it via:

    polyserve

Once running, you can preview your element at
`http://localhost:8080/components/f-di/`, where `f-di` is the name of the directory containing it.


## Testing Your Element

Simply navigate to the `/test` directory of your element to run its tests. If
you are using Polyserve: `http://localhost:8080/components/f-di/test/`

### web-component-tester

The tests are compatible with [web-component-tester](https://github.com/Polymer/web-component-tester).
Install it via:

    npm install -g web-component-tester

Then, you can run your tests on _all_ of your local browsers via:

    wct

#### WCT Tips

`wct -l chrome` will only run tests in chrome.

`wct -p` will keep the browsers alive after test runs (refresh to re-run).

`wct test/some-file.html` will test only the files you specify.


## Yeoman support

If you'd like to use Yeoman to scaffold your element that's possible. The official [`generator-polymer`](https://github.com/yeoman/generator-polymer) generator has a [`seed`](https://github.com/yeoman/generator-polymer#seed) subgenerator.
