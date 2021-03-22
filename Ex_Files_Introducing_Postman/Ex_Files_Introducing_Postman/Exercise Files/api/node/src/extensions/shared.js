const attachSymbol =
    target =>
        fn => {
            const sym = Symbol();

            Reflect.defineProperty(
                target,
                sym,
                {
                    enumerable: false,
                    writable: false,
                    configurable: false,
                    value: fn
                }
            );

            return sym;
        };

module.exports = {
    attachSymbol
};
