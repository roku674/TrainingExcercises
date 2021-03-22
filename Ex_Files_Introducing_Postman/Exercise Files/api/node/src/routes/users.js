const express = require("express");
const { PIPE } = require("../extensions/object/pipeline");
const { authorizationRequired } = require("../middleware/auth");
const routeShared = require("./shared");
const users = require("../lib/users");

const listUsers =
    (req, res) => {
        try {
            req
                [PIPE](routeShared.buildQueryOptions)
                [PIPE](users.listUsers)
                [PIPE](u => res.json(u));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to list users: ${ex.message}` });
        }
    };

const getUserDetails =
    (req, res) => {
        try {
            req
                .params
                .id
                [PIPE](users.getUserById)
                [PIPE](u => res.json(u));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to lookup user: ${ex.message}` });
        }
    }

const createUser =
    (req, res) => {
        try {
            req
                .body
                [PIPE](users.createUser)
                [PIPE](u => res.json(u));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to create user: ${ex.message}` });
        }
    };

const updateUser =
    (req, res) => {
        try {
            const id = req.params.id;

            req
                .body
                [PIPE](users.updateUser(id))
                [PIPE](u => res.json(u));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to update user: ${ex.message}` });
        }
    };

const deactivateUser =
    (req, res) => {
        try {
            req
                .params
                .id
                [PIPE](users.deactivateUser)
                [PIPE](u => res.json(u));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to deactivate user: ${ex.message}` });
        }
    };

const activateUser =
    (req, res) => {
        try {
            req
                .params
                .id
                [PIPE](users.activateUser)
                [PIPE](u => res.json(u));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to activate user: ${ex.message}` });
        }
    };

module.exports =
    express
        .Router()
        .use(authorizationRequired)
        .get("/", listUsers)
        .get("/:id", getUserDetails)
        .post("/", createUser)
        .put("/:id", updateUser)
        .delete("/:id", deactivateUser)
        .post("/:id", activateUser);
