const path = require("path");
const express = require("express");
const http = require("http");
const morgan = require("morgan");
const bodyParser = require("body-parser");
const dataContext = require("./dataContext");

require("dotenv").config({ path: path.resolve(process.cwd(), "api", "node", ".env") });

const port = 3000;

const captureError =
    (err, req, res, next) => {
        console.log(`Error: ${err.message | err}`);

        next(err);
    };

const handleShutdown =
    (sig) => {
        console.log(`Received shutdown signal: ${sig}`);

        dataContext.dump();

        process.exit();
    };

["SIGINT", "SIGTERM"]
    .forEach(
        sig => {
            console.log(`Registering ${sig} handler`);
            process.on(sig, handleShutdown.bind(null, [ sig ]));
        });

const app =
    express()
        .use(morgan("combined", { stream: process.stdout }))
        .use(bodyParser.urlencoded({ extended: true }))
        .use(bodyParser.json())
        .use("/api", require("./src/routes"))
        .use(captureError);

console.log(`Listening on port ${port}`);

const server =
    http
        .createServer(app)
        .listen(port);
