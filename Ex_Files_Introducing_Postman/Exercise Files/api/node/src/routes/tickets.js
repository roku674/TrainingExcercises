const express = require("express");
const { PIPE } = require("../extensions/object/pipeline");
const { authorizationRequired, authorizationOptional } = require("../middleware/auth");
const tickets = require("../lib/tickets");

const getTicket =
    (req, res) => {
        try {
            req.params.id
                [PIPE](tickets.getTicketById(req.identity))
                [PIPE](t => res.json(t));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to get ticket: ${ex.message}` });
        }
    };

const createTicket =
    (req, res) => {
        try {
            req
                .body
                [PIPE](tickets.createTicket(req.identity))
                [PIPE](b => res.json(b));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to create ticket: ${ex.message}`});
        }
    };

const updateTicket =
    (req, res) => {
        try {
            const id = req.params.id;

            req
                .body
                [PIPE](tickets.updateTicket(req.identity, id))
                [PIPE](t => res.json(t));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to update ticket: ${ex.message}` });
        }
    };

const deactivateTicket =
    (req, res) => {
        try {
            req
                .params
                .id
                [PIPE](tickets.deactivateTicket(req.identity))
                [PIPE](u => res.json(u));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to deactivate ticket: ${ex.message}` });
        }
    };

const activateTicket =
    (req, res) => {
        try {
            req
                .params
                .id
                [PIPE](tickets.activateTicket(req.identity))
                [PIPE](u => res.json(u));
        } catch (ex) {
            res.status(ex.code || 500).json({ message: `Unable to activate ticket: ${ex.message}` });
        }
    };

module.exports =
    express
        .Router()
        .get("/:id", [ authorizationOptional, getTicket ])
        .post("/", [ authorizationRequired, createTicket ])
        .put("/:id", [ authorizationRequired, updateTicket ])
        .delete("/:id", [ authorizationRequired, deactivateTicket ])
        .post("/:id", [ authorizationRequired, activateTicket ]);
