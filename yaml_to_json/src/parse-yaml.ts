import { parse } from "https://deno.land/std@0.98.0/encoding/yaml.ts";

export const parseYaml = (str: string): unknown => parse(str);
