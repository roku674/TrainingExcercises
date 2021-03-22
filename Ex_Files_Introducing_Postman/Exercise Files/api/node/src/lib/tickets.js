const _ = require("lodash");
const uuid = require("uuid/v1");
const dataContext = require("../../dataContext");
const { PIPE } = require("../extensions/object/pipeline");
const { SORT_BY } = require("../extensions/array");
const libShared = require("./shared");
const libBoards = require("./boards");
const APIError = require("../../APIError");

const priorities = ["low", "medium", "high"];
const states = ["todo", "in-progress", "done"];

const insertTicketDocument =
    libShared.insertDocument(dataContext.collections.tickets);

const replaceTicketDocument =
    libShared.replaceDocument(dataContext.collections.tickets);

const listTicketsForBoard =
    options =>
        id => {
            // Get the board to ensure we have access to it
            const board =
                id
                [PIPE](libBoards.getBoardById(options.identity));

            return dataContext
                .collections
                .tickets
                .filter(t => t.boardId === board.id)
                .map(t => ({
                    id: t.id,
                    name: t.name,
                    status: t.status,
                    priority: t.priority
                }))
                [SORT_BY]("name")
                [PIPE](libShared.toPagedResult(options));
        };

const getTicketById =
    identity =>
        ticketId => {
            const ticket =
                dataContext
                    .collections
                    .tickets
                    .find(t => t.id.localeCompare(ticketId) === 0);

            if (!ticket) throw new APIError("Unable to locate the specified ticket", 404);

            // Get the board to ensure we have access to it
            const board =
                ticket
                    .boardId
                    [PIPE](libBoards.getBoardById(identity));

            return ticket;
        };

const normalizeTicketModel =
    (identity, ticketId) =>
        ({ original, modified }) => ({
            original,
            modified: {
                id: ticketId,
                ownerId: identity.id,
                // Prevent moving a ticket to another board
                boardId: original ? original.boardId : modified.boardId,
                name: modified.name,
                description: modified.description,
                status:
                    modified.status
                    || _.get(original, "status")
                    || states[0],
                priority:
                    modified.priority
                    || _.get(original, "priority")
                    || priorities[1],
                active:
                    modified.active
                    || _.get(original, "active")
                    || true
            }
        });

const validateTicketModel =
    model => {
        if (!model.modified.boardId || model.modified.boardId.trim() === "")
            throw new APIError("Board id is required", 400);

        if (!model.modified.name || model.modified.name.trim() === "")
            throw new APIError("Missing ticket name", 400);

        if (priorities.indexOf(model.modified.priority) === -1)
            throw new APIError(`Priority must be one of the following values: ${priorities.join(", ")}`, 400);

        if (states.indexOf(model.modified.status) === -1)
            throw new APIError(`Status must be one of the following values: ${states.join(", ")}`, 400);

        return model;
    };
    
const verifyUserCanCreateTicket =
    identity =>
        model => {
            const board =
                model
                    .modified
                    .boardId
                    [PIPE](libBoards.getBoardById(identity));

            if (board.ownerId !== identity.id) {
                throw new APIError("You cannot create a ticket on this board", 401);
            }

            return model;
        };

const verifyUserCanUpdateTicket =
    identity =>
        model => {
            if (model.original.ownerId !== identity.id) {
                throw new APIError("Only the ticket owner can make changes to a ticket", 401);
            }

            return model;
        };

const createTicket =
    identity =>
        model =>
            ({
                original: null,
                modified: model
            })
                [PIPE](normalizeTicketModel(identity, uuid()))
                [PIPE](validateTicketModel)
                [PIPE](verifyUserCanCreateTicket(identity))
                [PIPE](insertTicketDocument)
                [PIPE](d => d.modified);

const updateTicket =
    (identity, id) =>
        model =>
            id
                [PIPE](getTicketById(identity))
                [PIPE](t => ({
                    original: t,
                    modified: model
                }))
                [PIPE](normalizeTicketModel(identity, id))
                [PIPE](validateTicketModel)
                [PIPE](verifyUserCanUpdateTicket(identity))
                [PIPE](replaceTicketDocument)
                [PIPE](d => d.modified);

const deactivateTicket =
    identity =>
        id =>
            id
                [PIPE](getTicketById(identity))
                [PIPE](t => ({
                    original: t,
                    modified: libShared.setActiveFlagOff(t)
                }))
                [PIPE](verifyUserCanUpdateTicket(identity))
                [PIPE](replaceTicketDocument)
                [PIPE](d => d.modified);

const activateTicket =
    identity =>
        id =>
            id
                [PIPE](getTicketById(identity))
                [PIPE](b => ({
                    original: b,
                    modified: libShared.setActiveFlagOn(b)
                }))
                [PIPE](verifyUserCanUpdateTicket(identity))
                [PIPE](replaceTicketDocument)
                [PIPE](d => d.modified);

module.exports = {
    listTicketsForBoard,
    getTicketById,
    createTicket,
    updateTicket,
    deactivateTicket,
    activateTicket
};
