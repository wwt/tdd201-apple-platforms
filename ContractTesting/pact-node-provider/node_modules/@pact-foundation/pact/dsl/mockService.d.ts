import { Request } from "../common/request";
import { Interaction } from "./interaction";
export declare type PactfileWriteMode = "overwrite" | "update" | "merge";
export interface Pacticipant {
    name: string;
}
export interface PactDetails {
    consumer?: Pacticipant;
    provider?: Pacticipant;
    pactfile_write_mode: PactfileWriteMode;
}
export declare class MockService {
    private consumer?;
    private provider?;
    private port;
    private host;
    private ssl;
    private pactfileWriteMode;
    pactDetails: PactDetails;
    request: Request;
    baseUrl: string;
    /**
     * @param {string} consumer - the consumer name
     * @param {string} provider - the provider name
     * @param {number} port - the mock service port, defaults to 1234
     * @param {string} host - the mock service host, defaults to 127.0.0.1
     * @param {boolean} ssl - which protocol to use, defaults to false (HTTP)
     * @param {string} pactfileWriteMode - 'overwrite' | 'update' | 'merge', defaults to 'overwrite'
     */
    constructor(consumer?: string | undefined, provider?: string | undefined, port?: number, host?: string, ssl?: boolean, pactfileWriteMode?: PactfileWriteMode);
    /**
     * Adds an interaction
     * @param {Interaction} interaction
     * @returns {Promise}
     */
    addInteraction(interaction: Interaction): Promise<string>;
    /**
     * Removes all interactions.
     * @returns {Promise}
     */
    removeInteractions(): Promise<string>;
    /**
     * Verify all interactions.
     * @returns {Promise}
     */
    verify(): Promise<string>;
    /**
     * Writes the Pact file.
     * @returns {Promise}
     */
    writePact(): Promise<string>;
}
