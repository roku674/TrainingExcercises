const _ = require("lodash");
const { PIPE } = require("../extensions/object/pipeline");
const { SORT_BY } = require("../extensions/array");
const libShared = require("./shared");

const and = (l, r) => x => l(x) && r(x);

const convertFiltersToFunctions =
    filters =>
        (filters || [])
            .map(fi =>
                _.isString(fi.value) && (!Reflect.has(fi, "exact") || !Reflect.get(fi, "exact"))
                    ? b => RegExp(fi.value).test(b[fi.field])
                    : b => b[fi.field] === fi.value);

const normalizeSearchInfo =
    original =>
        ({
            pageSize: original.pageSize || 10,
            pageNumber: original.pageNumber || 0,
            filters: convertFiltersToFunctions(original.filters),
            sort: original.sort || ""
        });

const doSearch =
    collection =>
        searchInfo => {
            const filter =
                searchInfo.filters && searchInfo.filters.length > 0
                    ? searchInfo
                        .filters
                        .reduce(and)
                    : x => true;

            return collection
                .filter(filter)
                [SORT_BY](searchInfo.sort)
                [PIPE](libShared.toPagedResult(searchInfo));
        };

module.exports = {
    normalizeSearchInfo,
    doSearch
}
