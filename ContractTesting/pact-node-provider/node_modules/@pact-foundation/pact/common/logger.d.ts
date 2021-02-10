import * as bunyan from "bunyan";
export declare class Logger extends bunyan {
    time(action: string, startTime: number): void;
    readonly logLevelName: string;
}
declare const _default: Logger;
export default _default;
