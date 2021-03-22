const _ = require("lodash");
const { attachSymbol } = require("../shared");

function ext_replace (predicate, newValue) {
    this.forEach((item, ix) => {
        if (predicate(item)) this[ix] = newValue;
    });

    return this;
}

function ext_toDictionary (selector) {
    return this.reduce(
        (agg, item) => {
            const key = selector(item);
            Reflect.set(agg, key, item);

            return agg;
        },
        {});
}

function ext_SortBy (props) {
    return _.sortBy(this, props);
}

const attachSymbolToArrayPrototype = attachSymbol(Array.prototype);

module.exports = {
    REPLACE: attachSymbolToArrayPrototype(ext_replace),
    SORT_BY: attachSymbolToArrayPrototype(ext_SortBy),
    TO_DICTIONARY: attachSymbolToArrayPrototype(ext_toDictionary)
};
