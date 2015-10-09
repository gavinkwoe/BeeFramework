## How to use

1. Set the `__BEE_LIVELOAD__` macro to `__ON__` in the `Bee_Precompile.h`
2. Add `SUPPORT_RESOURCE_LOADING( YES );` in your implementation(.m) file.
3. the xml file must has **the same name** with its corresponding class name, and **the same path** with its class too.

## Important

This service is Simulator-Support-Only !!!

You should set the `__BEE_LIVELOAD__` to `__OFF__` or remove the references of it.
