const buildQueryOptions =
    req => ({
        pageNumber: req.query.pn ? parseInt(req.query.pn, 10) : 0,
        pageSize: req.query.ps ? parseInt(req.query.ps, 10) : 10,
        identity: req.identity
    });

module.exports = {
    buildQueryOptions
};
