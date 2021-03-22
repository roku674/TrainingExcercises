const path = require("path")
const fs = require("fs");
const { PIPE } = require("./src/extensions/object/pipeline");

const dataPath = path.resolve(process.cwd(), "api", "data");

const loadDataFromFile =
    name => {
        console.log(`Attempting to load ${name} data from from file`);

        const filePath = path.resolve(dataPath, `${name.toLowerCase()}.json`);

        return fs.existsSync(filePath)
            ? filePath
                [PIPE](fs.readFileSync)
                .toString()
                [PIPE](JSON.parse)
            : [];
    };

const stringify =
    spaces =>
        data =>
            JSON.stringify(data, null, spaces);

const writeToFile =
    name =>
        data =>
            fs.writeFileSync(path.resolve(dataPath, `${name.toLowerCase()}.json`), data)

const persistData =
    ({ name, data }) => {
        console.log(`Attempting to persist ${name} to file`);

        data
            [PIPE](stringify(2))
            [PIPE](writeToFile(name));

        console.log(`Done persisting ${name}`);
    }

const dump =
    collections => 
        () => {
            Reflect
                .ownKeys(collections)
                .map(k => ({
                    name: k,
                    data: collections[k]
                }))
                .forEach(persistData);
        };

const collections =
    new Proxy(
        {},
        {
            get: (target, prop) => {
                if (!Reflect.has(target, prop)) {
                    const data = loadDataFromFile(prop);
                    Reflect.set(target, prop, data);
                }

                return Reflect.get(target, prop);
            }
        }
    );

module.exports = {
    collections,
    dump: dump(collections)
}

