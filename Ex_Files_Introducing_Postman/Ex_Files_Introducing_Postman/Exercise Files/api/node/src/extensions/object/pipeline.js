const { attachSymbol } = require("../shared");

function ext_Pipe (fn) {
    const self =
        Reflect.has(this, "valueOf")
            ? this.valueOf()
            : this;

    return fn(self);
}

const attachSymbolToObjectPrototype = attachSymbol(Object.prototype);

module.exports = {
    PIPE: attachSymbolToObjectPrototype(ext_Pipe)
};
