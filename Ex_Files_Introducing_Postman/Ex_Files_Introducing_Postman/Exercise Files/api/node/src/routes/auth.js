const express = require("express");
const { PIPE } = require("../extensions/object/pipeline");
const { authenticate } = require("../lib/users");

const login =
    (req, res) => {
        try {
            req
                .body
                [PIPE](authenticate)
                [PIPE](t => res.json(t));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Authentication failed: ${ex.message}` });
        }
    }

const router =
    express
        .Router()
        .post("/", login);

module.exports = router;
