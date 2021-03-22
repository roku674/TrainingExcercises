const _ = require("lodash");
const uuid = require("uuid/v1");
const dataContext = require("../../dataContext");
const { PIPE } = require("../extensions/object/pipeline");
const { TO_DICTIONARY } = require("../extensions/array");
const libShared = require("./shared");
const search = require("./search");
const APIError = require("../../APIError");

const insertBoardDocument =
    libShared.insertDocument(dataContext.collections.boards);

const replaceBoardDocument =
    libShared.replaceDocument(dataContext.collections.boards);

const applyStandardFilter =
    identity =>
        searchInfo => {
            searchInfo.filters.unshift(
                identity
                    ? (b => b.public || b.ownerId === identity.id)
                    : (b => b.public))

            return searchInfo;
        };

const addOwnerNameToBoards =
    data => {
        const users =
            _.unionWith(
                dataContext.collections.users,
                data.data,
                (l, r) => l.ownerId === r.id)
                [TO_DICTIONARY](u => u.id);

        // Map the data to new objects to avoid attaching the owner name
        // to the original Board objects.
        data.data =
            data
                .data
                .map(b => ({
                    ...b,
                    ownerName: `${users[b.ownerId].firstname} ${users[b.ownerId].lastname}`
                }));

        return data;
    };

const createDefaultSearchInfo =
    ({ pageSize, pageNumber }) =>
        ({
            pageSize,
            pageNumber,
            filters: [
                { field: "active", value: true }
            ],
            sort: "name"
        });

const searchBoards =
    identity =>
        searchInfo =>
            searchInfo
                [PIPE](search.normalizeSearchInfo)
                [PIPE](applyStandardFilter(identity))
                [PIPE](search.doSearch(dataContext.collections.boards))
                [PIPE](addOwnerNameToBoards);

const listBoards =
    options =>
        options
            [PIPE](createDefaultSearchInfo)
            [PIPE](searchBoards(options.identity));

const applyBoardIdFilter =
    boardId =>
        searchInfo => {
            searchInfo.filters.unshift({ field: "id", value: boardId });

            return searchInfo;
        };

const getBoardById =
    identity =>
        boardId => {
            const boards =
                ({ pageSize: 1, pageNumber: 0 })
                    [PIPE](createDefaultSearchInfo)
                    [PIPE](applyBoardIdFilter(boardId))
                    [PIPE](searchBoards(identity));
            
            if (boards.totalItems !== 1) {
                throw new APIError("Board does not exist or is not public", 404);
            }

            return boards.data[0];
        };

const normalizeBoardModel =
    (identity, id) =>
        ({ original, modified }) => ({
            original,
            modified: {
                id: id,
                ownerId: identity.id,
                name: modified.name,
                description: modified.description,
                public: modified.public || false,
                active: modified.active || true
            }
        });

const validateBoardModel =
    model => {
        if (!model.modified.name || model.modified.name.trim() === "") {
            throw new APIError("Missing board name", 400);
        }

        return model;
    };

const verifyUserCanUpdateBoard =
    identity =>
        model => {
            if (model.original.ownerId !== identity.id) {
                throw new APIError("Only the board owner can make changes to a board", 401);
            }

            return model;
        };

const createBoard =
    identity =>
        model =>
            ({
                original: null,
                modified: model
            })
                [PIPE](normalizeBoardModel(identity, uuid()))
                [PIPE](validateBoardModel)
                [PIPE](insertBoardDocument)
                [PIPE](d => d.modified);

const updateBoard =
    (identity, id) =>
        model =>
            id
                [PIPE](getBoardById(identity))
                [PIPE](b => ({
                    original: b,
                    modified: model
                }))
                [PIPE](normalizeBoardModel(identity, id))
                [PIPE](validateBoardModel)
                [PIPE](verifyUserCanUpdateBoard(identity))
                [PIPE](replaceBoardDocument)
                [PIPE](d => d.modified);

const deactivateBoard =
    identity =>
        id =>
            id
                [PIPE](getBoardById(identity))
                [PIPE](b => ({
                    original: b,
                    modified: libShared.setActiveFlagOff(b)
                }))
                [PIPE](verifyUserCanUpdateBoard(identity))
                [PIPE](replaceBoardDocument)
                [PIPE](d => d.modified);

const activateBoard =
    identity =>
        id =>
            id
                [PIPE](getBoardById(identity))
                [PIPE](b => ({
                    original: b,
                    modified: libShared.setActiveFlagOn(b)
                }))
                [PIPE](verifyUserCanUpdateBoard(identity))
                [PIPE](replaceBoardDocument)
                [PIPE](d => d.modified);

module.exports = {
    listBoards,
    searchBoards,
    getBoardById,
    createBoard,
    updateBoard,
    deactivateBoard,
    activateBoard
};
