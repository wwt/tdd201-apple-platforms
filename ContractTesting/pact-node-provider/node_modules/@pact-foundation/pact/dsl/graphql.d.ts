/**
 * Pact GraphQL module.
 *
 * @module GraphQL
 */
import { Interaction, InteractionState } from "../dsl/interaction";
export interface GraphQLVariables {
    [name: string]: any;
}
/**
 * GraphQL interface
 */
export declare class GraphQLInteraction extends Interaction {
    private operation;
    private variables;
    private query;
    /**
     * The type of GraphQL operation. Generally not required.
     */
    withOperation(operation: string): this;
    /**
     * Any variables used in the Query
     */
    withVariables(variables: GraphQLVariables): this;
    /**
     * The actual GraphQL query as a string.
     *
     * NOTE: spaces are not important, Pact will auto-generate a space-insensitive matcher
     *
     *  e.g. the value for the "query" field in the GraphQL HTTP payload:
     *  '{ "query": "{
     *        Category(id:7) {
     *          id,
     *          name,
     *          subcategories {
     *            id,
     *            name
     *          }
     *        }
     *     }"
     *  }'
     */
    withQuery(query: string): this;
    /**
     * Returns the interaction object created.
     */
    json(): InteractionState;
}
