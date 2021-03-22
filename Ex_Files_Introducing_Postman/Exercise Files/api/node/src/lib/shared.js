const { REPLACE } = require("../extensions/array");

const toPagedResult =
    options => {
        const startIndex = options.pageNumber * options.pageSize;
        const endIndex = startIndex + options.pageSize;

        return data => ({
            pageNumber: options.pageNumber,
            pageSize: options.pageSize,
            totalItems: data.length,
            totalPages: Math.ceil(data.length / options.pageSize),
            data: data.slice(startIndex, endIndex)
        });
    };

const insertDocument =
    collection =>
        model => {
            collection.push(model.modified);

            return model;
        };

const idSelector =
    id =>
        d => d.id.localeCompare(id) === 0;

const replaceDocument =
    (collection, selector) =>
        model => {
            collection
                [REPLACE](
                    selector || idSelector(model.modified.id),
                    model.modified);

            return model;
        };

const setActiveFlag =
    value =>
        model => ({
            ...model,
            active: value
        });

module.exports = {
    toPagedResult,
    insertDocument,
    replaceDocument,
    setActiveFlagOn: setActiveFlag(true),
    setActiveFlagOff: setActiveFlag(false)
};
