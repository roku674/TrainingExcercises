const uuid = require("uuid/v1");
const jwt = require("jsonwebtoken");
const { PIPE } = require("../extensions/object/pipeline");
const dataContext = require("../../dataContext");
const libShared = require("./shared");
const search = require("./search");
const APIError = require("../../APIError");

const insertUserDocument =
    libShared.insertDocument(dataContext.collections.users);

const replaceUserDocument =
    libShared.replaceDocument(dataContext.collections.users);

const removeProperty =
    propertyName =>
        model => {
            const newModel = { ...model };
            Reflect.deleteProperty(newModel, propertyName);

            return newModel;
        };

const removePassword = removeProperty("password");
const removeActiveFlag = removeProperty("active");

const searchUsersRaw =
    searchInfo =>
        searchInfo
            [PIPE](search.normalizeSearchInfo)
            [PIPE](search.doSearch(dataContext.collections.users));

const searchUsers =
    searchInfo =>
        searchInfo
            [PIPE](searchUsersRaw)
            [PIPE](data => ({
                ...data,
                data: data.data.map(removePassword)
            }));

const createDefaultSearchInfo =
    includeInactive =>
        ({ pageSize, pageNumber }) =>
            ({
                pageSize,
                pageNumber,
                filters:
                    includeInactive
                        ? []
                        : [ { field: "active", value: true } ],
                sort: [ "lastname", "firstname" ]
            });

const listUsers =
    options =>
        options
            [PIPE](createDefaultSearchInfo(false))
            [PIPE](searchUsers);

const applyUserIdFilter =
    userId =>
        searchInfo => {
            searchInfo.filters.unshift({ field: "id", value: userId });

            return searchInfo;
        };

const applyCredentialsFilter =
    ({ username, password }) =>
        searchInfo => {
            searchInfo.filters.unshift({ field: "username", value: username, exact: true });
            searchInfo.filters.unshift({ field: "password", value: password, exact: true });

            return searchInfo;
        };

const getSingleUser =
    searchInfo => {
        const users = searchUsersRaw(searchInfo);

        if (users.totalItems !== 1) {
            throw new APIError("Unable to locate the requested user", 404);
        }

        return users
            .data
            [0]
            [PIPE](removePassword);
    }

const getUserById =
    includeInactive =>
        userId =>
            ({ pageSize: 1, pageNumber: 0 })
                [PIPE](createDefaultSearchInfo(includeInactive))
                [PIPE](applyUserIdFilter(userId))
                [PIPE](getSingleUser)
                [PIPE](removePassword);

const getActiveUserById = getUserById(false);
const getAnyUserById = getUserById(true);

const getUserByCredentials =
    credentials =>
        ({ pageSize: 1, pageNumber: 0 })
            [PIPE](createDefaultSearchInfo(false))
            [PIPE](applyCredentialsFilter(credentials))
            [PIPE](getSingleUser)
            [PIPE](removePassword);

const normalizeUserModel =
    id =>
        ({ original, modified }) => ({
            original,
            modified: {
                id: id,
                username: modified.username,
                password: modified.password,
                firstname: modified.firstname,
                lastname: modified.lastname,
                active: modified.active || true
            }
        });

const validateUserModel =
    model => {
        if (!Reflect.has(model.modified, "username")) throw new APIError("Missing user name", 400);
        if (!Reflect.has(model.modified, "password")) throw new APIError("Missing password", 400);

        return model;
    };

const verifyUserNameIsUnique =
    model => {
        const usernameExists =
            dataContext
                .collections
                .users
                .some(
                    u =>
                        u.username.localeCompare(model.modified.username) === 0
                        && u.id.localeCompare(model.modified.id) !== 0)

        if (usernameExists) {
            throw new APIError(`The user name ${model.modified.username} is already taken`, 400);
        }

        return model;
    };

const createUser =
    model =>
        ({
            original: null,
            modified: model
        })
            [PIPE](normalizeUserModel(uuid()))
            [PIPE](validateUserModel)
            [PIPE](verifyUserNameIsUnique)
            [PIPE](insertUserDocument)
            [PIPE](d => d.modified)
            [PIPE](removePassword);

const updateUser =
    id =>
        model =>
            id
                [PIPE](getAnyUserById)
                [PIPE](u => ({
                    original: u,
                    modified: model
                }))
                [PIPE](normalizeUserModel(id))
                [PIPE](validateUserModel)
                [PIPE](verifyUserNameIsUnique)
                [PIPE](replaceUserDocument)
                [PIPE](d => d.modified)
                [PIPE](removePassword);

const deactivateUser =
    id =>
        id
            [PIPE](getAnyUserById)
            [PIPE](u => ({
                original: u,
                modified: libShared.setActiveFlagOff(u)
            }))
            [PIPE](replaceUserDocument)
            [PIPE](d => d.modified)
            [PIPE](removePassword);

const activateUser =
    id =>
        id
            [PIPE](getAnyUserById)
            [PIPE](u => ({
                original: u,
                modified: libShared.setActiveFlagOn(u)
            }))
            [PIPE](replaceUserDocument)
            [PIPE](d => d.modified)
            [PIPE](removePassword);

const createToken =
    user =>
        jwt
            .sign(
                user,
                process.env.JWT_SECRET || "secret",
                { expiresIn: process.env.JWT_EXP || "1h" });

const authenticate =
    model =>
        model
            [PIPE](getUserByCredentials)
            [PIPE](removePassword)
            [PIPE](removeActiveFlag)
            [PIPE](createToken)
            [PIPE](t => ({ token: t }));

module.exports = {
    authenticate,
    listUsers,
    getActiveUserById,
    createUser,
    updateUser,
    deactivateUser,
    activateUser
};