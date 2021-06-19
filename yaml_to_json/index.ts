import { parseYaml } from "./src/parse-yaml.ts";
import { getSourceYamlString } from "./src/interface.ts";

const yamlStr = await getSourceYamlString();
console.log(JSON.stringify(parseYaml(yamlStr), undefined, 2));
