import { AbstractService } from "./service";
import { SpawnArguments } from "./pact-util";
export declare class Server extends AbstractService {
    static create: (options?: ServerOptions | undefined) => Server;
    readonly options: ServerOptions;
    constructor(options?: ServerOptions);
}
declare const _default: (options?: ServerOptions | undefined) => Server;
export default _default;
export interface ServerOptions extends SpawnArguments {
    port?: number;
    ssl?: boolean;
    cors?: boolean;
    dir?: string;
    host?: string;
    sslcert?: string;
    sslkey?: string;
    log?: string;
    spec?: number;
    consumer?: string;
    provider?: string;
    monkeypatch?: string;
    logLevel?: "debug" | "info" | "warn" | "error";
    pactFileWriteMode?: "overwrite" | "update" | "merge";
}
