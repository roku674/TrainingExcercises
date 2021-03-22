const express = require("express");
const { PIPE } = require("../extensions/object/pipeline");
const { authorizationRequired, authorizationOptional } = require("../middleware/auth");
const shared = require("./shared");
const boards = require("../lib/boards");
const tickets = require("../lib/tickets");

const listBoards =
    (req, res) => {
        try {
            req
                [PIPE](shared.buildQueryOptions)
                [PIPE](boards.listBoards)
                [PIPE](l => res.json(l))
        } catch (ex) {
            res.status(ex.code || 500).json({ message: ex.message });
        }
    };

const searchBoards =
    (req, res) => {
        try {
            req
                .body
                [PIPE](boards.searchBoards(req.identity))
                [PIPE](l => res.json(l))
        } catch (ex) {
            res.status(ex.code || 500).json({ message: ex.message });
        }
    };

const getBoardDetails =
    (req, res) => {
        try {
            req.params.id
                [PIPE](boards.getBoardById(req.identity))
                [PIPE](b => res.json(b));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: ex.message });
        }
    };

const createBoard =
    (req, res) => {
        try {
            req
                .body
                [PIPE](boards.createBoard(req.identity))
                [PIPE](b => res.json(b));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to create board: ${ex.message}`});
        }
    };

const updateBoard =
    (req, res) => {
        try {
            const id = req.params.id;

            req
                .body
                [PIPE](boards.updateBoard(req.identity, id))
                [PIPE](b => res.json(b));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to update board: ${ex.message}`});
        }
    };

const deactivateBoard =
    (req, res) => {
        try {
            req
                .params
                .id
                [PIPE](boards.deactivateBoard(req.identity))
                [PIPE](u => res.json(u));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to deactivate board: ${ex.message}` });
        }
    };

const activateBoard =
    (req, res) => {
        try {
            req
                .params
                .id
                [PIPE](boards.activateBoard(req.identity))
                [PIPE](u => res.json(u));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to activate board: ${ex.message}` });
        }
    };

const listTickets =
    (req, res) => {
        try {
            const options =
                req
                [PIPE](shared.buildQueryOptions);

            req
                .params
                .id
                [PIPE](tickets.listTicketsForBoard(options))
                [PIPE](l => res.json(l));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to list tickets for board: ${ex.message}`});
        }
    };

module.exports =
    express
        .Router()
        .get("/", [ authorizationOptional, listBoards ])
        .post("/search", [authorizationOptional, searchBoards ])
        .get("/:id", [authorizationOptional, getBoardDetails ])
        .post("/", [ authorizationRequired, createBoard ])
        .put("/:id", [ authorizationRequired, updateBoard ])
        .delete("/:id", [ authorizationRequired, deactivateBoard ])
        .post("/:id", [ authorizationRequired, activateBoard ])
        .get("/:id/tickets", [ authorizationOptional, listTickets ]);
