/**
 * @module Message
 */
import { MessageProviderOptions } from "./dsl/options";
/**
 * A Message Provider is analagous to Consumer in the HTTP Interaction model.
 *
 * It is the initiator of an interaction, and expects something on the other end
 * of the interaction to respond - just in this case, not immediately.
 */
export declare class MessageProviderPact {
    private config;
    private state;
    constructor(config: MessageProviderOptions);
    /**
     * Verify a Message Provider.
     */
    verify(): Promise<any>;
    private waitForServerReady;
    private runProviderVerification;
    private setupVerificationHandler;
    private setupProxyServer;
    private setupProxyApplication;
    private setupStates;
    private findHandler;
}
