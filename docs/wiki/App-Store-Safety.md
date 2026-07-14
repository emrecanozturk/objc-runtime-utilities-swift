# App Store Safety

The package uses public runtime and Foundation APIs.

Safe use still depends on your app:

- do not use private selectors
- do not use private classes
- do not rely on undocumented framework internals
- keep swizzling narrow and tested

Runtime inspection can reveal private class names that are loaded in your process. Seeing a class name does not mean it is safe to use.
