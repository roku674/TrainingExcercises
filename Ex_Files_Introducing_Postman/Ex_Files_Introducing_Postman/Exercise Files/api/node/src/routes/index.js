const express = require("express");
const { PIPE } = require("../extensions/object/pipeline");

const authRoutes = require("./auth");
const boardRoutes = require("./boards");
const ticketRoutes = require("./tickets");
const userRoutes = require("./users");

const formatInfoAsPlainText =
    info =>
        `User-Agent: ${info["user-agent"]}\n`
        + `Accept: ${info["accept"]}\n`
        + `Status: ${info["status"]}`;

const formatInfoAsHtml =
    info =>
        `<!DOCTYPE html>
        <HTML><HEAD><TITLE>API Status</TITLE></HEAD>
        <BODY>
            <P>User-Agent: ${info["user-agent"]}</P>
            <P>Accept: ${info["accept"]}</P>
            <P>Status: ${info["status"]}</P>
        </BODY>
        </HTML>`;

const buildInfoObject =
    req => ({
        "user-agent": req.get("User-Agent"),
        "accept": req.get("Accept"),
        "status": "The API is listening..."
    });

const getInfo =
    (req, res) =>
        res
            .status(200)
            .format({
                "text/plain":
                    () =>
                        req
                            [PIPE](buildInfoObject)
                            [PIPE](formatInfoAsPlainText)
                            [PIPE](content => res.send(content)),
                "text/html":
                    () =>
                        req
                            [PIPE](buildInfoObject)
                            [PIPE](formatInfoAsHtml)
                            [PIPE](content => res.send(content)),
                "application/json":
                    () =>
                        req
                            [PIPE](buildInfoObject)
                            [PIPE](content => res.json(content)),
            });

const router =
    express
        .Router()
        .get("/", getInfo)
        .use("/auth", authRoutes)
        .use("/boards", boardRoutes)
        .use("/tickets", ticketRoutes)
        .use("/users", userRoutes);

module.exports = router;
