const jwt = require("jsonwebtoken");
const { PIPE } = require("../extensions/object/pipeline");
const APIError = require("../../APIError");

const headerTokenPattern = /^Bearer ([a-zA-Z0-9/+-\._~]*={0,2}$)/; // eslint-disable-line no-useless-escape

const tryGetTokenFromQueryString = source => (source.query || {}).access_token;
const tryGetTokenFromBody = source => (source.body || {}).access_token;
const tryGetTokenFromHeader = source => {
    const headerToken = (source.headers || {}).authorization;
    if (!headerToken) return undefined;

    const match = headerTokenPattern.exec(headerToken);

    if (!match) {
        throw new APIError("Authenticated request is missing authentication token or uses an unexpected token format.", 400);
    }

    return match[1];
};

function tryGetBearerToken (source) {
    console.log("Attempting to resolve bearer token");

    let tokens =
        [tryGetTokenFromQueryString, tryGetTokenFromBody, tryGetTokenFromHeader]
            .reduce(
                (acc, fn) => {
                    const token = fn(source);
                    if (token) acc.push(token);

                    return acc;
                },
                []
            );

    if (tokens.length === 0) {
        throw new APIError("Unable to resolve token for authenticated request", 400);
    } else if (tokens.length > 1) {
        // RFP 6750 states that only one access token mechanism can be used
        throw new APIError("Request must provide the access token only once.", 400);
    } else {
        return tokens.pop();
    }
}

const verifyJwt =
    tokenRequired =>
        (req, res, next) => {
            console.log("Validating bearer token");

            try {
                req.identity =
                    req
                        [PIPE](tryGetBearerToken)
                        [PIPE](token => jwt.verify(token, process.env.JWT_SECRET));

                next();
            } catch (ex) {
                if (tokenRequired) {
                    res.status(400).json({ message: ex.message });
                } else {
                    req.identity = undefined;
                    next();
                }
            }
        };

module.exports = {
    authorizationRequired: verifyJwt(true),
    authorizationOptional: verifyJwt(false)
};
