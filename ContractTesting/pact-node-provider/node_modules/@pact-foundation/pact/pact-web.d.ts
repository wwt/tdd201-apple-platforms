import { InteractionObject } from "./dsl/interaction";
import { MockService } from "./dsl/mockService";
import { PactOptions, PactOptionsComplete } from "./dsl/options";
/**
 * Creates a new {@link PactWeb}.
 * @memberof Pact
 * @name create
 * @param {PactOptions} opts
 * @return {@link PactWeb}
 * @static
 */
export declare class PactWeb {
    mockService: MockService;
    server: any;
    opts: PactOptionsComplete;
    constructor(config: PactOptions);
    /**
     * Add an interaction to the {@link MockService}.
     * @memberof PactProvider
     * @instance
     * @param {Interaction} interactionObj
     * @returns {Promise}
     */
    addInteraction(interactionObj: InteractionObject): Promise<string>;
    /**
     * Checks with the Mock Service if the expected interactions have been exercised.
     * @memberof PactProvider
     * @instance
     * @returns {Promise}
     */
    verify(): Promise<string>;
    /**
     * Writes the Pact and clears any interactions left behind.
     * @memberof PactProvider
     * @instance
     * @returns {Promise}
     */
    finalize(): Promise<string>;
    /**
     * Writes the Pact file but leave interactions in.
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
/**
 * Exposes {@link Matchers}
 * To avoid polluting the root module's namespace, re-export
 * Matchers as its owns module
 * @memberof Pact
 * @static
 */
import * as Matchers from "./dsl/matchers";
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
