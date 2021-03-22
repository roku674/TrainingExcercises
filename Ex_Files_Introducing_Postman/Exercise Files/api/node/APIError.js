class APIError extends Error {
    constructor(msg, code) {
        super(msg);
        this.code = code || 500;
    }
};

module.exports = APIError;
