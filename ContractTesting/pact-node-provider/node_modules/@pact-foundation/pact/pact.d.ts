import * as Matchers from "./dsl/matchers";
import { Interaction, InteractionObject } from "./dsl/interaction";
import { MockService } from "./dsl/mockService";
import { PactOptions, PactOptionsComplete } from "./dsl/options";
import { Server } from "@pact-foundation/pact-node/src/server";
/**
 * Creates a new {@link PactProvider}.
 * @memberof Pact
 * @name create
 * @param {PactOptions} opts
 * @return {@link PactProvider}
 */
export declare class Pact {
    static defaults: PactOptions;
    static createOptionsWithDefaults(opts: PactOptions): PactOptionsComplete;
    server: Server;
    opts: PactOptionsComplete;
    mockService: MockService;
    private finalized;
    constructor(config: PactOptions);
    /**
     * Start the Mock Server.
     * @returns {Promise}
     */
    setup(): Promise<void>;
    /**
     * Add an interaction to the {@link MockService}.
     * @memberof PactProvider
     * @instance
     * @param {Interaction} interactionObj
     * @returns {Promise}
     */
    addInteraction(interactionObj: InteractionObject | Interaction): Promise<string>;
    /**
     * Checks with the Mock Service if the expected interactions have been exercised.
     * @memberof PactProvider
     * @instance
     * @returns {Promise}
     */
    verify(): Promise<string>;
    /**
     * Writes the Pact and clears any interactions left behind and shutdown the
     * mock server
     * @memberof PactProvider
     * @instance
     * @returns {Promise}
     */
    finalize(): Promise<void>;
    /**
     * Writes the pact file out to file. Should be called when all tests have been performed for a
     * given Consumer <-> Provider pair. It will write out the Pact to the
     * configured file.
     * @memberof PactProvider
     * @instance
     * @returns {Promise}
     */
    writePact(): Promise<string>;
    /**
     * Clear up any interactions in the Provider Mock Server.
     * @memberof PactProvider
     * @instance
     * @returns {Promise}
     */
    removeInteractions(): Promise<string>;
}
export * from "./messageConsumerPact";
export * from "./messageProviderPact";
export * from "./dsl/message";
/**
 * Exposes {@link Verifier}
 * @memberof Pact
 * @static
 */
export * from "./dsl/verifier";
/**
 * Exposes {@link GraphQL}
 * @memberof Pact
 * @static
 */
export * from "./dsl/graphql";
/**
 * Exposes {@link Matchers}
 * To avoid polluting the root module's namespace, re-export
 * Matchers as its owns module
 * @memberof Pact
 * @static
 */
export import Matchers = Matchers;
/**
 * Exposes {@link Interaction}
 * @memberof Pact
 * @static
 */
export * from "./dsl/interaction";
/**
 * Exposes {@link MockService}
 * @memberof Pact
 * @static
 */
export * from "./dsl/mockService";
