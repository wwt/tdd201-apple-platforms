import { SpawnArguments } from "./pact-util";
import { AbstractService } from "./service";
export declare class Stub extends AbstractService {
    static create: (options?: StubOptions | undefined) => Stub;
    readonly options: StubOptions;
    constructor(options?: StubOptions);
}
declare const _default: (options?: StubOptions | undefined) => Stub;
export default _default;
export interface StubOptions extends SpawnArguments {
    pactUrls?: string[];
    port?: number;
    ssl?: boolean;
    cors?: boolean;
    host?: string;
    sslcert?: string;
    sslkey?: string;
    log?: string;
}
